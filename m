Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbZKWXfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbZKWXfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbZKWXfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:35:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55566 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbZKWXfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:35:45 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
	<m1my2cdhi3.fsf@fess.ebiederm.org>
	<20091123173616.75c3f600@tlielax.poochiereds.net>
	<20091123224948.GB5598@shareable.org>
	<20091123181545.05ad004d@tlielax.poochiereds.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Nov 2009 15:35:44 -0800
In-Reply-To: <20091123181545.05ad004d@tlielax.poochiereds.net> (Jeff Layton's message of "Mon\, 23 Nov 2009 18\:15\:45 -0500")
Message-ID: <m1ljhwbyr3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #5)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> On Mon, 23 Nov 2009 22:49:48 +0000
> Jamie Lokier <jamie@shareable.org> wrote:
>
>> Jeff Layton wrote:
>> > > check_path_accessible seems pretty horrible.   If a process is running
>> > > inside of a subdirectory it doesn't have permissions to access, say
>> > > a chroot, /proc/self/fd/XXX becomes completely unusable.
>> > > 
>> > 
>> > Hmm...I have this in there:
>> > 
>> > +		/* are we at global root or root of namespace? */
>> > +		if ((tdentry == root.dentry && vfsmnt == root.mnt) ||
>> > +		    vfsmnt->mnt_parent == vfsmnt)
>> > +			break;
>> > 
>> > ...In the case of a chroot, wouldn't "current->fs->root" point to the
>> > root of the process' namespace? Or am I misunderstanding what
>> > current->fs actually represents?
>> 
>> A process can run inside a subdirectory it doesn't have permissions to
>> access without that being a chroot.
>> 
>
> Certainly.
>
>> It can also run inside a subdirectory that isn't accessible from it's
>> root, if that's how it was started - as well as having other
>> descriptors pointing to things outside its root.
>> 
>
> Yes.
>
>> It can also be passed file descriptors from outside it's root while
>> it's running.
>> 
>
> Yep.
>
>> Really, I think the /proc/PID/fd/N check should restrict the open to
>> the O_* limitations that were used to open fd N before, and not have
>> any connection to actual paths at the time of this check.
>> 
>
> The big question with all of this is: Should a task have the ability
> to follow a /proc/pid symlink to a path that it wouldn't ordinarily be
> able to resolve with a path lookup. The concensus that I got from the
> bugtraq discussion was that it should not, and this patch is an attempt
> to prevent that.
>
> I take it from you and Eric's comments that you disagree? If so, what's
> your rationale for allowing a task to resolve this symlink when it
> wouldn't ordinarily be able to do so if it were a "normal" symlink?

For myself I start with the simple fact that the code has worked the
way it currently does since around linux 0.99.  We have to be very
careful if we change this to avoid breaking existing applications.

So if we change the existing behaviour it must be done in such a way
that legitimate applications do not break.

Eric
