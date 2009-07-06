Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZGFMPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZGFMPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZGFMPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:15:08 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51717 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbZGFMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:15:07 -0400
Date: Mon, 6 Jul 2009 21:14:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
Subject: Re: mmap syscall problem
Message-ID: <20090706121455.GA16908@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Michal Simek <michal.simek@petalogix.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	LTP <ltp-list@lists.sourceforge.net>,
	John Williams <john.williams@petalogix.com>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	subrata@linux.vnet.ibm.com
References: <4A4DFB77.1080700@petalogix.com> <200907031702.52612.arnd@arndb.de> <4A519A70.50801@petalogix.com> <200907061005.36094.arnd@arndb.de> <4A51E8EA.1050009@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A51E8EA.1050009@petalogix.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 02:07:06PM +0200, Michal Simek wrote:
> Arnd Bergmann wrote:
> > On Monday 06 July 2009, Michal Simek wrote:
> >   
> >>> Does this happen on microblaze-mmu or microblaze-nommu, or both?
> >>> The mmap code for the two is very different.
> >>>   
> >>>       
> >> For MMU code.
> >>     
> >
> > Could this be a cache-aliasing problem? If your cache is 'virtually-indexed'
> > (most architectures are 'physically-indexed'), the kernel may have written
> > into different parts of the D-cache than what the user space is reading
> > from. If you have a write-through cache, that can explain why you only
> > see the stale data at the beginning of the page -- the cache controller
> > is still busy writing back the data when you start reading it from
> > DRAM through the cache alias.
> >   
> I don't think so because we run that test on Microblaze without caches
> and test failed too.
> I think that this is sufficient test to tell that the problem is not
> relate with caches.
> 
Not necessarily, even on platforms that manage aliases in hardware
mappings that violate the aliasing constraints can still result in
undefined behaviour, this really depends more on your cache controller
and MMU than anything else. I notice that microblaze sets SHMLBA to
PAGE_SIZE, you may want to see if this test still breaks after bumping it
up to something like PAGE_SIZE * 4.

This is unfortunately one of the areas where what POSIX says is possible
and what hardware can support are at odds (you can look through
arch/sh/mm/mmap.c for a better idea).
