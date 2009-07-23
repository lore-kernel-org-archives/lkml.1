Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZGWOO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZGWOO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZGWOO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:14:28 -0400
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:49338 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZGWOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:14:27 -0400
Message-ID: <4A68703B.8030408@librato.com>
Date: Thu, 23 Jul 2009 10:14:19 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task	other
 than ourself
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com> <20090722175223.GA19389@us.ibm.com> <4A67E7D7.9060800@librato.com> <20090723131250.GA9535@us.ibm.com>
In-Reply-To: <20090723131250.GA9535@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@librato.com):
>>
>> Serge E. Hallyn wrote:
>>> Quoting Oren Laadan (orenl@librato.com):
>>>> Now we can do "external" checkpoint, i.e. act on another task.
>>> ...
>>>
>>>>  long do_checkpoint(struct ckpt_ctx *ctx, pid_t pid)
>>>>  {
>>>>  	long ret;
>>>>
>>>> +	ret = init_checkpoint_ctx(ctx, pid);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (ctx->root_freezer) {
>>>> +		ret = cgroup_freezer_begin_checkpoint(ctx->root_freezer);
>>>> +		if (ret < 0)
>>>> +			return ret;
>>>> +	}
>>> Self-checkpoint of a task in root freezer is now denied, though.
>>>
>>> Was that intentional?
>> Yes.
>>
>> "root freezer" is an arbitrary task in the checkpoint subtree or
>> container. It is used to verify that all checkpointed tasks - except
>> for current, if doing self-checkpoint - belong to the same freezer
>> group.
>>
>> Since current is busy calling checkpoint(2), and since we only permit
>> checkpoint of (cgroup-) frozen tasks, then - by definition - it cannot
>> possibly belong to the same group. If it did, it would itself be frozen
>> like its fellows and unable to call checkpoint(2).
> 
> So then you're saying that regular self-checkpoint no longer works,
> but the documentation still shows self.c and claims it should just
> work.

I'm unsure why you say that self-checkpoint no longer works ?
In fact, I just double checked that it does.

Self-checkpoint has two immediate use-cases:

1) Single process that checkpoints itself - ctx->root_freezer remains
NULL, which causes cgroup_freezer_begin_checkpoint() to be skipped.

2) Process P that belongs to a hierarchy (subtree or container), and
P calls checkpoint(2) to checkpoint the hierarchy.
For this to work, all other processes in the hierarchy must be frozen.
Therefore, they also belong to a freezer cgroup (perhaps more than one -
but that is not permitted).
In this case, ctx->root will point to a process from the freezer cgroup,
and the code tests all other processes (excluding P, which is current)
to confirm that they belong to the same freezer cgroup.
P itself can not possibly belong to it, otherwise it would have been
frozen and not executing the checkpoint(2) syscall.

IOW, for case 2 to work, one must arrange for all tasks in the target
hierarchy, except for P (- current, the checkpointer), to belong to
a single freezer cgroup, and for that cgroup to be frozen.

>>> Self-checkpoint of a task in root freezer is now denied, though.

Maybe I didn't really understand what you meant by that, and by
"root freezer" ?

> 
> Mind you I prefer this as it is more consistent, but I thought it
> was something you wanted to support.

Self-checkpoint simply allows a process to checkpoint itself (and
perhaps additional processes too). I never quite understood why you
view it as a source of inconsistency ...

Nevertheless, it still works.

Oren.

