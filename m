Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYCNCBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYCNCBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbYCNCBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:01:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35756 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617AbYCNCBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:01:07 -0400
Date: Fri, 14 Mar 2008 11:04:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@suse.de>, "Yasunori Goto" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make free_bootmem to loop bdata_list
Message-Id: <20080314110451.b41712b4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <86802c440803131839n4f723d14md906a15acb26c3a2@mail.gmail.com>
References: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
	<20080314103953.70be95b1.kamezawa.hiroyu@jp.fujitsu.com>
	<86802c440803131839n4f723d14md906a15acb26c3a2@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 18:39:34 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Thu, Mar 13, 2008 at 6:39 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Thu, 13 Mar 2008 11:53:31 -0700
> >  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
> >  > ===================================================================
> >  > --- linux-2.6.orig/mm/bootmem.c
> >  > +++ linux-2.6/mm/bootmem.c
> >  > @@ -427,7 +438,9 @@ int __init reserve_bootmem(unsigned long
> >  >
> >  >  void __init free_bootmem(unsigned long addr, unsigned long size)
> >  >  {
> >  > -     free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
> >  > +     bootmem_data_t *bdata;
> >  > +     list_for_each_entry(bdata, &bdata_list, list)
> >  > +             free_bootmem_core(bdata, addr, size);
> >  >  }
> >
> >
> >  Just a confirmation.
> >  In above loop, boundary check in free_bootmem_core() hits two or more times ?
> >  If yes, it's ok.
> >  If no, please exit loop at hit.
> 
> yes. need that handle range cross node (RAMDISK case that is end
> beyond end_of_ram).
> 
Then, <addr, size> can spread across nodes. 

IMHO, there are *big* memory hole between nodes in some systems. 
This kind of interface, which allows alloc/free bootmem accross nodes,
will see terrible trouble when a programmer assumes  "alloc/free bootmem
always return contiguous size of memory" (This is guaranteed now,)

Does the new allocator (you changed ?) guarantee that returned <address, size>
is fully contiguous even if it spreads accross nodes ?

If no, NACK for this version.

Thanks,
-Kame


