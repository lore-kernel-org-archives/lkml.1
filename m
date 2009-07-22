Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZGVCCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZGVCCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZGVCCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:02:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40107 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZGVCCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:02:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A6672F9.3050800@jp.fujitsu.com>
Date: Wed, 22 Jul 2009 11:01:29 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
 handler"
References: <4A64672E.8020005@cn.fujitsu.com> <4A6564F2.10404@jp.fujitsu.com> <20090721110857.GA21612@hmsreliant.think-freely.org>
In-Reply-To: <20090721110857.GA21612@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> None of this answers Erics question, what is it that you could do before, that
> you couldn't do now?

One is, as Ohmichi-san pointed, triggering kdump via echo c > /proc/sysrq-trigger.

In contrast to oops via SysRq-c from keyboard interrupt which results in
panic due to in_interrupt(), oops via echo-c will not become panic unless
panic_on_oops.

So in other words, we could expect same effect in both of echo-c and SysRq-c
before, but now we cannot because it depends on the panic_on_oops.
Isn't it a regression?

Whether kdump should be executed on oops (which is not panic) or not is a
separate thing.

> There are reasons to want to have a convenient way to
> crash the kernel, other than to test kdump (several distributions have augmented
> sysrq-c to do this for some time to test other previous dump mechanisms and
> features), so while its not been upstream, saying that its well known to test
> kdump without causing an oops is a bit of a misleading statement.

Let make me sure the difference between 'crash', 'oops', and 'panic'.
At least 'oops' is not panic, as is obvious from the name of panic_on_oops.
And it seems you are using 'crash' and 'oops' in mixture.

If you mean 'crash' as 'panic', my complaint is echo-c does not panic while
SysRq-c does panic.  So if possible I'd like to suggest a change like:

 static void sysrq_handle_crash(int key, struct tty_struct *tty)
 {
-	char *killer = NULL;
-	*killer = 1;
+	panic("SysRq-triggered panic!\n");
 }

I agree that causing a real crash(panic) is better way to test crashdump than
calling the entry function of the crashdump directly, and also that opening
the path for other dump mechanisms is welcomed.
 
> It seems to
> me that right now your major complaint is that the documentation is out of date,
> and you're having to do things slightly differently to get the same behavioral
> results.  Would it solve your issue, if we simply updated the documentation to
> illustrate how it works now?

Of course the documentation should be updated asap.
But I think the major complaint is about a difference in the behaviors of SysRq-c
and "echo c > /proc/sysrq-trigger".


Thanks,
H.Seto

