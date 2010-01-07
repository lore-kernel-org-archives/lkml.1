Return-Path: <linux-kernel-owner+w=401wt.eu-S932990Ab0AGD01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab0AGD01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714Ab0AGD00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:26:26 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55472 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0AGD0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:26:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Jan 2010 12:23:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] vmalloc: simplify vread()/vwrite()
Message-Id: <20100107122304.b5c1d777.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1262834141.17852.23.camel@yhuang-dev.sh.intel.com>
References: <20100107012458.GA9073@localhost>
	<20100107103825.239ffcf9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107025054.GA11252@localhost>
	<1262834141.17852.23.camel@yhuang-dev.sh.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jan 2010 11:15:41 +0800
Huang Ying <ying.huang@intel.com> wrote:

> > > 
> > > > The page_is_ram() check is necessary because kmap_atomic() is not
> > > > designed to work with non-RAM pages.
> > > > 
> > > I think page_is_ram() is not a complete method...on x86, it just check
> > > e820's memory range. checking VM_IOREMAP is better, I think.
> > 
> > (double check) Not complete or not safe?
> > 
> > EFI seems to not update e820 table by default.  Ying, do you know why?
> 
> In EFI system, E820 table is constructed from EFI memory map in boot
> loader, so I think you can rely on E820 table.
> 
Yes, we can rely on. But concerns here is that we cannot get any
information of ioremap via e820 map. 

But yes,
== ioremap()
 140         for (pfn = phys_addr >> PAGE_SHIFT;
 141                                 (pfn << PAGE_SHIFT) < (last_addr & PAGE_MASK);
 142                                 pfn++) {
 143 
 144                 int is_ram = page_is_ram(pfn);
 145 
 146                 if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
 147                         return NULL;
 148                 WARN_ON_ONCE(is_ram);
 149         }
==
you'll get warned before access if "ram" area is remapped...

But, about this patch, it seems that page_is_ram() is not free from architecture
dependecy.


Thanks,
-Kame

