Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbXK3Hoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbXK3Hoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 02:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXK3HoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 02:44:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:29223 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbXK3HoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 02:44:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wher+D0LeX8R0o4dSsI9KSvQ7XdwSIIKjO+zHN2a72dZr2NrbzaihNjqgPDLwjWqcGEzppT83T3JZ99ndm8RZ0nG/wFOx0Nuxu+smzoRE7KRrJrpYVbX9zto9jfuGELoQce+YNYMizSTV8yKEW3Pvzv7x0tJp7ePZwvpDjbx0r4=
Message-ID: <787b0d920711292344y43c9bc1cs2505a800617ecf86@mail.gmail.com>
Date: Fri, 30 Nov 2007 02:44:12 -0500
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Cc: "Ingo Molnar" <mingo@elte.hu>, "Guillaume Chazarain" <guichaz@yahoo.fr>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, oleg@tv-sign.ru,
       rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <m1hcj4buim.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	 <20071128014901.4b303954@inria.fr>
	 <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
	 <20071128104622.GB19694@elte.hu>
	 <m1ve7mehcm.fsf@ebiederm.dsl.xmission.com>
	 <787b0d920711280947g418330faie5c96293102c3f05@mail.gmail.com>
	 <m1hcj4buim.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 4:40 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Albert Cahalan" <acahalan@gmail.com> writes:
>
> > On Nov 28, 2007 6:31 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Ingo Molnar <mingo@elte.hu> writes:
> >> > * Albert Cahalan <acahalan@gmail.com> wrote:
> >> >> On Nov 27, 2007 7:49 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> Linux tasks when used in one particular way can fulfill the posix
> requirements for single threaded processes.
>
> Linux task groups when used in one particular way can fulfill the
> posix requirements for processes.

Right. Once you leave this, weirdness happens.
POSIX defines things in terms of processes and threads.
POSIX defines many of our interfaces. That includes
kernel behavior, the C library, and numerous programs.

> As for where /proc/self points given that procps seems to read
> files like /proc/self/stat.  It looks to me like we have a clear
> case of a user space application that cares about the current
> behavior and would break if we changed things.

I wasn't saying procps would break, though it would if
/proc/self/task went away. I'm more concerned about
multi-threaded things that look in their own /proc/self
directory. The procps programs are single-threaded.

In procps, the self link is used:

a. to see if the wchan file exists
b. to see if the task directory exists
c. to find the tty number

(that last one: there might not be a file descriptor
for the tty, and anyway I need it with the bits in all
the same places as what I get for the other processes)

I'll bet that something reads /proc/self/stat to see
CPU usage.

> > Note that it was intended that non-legacy additions
> > would normally be added to either the process directory
> > or the thread directory, not both. I think somebody may
> > have ripped out the ability to do this; at the very least
> > there have been numerous illogical additions.
>
> The rationale was not conveyed and the policy you describe
> seems like deprecating the /proc/<tgid> directory in favor
> of the /proc/<tgid>/task/<pid>/.  Which was a pattern
> never established and it doesn't seem to make anything better
> so I don't see the point there.

For the stuff that is logically per-task, yes.
For the rest, no. Oh well...

It does make things better because redundant info
is a source of confusion.

> >> I'm still trying to understand which will break user space more,
> >> adding /proc/task or changing /proc/self.
> >
> > Changing /proc/self makes you get per-thread data
> > when you asked for per-process data. That's bad.
>
> /proc/self used to ask for per task data.  Which is why there
> is some confusion.

Heh. Well, /proc/self used to ask for per process data.
It was all the same. I think it matters that /proc/self was
always documented as being per-process.

> >> >> This one is probably best:
> >> >> /proc/task -> 123/task/456
> >> >> (with both numbers showing)
> >> >
> >> > this sounds good to me. If it's a symlink then there's not much other
> >> > choice because the thread PIDs do not even show up under /proc anymore.
> >>
> >> The name sounds good to me.
>
> I will see about writing the patch for this in a bit and sending
> it to Andrew.

Nice.

> Nope.  /proc/mounts was a symlink to /proc/self/mounts long before
> /proc/self was modified to stop pointing at the task directory and
> changed it point at the new task group directory.

Having the filesystem namespace be per-process is wild enough.
We really don't need it to be per-thread. (and yes, I'm using the
POSIX terms on purpose)

> Frankly from what I have seen of the code the task-group work
> seems to be a larger source of bugs, and complications, because
> people have a darn hard time wrapping their head around how it
> is supposed to behave, and all of the corner cases were not
> resolved at the time it was developed.

People look at me like I have two heads when I explain to
them that the Linux kernel source uses "pid" to mean
a thread. The bad terminology probably promotes bad thinking.
It would be lovely if that could somehow get fixed.

> My favorite ongoing issue is what is needed to allow a threaded
> init to actually function properly.  I think enough fixes have
> gone in that it might even work.

My "favorite" is the multi-threaded debugger. By this I
mean the debugger itself wants to be multi-threaded,
issuing ptrace commands from multiple threads.
