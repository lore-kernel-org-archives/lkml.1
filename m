Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbYC1Cb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbYC1Cb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbYC1Car
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:30:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52335 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbYC1Cap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:30:45 -0400
Date: Fri, 28 Mar 2008 11:33:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned
 memory is bad
Message-Id: <20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EC5440.5020107@goop.org>
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>
	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>
	<20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>
	<47EC5440.5020107@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 19:13:20 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> >> Because, firmware may occupy some area in the section.
> >> Firmware must exclude those area to notify kernel. So, E820, EFI,
> >> or _CRS of ACPI may return not aligned address and size.
> >> register_memory_resource() and walk_memory_resource() are to skip
> >> them silently. This is intended.
> >>
> >>     
> > Ah, ok. sorry.
> >
> > Jeremy, I think you can check whether you have 'struct page' or not by
> > pfn_valid(). 
> >
> > If pfn_valid() == false, you should call add_memory() and create
> > a section/mem_map. If pfn_valid() == true, you should just remove
> > PG_reserved bit in mem_map by online_page().
> 
> OK.  Would that ever be necessary if I explicitly align my start and size?
> 
Maybe no. but be carefull not to register resource in overlapped manner.
(I wrote online_page() in above, but online_pages() is maybe better.
 It does all what you want.)

Start/Size are automatically alined to section in __add_pages().

See below.
==
110 int __add_pages(struct zone *zone, unsigned long phys_start_pfn,
 111                  unsigned long nr_pages)
 112 {
 113         unsigned long i;
 114         int err = 0;
 115         int start_sec, end_sec;
 116         /* during initialize mem_map, align hot-added range to section */
 117         start_sec = pfn_to_section_nr(phys_start_pfn);
 118         end_sec = pfn_to_section_nr(phys_start_pfn + nr_pages - 1);
==

And online_pages(), which onlines pages in [pfn, pfn + size), will see
registerred resources within [pfn, pfn + size).
==
184 int online_pages(unsigned long pfn, unsigned long nr_pages)
<snip>
227         walk_memory_resource(pfn, nr_pages, &onlined_pages,
228                 online_pages_range);
==

One of my concern is how-to-handle sysfs status in this case.

Another concerns is, currently, I think no one tried to online a section twice
to online reserved pages in a section. so, you may see bug.
For example, mem_notify() in online_pages() will be called several times against
a section.

Thanks,
-Kame


