Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbYBAWoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbYBAWoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYBAWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:44:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:5075 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbYBAWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BiawxIaU6Ygq/FmzWPElquRTvUQLkS3Dntd0O2yh3dG4bGKxvcoTv0lGNKosQ13MPBMU3G0QNAsRny98BuSdCs1GjY2pY7Z2mk7uBvw4kl2aHAdYuvtP3BmikP6WIxeb8lPgiogO664US8GNpu8mHvKYuZCIx/IFd1i2b0jFTa0=
Message-ID: <b647ffbd0802011444n366c1537m7fb44acf0b848941@mail.gmail.com>
Date: Fri, 1 Feb 2008 23:44:12 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation on x86-64 (bisected)
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0802011354ra2b9494ub59475abad4466aa@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2008, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> On 01/02/2008, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > thanks - i cannot reproduce it on my usual suspend/resume testbox
> > because e1000 broke on it, and this is a pretty annoying regression.
> > We'll have to undo the hung-tasks detection feature if it's not fixed
> > quickly. (there's no point in debugging features that _add_ bugs)
>
> I can reproduce it and Peter's patch does fix it for me.
>
> e.g.
> root@earth:/sys/devices/system/cpu/cpu1# time echo 0 > online
> real    0m6.743s
> root@earth:/sys/devices/system/cpu/cpu1# time echo 0 > online
> real    0m7.770s
>
> I've observed delays from ~3 s. up to ~8 s. (out of ~20 tests) so the
> 10s. delay of msleep_interruptible() might be related but
> I'm still looking for the reason why this fix helps (and what goes
> wrong with the current code).
>

heh... it's pretty obvious indeed. What's msleep_interruptible() is
all about? :-)

"sleep waiting for signals"

so the 'watchdog' thread gets woken up

[ as a result of cpu_callback(action = CPU_DEAD) --> kthread_stop() ]

just to be immediately scheduled out again for as long as the
remaining timeout > 0.

So it should work if we substitute msleep_interruptible() with
schedule_timeout_interruptible().


-- 
Best regards,
Dmitry Adamushko
