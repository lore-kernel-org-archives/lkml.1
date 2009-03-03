Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbZCCFw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbZCCFw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 00:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZCCFwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 00:52:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:50962 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZCCFwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 00:52:46 -0500
Message-ID: <49ACC56D.8050304@kernel.org>
Date: Mon, 02 Mar 2009 21:51:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>	 <49AAEC79.3000808@redhat.com>	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>	 <49AB38E7.60305@redhat.com>	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>	 <49AB4171.7000508@kernel.org>	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>	 <49AB4521.8010909@kernel.org>	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>	 <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>	 <1235979959.6204.212.camel@yhuang-dev.sh.intel.com>	 <49AC51D7.1080203@kernel.org>	 <1236042459.6204.226.camel@yhuang-dev.sh.intel.com>	 <49AC87AE.60001@kernel.org>	 <1236046936.6204.243.camel@yhuang-dev.sh.intel.com>	 <49AC9B99.5020000@kernel.org>	 <1236049574.6204.253.camel@yhuang-dev.sh.intel.com>	 <49ACAAAF.90300@kernel.org>	 <1236058371.6204.267.camel@yhuang-dev.sh.intel.com>	 <49ACC205.2040504@kernel.org> <1236058858.6204.273.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1236058858.6204.273.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Tue, 2009-03-03 at 13:37 +0800, Yinghai Lu wrote:
> [...]
>>> The dmesg with ignore_loglevel in kernel parameters is attached with the
>>> mail.
>>>
>>> init_memory_mapping: 0000000000000000-000000003f700000
>>>  0000000000 - 003f600000 page 2M
>>>  003f600000 - 003f700000 page 4k
>>> kernel direct mapping tables up to 3f700000 @ 8000-b000
>>> last_map_addr: 3f700000 end: 3f700000
>>>
>>> init_memory_mapping: 00000000fffb0000-00000000fffba000
>>>  00fffb0000 - 0100000000 page 4k
>>> last_map_addr: 100000000 end: fffba000
>> that is funny, the range calculating has some problem...when the range size < 2M...
> 
> Yes. Can you fix that? If you have no time, I can do that.
> 

please try

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index c9d4466..25a7be8 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -748,6 +748,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	pos = start_pfn << PAGE_SHIFT;
 	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
+	if (end_pfn > (end>>PAGE_SHIFT))
+		end_pfn = end>>PAGE_SHIFT;
 	if (start_pfn < end_pfn) {
 		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 		pos = end_pfn << PAGE_SHIFT;
