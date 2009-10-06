Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZJFAvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZJFAvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbZJFAuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:50:54 -0400
Received: from claw.goop.org ([74.207.240.146]:35228 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbZJFAux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:50:53 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Xen-devel <xen-devel@lists.xensource.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/5] x86/pvclock: no need to use strong read barriers in pvclock_get_time_values
Date: Mon,  5 Oct 2009 17:50:08 -0700
Message-Id: <1254790211-15416-3-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The time values are guaranteed to be only updated by the pcpu that the
vcpu is currently running on (preempting the guest), so there's never
any risk of cross-pcpu races.  Therefore, we only need a barrier to
prevent compiler reordering.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pvclock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 963f349..5ecce7f 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -86,12 +86,12 @@ static unsigned pvclock_get_time_values(struct pvclock_shadow_time *dst,
 {
 	do {
 		dst->version = src->version;
-		rmb();		/* fetch version before data */
+		barrier();		/* fetch version before data */
 		dst->tsc_timestamp     = src->tsc_timestamp;
 		dst->system_timestamp  = src->system_time;
 		dst->tsc_to_nsec_mul   = src->tsc_to_system_mul;
 		dst->tsc_shift         = src->tsc_shift;
-		rmb();		/* test version after fetching data */
+		barrier();		/* test version after fetching data */
 	} while ((src->version & 1) || (dst->version != src->version));
 
 	return dst->version;
-- 
1.6.2.5

