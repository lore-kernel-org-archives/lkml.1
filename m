Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbZLKKxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbZLKKxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760953AbZLKKxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:53:52 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37193 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbZLKKxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:53:51 -0500
Date: Fri, 11 Dec 2009 10:53:52 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] uswsusp: automatically free the in-memory image once
	s2disk has finished with it
Message-ID: <20091211105352.GB30670@csn.ul.ie>
References: <20091202122019.GD1457@csn.ul.ie> <4B16797C.3010304@tuffmail.co.uk> <20091202211107.GA20830@elf.ucw.cz> <20091202220718.GI1457@csn.ul.ie> <20091202221524.GB20830@elf.ucw.cz> <20091202222516.GD26702@csn.ul.ie> <20091203075301.GA29440@elf.ucw.cz> <4B17B5B8.1060105@tuffmail.co.uk> <20091203145018.GG26702@csn.ul.ie> <9b2b86520912071637v6957ed24ie0f67acf6785ab08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <9b2b86520912071637v6957ed24ie0f67acf6785ab08@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 12:37:36AM +0000, Alan Jenkins wrote:
> >> <SNIP>
> >> Here's a new datum:
> >>
> >> Applying this patch has left a less frequent hang.  So far it has
> >> happened twice.  (Once playing last night, and once today testing
> >> hibernation with KMS enabled).
> >>
> >> This hang happens at a different point.  It happens _before_ writing out
> >> the hibernation image.  That is, I don't see the textual progress bar,
> >> and if I force a power-cycle then it doesn't resume (and complains about
> >> uncleanly unmounted filesystems).
> >>
> >> Here is the backtrace:
> >>
> >> [top of screen]
> >> s2disk D c1c05580 0 5988 5809 0x00000000
> >> ...
> >> Call Trace:
> >> ...
> >> ? wait_for_common
> >> ? default_wake_function
> >> ? kthread_create
> >> ? worker_thread
> >> ? create_workqueue_thread
> >> ? worker_thread
> >> ? __create_workqueue_thread
> >> ? stop_machine_create
> >> ? disable_nonboot_cpus
> >> ? hibernation_snapshot
> >> ? snapshot_ioctl
> >> ...
> >> ? sys_ioctl
> >>
> 
> > Can you reconfirm that backing out both of those patches makes this 100%
> > reliable or is it just a lot harder to trigger. It does not even appear
> > that it's locked up within the page allocator at this trace message.
> > Assuming c1c05580 is where it's stuck at, where does addr2line say that
> > is (requires CONFIG_DEBUG_INFO) ?
> 
> The new hang happened with only one patch applied (my "uswsusp:
> automatically free the in-memory image once s2disk has finished with
> it").
> 

Ok. I'm learning towards believing that the system is extremely
borderline and what c1c05580 is doing is changing very slightly how many
pages are available. Why it makes a difference on uni-core, I have no
idea but it could be very small differences in available memory as it
does increase the size of some in-kernel structures.

> I was able to capture a longer version of the above backtrace by using
> KMS [1].  This pre-writeout hang is similar to the post-writeout hang
> which occurred on vanilla 2-6.32-rc8 [2].  In both cases the s2disk
> process is hanging in disable_nonboot_cpus().  [Which is in turn
> blocked on stop_machine_create(), which is apparently failing to
> allocate pages for a new task].  The only difference is where
> disable_nonboot_cpus() is called from.
> 
> And then, the problem went away :-(.  I was unable to reproduce either
> hang, even using the same unpatched kernel binaries as before.  Sorry.
> 
> [1] Infrequent pre-writeout hang (new, longer backtrace):
> <http://picasaweb.google.com/Alan.Christopher.Jenkins/Screenshots#5412613393538769410>
> 
> [2] Frequent post-writeout hang:
> <http://picasaweb.google.com/Alan.Christopher.Jenkins/Screenshots#5410594126006567282>
> 
> > On Thu, Dec 03, 2009 at 12:57:28PM +0000, Alan Jenkins wrote:
> >> It looks like hibernation_snapshot() calls disable_nonboot_cpus()
> >> _before_ we allocate the hibernation image.  (I.e. before
> >> swsusp_arch_suspend(), which calls swsusp_save()).
> >>
> 
> Sorry, I was wrong here.  The hang occurs after "PM: Preallocating
> image memory...".  So it's a bit less mysterious; we can expect to be
> low on memory at this point (although it's still a mystery why we
> should run out completely).
> 
> > I'm not that familiar with the area but considering where we are getting
> > stuck and what the path affected, I thought it might be CPU related.
> > There is a patch below that prints debugging messages to show how the
> > CPU is being taken down with respect to PCP draining in case something
> > has changed there. It also puts in some debugging code in the most
> > likely place to be infinite looping due to the patch.
> >
> >> So I think Pavel's right, we still need to work out what's happening here.
> >>
> >
> > Can you apply the following patch please and retry?
> >
> > Two things to watch out for. First, do either of the BUG_ON triggers?
> > Second, for the TRACE messages, do they always appear in the order of
> > "draining pages" and then "deleting pagesets"?
> 
> I went ahead and tried this, even though I couldn't reproduce the hang anymore.
> 
> It didn't BUG.  It didn't show any TRACEs either.  I guess the cpu
> notifiers weren't called at all, since no cpu hotplug is necessary on
> my uni-core system.
> 

Ok, at least it's not something that is obviously very wrong.

> So...
> It looks like I can't provide any more data.
> 
> I can confidently say that post-writeout hangs would be avoided by my
> patch.   But I don't think we want to apply it, because it didn't
> solve the pre-writeout hang - which appears to have a similar root
> cause. 

I think the underlying cause is very tight memory space. A reasonable
approach is to apply your patch for the post-writeout case because why
hold onto a large chunk of memory that is not in use? For the
pre-writeout pause, up the PAGES_FOR_IO. It wouldn't be the first time
the kernels memory requirements grew :(

> The post-writeout hang happened to be easier to reproduce, and
> it was better in that it didn't cause data loss / fsck (the system
> could still resume).
> 
> As a curious tester, I would favour not increasing PAGES_FOR_IO on
> similar grounds. Call me naive but 4Mb should be plenty, at least for
> this system. That said, I wouldn't mind if we reserve an extra 4Mb to
> avoid the hang, _and then abort the hibernation if we actually have to
> use it_.  (We can't simply print a warning message; no-one would see
> it because it wouldn't survive the power-down).
> 

At one level, I can see your point. It'd prove for example that the low
memory was the problem but how should a user respond when hibernation
fails because 4MB was not enough?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
