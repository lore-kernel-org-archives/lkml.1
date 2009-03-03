Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZCCHxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZCCHxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZCCHxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:53:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:32969 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbZCCHxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:53:04 -0500
Date: Tue, 3 Mar 2009 07:51:41 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, hpa@zytor.com,
       mingo@redhat.com, yinghai@kernel.org, bmaly@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, yinghai@kernel.org, bmaly@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49ACDDED.1060508@kernel.org>
References: <49ACDDED.1060508@kernel.org>
Subject: [tip:x86/urgent] x86: fix init_memory_mapping() to handle small ranges
Message-ID: <tip-0fc59d3a01820765e5f3a723733728758b0cf577@git.kernel.org>
Git-Commit-ID: 0fc59d3a01820765e5f3a723733728758b0cf577
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 07:51:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fc59d3a01820765e5f3a723733728758b0cf577
Gitweb:     http://git.kernel.org/tip/0fc59d3a01820765e5f3a723733728758b0cf577
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Mon, 2 Mar 2009 23:36:13 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 08:50:22 +0100

x86: fix init_memory_mapping() to handle small ranges

Impact: fix failed EFI bootup in certain circumstances

Ying Huang found init_memory_mapping() has problem with small ranges
less than 2M when he tried to direct map the EFI runtime code out of
max_low_pfn_mapped.

It turns out we never considered that case and didn't check the range...

Reported-by: Ying Huang <ying.huang@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Maly <bmaly@redhat.com>
LKML-Reference: <49ACDDED.1060508@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_64.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e6d36b4..b135225 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -714,6 +714,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	pos = start_pfn << PAGE_SHIFT;
 	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > (end >> PAGE_SHIFT))
+		end_pfn = end >> PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 		pos = end_pfn << PAGE_SHIFT;
