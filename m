Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbXFFREW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbXFFREW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbXFFREP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:04:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58339 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbXFFREO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:04:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
References: <1181146045.9503.67.camel@dyn9047017100.beaverton.ibm.com>
Date: Wed, 06 Jun 2007 11:02:55 -0600
In-Reply-To: <1181146045.9503.67.camel@dyn9047017100.beaverton.ibm.com>
	(Badari Pulavarty's message of "Wed, 06 Jun 2007 09:07:24 -0700")
Message-ID: <m1sl95t3r4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty <pbadari@us.ibm.com> writes:

> Hi Eric,
>
> Your recent cleanup to shm code, namely
>
> [PATCH] shm: make sysv ipc shared memory use stacked files
>
> took away one of the debugging feature for shm segments.
> Originally, shmid were forced to be the inode numbers and
> they show up in /proc/pid/maps for the process which mapped
> this shared memory segments (vma listing). That way, its easy
> to find out who all mapped this shared memory segment. Your
> patchset, took away the inode# setting. So, we can't easily
> match the shmem segments to /proc/pid/maps easily. (It was
> really useful in tracking down a customer problem recently). 
> Is this done deliberately ? Anything wrong in setting this back ?
>
> Comments ?
>
> Thanks,
> Badari
>
> Without patch:
> --------------
>
> # ipcs -m
>
> ------ Shared Memory Segments --------
> key        shmid      owner      perms      bytes      nattch     status
> 0x00000000 884737     db2inst1  767        33554432   13
>
> # grep 884737 /proc/*/maps
> #
>
> With patch:
> -----------
>
> # ipcs -m
>
> ------ Shared Memory Segments --------
> key        shmid      owner      perms      bytes      nattch     status
> 0x00000000 884737     db2inst1  767        33554432   13
>
> # grep 884737 /proc/*/maps
> /proc/11110/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11111/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11112/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11113/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11114/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11115/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11116/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11117/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11118/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11121/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11122/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11124/maps:4000389c000-4000589c000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
> /proc/11575/maps:40006724000-40008724000 rw-s 00000000 00:08 884737
> /SYSV00000000 (deleted)
>
>
>
> Here is the patch.
>
> "ino#" in /proc/pid/maps used to match "ipcs -m" output for shared 
> memory (shmid). It was useful in debugging, but its changed recently. 
> This patch sets inode number to shared memory id to match /proc/pid/maps.

Theoretically it makes the stacked file concept more brittle, because
it means the lower layers can't care about their inode number.

We do need something to tie these things together.

So I suspect what makes most sense is to simply rename the dentry
SYSVID<segmentid>

That should give you the necessary information while not doing something
that is a long term maintenance problem.

Do you think you can cook up a patch to that effect?
Otherwise I will see if I can.

In practice I'm not really against your change, but I would prefer
to leave the code in a state where someone can reimplement hugetlbfs
or shmfs and we simply don't care.

Eric
