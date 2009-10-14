Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbZJNTas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbZJNTas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759110AbZJNT37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:29:59 -0400
Received: from claw.goop.org ([74.207.240.146]:55336 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbZJNT35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:57 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 06/12] x86/pvclock: make sure rdtsc doesn't speculate out of region
Date: Wed, 14 Oct 2009 12:28:30 -0700
Message-Id: <1255548516-15260-7-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdtsc is not necessarily ordered with surrounding instructions so we
need to make sure that it doesn't get sampled out of order with
respect to reading the time_info.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <gcosta@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
---
 arch/x86/kernel/pvclock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 03801f2..963f349 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -117,10 +117,10 @@ cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 
 	do {
 		version = pvclock_get_time_values(&shadow, src);
-		barrier();
+		rdtsc_barrier();
 		offset = pvclock_get_nsec_offset(&shadow);
 		ret = shadow.system_timestamp + offset;
-		barrier();
+		rdtsc_barrier();
 	} while (version != src->version);
 
 	return ret;
-- 
1.6.2.5

