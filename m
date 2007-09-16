Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXIQOtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXIQOtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbXIQOtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:49:42 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:23538 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753352AbXIQOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:49:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2mSv+9STle+PRBAn0UytFUrJHJ9GIfwTMZchYrDn42dmXsuZzHBcY4XIHtVFu/NKX0zUNI6wu9rlBt5yXoTTMOCs5tQwlEhuJnctdiz1gS21I0jCI1wBrqMwzUDc+gETZvXt8dJwejtyaY5jU7nDwGESsauB8zvfhpMZzhRFro4=  ;
X-YMail-OSG: ZdpT1OoVM1mAzn7.eoRGcWhwZ0CXv8iY2azfFnhNoH5M7ZxLOQovMkuKalr8O6fYlxU54ogPNg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Anton Altaparmakov <aia21@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Date: Mon, 17 Sep 2007 08:28:00 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk> <13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk> <DC408F26-E53F-4F27-9DEF-E996401D95FB@cam.ac.uk>
In-Reply-To: <DC408F26-E53F-4F27-9DEF-E996401D95FB@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709170828.01098.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 00:09, Anton Altaparmakov wrote:
> On 17 Sep 2007, at 15:04, Anton Altaparmakov wrote:
> > On 15 Sep 2007, at 11:52, Andrew Morton wrote:
> >> On Sat, 15 Sep 2007 12:08:17 +0200 Peter Zijlstra
> >>
> >> <peterz@infradead.org> wrote:
> >>> Anyway, looks like all of zone_normal is pinned in kernel
> >>>
> >>> allocations:
> >>>> Sep 13 15:31:25 escabot Normal free:3648kB min:3744kB low:4680kB
> >>>> high: 5616kB active:0kB inactive:3160kB present:894080kB
> >>>> pages_scanned:5336 all_unreclaimable? yes
> >>>
> >>> Out of the 870 odd mb only 3 is on the lru.
> >>>
> >>> Would be grand it you could have a look at slabinfo and the like.
> >>
> >> Definitely.
> >>
> >>>> Sep 13 15:31:25 escabot free:1090395 slab:198893 mapped:988
> >>>> pagetables:129 bounce:0
> >>
> >> 814,665,728 bytes of slab.
> >
> > Marc emailed me the contents of /proc/
> > {slabinfo,meminfo,vmstat,zoneinfo} taken just a few seconds before
> > the machine panic()ed due to running OOM completely...  They files
> > are attached this time rather than inlined so people don't complain
> > about line wrapping!  (No doubt people will not complain about them
> > being attached!  )-:)
> >
> > If I read it correctly it appears all of low memory is eaten up by
> > buffer_heads.
> >
> > <quote>
> > # name            <active_objs> <num_objs> <objsize> <objperslab>
> > <pagesperslab>
> >
> > : tunables <limit> <batchcount> <sharedfactor> : slabdata
> >
> > <active_slabs> <num_s
> > labs> <sharedavail>
> > buffer_head       12569528 12569535     56   67    1 : tunables
> > 120   60    8 :
> > slabdata 187605 187605      0
> > </quote>
> >
> > That is 671MiB of low memory in buffer_heads.
>
> I meant that is 732MiB of low memory in buffer_heads.  (12569535
> num_objs / 67 objperslab * 1 pagesperslab * 4096 PAGE_SIZE)

There is a sledgehammer in there which is supposed to alleviate
this problem. vmscan.c has buffer_heads_over_limit (could you check
if that is kicking in? (add a line in mm/page_alloc.c:show_free_areas()
to check it).

However, I'd guess the logic should be pretty robust. So it looks like
highmem is not getting scanned, so the buffer heads are not ever
getting a chance to be stripped off highmem pages!

(Rik has a patch sitting in -mm I believe which would make this problem
even worse, by doing even less highmem scanning in response to lowmem
allocations). However your user isn't using that kernel, so I wonder why it
isn't scanning highmem... it's been a while since I looked at reclaim, but
AFAIR it *should* be scanning it.
