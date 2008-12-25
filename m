Return-Path: <linux-kernel-owner+w=401wt.eu-S1752011AbYLYHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbYLYHwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 02:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYLYHwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 02:52:09 -0500
Received: from viefep14-int.chello.at ([62.179.121.34]:25747 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948AbYLYHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 02:52:08 -0500
X-SourceIP: 213.46.9.244
Subject: Re: asterisk hangs with RT priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhaval@linux.vnet.ibm.com, kaber@trash.net, mingo@elte.hu,
       linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, balbir@in.ibm.com
In-Reply-To: <E1LFbsj-0008WU-Gp@gondolin.me.apana.org.au>
References: <E1LFbsj-0008WU-Gp@gondolin.me.apana.org.au>
Content-Type: text/plain
Date: Thu, 25 Dec 2008 08:52:07 +0100
Message-Id: <1230191527.9487.262.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-25 at 09:07 +1100, Herbert Xu wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > So you have uid-group scheduling and RT-group scheduling enabled (a
> > feature that's experimental for real and has never been enabled by
> > default), looking at the sys_setuid() code, the real uid change is done
> > by switch_uid() and that doesn't have a failable scheduler hook.
> 
> An experimental marking is no excuse for being broken.

True, and we strive to fix them -- so thanks for finding this one.

> > The thing is, I suspect the uid you switch to doesn't have a RT runtime
> > quota configured, therefore the RT task that gets placed in it by
> > switch_uid() doesn't get to run.
> > 
> > [ Please read Documentation/scheduler/sched-rt-group.txt
> >  when you enable RT group scheduling ]
> 
> This seems broken to me.  The only way for a process to get into
> RR mode is if it had been set by someone with the right privileges
> or if it was inherited from its parent.
> 
> So having a default where such a process stops executing altogether
> after performing a setuid is wrong.

True, therefore the setuid must fail.

> The default should be to give each user a non-zero allotment.

That's sadly impossible. The thing is, you cannot over-commit this time
-- nor change an active configuration. So the only possibility left is a
default of 0.

> > The correct thing would be for switch_uid() (or set_user) to fail with
> > -EINVAL, much like cpu_cgroup_can_attach() currently does for cgroup
> > grouping.
> > 
> > After that it demonstrates a bug in your test program, which fails to
> > check errors ;-)
> 
> Well the program which this was based on, asterisk does check for
> errors on setuid.  However, even if setuid did return an error this
> isn't much better than the status quo since the user will be left
> with the question "why on earth is asterisk failing on setuid?".

Maybe a more descriptive error like -ENOTIME ?

