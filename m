Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZHOKHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZHOKHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZHOKHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:07:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:52684 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZHOKHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:07:19 -0400
Date: Sat, 15 Aug 2009 10:06:37 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <E1Mc1x7-0005Ce-6t@eag09.americas.sgi.com>
References: <E1Mc1x7-0005Ce-6t@eag09.americas.sgi.com>
Subject: [tip:x86/urgent] x86: Fix UV BAU destination subnode id
Message-ID: <tip-3ef12c3c97603bad405d30c989718cc9405e2759@git.kernel.org>
Git-Commit-ID: 3ef12c3c97603bad405d30c989718cc9405e2759
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 10:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ef12c3c97603bad405d30c989718cc9405e2759
Gitweb:     http://git.kernel.org/tip/3ef12c3c97603bad405d30c989718cc9405e2759
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Fri, 14 Aug 2009 13:56:37 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 11:58:02 +0200

x86: Fix UV BAU destination subnode id

The SGI UV Broadcast Assist Unit is used to send TLB shootdown
messages to remote nodes of the system.  The header of the
message must contain the subnode id of the block in the
receiving hub that handles such messages.  It should always be
0x10, the id of the "LB" block.

It had previously been documented as a "must be zero" field.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <E1Mc1x7-0005Ce-6t@eag09.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_bau.h |    2 +-
 arch/x86/kernel/tlb_uv.c         |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index bddd44f..80e2984 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -133,7 +133,7 @@ struct bau_msg_payload {
  * see table 4.2.3.0.1 in broacast_assist spec.
  */
 struct bau_msg_header {
-	unsigned int dest_subnodeid:6;	/* must be zero */
+	unsigned int dest_subnodeid:6;	/* must be 0x10, for the LB */
 	/* bits 5:0 */
 	unsigned int base_dest_nodeid:15; /* nasid>>1 (pnode) of */
 	/* bits 20:6 */			  /* first bit in node_map */
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 8ccabb8..77b9689 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -744,6 +744,7 @@ uv_activation_descriptor_init(int node, int pnode)
 		 * note that base_dest_nodeid is actually a nasid.
 		 */
 		ad2->header.base_dest_nodeid = uv_partition_base_pnode << 1;
+		ad2->header.dest_subnodeid = 0x10; /* the LB */
 		ad2->header.command = UV_NET_ENDPOINT_INTD;
 		ad2->header.int_both = 1;
 		/*
