Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbXKUGmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbXKUGmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXKUGmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:42:04 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57685 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXKUGmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:42:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: Futexes and network filesystems.
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
	<4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
	<472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org>
	<20071102010419.23f3db5c.akpm@linux-foundation.org>
	<1194024622.6271.108.camel@localhost>
	<alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
	<20071103201251.GB26366@elte.hu>
	<m1ir3wr0jj.fsf_-_@ebiederm.dsl.xmission.com>
	<79EA1EBC-895B-4AFC-92EB-05E46C6AAEF5@mac.com>
Date: Tue, 20 Nov 2007 23:30:58 -0700
In-Reply-To: <79EA1EBC-895B-4AFC-92EB-05E46C6AAEF5@mac.com> (Kyle Moffett's
	message of "Wed, 21 Nov 2007 01:16:27 -0500")
Message-ID: <m1lk8sp0t9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <mrmacman_g4@mac.com> writes:

> On Nov 20, 2007, at 17:53:52, Er ic W. Biederman wrote:
>> I had a chance to think about this a bit more, and realized that the problem
>> is that futexes don't appear to work on network  filesystems, even if the
>> network filesystems provide coherent  shared memory.
>>
>> It seems to me that we need to have a call that gets a unique token for a
>> process for each filesystem per filesystem for use in futexes  (especially
>> robust futexes).  Say get_fs_task_id(const char *path);
>>
>> On local filesystems this could just be the pid as we use today, but for
>> filesystems that can be accessed from contexts with  potentially overlapping
>> pid values this could be something else.   It is an extra syscall in the
>> preparation path, but it should be hardly more expensive the current getpid().
>>
>> Once we have fixed the futex infrastructure to be able to handle futexes on
>> network filesystems, the pid namespace case will be  trivial to implement.
>
> Actually, I would think that get_vm_task_id(void *addr) would be a more useful
> interface.  The call would still be a relatively simple  lookup to find the
> struct file associated with the particular virtual  mapping, but it would be
> race-free from the perspective of userspace  and would not require that we
> somehow figure out the file descriptor  associated with a particular mmap()
> (which may be closed by this  point in time).  Useful extension would be the
> get_fd_task_id(int fd) and get_fs_task_id(const char *path), but those are less
> important.

You are probably right.  The important thing is that we get an interface where
user space can cache the result.  Or else you totally loose the benefit of
avoiding trapping into the kernel.

> The other important thing is to ensure that somehow the numbers are considered
> unique only within the particular domain of a container,  such that you can
> migrate a container from one system to another even  using a simple local ext3
> filesystem (on a networked block device)  and still be able to have things work
> properly even after the  migration.  Naturally this would only work with an
> upgraded libc but  I think that's a reasonable requirement to enforce for
> migration of  futexes and cross-network futexes.

Well. The numbers are unique per filesystem.  Which is what should save you.
The numbers can't simply be unique per container.

> Even for network filesystems which don't implement coherent shared memory, you
> might add a memexcl() system call which (when used by  multiple cooperating
> processes) ensures that a given page is only  ever mapped by at most one
> computer accessing a given network filesystem.  The page-outs and page-ins when
> shuttling that page  across the network would be expensive, but I believe the
> cost would  be reasonable for many applications and it would allow traditional
> atomic ops on the mapped pages to take and release futexes in the  uncontended
> case.

Sounds reasonable to me. 

Eric
