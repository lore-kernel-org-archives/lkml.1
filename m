Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZEYO6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZEYO6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZEYO5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:57:55 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44618 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZEYO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:57:55 -0400
Date: Mon, 25 May 2009 16:56:10 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2 bugs related to suspend to disk
In-Reply-To: <200905242158.15093.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0905251614160.4048@localhost.localdomain>
References: <4A199A7A.3010705@gmail.com> <200905242158.15093.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Erich Baier Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Sun, 24 May 2009, Rafael J. Wysocki wrote:

> On Sunday 24 May 2009, Marcin Slusarz wrote:
> > 1) echo platform > /sys/power/disk; echo disk > /sys/power/state
> > 
> > works but prints:
> > 
> > BUG: sleeping function called from invalid context at include/linux/writeback.h:87
> > in_atomic(): 1, irqs_disabled(): 0, pid: 6509, name: sh
> > 3 locks held by sh/6509:
> >  #0:  (&buffer->mutex){+.+.+.}, at: [<>] sysfs_write_file+0x38/0x119
> >  #1:  (pm_mutex){+.+.+.}, at: [<>] hibernate+0x17/0x169
> >  #2:  (swap_lock){+.+...}, at: [<>] swap_type_of+0x2e/0xed
> > Pid: 6509, comm: sh Not tainted 2.6.30-rc7-mod #124
> > Call Trace:
> >  ? __debug_show_held_locks
> >  ? bdev_test
> >  __might_sleep
> >  ifind
> >  ? bdev_test
> >  iget5_locked
> >  ? bdev_set
> >  bdget
> >  swap_type_of
> >  swsusp_write
> >  ? acpi_sleep_tts_switch
> >  hibernate
> >  state_store
> >  kobj_attr_store
> >  sysfs_write_file
> >  vfs_write
> >  sys_write
> >  system_call_fastpath
> > 
> > 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
> > 
> > It's not a regression, because I never tried to STD (STR worked).
> 
> Both look strange, at least the first one does.
> 
> Thanks for the report, I'll do my best to take care of this as soon as I can.
> 

i've seen a similar warning, the problem seems to be that swap_type_of 
calls bdget with the swap_lock held.

with the attached patch i don't see this warning any more - but i'm not 
sure if this is the correct way to fix this

regards, sebastian
---

don't call bdget with swap_lock held

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.5/mm/swapfile.c
===================================================================
--- linux-2.5.orig/mm/swapfile.c	2009-03-24 13:51:00.000000000 +0100
+++ linux-2.5/mm/swapfile.c	2009-05-25 15:33:34.000000000 +0200
@@ -634,10 +634,10 @@ int swap_type_of(dev_t device, sector_t 
 			continue;
 
 		if (!bdev) {
+			spin_unlock(&swap_lock);
 			if (bdev_p)
 				*bdev_p = bdget(sis->bdev->bd_dev);
 
-			spin_unlock(&swap_lock);
 			return i;
 		}
 		if (bdev == sis->bdev) {
@@ -646,10 +646,10 @@ int swap_type_of(dev_t device, sector_t 
 			se = list_entry(sis->extent_list.next,
 					struct swap_extent, list);
 			if (se->start_block == offset) {
+				spin_unlock(&swap_lock);
 				if (bdev_p)
 					*bdev_p = bdget(sis->bdev->bd_dev);
 
-				spin_unlock(&swap_lock);
 				bdput(bdev);
 				return i;
 			}
