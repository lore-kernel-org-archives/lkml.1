Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZA2Mi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZA2Mi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 07:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZA2MiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 07:38:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41503 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZA2MiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 07:38:20 -0500
Date: Thu, 29 Jan 2009 13:38:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
Message-ID: <20090129123804.GA22239@elte.hu>
References: <20090127132759.GI23121@elte.hu> <20090127134128.GA24965@elte.hu> <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop> <1233082650.4455.9.camel@johannes.local> <1233130815.10992.39.camel@laptop> <1233136487.4151.5.camel@johannes.local> <1233137581.10992.44.camel@laptop> <1233140081.3936.21.camel@johannes.local> <1233166017.4811.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233166017.4811.9.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2009-01-28 at 11:59 +0100, Johannes Berg wrote:
> 
> > > > I actually got "trying to register non-static key" on my powerpc64
> > > > machine. Is there a possibility that functions are not static??
> > > 
> > > Hmm, weird, afaict static_obj() includes both text and data, for the
> > > core kernel as well as modules.
> > 
> > Yeah, I'd think it should. I'll run it by the powerpc list when I get it
> > again, it only seems to happen very rarely.
> 
> It's actually a generic bug.
> 
> delayed work structs are initialised like this:
> 
> #define __DELAYED_WORK_INITIALIZER(n, f) {                      \
>         .work = __WORK_INITIALIZER((n).work, (f)),              \
>         .timer = TIMER_INITIALIZER(NULL, 0, 0),                 \
>         }
> 
> #define DECLARE_DELAYED_WORK(n, f)                              \
>         struct delayed_work n = __DELAYED_WORK_INITIALIZER(n, f)
> 
> 
> Note the NULL function, which I used for the key of timers. Thus, the
> key is NULL, and the name is "NULL".
> 
> Now, this means that my code for the run timer:
> 
> 				struct lockdep_map lockdep_map =
> 					timer->lockdep_map;
> 
> will actually have lockdep_map here with a NULL key. Once it gets into
> 
> 			lock_map_acquire(&lockdep_map);
> 
> it'll try to register &lockdep_map as the key.
> 
> Interestingly, that doesn't seem to be a problem on x86_64, which would
> appear to be a bug, the stack certainly isn't a static location.
> 
> The patch below fixes it by using the file/lineno of the static
> definition as both the name and the key -- using it as the name means
> you have a good chance of finding it if something goes wrong, and using
> it as the key means we have a good key for it. The patch looks horrible
> though. Any better ideas? If not, I think we should roll this into the
> original patch.

I suspect this invalidates v3 - mind resending a full v4 patch?

	Ingo
