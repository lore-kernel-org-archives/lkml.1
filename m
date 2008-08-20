Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYHTT0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYHTT0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYHTT0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:26:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50858 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbYHTT0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:26:02 -0400
Subject: [RFC v2][PATCH 0/9] kernel-based checkpoint-restart
To: arnd@arndb.de
Cc: orenl@cs.columbia.edu, jeremy@goop.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 Aug 2008 12:25:57 -0700
Message-Id: <20080820192557.98788FAB@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are from Oren Laadan.  I've refactored them
a bit to make them a wee bit more reviewable by:

1. Removing code that we're not yet using
2. Separating out i386 code into a separate patch
3. Simplyifying the filename handling

This should also be at least build-bisetable.

TODO:
- Investigate using anon_inodes for the sys_checkpoint() side
- Move all the structure declarations to somewhere that we
  can easily export them to userspace.
- Lots of ABI issues to work out.
- Combine the "cleanup" patches later in the series into the
  base patches.

--

At the containers mini-conference before OLS, the consensus among
all the stakeholders was that doing checkpoint/restart in the kernel
as much as possible was the best approach.  With this approach, the
kernel will export a relatively opaque 'blob' of data to userspace
which can then be handed to the new kernel at restore time.

This is different that what had been proposed before, which was
that a userspace application would be responsible for collecting
all of this data.  We were also planning on adding lots of new,
little kernel interfaces for all of the things that needed
checkpointing.  This unites those into a single, grand interface.

The 'blob' will contain copies of select portions of kernel
structures such as vmas and mm_structs.  It will also contain
copies of the actual memory that the process uses.  Any changes
in this blob's format between kernel revisions can be handled by
an in-userspace conversion program.

This is a similar approach to virtually all of the commercial
checkpoint/restart products out there, as well as the research
project Zap.

These patches basically serialize internel kernel state and write
it out to a file descriptor.  The checkpoint and restore are done
with two new system calls: sys_checkpoint and sys_restart.

In this incarnation, they can only work checkpoint and restore a
single task. The task's address space may consist of only private,
simple vma's - anonymous or file-mapped.

--
Oren's original announcement

In the recent mini-summit at OLS 2008 and the following days it was
agreed to tackle the checkpoint/restart (CR) by beginning with a very
simple case: save and restore a single task, with simple memory
layout, disregarding other task state such as files, signals etc.

Following these discussions I coded a prototype that can do exactly
that, as a starter. This code adds two system calls - sys_checkpoint
and sys_restart - that a task can call to save and restore its state
respectively. It also demonstrates how the checkpoint image file can
be formatted, as well as show its nested nature (e.g. cr_write_mm()
-> cr_write_vma() nesting).

The state that is saved/restored is the following:
* some of the task_struct
* some of the thread_struct and thread_info
* the cpu state (including FPU)
* the memory address space

[The patch is against commit fb2e405fc1fc8b20d9c78eaa1c7fd5a297efde43
of Linus's tree (uhhh.. don't ask why), but against tonight's head too].

In the current code, sys_checkpoint will checkpoint the current task,
although the logic exists to checkpoint other tasks (not in the
checkpointee's execution context). A simple loop will extend this to
handle multiple processes. sys_restart restarts the current tasks, and
with multiple tasks each task will call the syscall independently.
(Actually, to checkpoint outside the context of a task, it is also
necessary to also handle restart-block logic when saving/restoring the
thread data).

It takes longer to describe what isn't implemented or supported by
this prototype ... basically everything that isn't as simple as the
above.

As for containers - since we still don't have a representation for a
container, this patch has no notion of a container. The tests for
consistent namespaces (and isolation) are also omitted.

Below are two example programs: one uses checkpoint (called ckpt) and
one uses restart (called rstr). Execute like this (as a superuser):

orenl:~/test$ ./ckpt > out.1
hello, world!  (ret=1)          <-- sys_checkpoint returns positive id
                                <-- ctrl-c
orenl:~/test$ ./ckpt > out.2
hello, world!  (ret=2)
                                <-- ctrl-c
orenl:~/test$ ./rstr < out.1
hello, world!  (ret=0)          <-- sys_restart return 0

(if you check the output of ps, you'll see that "rstr" changed its
name to "ckpt", as expected).

Hoping this will accelerate the discussion. Comments are welcome.
Let the fun begin :)

Oren.


============================== ckpt.c ================================

#define _GNU_SOURCE        /* or _BSD_SOURCE or _SVID_SOURCE */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <asm/unistd_32.h>
#include <sys/syscall.h>

int main(int argc, char *argv[])
{
        pid_t pid = getpid();
        int ret;

        ret = syscall(__NR_checkpoint, pid, STDOUT_FILENO, 0);
        if (ret < 0)
                perror("checkpoint");

        fprintf(stderr, "hello, world!  (ret=%d)\n", ret);

        while (1)
                ;

        return 0;
}

============================== rstr.c ================================

#define _GNU_SOURCE        /* or _BSD_SOURCE or _SVID_SOURCE */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <asm/unistd_32.h>
#include <sys/syscall.h>

int main(int argc, char *argv[])
{
        pid_t pid = getpid();
        int ret;

        ret = syscall(__NR_restart, pid, STDIN_FILENO, 0);
        if (ret < 0)
                perror("restart");

        printf("should not reach here !\n");

        return 0;
}
_______________________________________________
Containers mailing list
Containers@lists.linux-foundation.org
https://lists.linux-foundation.org/mailman/listinfo/containers
