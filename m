Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbYBAXWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbYBAXWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbYBAXWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:22:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:48309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762016AbYBAXWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:22:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BVWD4T4vWz4oVuN7djnl2t5NwUko7N/N6Blf7u9mmsIfo86nOwM3A1qevqaJdw6IF2/54GZ25LXhBcfZ3N0pa8sujv8/EUxGBR8Z+Nb4/aN0d3HrfavAZkAvsK9Q39j2WSFssSZ2ImdPPJjRkAQiqEUzyNCm6kPGWSjxBG4v77M=
Message-ID: <b647ffbd0802011522y3d4d779ambaf1a21f368ef74a@mail.gmail.com>
Date: Sat, 2 Feb 2008 00:22:35 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080201224852.GA16700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801272229.48955.rjw@sisk.pl> <200801280226.22013.rjw@sisk.pl>
	 <1201795128.32654.22.camel@lappy> <200801312154.33754.rjw@sisk.pl>
	 <1201867497.32654.49.camel@lappy>
	 <b647ffbd0802010711q744f5023mdbfccd9540556b70@mail.gmail.com>
	 <20080201171022.GC2159@elte.hu>
	 <b647ffbd0802011354ra2b9494ub59475abad4466aa@mail.gmail.com>
	 <b647ffbd0802011444n366c1537m7fb44acf0b848941@mail.gmail.com>
	 <20080201224852.GA16700@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2008, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
> > > I've observed delays from ~3 s. up to ~8 s. (out of ~20 tests) so
> > > the 10s. delay of msleep_interruptible() might be related but I'm
> > > still looking for the reason why this fix helps (and what goes wrong
> > > with the current code).
> >
> > heh... it's pretty obvious indeed. What's msleep_interruptible() is
> > all about? :-)
> >
> > "sleep waiting for signals"
> >
> > so the 'watchdog' thread gets woken up
> >
> > [ as a result of cpu_callback(action = CPU_DEAD) --> kthread_stop() ]
> >
> > just to be immediately scheduled out again for as long as the
> > remaining timeout > 0.
> >
> > So it should work if we substitute msleep_interruptible() with
> > schedule_timeout_interruptible().
>
> Doh. Could someone with ths problem please test the patch below, does it
> do the trick?

yeah, I was already on a half-way to check it out.

It does fix a problem for me.

Don't forget to take along these 2 fixes from Peter's patch:

- fix break usage in do_each_thread() { } while_each_thread().
- fix the hotplug switch stmt, a fall-through case was broken.


Rafael, does your system still hangs? I'd expect, yes -- as
effectively this fix is not that different from Peter's one when it
comes to suspend-case.

Can you then send your config? Anything special about this machine
(say, some /proc tunables are altered)?



>
>         Ingo
>

-- 
Best regards,
Dmitry Adamushko
