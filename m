Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYHHTuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYHHTuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 15:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760672AbYHHTug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 15:50:36 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:52620 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760211AbYHHTuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 15:50:35 -0400
Message-ID: <489CA21A.4060009@cs.columbia.edu>
Date: Fri, 08 Aug 2008 15:44:26 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][PATCH 0/4] kernel-based checkpoint restart
References: <20080807224033.FFB3A2C1@kernel> <200808081125.12706.arnd@arndb.de>
In-Reply-To: <200808081125.12706.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Arnd Bergmann wrote:
> On Friday 08 August 2008, Dave Hansen wrote:
>> These patches are from Oren Laaden.  I've refactored them
>> a bit to make them a wee bit more reviewable.  I think this
>> separates out the per-arch bits pretty well.  It should also
>> be at least build-bisetable.
> 
> Cool stuff
> 

Thanks. This is a proof of concept so all sorts of feedback are
definitely welcome. Some of the ideas and discussions are found
around:
   http://wiki.openvz.org/Containers/Mini-summit_2008
and the notes:
   http://wiki.openvz.org/Containers/Mini-summit_2008_notes
and the archives of the linux containers mailing list:
   https://lists.linux-foundation.org/pipermail/containers/
(August and July).

Several aspects of the implementation are still experimental and
I expect them to evolve with the feedback. In particular, expect
the specific user interface (syscalls) and the checkpoint image
format to be moving targets.

>> ============================== ckpt.c ================================
>>
>> #define _GNU_SOURCE        /* or _BSD_SOURCE or _SVID_SOURCE */
>>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <errno.h>
>> #include <fcntl.h>
>> #include <unistd.h>
>> #include <asm/unistd_32.h>
>> #include <sys/syscall.h>
> 
> Note that asm/unistd_32.h is not portable, you should use asm/unistd.h
> in the example.
> 
>>         pid_t pid = getpid();
>>         int ret;
>>
>>         ret = syscall(__NR_checkpoint, pid, STDOUT_FILENO, 0);
> 
> Interface-wise, I would consider checkpointing yourself signficantly
> different from checkpointing some other thread. If checkpointing
> yourself is the common case, it probably makes sense to allow passing
> of pid=0 for this.
> 

The checkpoint/restart code is meant to checkpoint a whole container,
that is be able to save the state of multiple other tasks. The same
code can also be used to checkpoint yourself fairly easily with minimal
changes (see comments in the code about "in context" checkpoint/restart
that take care of this).

I suggest to keep the interface as is in the sense that the pid will
identify the target container (e.g. the pid of the init process of that
container).

Then, pid=0 would mean "the container to which I belong" if
you are inside a container (and therefore don't know the pid of the
init process there).

Finally, to checkpoint yourself, you would set the a bit in the flags
argument to something like CR_CKPT_MYSELF. Such a flag will be needed
internally anyway to special-case self checkpoint where appropriate.

Comments are welcome.

Oren.

