Return-Path: <linux-kernel-owner+w=401wt.eu-S1764162AbZEARKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764162AbZEARKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762382AbZEARKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:10:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:43328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbZEARKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:10:23 -0400
Date: Fri, 1 May 2009 17:07:58 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F655B6.8020109@kernel.org>
References: <49F655B6.8020109@kernel.org>
Subject: [tip:irq/numa] irq: make ht irq_desc more numa aware
Message-ID: <tip-56b581ea9591b5767b1e0204c6a06c7d0c49396e@git.kernel.org>
Git-Commit-ID: 56b581ea9591b5767b1e0204c6a06c7d0c49396e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:08:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56b581ea9591b5767b1e0204c6a06c7d0c49396e
Gitweb:     http://git.kernel.org/tip/56b581ea9591b5767b1e0204c6a06c7d0c49396e
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 18:02:46 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:19 +0200

irq: make ht irq_desc more numa aware

Try to get irq_desc on the same node as create_irq_nr().

[ Impact: optimization, make HT IRQs more NUMA-aware ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49F655B6.8020109@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 drivers/pci/htirq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index bf7d6ce..4e9dd0f 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -98,6 +98,7 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	int max_irq;
 	int pos;
 	int irq;
+	int node;
 
 	pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
 	if (!pos)
@@ -125,7 +126,8 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	cfg->msg.address_lo = 0xffffffff;
 	cfg->msg.address_hi = 0xffffffff;
 
-	irq = create_irq();
+	node = dev_to_node(&dev->dev);
+	irq = create_irq_nr(0, node);
 
 	if (irq <= 0) {
 		kfree(cfg);
