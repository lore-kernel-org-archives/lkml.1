Return-Path: <linux-kernel-owner+w=401wt.eu-S938350AbZDJMlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938350AbZDJMlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938238AbZDJMjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:39:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:45881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938245AbZDJMjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:39:09 -0400
Date: Fri, 10 Apr 2009 12:37:19 GMT
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, andreas.herrmann3@amd.com,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, akpm@linux-foundation.org,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409132406.GK31527@alberich.amd.com>
References: <20090409132406.GK31527@alberich.amd.com>
Subject: [tip:x86/cpu] x86: cacheinfo: disable L3 ECC scrubbing when L3 cache index is disabled
Message-ID: <tip-ba518bea2db21c72d44a6cbfd825b026ef9cdcb6@git.kernel.org>
Git-Commit-ID: ba518bea2db21c72d44a6cbfd825b026ef9cdcb6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:37:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba518bea2db21c72d44a6cbfd825b026ef9cdcb6
Gitweb:     http://git.kernel.org/tip/ba518bea2db21c72d44a6cbfd825b026ef9cdcb6
Author:     Mark Langsdorf <mark.langsdorf@amd.com>
AuthorDate: Thu, 9 Apr 2009 15:24:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 14:22:34 +0200

x86: cacheinfo: disable L3 ECC scrubbing when L3 cache index is disabled

(Use correct mask to zero out bits 24-28 by Andreas)

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20090409132406.GK31527@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fc28291..d46a849 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -731,6 +731,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	int node = cpu_to_node(cpu);
 	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned long val = 0;
+	unsigned int scrubber = 0;
 
 	if (!this_leaf->can_disable)
 		return -EINVAL;
@@ -745,6 +746,11 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 		return -EINVAL;
 
 	val |= 0xc0000000;
+
+	pci_read_config_dword(dev, 0x58, &scrubber);
+	scrubber &= ~0x1f000000;
+	pci_write_config_dword(dev, 0x58, scrubber);
+
 	pci_write_config_dword(dev, 0x1BC + index * 4, val & ~0x40000000);
 	wbinvd();
 	pci_write_config_dword(dev, 0x1BC + index * 4, val);
