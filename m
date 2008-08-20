Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbYHTVr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbYHTVr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYHTVrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:47:48 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:54921 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYHTVrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:47:47 -0400
Message-ID: <48AC8F63.3050500@cs.columbia.edu>
Date: Wed, 20 Aug 2008 17:40:51 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
References: <20080807224033.FFB3A2C1@kernel> <200808081146.54834.arnd@arndb.de>	<1218221451.19082.36.camel@nimitz>	<200808090013.41999.arnd@arndb.de>	<1218234411.19082.58.camel@nimitz>	<20080811150703.GA25930@us.ibm.com> <20080814055301.GH6995@ucw.cz>
In-Reply-To: <20080814055301.GH6995@ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Pavel Machek wrote:
> Hi!
> 
>>>>> I have to wonder if this is just a symptom of us trying to do this the
>>>>> wrong way.  We're trying to talk the kernel into writing internal gunk
>>>>> into a FD.  You're right, it is like a splice where one end of the pipe
>>>>> is in the kernel.
>>>>>
>>>>> Any thoughts on a better way to do this?  
>>>> Maybe you can invert the logic and let the new syscalls create a file
>>>> descriptor, and then have user space read or splice the checkpoint
>>>> data from it, and restore it by writing to the file descriptor.
>>>> It's probably easy to do using anon_inode_getfd() and would solve this
>>>> problem, but at the same time make checkpointing the current thread
>>>> hard if not impossible.
>>> Yeah, it does seem kinda backwards.  But, instead of even having to
>>> worry about the anon_inode stuff, why don't we just put it in a fs like
>>> everything else?  checkpointfs!
>> One reason is that I suspect that stops us from being able to send that
>> data straight to a pipe to compress and/or send on the network, without
>> hitting local disk.  Though if the checkpointfs was ram-based maybe not?
>>
>> As Oren has pointed out before, passing in an fd means we can pass a
>> socket into the syscall.
> 
> If you do pass a socket, will it handle blocking correctly? Getting
> deadlocked task would be bad. What happens if I try to snapshot into
> /proc/self/fd/0 ? Or maybe restore from /proc/cmdline?

Hmmm... these are good points.

Keep in mind that our principal goal is to checkpoint a whole container,
rather then a task to checkpoint itself (which is a by-product). Of course
your comments apply to a whole container as well.

In both cases, I don't think that blocking on a socket is a problem; the
checkpointer will enter a TASK_INTERRUPTIBLE state. Where is the deadlock ?
Writing or reading to/from /proc/self/... likewise - the programmer must
understand the implications, or the program won't work as expected. I don't
see a possible deadlock here, though.

For example - writing to /proc/self/fd/0 is ok; the state of fd[0] of that
task will be captured at some point in the middle of the checkpoint, so
after restart one cannot assume anything about the file position; the rest
should work.

Oren.

