Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbXDEBfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbXDEBfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 21:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXDEBfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 21:35:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18887 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbXDEBfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 21:35:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=s7QFfkXqGB2/jkxCPMcSi7onZ6CN0+sBLpE4g/PuboX+pUdn0WW5Z2xTeuv0DNMdG
	FA1Au2geAqGH0QdMhRHCw==
Message-ID: <6599ad830704041835g38d40e8auc79ed8436bec19bb@mail.gmail.com>
Date: Wed, 4 Apr 2007 18:35:28 -0700
From: "Paul Menage" <menage@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: vatsa@in.ibm.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       dev@sw.ru, devel@openvz.org
In-Reply-To: <m1ircb2168.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070403171155.GK2456@in.ibm.com>
	 <20070403175101.GN2456@in.ibm.com>
	 <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
	 <20070404030756.GA9008@in.ibm.com>
	 <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com>
	 <20070404051526.GA16562@in.ibm.com>
	 <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com>
	 <20070404172643.GA28328@in.ibm.com>
	 <6599ad830704041157m22f62077tbc41dbc064385838@mail.gmail.com>
	 <m1ircb2168.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> In addition there appear to be some weird assumptions (an array with
> one member per task_struct) in the group.  The pid limit allows
> us millions of task_structs if the user wants it.   A several megabyte
> array sounds like a completely unsuitable data structure.   What
> is wrong with just traversing task_list at least initially?

The current code creates such arrays when it needs an atomic snapshot
of the set of tasks in the container (e.g. for reporting them to
userspace or updating the mempolicies of all the tasks in the case of
cpusets). It may be possible to do it by traversing tasklist and
dropping the lock to operate on each task where necessary - I'll take
a look at that.

>
> - What functionality do we want to provide.
> - How do we want to export that functionality to user space.

I'm working on a paper for OLS that sets out a lot of these issues -
I'll send you a draft copy hopefully tonight.

>
> You can share code by having an embedded structure instead of a magic
> subsystem things have to register with, and I expect that would be
> preferable.  Libraries almost always are easier to work with then
> a subsystem with strict rules that doesn't give you choices.
>
> Why do we need a subsystem id?  Do we expect any controllers to
> be provided as modules?  I think the code is so in the core that
> modules of any form are a questionable assumption.

One of the things that I'd really like to be able to do is allow
userspace to mount one filesystem instance with several
controllers/subsystems attached to it, so that they can define a
single task->container mapping to be used for multiple different
subsystems.

I think that would be hard to do without a central registration of subsystems.

I'm not particularly expecting modules to register as subsystems,
since as you say they'd probably need to be somewhat embedded in the
kernel in order to operate. And there are definite performance
advantages to be had from allowing in-kernel subsystems to have a
constant subsystem id.

It would be nice if subsystems could optionally have a dynamic
subsystem id so that new subsystem patches didn't have to clash with
one another in some global enum, but maybe that's not worth worrying
about at this point.

>
> I'm inclined to the rcfs variant and using nsproxy (from what I have
> seen in passing) because it is more of an exercise in minimalism, and I
> am strongly inclined to be minimalistic.

There's not a whole lot of difference between the two patch sets,
other than the names, and whether they piggyback on nsproxy or on a
separate object (container_group) that could be merged with nsproxy
later if it seemed appropriate. Plus mine have the ability to support
subsystem callbacks on fork/exit, with no significant overhead in the
event that no configured subsystems actually want those callbacks.

Paul
