Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbYKKONN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbYKKONN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbYKKOM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:12:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbYKKOM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:12:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Date: Tue, 11 Nov 2008 15:17:53 +0100
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20081109140726.GB1786@ucw.cz> <200811101928.04565.rjw@sisk.pl> <20081111103043.GD5464@elf.ucw.cz>
In-Reply-To: <20081111103043.GD5464@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111517.54470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Pavel Machek wrote:
> On Mon 2008-11-10 19:28:03, Rafael J. Wysocki wrote:
> > On Monday, 10 of November 2008, Andi Kleen wrote:
> > > Ingo Molnar <mingo@elte.hu> writes:
> > > >
> > > > No good ideas - the bug description gives me the impression of memory 
> > > > maps save/restore hickup in the hibernation code - and memory maps are 
> > > > pretty much the only thing that are significantly different on NUMA. 
> > > 
> > > I assume the problem happened on a single node system.
> > > On single node the memory map should be actually quite similar
> > > to the UMA case.
> > 
> > It is.  However, the problem is 100% reproducible on any 32-bit single-node
> > system with CONFIG_NUMA set, from what I can tell.
> > 
> > It doesn't happen if the kernel is booted with highmem=0, so it looks like
> > the code that saves highmem causes the problem to happen.  However, this
> > same code works well for all of the !CONFIG_NUMA cases and practically only
> > the only non-open-coded it uses is kmap_atomic().
> 
> kmap_atomic() and kernel_map_pages(), AFAICT.
> 
> Can kmap_atomic() modify pages in highmem, too?
> 
> Wait... are we putting kernel pagetables in the high memory?
> 
> What about this cleanup (warning: untested)

Yes, I have this queued up and actually tested.

Thanks,
Rafael

 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 5d2ab83..f1d8336 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -966,7 +966,7 @@ static void copy_data_page(unsigned long
>  			 * data modified by kmap_atomic()
>  			 */
>  			safe_copy_page(buffer, s_page);
> -			dst = kmap_atomic(pfn_to_page(dst_pfn), KM_USER0);
> +			dst = kmap_atomic(d_page, KM_USER0);
>  			memcpy(dst, buffer, PAGE_SIZE);
>  			kunmap_atomic(dst, KM_USER0);
>  		} else {
> 
> 									Pavel



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan
