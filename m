Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbYGHX0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbYGHX0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbYGHXPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:06 -0400
Received: from gw.goop.org ([64.81.55.164]:51206 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 49 of 55] xen64: implement 64-bit update_descriptor
X-Mercurial-Node: 0633bd40ee5832edcbedce6ff3b66ef65004f3c8
Message-Id: <0633bd40ee5832edcbed.1215554831@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

64-bit hypercall interface can pass a maddr in one argument rather
than splitting it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/xen/hypercall.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -466,10 +466,15 @@
 			struct desc_struct desc)
 {
 	mcl->op = __HYPERVISOR_update_descriptor;
-	mcl->args[0] = maddr;
-	mcl->args[1] = maddr >> 32;
-	mcl->args[2] = desc.a;
-	mcl->args[3] = desc.b;
+	if (sizeof(maddr) == sizeof(long)) {
+		mcl->args[0] = maddr;
+		mcl->args[1] = *(unsigned long *)&desc;
+	} else {
+		mcl->args[0] = maddr;
+		mcl->args[1] = maddr >> 32;
+		mcl->args[2] = desc.a;
+		mcl->args[3] = desc.b;
+	}
 }
 
 static inline void


