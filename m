Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZLNLIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZLNLIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbZLNLIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:08:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35404 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbZLNLIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:08:47 -0500
Date: Mon, 14 Dec 2009 12:08:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH] uswsusp: automatically free the in-memory image once
 s2disk has finished with it
Message-ID: <20091214110835.GA1937@elf.ucw.cz>
References: <4B16797C.3010304@tuffmail.co.uk>
 <20091202211107.GA20830@elf.ucw.cz>
 <20091202220718.GI1457@csn.ul.ie>
 <20091202221524.GB20830@elf.ucw.cz>
 <20091202222516.GD26702@csn.ul.ie>
 <20091203075301.GA29440@elf.ucw.cz>
 <4B17B5B8.1060105@tuffmail.co.uk>
 <20091203145018.GG26702@csn.ul.ie>
 <9b2b86520912071637v6957ed24ie0f67acf6785ab08@mail.gmail.com>
 <20091211105352.GB30670@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211105352.GB30670@csn.ul.ie>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-11 10:53:52, Mel Gorman wrote:
> On Tue, Dec 08, 2009 at 12:37:36AM +0000, Alan Jenkins wrote:
> > >> <SNIP>
> > >> Here's a new datum:
> > >>
> > >> Applying this patch has left a less frequent hang.  So far it has
> > >> happened twice.  (Once playing last night, and once today testing
> > >> hibernation with KMS enabled).
> > >>
> > >> This hang happens at a different point.  It happens _before_ writing out
> > >> the hibernation image.  That is, I don't see the textual progress bar,
> > >> and if I force a power-cycle then it doesn't resume (and complains about
> > >> uncleanly unmounted filesystems).
> > >>
> > >> Here is the backtrace:
> > >>
> > >> [top of screen]
> > >> s2disk D c1c05580 0 5988 5809 0x00000000
> > >> ...
> > >> Call Trace:
> > >> ...
> > >> ? wait_for_common
> > >> ? default_wake_function
> > >> ? kthread_create
> > >> ? worker_thread
> > >> ? create_workqueue_thread
> > >> ? worker_thread
> > >> ? __create_workqueue_thread
> > >> ? stop_machine_create
> > >> ? disable_nonboot_cpus
> > >> ? hibernation_snapshot
> > >> ? snapshot_ioctl
> > >> ...
> > >> ? sys_ioctl
> > >>
> > 
> > > Can you reconfirm that backing out both of those patches makes this 100%
> > > reliable or is it just a lot harder to trigger. It does not even appear
> > > that it's locked up within the page allocator at this trace message.
> > > Assuming c1c05580 is where it's stuck at, where does addr2line say that
> > > is (requires CONFIG_DEBUG_INFO) ?
> > 
> > The new hang happened with only one patch applied (my "uswsusp:
> > automatically free the in-memory image once s2disk has finished with
> > it").
> > 
> 
> Ok. I'm learning towards believing that the system is extremely
> borderline and what c1c05580 is doing is changing very slightly how many
> pages are available. Why it makes a difference on uni-core, I have no
> idea but it could be very small differences in available memory as it
> does increase the size of some in-kernel structures.

It should be very easy to test that theory, right? Just reduce
PAGES_FOR_IO to 3.9MB, and if it breaks, you know system was
borderline. 
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
