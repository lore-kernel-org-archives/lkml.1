Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbXFNN6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbXFNN6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXFNN5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:57:52 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:17388 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbXFNN5v (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:57:51 -0400
Message-ID: <4671495A.3020605@de.ibm.com>
Date: Thu, 14 Jun 2007 15:57:46 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Jared Hulbert <jaredeh@gmail.com>
CC: carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au> <6934efce0706011748p46cf7995vdca0b9cc3f0b06a3@mail.gmail.com> <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706121711m738bd9abqa02350ccc7eabf9f@mail.gmail.com>
In-Reply-To: <6934efce0706121711m738bd9abqa02350ccc7eabf9f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
>> Nick Piggin wrote:
>> > The question is, why is that not enough (I haven't looked at these
>> > patches enough to work out if there is anything more they provide).
>> I think, it just takes trying things out. From reading the code, I
>> think this should work well for the filemap_xip code with no struct page.
>> Also, we need eliminate nopage() to get rid of the struct page.
>> Unfortunately I don't find time to try this out for now, and on 390 we
>> can live with struct page for the time being. In contrast to the
>> embedded platforms, the mem_mep array gets swapped out to disk by our
>> hypervisor.
> 
> Can you help me understand the comment about nopage()?  Do you mean
> set xip_file_vm_ops.nopage to NULL?

Yes, but not without replacement. Today, the page table entry for xip 
mappings is created like this:
__handle_mm_fault calls handle_pte_fault, which calls do_no_page [all 
in mm/memory.c]. do_no_page does call the ->nopage operation, and 
creates a page table entry. The ->nopage operation is set to 
xip_file_nopage() [mm/filemap_xip.c], which calls the get_xip_page 
address space operation. For ext2, this is implemented in 
ext2_get_xip_page (fs/ext2/xip.c).
In this process, the struct page entry in mem_map is looked up in 
ext2_get_xip_page(), returned to xip_file_nopage, then returned to 
do_no_page.
An alternative approach, which does not need to have struct page at 
hand, would be to use the nopfn vm operations struct. That one would 
have to rely on get_xip_pfn. The current path would then be 
deprecated. If you're interrested in using the later for xip without 
struct page, I would volounteer to go ahead and implement this?

so long,
Carsten
