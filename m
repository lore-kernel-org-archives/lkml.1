Return-Path: <linux-kernel-owner+w=401wt.eu-S1760835AbXK1KrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760835AbXK1KrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbXK1KrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:47:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39298 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbXK1KrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:47:00 -0500
Date: Wed, 28 Nov 2007 11:46:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Albert Cahalan <acahalan@gmail.com>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@tv-sign.ru,
       rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Message-ID: <20071128104622.GB19694@elte.hu>
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org> <20071128014901.4b303954@inria.fr> <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Albert Cahalan <acahalan@gmail.com> wrote:

> On Nov 27, 2007 7:49 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:
> > akpm@linux-foundation.org wrote:
> >
> > > We may be stuck with the current broken behavior for backwards
> > > compatibility reasons but lets try fixing our ancient bug for the 2.6.25
> > > time frame and see if anyone screams.
> 
> It's not broken. It's just not the feature you're looking for.

well it's quite broken at the moment and we are looking for solutions 
not for a blame game :-) You might have read the thread where i describe 
what i had to go through to do something fairly trivial.

> > Ccing Albert Cahalan as he made the change to /proc/self in the first
> > place:
> 
> Changing /proc/self is somewhat risky, and probably
> undesirable anyway. That file has always been used
> to represent the process; at one time this also meant
> the task. Documentation everywhere says "process".

in Linux we never truly had a notion of "process" when your change was 
done - "process" always meant the task itself. That's why all the 
task_struct parameters/variables used to be named 'p', not 't'. So when 
NTPL came around this became a poorly defined notion.

> This one is probably best:
> /proc/task -> 123/task/456
> (with both numbers showing)

this sounds good to me. If it's a symlink then there's not much other 
choice because the thread PIDs do not even show up under /proc anymore.

> The problem with /proc/self/task/self is that it
> makes /proc/789/task/self be ill-defined when
> the observer is not tgid 789. If the directory can
> only show up in the observer's own task directory,
> then this solution is good.

agreed.

> I really don't want to see anything that would encourage
> more use of the gdb backdoor. For those that don't
> remember, gdb broke when access to threads via the
> top-level /proc directory was temporarily removed.
> We need that back door, unfortunately, but having it
> show up in symlink targets is quite nasty.
> 
> As for the history:
> 
> I left it out. At the time it would have been fairly useless.
> Back then, glibc didn't make things painful by pulling
> phony thread IDs out of its ass. Shell scripts sure didn't
> deal in threads. Monitoring tools like "ps" didn't need it.
> If nothing needs it, well, why have it?

sound, future-proof API design, with a little bit of foresight? I am 
faced with incidents on an almost daily basis that show how much we 
kernel folks suck at defining new APIs. The only luck is that the set of 
system calls is fairly complete already - but in the rare case where we 
touch an API it's a catastrophy most of the time. With such an API track 
record we'd probably never survive as a user-space project.

	Ingo
