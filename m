Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZIIETa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZIIETa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZIIET3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:19:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38714 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZIIET3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:19:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: rostedt@goodmis.org
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on oops
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1252464784.12982.4.camel@gandalf.stny.rr.com>
References: <4AA715A3.8040108@cn.fujitsu.com> <1252464784.12982.4.camel@gandalf.stny.rr.com>
Message-Id: <20090909122425.0CEF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Sep 2009 13:19:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-09-09 at 10:40 +0800, Li Zefan wrote:
> 
> > > I have another silly question.
> > > Why should we call tracing_off() in oops_enter()?
> > > 
> > 
> > I guess it's because trace outputs generated during oops can
> > overwrite/mess up those generated before oops?
> > 
> > It was added by this commit, but I can't find trace_printk_on_oops.
> 
> That's because Thomas did not bother looking up the actual variable he
> was talking about. s/trace_printk_on_oops/ftrace_dump_on_oops/

After a bit thinking, I think ftrace_dump_on_oops and kernel dump with panic have
very similar requirement.
Then, I think we can reuse this infrastructure for kernel dump.

Requirement
  - Need to know why the problem occur.
  - Need to don't logging oops (panic) internal.

Unfortunately, panic() call panic_notifier after crash_kexec().
it mean tracing_off() was not called when panic on the machine w/ kernel-dump.

	NORET_TYPE void panic(const char * fmt, ...)
	{
	(snip)
	        crash_kexec(NULL);
	(snip)
	        atomic_notifier_call_chain(&panic_notifier_list, 0, buf);

I think we can insert tracing_off() into panic() directly. it only
bit mask operation, it mean it don't have side effect risk.

Perhaps, There are other kernel dump specific requrement. but I guess
it's very small. Maybe it can be handled by trace_die_handler() or something like.

What do you think?


> 
> -- Steve
> 
> > 
> > commit bdff78707f3ce47e891f3201c9666122a70556ce
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Fri Jul 24 15:30:45 2009 -0400
> > 
> >     trace: stop tracer in oops_enter()
> > 
> >     If trace_printk_on_oops is set we lose interesting trace information
> >     when the tracer is enabled across oops handling and printing. We want
> >     the trace which might give us information _WHY_ we oopsed.
> > 
> 



