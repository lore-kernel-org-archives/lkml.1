Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZHPJkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZHPJkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZHPJis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:38:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45340 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbZHPJaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/48] KVM: fix cpuid E2BIG handling for extended request types
Date: Sun, 16 Aug 2009 12:29:25 +0300
Message-Id: <1250415008-17175-6-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

If we run out of cpuid entries for extended request types
we should return -E2BIG, just like we do for the standard
request types.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a93ba37..25a1c57 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1506,6 +1506,10 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 	for (func = 0x80000001; func <= limit && nent < cpuid->nent; ++func)
 		do_cpuid_ent(&cpuid_entries[nent], func, 0,
 			     &nent, cpuid->nent);
+	r = -E2BIG;
+	if (nent >= cpuid->nent)
+		goto out_free;
+
 	r = -EFAULT;
 	if (copy_to_user(entries, cpuid_entries,
 			 nent * sizeof(struct kvm_cpuid_entry2)))
-- 
1.6.3.3

