Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXFONyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXFONyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXFONyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:54:01 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:54542 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbXFONyA (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:54:00 -0400
Message-ID: <467299F5.3070704@de.ibm.com>
Date: Fri, 15 Jun 2007 15:53:57 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: carsteno@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
References: <1179871779.24163.11.camel@localhost.localdomain> <20070522154905.1d7e8a2e.akpm@linux-foundation.org> <4653F264.1030807@de.ibm.com> <465BB5BA.3050900@yahoo.com.au>
In-Reply-To: <465BB5BA.3050900@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Carsten Otte wrote:
>> The current xip stack relies on having struct page behind the memory 
>> segment. This causes few impact on memory management, but occupies 
>> some more memory. The cramfs patch chose to modify copy on write in 
>> order to deal with vmas that don't have struct page behind.
>> So far, Hugh and Linus have shown strong opposition against copy on 
>> write with no struct page behind. If this implementation is acceptable 
>> to the them, it seems preferable to me over wasting memory. The xip 
>> stack should be modified to use this vma flag in that case.
> 
> I would rather not :P
> 
> We can copy on write without a struct page behind the source today, no?
> What is insufficient for the XIP code with the current COW?

I've looked at the -mm version of mm/memory.c today, with intend to 
try out VM_PFNMAP for our xip mappings and replace nopage() with fault().
The thing is, I believe it does'nt work for us:
  * The way we recognize those mappings is through the rules set up
  * by "remap_pfn_range()": the vma will have the VM_PFNMAP bit set,
  * and the vm_pgoff will point to the first PFN mapped: thus every
  * page that is a raw mapping will always honor the rule
  *
  *      pfn_of_page == vma->vm_pgoff + ((addr - vma->vm_start) >> 
PAGE_SHIFT)

This is, as far as I can tell, not true for our xip mappings. Ext2 may 
spread the physical pages behind a given file all over its media. That 
means, that the pfns of the pages that form a vma may be more or less 
random rather than contiguous. The common memory management code 
cannot tell whether or not a given page has been COW'ed.
Did I miss something?

so long,
Carsten
