Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYCNCHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYCNCHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYCNCH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:07:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:42309 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYCNCH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W9L09h6xyNHI5VqmTL3iLTMg4uvIRrE3ICzp9i9ukEMFGW9f64D97xRic7Io/zyFKwqowAJ7fMTUxeTIuHwm+UNk5M5Cg3P0gkkzp91SqAgdriAEQYO093Lj3VR+2cvIZNwOL6uVQvBj24Al4MZCRd5PDvDY7c834+M/RmeZl1E=
Message-ID: <86802c440803131907p5d09d0a4m86c6d664362fa9b@mail.gmail.com>
Date: Thu, 13 Mar 2008 19:07:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make free_bootmem to loop bdata_list
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@suse.de>, "Yasunori Goto" <y-goto@jp.fujitsu.com>
In-Reply-To: <20080314110451.b41712b4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
	 <20080314103953.70be95b1.kamezawa.hiroyu@jp.fujitsu.com>
	 <86802c440803131839n4f723d14md906a15acb26c3a2@mail.gmail.com>
	 <20080314110451.b41712b4.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 7:04 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 13 Mar 2008 18:39:34 -0700
>
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Thu, Mar 13, 2008 at 6:39 PM, KAMEZAWA Hiroyuki
>  > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  > > On Thu, 13 Mar 2008 11:53:31 -0700
>  > >  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>  > >  > ===================================================================
>  > >  > --- linux-2.6.orig/mm/bootmem.c
>  > >  > +++ linux-2.6/mm/bootmem.c
>  > >  > @@ -427,7 +438,9 @@ int __init reserve_bootmem(unsigned long
>  > >  >
>  > >  >  void __init free_bootmem(unsigned long addr, unsigned long size)
>  > >  >  {
>  > >  > -     free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>  > >  > +     bootmem_data_t *bdata;
>  > >  > +     list_for_each_entry(bdata, &bdata_list, list)
>  > >  > +             free_bootmem_core(bdata, addr, size);
>  > >  >  }
>  > >
>  > >
>  > >  Just a confirmation.
>  > >  In above loop, boundary check in free_bootmem_core() hits two or more times ?
>  > >  If yes, it's ok.
>  > >  If no, please exit loop at hit.
>  >
>  > yes. need that handle range cross node (RAMDISK case that is end
>  > beyond end_of_ram).
>  >
>  Then, <addr, size> can spread across nodes.
>
>  IMHO, there are *big* memory hole between nodes in some systems.
>  This kind of interface, which allows alloc/free bootmem accross nodes,
>  will see terrible trouble when a programmer assumes  "alloc/free bootmem
>  always return contiguous size of memory" (This is guaranteed now,)
>
>  Does the new allocator (you changed ?) guarantee that returned <address, size>
>  is fully contiguous even if it spreads accross nodes ?
>
>  If no, NACK for this version.

i didn't change alloc_mem, it still get range from one node and continuous.

new free_bootmem could remove the assumpition in
setup_64.c::setup_arch:free_bootmem about node0
                        /* Assumes everything on node 0 */
                        free_bootmem(ramdisk_image, ramdisk_size);
                        printk(KERN_ERR "initrd extends beyond end of memory "
                               "(0x%08lx > 0x%08lx)\ndisabling initrd\n",
                               ramdisk_end, end_of_mem);
                        initrd_start = 0;

YH
