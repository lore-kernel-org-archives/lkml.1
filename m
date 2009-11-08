Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZKHKQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZKHKQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:16:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZKHKQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:16:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40636 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZKHKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:15:59 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       adobriyan@gmail.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] proc: revalidate dentry returned by proc_pid_follow_link
References: <1257513594-31071-1-git-send-email-jlayton@redhat.com>
	<20091106203601.GD27751@shareable.org>
	<20091106160612.4cd05e76@tlielax.poochiereds.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 08 Nov 2009 02:15:57 -0800
In-Reply-To: <20091106160612.4cd05e76@tlielax.poochiereds.net> (Jeff Layton's message of "Fri\, 6 Nov 2009 16\:06\:12 -0500")
Message-ID: <m17hu1miea.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> On Fri, 6 Nov 2009 20:36:01 +0000
> Jamie Lokier <jamie@shareable.org> wrote:
>
>> Jeff Layton wrote:
>> > The problem here is that this makes that code shortcut any lookup or
>> > revalidation of the dentry. In general, this isn't a problem -- in most
>> > cases the dentry is known to be good. It is a problem however for NFSv4.
>> > If this symlink is followed on an open operation no actual open call
>> > occurs and the open state isn't properly established. This causes
>> > problems when we later try to use this file descriptor for actual
>> > operations.
>> 
>> As NFS uses open() as a kind of fcntl-lock barrier, I can see it's
>> important to do _something_ on new opens, rather than just cloning
>> most of the file descriptor.
>> 
>
> I guess you mean the close-to-open cache consistency? If so, this
> problem doesn't actually break that. The actual nfs_file_open call does
> occur even when you're opening by following one of these symlinks. I
> believe the cache consistency code occurs there.
>
> The problem here is really nfsv4 specific. There the on-the-wire open
> call and initialization of state actually happens during d_lookup and
> d_revalidate. Neither of these happens with these LAST_BIND symlinks so
> we end up with a filp that has no NFSv4 state attached.
>
>> > This patch takes a minimalist approach to fixing this by making the
>> > /proc/pid follow_link routine revalidate the dentry before returning it.
>> 
>> What happens if the file descriptor you are re-opening is for a file
>> which has been deleted.  Does it still have a revalidatable dentry?
>> 
>
> Well, these LAST_BIND symlinks return a real dget'ed dentry today. If
> we assume that it always returns a valid dentry (which seems to be the
> case), then I suppose it's OK to do a d_revalidate against it.
>
> It's possible though that that revalidate will either fail though or
> return that it's no good. In that case, this code just returns ESTALE
> which should make the path walking code revalidate all the way up the
> chain. That should (hopefully) make whatever syscall we're servicing
> return an error.

Hmm.  Looking at the code I get the impression that a file bind mount
will have exactly the same problem.

Can you confirm.

If file bind mounts also have this problem a bugfix to to just
proc seems questionable.

Eric
