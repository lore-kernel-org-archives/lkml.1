Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZEYV37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZEYV37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZEYV3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:29:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40765 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbZEYV3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:29:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: [linux-pm] 2 bugs related to suspend to disk
Date: Mon, 25 May 2009 23:29:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <4A199A7A.3010705@gmail.com> <200905242158.15093.rjw@sisk.pl> <alpine.LFD.2.00.0905251614160.4048@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905251614160.4048@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252329.51274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Sebastian Ott wrote:
> hi,
> 
> On Sun, 24 May 2009, Rafael J. Wysocki wrote:
> 
> > On Sunday 24 May 2009, Marcin Slusarz wrote:
> > > 1) echo platform > /sys/power/disk; echo disk > /sys/power/state
> > > 
> > > works but prints:
> > > 
> > > BUG: sleeping function called from invalid context at include/linux/writeback.h:87
> > > in_atomic(): 1, irqs_disabled(): 0, pid: 6509, name: sh
> > > 3 locks held by sh/6509:
> > >  #0:  (&buffer->mutex){+.+.+.}, at: [<>] sysfs_write_file+0x38/0x119
> > >  #1:  (pm_mutex){+.+.+.}, at: [<>] hibernate+0x17/0x169
> > >  #2:  (swap_lock){+.+...}, at: [<>] swap_type_of+0x2e/0xed
> > > Pid: 6509, comm: sh Not tainted 2.6.30-rc7-mod #124
> > > Call Trace:
> > >  ? __debug_show_held_locks
> > >  ? bdev_test
> > >  __might_sleep
> > >  ifind
> > >  ? bdev_test
> > >  iget5_locked
> > >  ? bdev_set
> > >  bdget
> > >  swap_type_of
> > >  swsusp_write
> > >  ? acpi_sleep_tts_switch
> > >  hibernate
> > >  state_store
> > >  kobj_attr_store
> > >  sysfs_write_file
> > >  vfs_write
> > >  sys_write
> > >  system_call_fastpath
> > > 
> > > 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
> > > 
> > > It's not a regression, because I never tried to STD (STR worked).
> > 
> > Both look strange, at least the first one does.
> > 
> > Thanks for the report, I'll do my best to take care of this as soon as I can.
> > 
> 
> i've seen a similar warning, the problem seems to be that swap_type_of 
> calls bdget with the swap_lock held.

Well, it didn't cause any problems in the past.

> with the attached patch i don't see this warning any more - but i'm not 
> sure if this is the correct way to fix this

I'll have a look, thanks for the patch.

> regards, sebastian
> ---
> 
> don't call bdget with swap_lock held
> 
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
> ---
>  mm/swapfile.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.5/mm/swapfile.c
> ===================================================================
> --- linux-2.5.orig/mm/swapfile.c	2009-03-24 13:51:00.000000000 +0100
> +++ linux-2.5/mm/swapfile.c	2009-05-25 15:33:34.000000000 +0200
> @@ -634,10 +634,10 @@ int swap_type_of(dev_t device, sector_t 
>  			continue;
>  
>  		if (!bdev) {
> +			spin_unlock(&swap_lock);
>  			if (bdev_p)
>  				*bdev_p = bdget(sis->bdev->bd_dev);
>  
> -			spin_unlock(&swap_lock);
>  			return i;
>  		}
>  		if (bdev == sis->bdev) {
> @@ -646,10 +646,10 @@ int swap_type_of(dev_t device, sector_t 
>  			se = list_entry(sis->extent_list.next,
>  					struct swap_extent, list);
>  			if (se->start_block == offset) {
> +				spin_unlock(&swap_lock);
>  				if (bdev_p)
>  					*bdev_p = bdget(sis->bdev->bd_dev);
>  
> -				spin_unlock(&swap_lock);
>  				bdput(bdev);
>  				return i;
>  			}
> --

Best,
Rafael
