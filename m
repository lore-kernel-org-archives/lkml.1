Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZFYV41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZFYV41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZFYV4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:56:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:61902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZFYV4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:56:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,292,1243839600"; 
   d="scan'208";a="527887818"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>
CC: "'chrisw@redhat.com'" <chrisw@redhat.com>,
       "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Date: Thu, 25 Jun 2009 14:56:19 -0700
Subject: RE: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
Thread-Topic: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
Thread-Index: Acn130RTppA5deDnSmS/w1D6lAJhfgAABxSQ
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B0216BF5@orsmsx505.amr.corp.intel.com>
References: <20090625003841.GA12226@linux-os.sc.intel.com>
	 <20090625095643F.fujita.tomonori@lab.ntt.co.jp>
	 <20090625041605.GA9330@linux-os.sc.intel.com>
	 <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
	 <1245913886.17089.91.camel@macbook.infradead.org>
 <1245966743.30355.42.camel@macbook.infradead.org>
In-Reply-To: <1245966743.30355.42.camel@macbook.infradead.org>
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

>-----Original Message-----
>From: David Woodhouse [mailto:dwmw2@infradead.org]
>Sent: Thursday, June 25, 2009 2:52 PM
>To: FUJITA Tomonori
>Cc: Yu, Fenghua; chrisw@redhat.com; torvalds@linux-foundation.org;
>akpm@linux-foundation.org; Luck, Tony; linux-kernel@vger.kernel.org;
>iommu@lists.linux-foundation.org; linux-ia64@vger.kernel.org
>Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
>Mapping Support
>
>On Thu, 2009-06-25 at 08:11 +0100, David Woodhouse wrote:
>> It raises the question: Why are we using firmware-specific interfaces to
>> list the available memory -- can't we get that from somewhere _generic_?
>>
>> The less we tie our code to these crappy BIOS, EFI and ACPI interfaces,
>> the better off we'll be.
>
>Does this work everywhere... ?
>
>(Fenghua, why are we doing the whole setup per pci dev anyway -- why not
>set up the page tables once and point all devices at the same page
>tables?)
>

That's what the ia64 fix patch does...the first pci device set up the page table. Then all following pci devices use that page table by setting up the context mapping.

+		if (first_pdev) {
+			/*
+			 * first pdev sets up the whole page table for
+			 * si_domain.
+			 */
+			first_pdev = 0;
+			ret = iommu_setup_identity_map(pdev);
+			if (ret)
+				return ret;
+		} else {
+			/*
+			 * following pdev's just use the page table.
+			 */
+			printk(KERN_INFO "IOMMU: identity mapping for device %s\n",
+			       pci_name(pdev));
+			ret = domain_context_mapping(si_domain, pdev,
+						     CONTEXT_TT_MULTI_LEVEL);
+			if (ret)
Thanks.

-Fenghua
