Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYLIUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYLIUZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbYLIUXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34845 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbYLIUXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 08/44] KVM: Fix cpuid iteration on multiple leaves per eac
Date: Tue,  9 Dec 2008 22:22:23 +0200
Message-Id: <1228854179-23002-9-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

The code to traverse the cpuid data array list for counting type of leaves is
currently broken.

This patches fixes the 2 things in it.

 1. Set the 1st counting entry's flag KVM_CPUID_FLAG_STATE_READ_NEXT. Without
    it the code will never find a valid entry.

 2. Also the stop condition in the for loop while looking for the next unflaged
    entry is broken. It needs to stop when it find one matching entry;
    and in the case of count of 1, it will be the same entry found in this
    iteration.

Signed-Off-By: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2889a0f..7a2aeba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1246,6 +1246,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		int t, times = entry->eax & 0xff;
 
 		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
+		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
 		for (t = 1; t < times && *nent < maxnent; ++t) {
 			do_cpuid_1_ent(&entry[t], function, 0);
 			entry[t].flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
@@ -2801,7 +2802,7 @@ static int move_to_next_stateful_cpuid_entry(struct kvm_vcpu *vcpu, int i)
 
 	e->flags &= ~KVM_CPUID_FLAG_STATE_READ_NEXT;
 	/* when no next entry is found, the current entry[i] is reselected */
-	for (j = i + 1; j == i; j = (j + 1) % nent) {
+	for (j = i + 1; ; j = (j + 1) % nent) {
 		struct kvm_cpuid_entry2 *ej = &vcpu->arch.cpuid_entries[j];
 		if (ej->function == e->function) {
 			ej->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
-- 
1.6.0.3

