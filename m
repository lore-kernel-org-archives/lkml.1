Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbYB1WPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbYB1WPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762030AbYB1WOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:14:41 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761757AbYB1WOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:14:40 -0500
Date: Thu, 28 Feb 2008 14:13:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: segher@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       johnstul@us.ibm.com
Subject: Re: [PATCH] Prevent the loop in timespec_add_ns() to be optimised
 away
Message-Id: <20080228141310.387f077b.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802282257490.3111@apollo.tec.linutronix.de>
References: <6a95d77ad55b29ff2d856c9e1f7dd79682370300.1203715782.git.segher@kernel.crashing.org>
	<20080227154341.824efe3c.akpm@linux-foundation.org>
	<alpine.LFD.1.00.0802282257490.3111@apollo.tec.linutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 22:58:49 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 27 Feb 2008, Andrew Morton wrote:
> 
> > On Fri, 22 Feb 2008 22:40:45 +0100
> > Segher Boessenkool <segher@kernel.crashing.org> wrote:
> > 
> > > ...since some architectures don't support __udivdi3() (and
> > > we don't want to use that, anyway).
> > > 
> > > Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
> > > ---
> > >  include/linux/time.h |    4 ++++
> > >  1 files changed, 4 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/time.h b/include/linux/time.h
> > > index 2091a19..d32ef0a 100644
> > > --- a/include/linux/time.h
> > > +++ b/include/linux/time.h
> > > @@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
> > >  {
> > >  	ns += a->tv_nsec;
> > >  	while(unlikely(ns >= NSEC_PER_SEC)) {
> > > +		/* The following asm() prevents the compiler from
> > > +		 * optimising this loop into a modulo operation.  */
> > > +		asm("" : "+r"(ns));
> > > +
> > >  		ns -= NSEC_PER_SEC;
> > >  		a->tv_sec++;
> > >  	}
> > 
> > It's pretty sad that we need to turn this into a loop just because of the
> > __udivdi3() thing.
> > 
> > otoh, it's rarely occurring, and it could be that the number of times it
> > loops is usually 1 (if it wasn't zero), so perhaps a loop is faster than a
> > divide anyway.
> > 
> > This code is probably too large to be inlined.
> > 
> > I queued this patch as needed-in-2.6.25, to-be-merged-via-Thomas.
> 
> Are you going to send it or should I grab it from the mailing list
> myself ?
> 

My secret-undocumented protocol for handling a patch which I think is
needed in 2.6.current and which is handled via a subsystem tree is:

- queue it up behind all the subsystem trees in -mm's "2.6.25:" section

  - actually it's now "2.6.25"'s "others:" section.  I've split the
    "2.6.25:" section into two parts: "me:" and "others:".

- drop it if it turns up in a subsystem tree

  - and hope like hell that whoever merged it has considered whether
    it's needed in the current kernel cycle, because I just lost track of
    it.

- let it cook for a few days or more, to give time for people to comment,
  and perhaps to get it into a -mm release

- send it out to the subsystem maintainer tagged as "[patch (for 2.6.25?)]"

- repeat.


patches which I currently have in this state are:

x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
x86-fix-clearcopy_user_page-declarations-in-pageh.patch
x86-visws-fix-printk-format-warnings.patch
mpt-fusion-dont-oops-if-numphys==0.patch
bluetooth-hci_core-defer-hci_unregister_sysfs.patch
e100-do-suspend-shutdown-like-e1000.patch
dm-raid1-bitops-bug.patch
iova-lockdep-false-alarm-fix.patch
bluetooth-conwise-technology-based-adapters-with-buggy-sco-support-bugzilla-9027.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
fix-typo-in-tick-broadcastc.patch
i8042-use-sgi_has_i8042-to-select-sgi-i8042-handlinig.patch
fix-b43-driver-build-for-arm.patch
apanel-fix-kconfig-dependencies.patch
de2104x-remove-bug_on-when-changing-media-type.patch
scsi-fix-cd-burning-regression.patch
arm-fix-freeing-of-page-tables-in-free_pgd_slow.patch
time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch
acpi-ec-fix-regression.patch
drivers-acpi-asus_acpic-correct-use-of-and.patch
drivers-media-video-em28xx-correct-use-of-and.patch
drivers-media-video-em28xx-correct-use-of-and-fix.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
scsi-arcmsr-update-driver-version.patch


the way to stop me from continuing to loop is to send me an "acked-by,
please send to Linus for 2.6.25".

I'll then move the patch into -mm's "me:" section (or even right up next to
origin.patch if it's simple-and-obvious) for sending to LT.

