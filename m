Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZDNO5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZDNO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 10:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZDNO5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 10:57:10 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:52839 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbZDNO5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 10:57:10 -0400
Message-ID: <49E4A380.4070503@cs.columbia.edu>
Date: Tue, 14 Apr 2009 10:53:52 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: containers@lists.osdl.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Creating tasks on restart: userspace vs kernel
References: <49E40662.2040508@cs.columbia.edu> <20090414095904.GD3558@elte.hu>
In-Reply-To: <20090414095904.GD3558@elte.hu>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Oren Laadan <orenl@cs.columbia.edu> wrote:
> 
>> <3> Clone with pid:
>>
>> To restart processes from userspace, there needs to be a way to 
>> request a specific pid--in the current pid_ns--for the child 
>> process (clearly, if it isn't in use).
>>
>> Why is it a disadvantage ?  to Linus, a syscall clone_with_pid() 
>> "sounds like a _wonderful_ attack vector against badly written 
>> user-land software...".  Actually, getting a specific pid is 
>> possible without this syscall.  But the point is that it's 
>> undesirable to have this functionality unrestricted.
> 
> The point is that there's a class of a difference between a racy and 
> unreliable method of 'create tens of thousands of tasks to steal the 
> right PID you are interested in' and a built-in syscall that gives 
> this within a couple of microseconds.
> 
> Most signal races are timing dependent so the ability to do it 
> really quickly makes or breaks the practicality of many classes of 
> exploits.

Exactly.

> 
>> So one option is to require root privileges. Another option is to 
>> restrict such action in pid_ns created by the same user. Even more 
>> so, restrict to only containers that are being restarted.
> 
> Requiring root privileges seems to remove much of the appeal of 
> allowing this to be a more generic sub-container creation thing. If 
> regular unprivileged apps cannot use this to save/restore their own 
> local task hierarchy, the whole thing becomes rather pointless, 
> right?

First, I suggest to distinguish between two cases: (1) c/r of a whole
container, and (2) c/r of a task subtree. (#2 is a nice byproduct of
this work, but with more limited scope/applicability).

#2 is easier: we don't use a new ipc_ns necessarily, so we don't need
to (and perhaps can't) restore old pids. So there is no question about
privileges. (This of course requires that the application be c/r-aware
or c/r-agnostic).

For #1, we need to create a new container to begin with. This already
requires CAP_SYS_ADMIN. Yes, for now we can use some setuid() to create
a new pid_ns and then do the restart.

We will eventually need CAP_SYS_ADMIN for other parts of the restart,
for instance to restore a listening socket on a privileged port, or to
restore tasks of multiple users, or to restore an open file accessible
by, say, root only (assume the original task opened the file and then
dropped its privileges).

So for c/r - eventually we'll need to trust something in the checkpoint
image, like you trust a kernel module. One way to do it is to have the
userland utility (particularly restart) setuid, and have it sign the
image during checkpoint and then verify the signature during restart.

Oren.
