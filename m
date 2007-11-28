Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbXK1SOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbXK1SOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXK1SOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:14:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:23329 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXK1SOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O7PjMNtU5zpZx5i6m1T4s24gnO2fVEdfPhgYoB6uOPdlGfg4dJ6pVmmWjYwgtU1gND18HaP8AVl+0xCQIIxMfMYYPAV0XGRUuTF1Yn/E9SPqpDkVIT2QturmXM2icjE96ibwMzPT6f8OnfVBrCgP2LhdtLr6YpAmgOoR230dy90=
Message-ID: <787b0d920711281014i76f182b7xaba100247e4ee79a@mail.gmail.com>
Date: Wed, 28 Nov 2007 13:14:29 -0500
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Cc: "Guillaume Chazarain" <guichaz@yahoo.fr>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@tv-sign.ru,
       rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20071128104622.GB19694@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	 <20071128014901.4b303954@inria.fr>
	 <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
	 <20071128104622.GB19694@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 28, 2007 5:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Albert Cahalan <acahalan@gmail.com> wrote:
> > On Nov 27, 2007 7:49 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:
> > > akpm@linux-foundation.org wrote:
> > >
> > > > We may be stuck with the current broken behavior for backwards
> > > > compatibility reasons but lets try fixing our ancient bug for the 2.6.25
> > > > time frame and see if anyone screams.
> >
> > It's not broken. It's just not the feature you're looking for.
>
> well it's quite broken at the moment and we are looking for solutions
> not for a blame game :-) You might have read the thread where i describe
> what i had to go through to do something fairly trivial.

In some ways that is NOT trivial, given that a high-level
language is free to use N:M threading.

If we assume that isn't allowed though, blaming the library
for not using native Linux thread IDs is entirely reasonable.
Linus picked sane ID numbering, not Solaris-style. Normal
app developers are unable to take advantage of Linus'
wise decision.

> > Changing /proc/self is somewhat risky, and probably
> > undesirable anyway. That file has always been used
> > to represent the process; at one time this also meant
> > the task. Documentation everywhere says "process".
>
> in Linux we never truly had a notion of "process" when your change was
> done - "process" always meant the task itself. That's why all the
> task_struct parameters/variables used to be named 'p', not 't'. So when
> NTPL came around this became a poorly defined notion.

We were sort of settling on "struct signal" as the process.

> > This one is probably best:
> > /proc/task -> 123/task/456
> > (with both numbers showing)
>
> this sounds good to me. If it's a symlink then there's not much other
> choice because the thread PIDs do not even show up under /proc anymore.
>
> > The problem with /proc/self/task/self is that it
> > makes /proc/789/task/self be ill-defined when
> > the observer is not tgid 789. If the directory can
> > only show up in the observer's own task directory,
> > then this solution is good.
>
> agreed.
>
> > I really don't want to see anything that would encourage
> > more use of the gdb backdoor. For those that don't
> > remember, gdb broke when access to threads via the
> > top-level /proc directory was temporarily removed.
> > We need that back door, unfortunately, but having it
> > show up in symlink targets is quite nasty.
> >
> > As for the history:
> >
> > I left it out. At the time it would have been fairly useless.
> > Back then, glibc didn't make things painful by pulling
> > phony thread IDs out of its ass. Shell scripts sure didn't
> > deal in threads. Monitoring tools like "ps" didn't need it.
> > If nothing needs it, well, why have it?
>
> sound, future-proof API design, with a little bit of foresight?

Yes, in a way. Adding stuff is usually easier than removing
stuff. I couldn't decide between /proc/self/task/self and /proc/task,
so I left the decision for later. I wasn't sure that I'd thought of
all the issues.

> I am
> faced with incidents on an almost daily basis that show how much we
> kernel folks suck at defining new APIs. The only luck is that the set of
> system calls is fairly complete already - but in the rare case where we
> touch an API it's a catastrophy most of the time. With such an API track
> record we'd probably never survive as a user-space project.

Most of user-space is worse.

What shocks me is that people keep designing ABIs with structs
that contain holes. (data leaks, waste, portability trouble, etc.)
This happens in kernel ABIs all the time. It ought to be blocked
by some sort of build tool. (with a whitelist for old stuff)

Another shocker is /proc/*/smaps, which should make you cry.
At the time I was working too much overtime to post about it,
and I figured that nobody would allow that into the kernel anyway...

Speaking of which, that's one that has no need to be in the task
directories. I put a maps file there to make porting old code easier,
but neither one really belongs. It's per-mm, which was in a 1:n
relationship with struct signal last I checked.
