Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYJ3Rr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYJ3Rr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYJ3Rrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:47:48 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:45437 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYJ3Rrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:47:47 -0400
Message-ID: <4909F2B5.7040907@cs.columbia.edu>
Date: Thu, 30 Oct 2008 13:45:25 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: Andrey Mirkin <major@openvz.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based	checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org> <200810271707.13580.major@openvz.org> <4905D2AD.1070309@cs.columbia.edu> <200810300902.47067.major@openvz.org> <20081030114747.GL15171@hawkmoon.kerlabs.com>
In-Reply-To: <20081030114747.GL15171@hawkmoon.kerlabs.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Louis Rilling wrote:
> On Thu, Oct 30, 2008 at 10:02:44AM +0400, Andrey Mirkin wrote:
>>>> kernel. Also we will need a functionolity to create processes with
>>>> predefined PID. I think it is not very good to provide such ability to
>>>> user space. That is why we prefer in OpenVZ to do all the job in kernel.
>>> This is the weak side of creating the processes in user space -
>>> that we need such an interface. Note, however, that we can
>>> easily "hide" it inside the interface of the sys_restart() call,
>>> and restrict how it may be used.
>> Of course we can "hide" it somehow, but anyway we will have a hole and that is 
>> not good.
>>
>> Anyway we should ask everyone what they think about user- and kernel- based 
>> process creation.
>> Dave, Serge, Cedric, Daniel, Louis what do you think about that?
> 
> Frankly, I'm not convinced (yet) that one approach is better than the other one.
> I only *tend* to prefer kernel-based, for the reasons explained below. I know
> that there are arguments in favor of userspace (I've at least seen
> security-related ones), but I let their authors detail them (again).

I'm not convinced either. I think both implementation can eventually
work well.

> 
> In Kerrighed this is kernel-based, and will remain kernel-based because we
> checkpoint a distributed task tree, and want to restart it as mush as possible
> with the same distribution. The distributed protocol used for restart is
> currently too fragile and complex to rely on customized user-space
> implementations. That said, if someone brings very good arguments in favor of
> userspace implementations, we might consider changing this.

Zap also has distributed checkpoint which does not require strict
kernel-side ordering. Do you need that because you do SSI ?

> 
> Without taking distributed restart into account, I also tend to prefer
> kernel-based, mainly for two (not so strong) reasons:
> 1) this prevents userspace from doing weird things, like changing the task tree
> and let the kernel detect it and deal with the mess this creates (think about
> two threads being restarted in separate processes that do not even share their
> parents). But one can argue that userspace can change the checkpoint image as
> well, so that the kernel must check for such weird things anyway.

I don't really buy this argument. First, as you say, user can change
the checkpoint image file. Second, you can verify in the kernel that
the real relationships of the processes match those specified (and
expected from) the image file. That's pretty straightforward.

> 2) restart will be more efficient with respect to shared objects.

Can you elaborate on this ?  In what sense "more efficient" ?

Note that the topic in question is not whether to do the entire restart
from user space (and I argue that most work should be done in the kernel),
but rather whether process creation (and only that) should be done in
kernel or user space.

Quick thoughts of pros/cons of each approach are:

user space:

+ re-use existing api (fork)
+ easier to debug
+ will allow 'handmade' resources restart: it was mentioned before that
  one may want to reattach stdout to a different place after restart; a
  user based restart of processes can make this much easier: e.g. the
  user process can create the alternative resources, give them to the
  kernel and only then call sys_restart)
+ arch-independent code

- a bit slower than in kernel space
- requires a clone-with-specific-pid syscall or interface

kernel space:

+ a bit easier to control everything
+ a bit faster than user space
+ no need for user-visible interface for clone-with-...

- arch-dependent code
- needs special code to fight 'fork-bomb'

So, I'm not convinced, and I even think there may be room to both, for
the time being. I volunteer to support the user-space alternative while
we make up our minds.

Oren.

