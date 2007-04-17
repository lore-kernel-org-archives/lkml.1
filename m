Return-Path: <linux-kernel-owner+w=401wt.eu-S1161143AbXDQT4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143AbXDQT4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161159AbXDQT4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:56:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34308 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161143AbXDQT43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:56:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164620.588752236@szeredi.hu>
	<20070412203208.GG27772@sergelap.austin.ibm.com>
	<m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
	<1176713221.9488.17.camel@ram.us.ibm.com>
	<E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu>
	<1176716941.9488.57.camel@ram.us.ibm.com>
	<E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu>
	<m18xcsl3yc.fsf@ebiederm.dsl.xmission.com>
	<E1HdTag-0007bd-00@dorka.pomaz.szeredi.hu>
	<m1zm58jfj3.fsf@ebiederm.dsl.xmission.com>
	<20070416195652.GA350@sergelap.austin.ibm.com>
	<m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com>
	<E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu>
	<m1zm56j27m.fsf@ebiederm.dsl.xmission.com>
	<E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu>
Date: Tue, 17 Apr 2007 13:54:14 -0600
In-Reply-To: <E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu> (Miklos Szeredi's
	message of "Tue, 17 Apr 2007 20:36:04 +0200")
Message-ID: <m1vefuixp5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

>> > I'm still not sure, what your problem is.
>> 
>> My problem right now is that I see a serious complexity escalation in
>> the user interface that we must support indefinitely.
>> 
>> I see us taking a nice powerful concept and seriously watering it down.
>> To some extent we have to avoid confusing suid applications.  (I would
>> so love to remove the SUID bit...).
>> 
>> I'm being contrary to ensure we have a good code review.
>
> OK.  And it's very much appreciated :)
>
>> I have heard it said that there are two kinds of design.  Something
>> so simple it obviously has no deficiencies.  Something so complex it has
>> no obvious deficiencies.  I am very much afraid we are slipping the
>> mount namespace into the latter category of work.  Which is a bad
>> bad thing for core OS feature.
>
> I've tried to make this unprivileged mount thing as simple as
> possible, and no simpler.  If we can make it even simpler, all the
> better.

We are certainly much more complex then the code in plan9 (just
read through it) so I think we have room for improvement.

Just for reference what I saw in plan 9 was:
- No super user checks in it's mount, unmount, or namespace creation paths.
- A flag to deny new mounts but not new bind mounts (for administrative purposes
  the comment said).

Our differences from plan9.
- suid capable binaries. (SUID please go away).
- A history of programs assuming only root could call mount/unmount.

>> In part this really disturbs me because we now have two mechanisms for
>> controlling the scope of what a user can do.
>
> You mean rbind+chroot and clone(CLONE_NS)?  Yes, those are two
> different mechanisms achieving very similar results.  But what has
> this to do with unprivileged mounts?

The practical question is how do we limit what a user can mount and
unmount.


I would contend that at first glance stuffing a user in their own
mount namespace is sufficient, on a system with utilities aware
of the consequences of mount/unmount.

So we may not need a unprivileged mount disable except as a way
to allow an old user space to run a new kernel.

>> A flag or a new namespace.  Two mechanisms to accomplish the same
>> thing sound wrong, and hard to manage.
>
> The flag permitting the unprivileged mounts (which we now agreed to
> name "allowusermnt") is used in both cases.
>
> Just creating a new namespace doesn't always imply that you want to
> allow user mounts inside, does it?  These are orthogonal features.

After user space has been updated we always want to allow unprivileged
mounts. 

If I get pushed I will say that we need to remove suid exec capability
from user space as well.  At which point we don't even need directory
security checks, there is enough benefit there I certainly think
it is worth considering having an entire NOSUID user space.

Removing suid is probably excessive but if it isn't much harder
then sane mount namespace support we should probably consider it.


>> >   - sysadmin creates /mnt/usermounts writable to all users, with
>> >     sticky bit (same as /tmp), does "mount --bind /mnt/usermounts
>> >     /mnt/usermounts" and sets the "allow unpriv submounts" on
>> >     /mnt/usermounts.
>> >
>> > All of these are perfectly safe wrt userdel and backup (assuming it
>> > doesn't try back up /mnt).
>> 
>> I also don't understand at all the user= mount flag and options.
>
> The "user=UID" or (or MNT_USER flag) serves multiple purposes:
>
>   - help mount(8) move away from /etc/mtab
>   - allow unprivileged umounts
>   - account user mounts
>
>> All it seemed to be used for was adding permissions to unmount.  In user
>> space to deal with the lack of any form of untrusted mounts I can understand
>> this.  In kernel space this seems to be more of a problem.
>
> Why is handling unprivileged mounts in kernel different from handling
> them in userspace in this respect?

Ok.  I just looked at what user space is doing.  The difference is that
what user space is doing predates mount namespaces, and was there as
far as I can tell to keep one user from causing problems for
another user.   If we choose to make mount namespaces to be
the unit of granularity we don't need this capability.

All we have to do is deny unmounts that would confuse a suid
executable.  Which mounts are those?

Eric
