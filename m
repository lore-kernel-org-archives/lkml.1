Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbYLNIQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbYLNIQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYLNIH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 36/36] x86: KVM guest: kvm_get_tsc_khz: return khz, not lpj
Date: Sun, 14 Dec 2008 10:07:09 +0200
Message-Id: <1229242029-13410-37-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

kvm_get_tsc_khz() currently returns the previously-calculated preset_lpj
value, but it is in loops-per-jiffy, not kHz. The current code works
correctly only when HZ=1000.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/kvmclock.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index b38e801..652fce6 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -89,17 +89,17 @@ static cycle_t kvm_clock_read(void)
  */
 static unsigned long kvm_get_tsc_khz(void)
 {
-	return preset_lpj;
+	struct pvclock_vcpu_time_info *src;
+	src = &per_cpu(hv_clock, 0);
+	return pvclock_tsc_khz(src);
 }
 
 static void kvm_get_preset_lpj(void)
 {
-	struct pvclock_vcpu_time_info *src;
 	unsigned long khz;
 	u64 lpj;
 
-	src = &per_cpu(hv_clock, 0);
-	khz = pvclock_tsc_khz(src);
+	khz = kvm_get_tsc_khz();
 
 	lpj = ((u64)khz * 1000);
 	do_div(lpj, HZ);
-- 
1.6.0.3

