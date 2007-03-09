Return-Path: <linux-kernel-owner+w=401wt.eu-S1161359AbXCIAkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbXCIAkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161360AbXCIAkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:40:09 -0500
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:35343 "EHLO
	kepler.fjfi.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161359AbXCIAkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:40:07 -0500
Date: Fri, 9 Mar 2007 01:38:38 +0100 (CET)
From: Martin Drab <drab@kepler.fjfi.cvut.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: hugh@veritas.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Bryan O'Sullivan" <bos@serpentine.com>
Subject: Re: Question about memory mapping mechanism
In-Reply-To: <45F0AA09.8070503@goop.org>
Message-ID: <Pine.LNX.4.64.0703090137180.25365@kepler.fjfi.cvut.cz>
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
 <45F0AA09.8070503@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Jeremy Fitzhardinge wrote:

> Martin Drab wrote:
> > Hi,
> >
> > I'm writing a driver for a sampling device that is constantly delivering a 
> > relatively high amount of data (about 16 MB/s) and I need to deliver the 
> > data to the user-space ASAP. To prevent data loss I create a queue of 
> > buffers (consisting of few pages each) which are more or less directly 
> > filled by the device and then mapped to the user-space via mmap().
> >
> > The thing is that I'd like to prevent kernel to swap these pages out, 
> > because then I may loose some data when they are not available in time 
> > for the next round.
> >
> > My original idea (that used to work in the past) was to allocate the 
> > buffers using __get_free_pages(), then pin the pages down by setting their 
> > PG_reserved bit in the page flags before using them. And then set the 
> > VM_RESERVED flag of the appropriate VMA when mmap() is called for these 
> > pages that are then mapped using nopage() mechanism.
> >
> > But this way no longer seems to work correctly, it kind of works, but I'm 
> > getting following messages for each mmapped page upon munmap() call:
> >
> > --------------------------------------
> > [19172.939248] Bad page state in process 'dtrtest'
> > [19172.939249] page:ffff81000160a978 flags:0x001a000000000404 mapping:0000000000000000 mapcount:0 count:0
> > [19172.939251] Trying to fix it up, but a reboot is needed
> > [19172.939253] Backtrace:
> > [19172.939256]
> > [19172.939257] Call Trace:
> > [19172.939273]  [<ffffffff802adc37>] bad_page+0x57/0x90
> > [19172.939280]  [<ffffffff8020b92f>] free_hot_cold_page+0x7f/0x180
> > [19172.939287]  [<ffffffff80207a90>] unmap_vmas+0x450/0x750
> > [19172.939308]  [<ffffffff80212867>] unmap_region+0xb7/0x160
> > [19172.939318]  [<ffffffff80211918>] do_munmap+0x238/0x2f0
> > [19172.939325]  [<ffffffff802656c5>] __down_write_nested+0x35/0xf0
> > [19172.939334]  [<ffffffff80215ffd>] sys_munmap+0x4d/0x80
> > [19172.939341]  [<ffffffff8025f11e>] system_call+0x7e/0x83
> > -------------------------------
> >
> > Aparently due to the PG_reserved bit set.
> >
> > So my question is: What is currently a proper way to do all this cleanly?
> 
> Have you looked at the Infiniband stuff?  I know the folks working on
> the ipath driver eventually got this kind of thing working in a sane way.

I didn't. But I will, thanks a lot for the tip.

Martin
