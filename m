Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbYLXVdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbYLXVdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 16:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYLXVdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 16:33:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:53157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYLXVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 16:33:15 -0500
Subject: Re: asterisk hangs with RT priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20081224203747.GA32060@gondor.apana.org.au>
References: <483054DB.4030504@trash.net>
	 <20081224113617.GA29037@gondor.apana.org.au>
	 <20081224134225.GA4666@linux.vnet.ibm.com>
	 <20081224203747.GA32060@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 24 Dec 2008 22:32:43 +0100
Message-Id: <1230154363.24082.10.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-25 at 07:37 +1100, Herbert Xu wrote:
> On Wed, Dec 24, 2008 at 07:12:25PM +0530, Dhaval Giani wrote:
> > 
> > Hmm. Do you have CONFIG_FAIR_USER_SCHED set on?
> 
> I can't find such a config option, but
> 
> $ grep SCHED .config
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_RT_GROUP_SCHED=y
> CONFIG_USER_SCHED=y
> # CONFIG_CGROUP_SCHED is not set

> CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
> CONFIG_SCHED_HRTICK=y

So you have uid-group scheduling and RT-group scheduling enabled (a
feature that's experimental for real and has never been enabled by
default), looking at the sys_setuid() code, the real uid change is done
by switch_uid() and that doesn't have a failable scheduler hook.

The thing is, I suspect the uid you switch to doesn't have a RT runtime
quota configured, therefore the RT task that gets placed in it by
switch_uid() doesn't get to run.

[ Please read Documentation/scheduler/sched-rt-group.txt
  when you enable RT group scheduling ]

The correct thing would be for switch_uid() (or set_user) to fail with
-EINVAL, much like cpu_cgroup_can_attach() currently does for cgroup
grouping.

After that it demonstrates a bug in your test program, which fails to
check errors ;-)


