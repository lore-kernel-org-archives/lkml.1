Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbXK2Vm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbXK2Vm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763789AbXK2Vms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:42:48 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54569 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763784AbXK2Vmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:42:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Albert Cahalan" <acahalan@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Guillaume Chazarain" <guichaz@yahoo.fr>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, oleg@tv-sign.ru,
       rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	<20071128014901.4b303954@inria.fr>
	<787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
	<20071128104622.GB19694@elte.hu>
	<m1ve7mehcm.fsf@ebiederm.dsl.xmission.com>
	<787b0d920711280947g418330faie5c96293102c3f05@mail.gmail.com>
Date: Thu, 29 Nov 2007 14:40:17 -0700
In-Reply-To: <787b0d920711280947g418330faie5c96293102c3f05@mail.gmail.com>
	(Albert Cahalan's message of "Wed, 28 Nov 2007 12:47:31 -0500")
Message-ID: <m1hcj4buim.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Albert Cahalan" <acahalan@gmail.com> writes:

> On Nov 28, 2007 6:31 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Ingo Molnar <mingo@elte.hu> writes:
>> > * Albert Cahalan <acahalan@gmail.com> wrote:
>> >> On Nov 27, 2007 7:49 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:
>
>> In a lot of ways if you access /proc/self and you get back information
>> that does not correspond to yourself the result is nonsense.  Which
>> is a fairly mighty problem.
>
> In general, this is not a problem we have.

True in general we do not have a problem, in specific corner cases
we do have a problem, and being a system software developer corner
cases that do not work properly disturb me.




Linux does not have processes.

Linux has tasks
Linux has task groups.

Linux tasks when used in one particular way can fulfill the posix
requirements for single threaded processes. 

Linux task groups when used in one particular way can fulfill the
posix requirements for processes.

Prior to 2.6 and good threading support task and process were
used interchangeably in linux.



Claiming something linux specific should be one way or another way
because the documentation said process is not an argument but rather
an indication that the documentation was ambiguous.



When the CLONE_THREAD support was added in 2.5 we left a lot of
corner cases ill-defined and not thought through and that continues
to give us trouble.  In particular peoples intuition varies on what
the right set of semantics in a different situations are.



Regardless of the original intent the way the files in /proc are today
is that both /proc/<tgid>/ and /proc/<tgid>/task/<tid>/ contain all of
the same status files with the files under /proc/<tgid>/ containing
information summed across the entire thread group.  To preserve
the pre thread group understanding of /proc this needs to continue
to be the case.  Otherwise the /proc/<tgid>/ directory would quickly
become uninteresting to everything except tools like ps and top.


As for where /proc/self points given that procps seems to read
files like /proc/self/stat.  It looks to me like we have a clear
case of a user space application that cares about the current
behavior and would break if we changed things.


> Note that it was intended that non-legacy additions
> would normally be added to either the process directory
> or the thread directory, not both. I think somebody may
> have ripped out the ability to do this; at the very least
> there have been numerous illogical additions.

The rationale was not conveyed and the policy you describe
seems like deprecating the /proc/<tgid> directory in favor
of the /proc/<tgid>/task/<pid>/.  Which was a pattern
never established and it doesn't seem to make anything better
so I don't see the point there.


>> I'm still trying to understand which will break user space more,
>> adding /proc/task or changing /proc/self.
>
> Changing /proc/self makes you get per-thread data
> when you asked for per-process data. That's bad.

/proc/self used to ask for per task data.  Which is why there
is some confusion.

>> >> This one is probably best:
>> >> /proc/task -> 123/task/456
>> >> (with both numbers showing)
>> >
>> > this sounds good to me. If it's a symlink then there's not much other
>> > choice because the thread PIDs do not even show up under /proc anymore.
>>
>> The name sounds good to me.

I will see about writing the patch for this in a bit and sending
it to Andrew.

>> I am not certain the two components make sense as we have a possible
>> permission problem where it is remotely possible that a task will
>> have permission to access /proc/<tid> but not /proc/<tgid>.
>
> If it hurts, don't do that. We allow foot shooting.

Well as I replied earlier I have a solution to this so it isn't
an issue.

However we don't go around pointing guns at peoples feet.  If
there isn't a reason for problems we should not do it.  Now
I do admit security modules in general and selinux in particular
seem to be foot shooting by definition but that is another issue
entirely.  Waving too many problems away as foot shooting is a
reckless attitude can cause problems later.

> As I predicted, the container bloat would be a never-ending
> source of bugs. You're discovering bugs where there were none.

Nope.  /proc/mounts was a symlink to /proc/self/mounts long before
/proc/self was modified to stop pointing at the task directory and
changed it point at the new task group directory.

Frankly from what I have seen of the code the task-group work
seems to be a larger source of bugs, and complications, because
people have a darn hard time wrapping their head around how it
is supposed to behave, and all of the corner cases were not
resolved at the time it was developed.

My favorite ongoing issue is what is needed to allow a threaded
init to actually function properly.  I think enough fixes have
gone in that it might even work.

> You'll never run out of this sort of problem. Keeping Linux lean
> and simple would be far better.

Nah.  The control group stuff has all kinds of corner cases because
it is a new and untested API.  The namespace work after we get the
code cleanup up so it is maintainable and we can work with it
is usually just finding our globals through a pointer instead of
from a static variable.  Hardly a measurable cost on the best day.

The rule is that the user space interfaces change as little as
possible.  For /proc that could mean either we capture all of
the namespaces at mount time so things stay exactly the way
the are today, or that we find a way to show things that have
now become namespace dependent.  Given that monitoring works
best if you can access the status files of other namespaces
it seems to make sense to follow the lead of /proc mounts.
Although I believe we should shortly reach the point where
/proc/.../mounts will have the same inode number if it is
the same mount namespace.

Eric
