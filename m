Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbXK1Rrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbXK1Rrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbXK1Rre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:47:34 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:7764 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbXK1Rrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A0Rw3/IukZ7DN3EFBl3s5gf3wAz/jpmLJVX2FZyvCnMO4p3HypETESAJG+NeMkCCLD1NKknaiY9hRioZUAMmi33Wwk7IvMX3w7N/Kb/PPhpHJahfE/wHU9ntzHBkQnthhKnuBz4c6w66KbpjjFlOF4czI5x+bSziL9exWJZUcAA=
Message-ID: <787b0d920711280947g418330faie5c96293102c3f05@mail.gmail.com>
Date: Wed, 28 Nov 2007 12:47:31 -0500
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: + proc-fix-the-threaded-proc-self.patch added to -mm tree
Cc: "Ingo Molnar" <mingo@elte.hu>, "Guillaume Chazarain" <guichaz@yahoo.fr>,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, oleg@tv-sign.ru,
       rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <m1ve7mehcm.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711262339.lAQNdNrw029057@imap1.linux-foundation.org>
	 <20071128014901.4b303954@inria.fr>
	 <787b0d920711280141v463759efod86395c50c1b47c5@mail.gmail.com>
	 <20071128104622.GB19694@elte.hu>
	 <m1ve7mehcm.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 28, 2007 6:31 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> > * Albert Cahalan <acahalan@gmail.com> wrote:
> >> On Nov 27, 2007 7:49 PM, Guillaume Chazarain <guichaz@yahoo.fr> wrote:

> In a lot of ways if you access /proc/self and you get back information
> that does not correspond to yourself the result is nonsense.  Which
> is a fairly mighty problem.

In general, this is not a problem we have.

/proc/self points to the process, not the task group leader.

They are different. Look at /proc/*/stat, where the
per-process info is summary data. The per-thread
stat file is not summary data. This is intended to be
true for all files in /proc; there may be some with bugs.

Some of the data can not be summed up and will not
always be shared. This is legacy crud. Don't use it,
and don't try to "fix" it. It's there so that old programs
can continute to work as long as weird threading isn't
in use.

Note that it was intended that non-legacy additions
would normally be added to either the process directory
or the thread directory, not both. I think somebody may
have ripped out the ability to do this; at the very least
there have been numerous illogical additions.

> I'm still trying to understand which will break user space more,
> adding /proc/task or changing /proc/self.

Changing /proc/self makes you get per-thread data
when you asked for per-process data. That's bad.

> >> This one is probably best:
> >> /proc/task -> 123/task/456
> >> (with both numbers showing)
> >
> > this sounds good to me. If it's a symlink then there's not much other
> > choice because the thread PIDs do not even show up under /proc anymore.
>
> The name sounds good to me.
>
> I am not certain the two components make sense as we have a possible
> permission problem where it is remotely possible that a task will
> have permission to access /proc/<tid> but not /proc/<tgid>.

If it hurts, don't do that. We allow foot shooting.

> The reason I care is that we need to fix /proc/mounts.  So once we
> have /proc/task we can also have change /proc/mounts to
> be a symlink to /proc/task/mounts.
>
> Once we get the /proc/mounts thing sorted out.  There are several
> other entries in /proc that need to that need to follow in it's wake
> as they also become per namespace.  /proc/net and /proc/sysvipc for
> starters.

As I predicted, the container bloat would be a never-ending
source of bugs. You're discovering bugs where there were none.
You'll never run out of this sort of problem. Keeping Linux lean
and simple would be far better.
