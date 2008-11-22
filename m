Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYKVQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYKVQSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 11:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758530AbYKVQSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 11:18:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:16617 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758520AbYKVQSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 11:18:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,650,1220252400"; 
   d="scan'208";a="80704674"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
       "Luck, Tony" <tony.luck@intel.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>
CC: "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'mingo@elte.hu'" <mingo@elte.hu>
Date: Sat, 22 Nov 2008 08:18:02 -0800
Subject: RE: [PATCH] IA64: fix VT-d dma_mapping_error
Thread-Topic: [PATCH] IA64: fix VT-d dma_mapping_error
Thread-Index: AclMohtwQPq+NQuxRV+UMWgAhq/6AgAGciBA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB88EAB57E1@orsmsx505.amr.corp.intel.com>
References: <20081122215822A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081122215822A.fujita.tomonori@lab.ntt.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
>+int intel_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
>+{
>+	return !dma_addr;
>+}

The implementation of inte_dma_mapping_error is incomplete.

Dma_addr is valid only when it belongs to hwdev's domain. This is all about VT-d isolation fundamental.

+int intel_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
+{
+        struct pci_dev *pdev = to_pci_dev(hwdev);
+        struct dmar_domain *domain;
+        struct iova *iova;
+
+        domain = find_domain(pdev);
+
+        iova = find_iova(&domain->iovad, IOVA_PFN(dma_addr));
+        if (!iova)
+                return -EINVAL;
+	   return 0;
+}
