Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYKGDz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYKGDz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 22:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYKGDzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 22:55:15 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35736 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYKGDzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 22:55:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
	<m1abccxpc5.fsf@frodo.ebiederm.org>
	<20081106184945.179c248a.akpm@linux-foundation.org>
Date: Thu, 06 Nov 2008 19:51:23 -0800
In-Reply-To: <20081106184945.179c248a.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 6 Nov 2008 18:49:45 -0800")
Message-ID: <m1iqr0urb8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, containers@lists.osdl.org, viro@ZenIV.linux.org.uk, adobriyan@gmail.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task directories
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 06 Nov 2008 18:05:46 -0800 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> > On Thu, 06 Nov 2008 02:48:35 -0800
>> > ebiederm@xmission.com (Eric W. Biederman) wrote:
>> >
>> >> +void proc_shrink_automounts(void)
>> >> +{
>> >> +	struct list_head *list = &proc_automounts;
>> >> +
>> >> +	mark_mounts_for_expiry(list);
>> >> +	mark_mounts_for_expiry(list);
>> >
>> > Strange.  In case the first attempt didn't work?
>> 
>> Yes.  I'd like to say.  Mount just go away but it takes two passes before
>> a mount is actually removed.
>
> hm.  I stared at mark_mounts_for_expiry() for a while trying to work
> out how that can happen and what it semantically *means*, and failed.
>
> I guess I'm just not smart/experienced enough.

The semantics are a classic two pass exiry.  The mount is not in use
and it was not in use last time we came by remove the mount.

The code is fs/namespace.c is especially clever.  It took me a long
time starring at it to figure out what is going on.  The bug fix comes
from when I was working out what that code does.

>> For NFS which does the whole expiry of all inodes where it comes from it
>> is a good fit.  For /proc where we don't have to guess it isn't the best
>> fit but it isn't shabby either.
>> 
>> >
>> >> +	if (list_empty(list))
>
> So even after two passes through mark_mounts_for_expiry(), there can
> still be mounts on our list.

Only if the mounts are actually in use.

>> >> +		return;
>> >> +
>> >> +	schedule_delayed_work(&proc_automount_task, proc_automount_timeout);
>
> And this causes proc_shrink_automounts() to be called every 500 seconds
> for ever and ever, until proc_automounts is empty.

Yes.

> Again, I just don't know how the reader of this file is to understand
> why this is done this way.  What is the thinking behind it?  What is
> the expected dynamic behaviour?  Under what circumstances will this
> very unusual repeated polling activity be triggered?


Basically if someone does:

cd /proc/<pid>/net/stat  or something like that and holds one of the dentries
alive.  The mount is not allowed to go away.

When a process exits release_task is called which in turn calls
proc_shrink_automounts().  In a normal case it will remove mounts that
are under that process.  

Unfortunately if one of these mounts is busy because the path to a dentry
references it we can not free it (although d_revalidate will cause the
dentry to become unhashed so we can't find the mount going in the other
direction).

So we have to periodically check, is the mount free yet.

If we could do all of this with reference counting so that the
mount would persist exactly until the last user of it has gone
away without a periodic poll I would love it.  But the infrastructure
doesn't support that today, and where this is at least partially
a bug fix I would rather not have the change depend on enhancing
the VFS.

The algorithm is actually very aggressive and in practice you don't
see any /proc/<pid>/net showing up as a mount point.

> Obviously, that becomes clearer as one spends more time with the code,
> but I wonder whether this has all been made as maintainble as it
> possibly could be.

Good question.

In the sense of will we have to go through and futz with the code all
of the time.  The abstraction seems good.   You put a mount on
the proc_automounts list with do_add_mounts and it goes away eventually
with all of the vfs rules maintained.

In the sense of can the code be read?    Perhaps it could be better.
I expect it helps to have run the code and see /proc/net as a filesystem.
that is magically mounted.

In the long term it also seems to make sense maintenance wise to split
/proc into separate parts that can go different directions, and having
the automounting of the old pieces, helps a lot with that.

Unless there are some real bugs my preference is to evolve the code from
where it is today.  The code is at least simple and stupid.

Eric
