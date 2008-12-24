Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbYLXWH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbYLXWH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYLXWHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:07:21 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:53822 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751254AbYLXWHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:07:20 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: a.p.zijlstra@chello.nl (Peter Zijlstra)
Subject: Re: asterisk hangs with RT priority
Cc: herbert@gondor.apana.org.au, dhaval@linux.vnet.ibm.com, kaber@trash.net,
       mingo@elte.hu, linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, balbir@in.ibm.com
Organization: Core
In-Reply-To: <1230154363.24082.10.camel@lappy.programming.kicks-ass.net>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1LFbsj-0008WU-Gp@gondolin.me.apana.org.au>
Date: Thu, 25 Dec 2008 09:07:09 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> So you have uid-group scheduling and RT-group scheduling enabled (a
> feature that's experimental for real and has never been enabled by
> default), looking at the sys_setuid() code, the real uid change is done
> by switch_uid() and that doesn't have a failable scheduler hook.

An experimental marking is no excuse for being broken.

> The thing is, I suspect the uid you switch to doesn't have a RT runtime
> quota configured, therefore the RT task that gets placed in it by
> switch_uid() doesn't get to run.
> 
> [ Please read Documentation/scheduler/sched-rt-group.txt
>  when you enable RT group scheduling ]

This seems broken to me.  The only way for a process to get into
RR mode is if it had been set by someone with the right privileges
or if it was inherited from its parent.

So having a default where such a process stops executing altogether
after performing a setuid is wrong.

The default should be to give each user a non-zero allotment.

> The correct thing would be for switch_uid() (or set_user) to fail with
> -EINVAL, much like cpu_cgroup_can_attach() currently does for cgroup
> grouping.
> 
> After that it demonstrates a bug in your test program, which fails to
> check errors ;-)

Well the program which this was based on, asterisk does check for
errors on setuid.  However, even if setuid did return an error this
isn't much better than the status quo since the user will be left
with the question "why on earth is asterisk failing on setuid?".

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
