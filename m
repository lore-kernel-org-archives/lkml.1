Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZKSVbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZKSVbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbZKSVbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:31:19 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:40926 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZKSVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:31:18 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, pavel@ucw.cz,
       Miklos Szeredi <miklos@szeredi.hu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal" symlinks
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
	<m14ooq5tq3.fsf@fess.ebiederm.org>
	<20091119132833.30bc93a4@barsoom.rdu.redhat.com>
	<m1skca2vi3.fsf@fess.ebiederm.org>
	<20091119143555.7851953f@barsoom.rdu.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Nov 2009 13:31:16 -0800
In-Reply-To: <20091119143555.7851953f@barsoom.rdu.redhat.com> (Jeff Layton's message of "Thu\, 19 Nov 2009 14\:35\:55 -0500")
Message-ID: <m14ooqw6aj.fsf@fess.ebiederm.org>
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

> Thanks, that makes sense. The raciness was evident once you pointed it
> out, so I think you're correct that we can't take this approach.
>
> Adding the missing revalidations is fine, but I don't believe that
> helps to fix Pavel's issue. I'll go back and take a more careful look
> at the suggestion that Miklos made and see whether it makes sense to
> implement a new FS_* flag for this, and see what it'll take to fix
> Pavel's issue.

Fundamentally today the proc/fd links are special kind of hard link,
the same kind as bind mounts and have the same issues crop up.  Given
that definition there is absolutely nothing wrong their behavior.

The fact that we create the proc/fd implicitly is a little bit
surprising and the source of the concerns.  So far the cost of
changing the semantics and breaking potentially valid user space
applications appears to outweigh the potential security benefit.


I can't find a reason for the missing revalidate.  It is easy to get
into a state where the destination of of a proc/fd/N symlink or
a file bind mount has been deleted, and everything continues to
work.  You can even open d_dropped file descriptors.

If you want confirmation just do:

$ mkdir toy
$ cd toy
$ echo 123 > f
$ touch g
$ sudo mount --bind ./f ./g
$ sleep 3000 < g &
$ child=$!
$ ls -l /proc/$child/fd/0
lr-x------ 1 eric eric 64 2009-11-19 13:27 /proc/28797/fd/0 -> /tmp/toy/g
$ rm f
$ ls -l /proc/$child/fd/0
lr-x------ 1 eric eric 64 2009-11-19 13:27 /proc/28797/fd/0 -> /tmp/toy/g (deleted)
$ cat /proc/$child/fd/0
123
$ kill $child
$ sudo umount ./g
$ cat g
$ rm g

What we can't do right now is revalidate the source of a mount as
that will make it impossible to find the vfsmount to unmount it.

Eric
