Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZBZTme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZBZTme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZBZTmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:42:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42795 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZBZTmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:42:23 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] remove static declaration from wall clock version
Date: Thu, 26 Feb 2009 14:42:20 -0500
Message-Id: <1235677340-3139-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt T. Yourst noted that we're currently having a dumb
race for no reason in paravirtual wall clock. This is due
to the use of a static variable to hold the counting.

This can race with multiple guests reading wallclock
at the same time, since the static variable value would
then be accessible to all callers. This wasn't noted
before because it is a rather rare scenario.

Instead, just use a normal stack variable. This will
mean that each caller will have it's version written
separatedly. No need for a global counter.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/x86.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2511708..d7236f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -548,15 +548,13 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 {
-	static int version;
+	int version = 1;
 	struct pvclock_wall_clock wc;
 	struct timespec now, sys, boot;
 
 	if (!wall_clock)
 		return;
 
-	version++;
-
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 
 	/*
-- 
1.5.6.5

