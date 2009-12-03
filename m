Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZLCTtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZLCTtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbZLCTtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:49:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005AbZLCTts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:49:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] uswsusp: automatically free the in-memory image once s2disk has finished with it
Date: Thu, 3 Dec 2009 20:50:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Mel Gorman <mel@csn.ul.ie>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <4B1575AC.6080904@tuffmail.co.uk> <20091203075301.GA29440@elf.ucw.cz> <4B17B5B8.1060105@tuffmail.co.uk>
In-Reply-To: <4B17B5B8.1060105@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912032050.33480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009, Alan Jenkins wrote:
> Pavel Machek wrote:
> > On Wed 2009-12-02 22:25:16, Mel Gorman wrote:
> >   
> >> On Wed, Dec 02, 2009 at 11:15:24PM +0100, Pavel Machek wrote:
> >>     
> >>> On Wed 2009-12-02 22:07:18, Mel Gorman wrote:
> >>>       
> >>>> On Wed, Dec 02, 2009 at 10:11:07PM +0100, Pavel Machek wrote:
> >>>>         
> >>>>> On Wed 2009-12-02 14:28:12, Alan Jenkins wrote:
> >>>>>           
> >>>>>> The original in-kernel suspend (swsusp) frees the in-memory hibernation
> >>>>>> image before powering off the machine.  s2disk doesn't, so there is
> >>>>>> _much_ less free memory when it tries to power off.
> >>>>>>
> >>>>>> This is a gratuitous difference.  The userspace suspend interface
> >>>>>> /dev/snapshot only allows the hibernation image to be read once.
> >>>>>> Once the s2disk program has read the last page, we can free the entire
> >>>>>> image.
> >>>>>>
> >>>>>> This avoids a hang after writing the hibernation image which was
> >>>>>> triggered by commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61
> >>>>>> "page-allocator: split per-cpu list into one-list-per-migrate-type":
> >>>>>>             
> >>>>> Yes, you work around page-allocator hang. But is it right thing to do?
> >>>>>
> >>>>>           
> >>>> What's wrong with it? The hang is likely because the allocator has no
> >>>> memory to work with. The patch in question makes small changes to the
> >>>> amount of available memory but it shouldn't matter on uni-core. Some
> >>>> structures are slightly larger but it's extremely borderline. I'm at a
> >>>> loss to explain actually why it makes a difference untill things were
> >>>> extremely borderline to begin with.
> >>>>         
> >>> We reserve 4MB, for such purposes, and we already wrote image to disk
> >>> with such constrains, so memory should not be _too_ tight.
> >>>
> >>> Can you try increasing PAGES_FOR_IO to 8MB or something like that?
> >>>
> >>>       
> >> What's wrong with just freeing the memory that is no longer required?
> >>     
> >
> > Nothing. But 4MB was enough to power down before, it is not enough
> > now, and I'd like to understand why.
> > 									Pavel
> >   
> 
> Here's a new datum:
> 
> Applying this patch has left a less frequent hang.  So far it has 
> happened twice.  (Once playing last night, and once today testing 
> hibernation with KMS enabled).
> 
> This hang happens at a different point.  It happens _before_ writing out 
> the hibernation image.  That is, I don't see the textual progress bar, 
> and if I force a power-cycle then it doesn't resume (and complains about 
> uncleanly unmounted filesystems).
> 
> Here is the backtrace:
> 
> [top of screen]
> s2disk D c1c05580 0 5988 5809 0x00000000
> ...
> Call Trace:
> ...
> ? wait_for_common
> ? default_wake_function
> ? kthread_create
> ? worker_thread
> ? create_workqueue_thread
> ? worker_thread
> ? __create_workqueue_thread
> ? stop_machine_create
> ? disable_nonboot_cpus
> ? hibernation_snapshot
> ? snapshot_ioctl
> ...
> ? sys_ioctl
> 
> 
> It looks like hibernation_snapshot() calls disable_nonboot_cpus() 
> _before_ we allocate the hibernation image.  (I.e. before 
> swsusp_arch_suspend(), which calls swsusp_save()).
> 
> So I think Pavel's right, we still need to work out what's happening here.

OK, patch dropped.

Thanks,
Rafael
