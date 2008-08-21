Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbYHUPrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbYHUPrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYHUPqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:46:53 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:34917 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYHUPqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:46:52 -0400
Message-ID: <48AD8D22.7000604@cs.columbia.edu>
Date: Thu, 21 Aug 2008 11:43:30 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpoint/restart ABI
References: <20080807224033.FFB3A2C1@kernel> <200808112347.50245.arnd@arndb.de> <48AD0379.9030705@cs.columbia.edu> <200808211043.41387.arnd@arndb.de>
In-Reply-To: <200808211043.41387.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann wrote:
> On Thursday 21 August 2008, Oren Laadan wrote:
 >
>> Using a single handle (crid or a special file descriptor) to identify
>> the whole checkpoint is very useful - to be able to stream it (eg. over
>> the network, or through filters). It is also very important for future
>> features and optimizations. For example, to reduce downtime of the
>> application during checkpoint, one can use COW for dirty pages, and
>> only write-back the entire data after the application resumes execution.
>> Or imagine a use-case where one would like to keep the entire checkpoint
>> in memory. These are pretty hard to do if you split the handling between
>> multiple files or handles.
> 
> right.
> 
>>> On the restart side, I think the most consistent interface would
>>> be a new binfmt_chkpt implementation that you can use to execve
>>> a checkpoint, just like you execute an ELF file today. The binfmt
>>> can be a module (unlike a syscall), so an administrator that is
>>> afraid of the security implications can just disable it by not
>>> loading the module. In an execve model, the parent process can
>>> set up anything related to credentials as good as it's allowed
>>> to and then let the kernel do the rest.
>> This is an interesting idea but not without its problems. In particular,
>> a successful execve() by one thread destroys all the others.
> 
> Right, execve currently assumes that the new process starts up with
> a single thread, but a potential binfmt_chkpt would need to potentially
> start multithreaded. I guess this either requires execve to reuse
> the existing threads (assuming they have been set up correctly in
> advance) or to create new ones according to the context of the
> checkpoint data. It may not be as easy as I thought initially, but
> both seem possible.
> Restarting a whole set of processes from a checkpoint would be
> a relatively simple extension of that.
> 
>> Also, it isn't clear how this can work with pre-copying and live-migration;
>> And finally, I'm not sure how to handle shared objects in this manner.
> 
> What do you mean with pre-copying?
> How is live-migration different from restarting a previously saved
> task from the same machine?

By pre-copying I refer to the first stage of live-migration: to reduce
down time, much of the state of a container can be saved while tasks
are still running (most notably memory, but also file system snapshot,
if need be). Since the state may change, this is repeated - to save the
what changed in the meanwhile - until the delta is small enough. During
all this time the tasks continue to execute. At this point, we freeze
the container, save the last delta, and resume (in case of snapshot) or
or kill (in case of live-migration) the container. I'm not convinced that
execve() is the best way to handle this iterative process.

Also, with multiple tasks in a container, data for consecutive tasks
will appear in order in the checkpoint image. Moreover, a future
optimization would be the have multiple threads checkpoint the container,
with data interleaved in the checkpoint image stream. Here, too, I'm
not sure how execve()-like approach plays.

Finally there is the case of shared objects: v2 demonstrates this in
checkpoint/objhash.c (see also Documentation/checkpoint.txt). Again,
I'm not sure how execve() can adapt to this need.

I definitely agree that using something like execve() is elegant and
has its advantages. It just isn't clear to me that it is truly suitable
for the needs. Suggestions are welcome.

Oren.

> 
>> As for kernel module - it is easy to implement most of the checkpoint
>> restart functionality in a kernel module, leaving only the syscall stubs
>> in the kernel.
> 
> Yeah, I've done the same in spufs, but I still think it's ugly ;-)
> 
> 	Arnd <><
