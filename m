Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYCYM1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYCYM1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYCYM1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:27:42 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46329 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYCYM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:27:41 -0400
Date: Tue, 25 Mar 2008 08:27:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] RWSEM: Rewrite rwsem.c and rwsem-spinlock.c more
 simply.
In-Reply-To: <87skyfgg4y.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.00.0803250813190.19386@localhost.localdomain>
References: <alpine.LFD.1.00.0803250659530.18358@localhost.localdomain> <87skyfgg4y.fsf@basil.nowhere.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008, Andi Kleen wrote:

> "Robert P. J. Day" <rpjday@crashcourse.ca> writes:
>
> > Rewrite these source files more simply by deleting the superfluous
> > "tsk" task_struct pointer and rephrasing in terms of the "current"
> > task pointer.
>
> This is likely a code pessimization because "current" is inline
> assembler and many gcc versions cannot CSE it.

i'm not sure what this means -- which of the transformations in that
patch is considered unsafe?  here's a typical simplification:

-       tsk = current;
-       set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+       set_current_state(TASK_UNINTERRUPTIBLE);


  there's all sorts of usage of set_current_state() throughout the
tree.  how is simplifying the code in these two files in exactly the
same way any different?  or am i missing something because this
involves semaphores?

rday

p.s.  given this bit from sched.h:

...
#define __set_task_state(tsk, state_value)              \
        do { (tsk)->state = (state_value); } while (0)
#define set_task_state(tsk, state_value)                \
        set_mb((tsk)->state, (state_value))

...

#define __set_current_state(state_value)                        \
        do { current->state = (state_value); } while (0)
#define set_current_state(state_value)          \
        set_mb(current->state, (state_value))
...

it's not clear why set_current_state() and __current_state() are
defined the way they are when it would seem to be simpler (and less
error-prone) to just write:

#define __set_current_state(sv)  __set_task_state(current, sv)
#define set_current_state(sv)   set_task_state(current, sv)

  the law of parsimony and all that.  or, once again, is there
something subtle i'm not seeing?

--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
