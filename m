Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYC1BvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYC1BvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYC1Bu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:50:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45445 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYC1Buz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:50:55 -0400
Date: Fri, 28 Mar 2008 10:54:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned
 memory is bad
Message-Id: <20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>
	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 10:34:51 +0900
Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > > --- a/mm/memory_hotplug.c
> > > +++ b/mm/memory_hotplug.c
> > > @@ -300,6 +300,11 @@
> > >  	int ret;
> > >  	u64 start = res->start;
> > >  	u64 size = res->end - res->start + 1;
> > > +
> > > +	/* Adding non-section-aligned memory will give unexpected
> > > +	   and unintuitive results. */
> > > +	WARN_ON((start & SECTION_SIZE_MASK) != 0);
> > > +	WARN_ON((size & SECTION_SIZE_MASK) != 0);
> > >  
> > Why just WARNING ? not BUG_ON?
> 
> Both Nack.
> 
> Because, firmware may occupy some area in the section.
> Firmware must exclude those area to notify kernel. So, E820, EFI,
> or _CRS of ACPI may return not aligned address and size.
> register_memory_resource() and walk_memory_resource() are to skip
> them silently. This is intended.
> 
Ah, ok. sorry.

Jeremy, I think you can check whether you have 'struct page' or not by
pfn_valid(). 

If pfn_valid() == false, you should call add_memory() and create
a section/mem_map. If pfn_valid() == true, you should just remove
PG_reserved bit in mem_map by online_page().

Thanks,
-Kame

