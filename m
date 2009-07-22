Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZGVLL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZGVLL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbZGVLL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:11:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34657 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbZGVLL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:11:26 -0400
Date: Wed, 22 Jul 2009 07:10:49 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
	handler"
Message-ID: <20090722111049.GB4539@hmsreliant.think-freely.org>
References: <4A64672E.8020005@cn.fujitsu.com> <4A6564F2.10404@jp.fujitsu.com> <20090721110857.GA21612@hmsreliant.think-freely.org> <4A6672F9.3050800@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6672F9.3050800@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:01:29AM +0900, Hidetoshi Seto wrote:
> Neil Horman wrote:
> > None of this answers Erics question, what is it that you could do before, that
> > you couldn't do now?
> 
> One is, as Ohmichi-san pointed, triggering kdump via echo c > /proc/sysrq-trigger.
> 
> In contrast to oops via SysRq-c from keyboard interrupt which results in
> panic due to in_interrupt(), oops via echo-c will not become panic unless
> panic_on_oops.
> 
> So in other words, we could expect same effect in both of echo-c and SysRq-c
> before, but now we cannot because it depends on the panic_on_oops.
> Isn't it a regression?
> 
Only if you blindly consider a change in behavior to be a regression.  consider
that previously executing a sysrq-c did the same thing if you did a echo c >
/proc/sysrq-trigger on a keyboard sysrq-c, but did different things based on
weather or not your had a kexec kernel loaded.

> Whether kdump should be executed on oops (which is not panic) or not is a
> separate thing.
> 
> > There are reasons to want to have a convenient way to
> > crash the kernel, other than to test kdump (several distributions have augmented
> > sysrq-c to do this for some time to test other previous dump mechanisms and
> > features), so while its not been upstream, saying that its well known to test
> > kdump without causing an oops is a bit of a misleading statement.
> 
> Let make me sure the difference between 'crash', 'oops', and 'panic'.
> At least 'oops' is not panic, as is obvious from the name of panic_on_oops.
> And it seems you are using 'crash' and 'oops' in mixture.
> 
I'm perfectly well aware of the difference, I just assert theres value to having
sysrq-c be able to test both paths, especially given that we already have the
sysrq-c sysctl available to toggle behavior for just this case.

> If you mean 'crash' as 'panic', my complaint is echo-c does not panic while
> SysRq-c does panic.  So if possible I'd like to suggest a change like:
>
See above, I think theres value to having sysrq-c be able to do both, although I
agree the method by which it triggers both is a bit muddled.
 
>  static void sysrq_handle_crash(int key, struct tty_struct *tty)
>  {
> -	char *killer = NULL;
> -	*killer = 1;
> +	panic("SysRq-triggered panic!\n");
>  }
> 
Well, this removes the ability from sysrq-c to test the oops handling path, but
I suppose it does buy us consistent behavior between the keyboard and proc
interfaces, which is likely more important.  I can agree to that.  Perhaps we
can create another sysctl to test the oops path later.

> I agree that causing a real crash(panic) is better way to test crashdump than
> calling the entry function of the crashdump directly, and also that opening
> the path for other dump mechanisms is welcomed.
>  
Ok, so we're in line there :)

> > It seems to
> > me that right now your major complaint is that the documentation is out of date,
> > and you're having to do things slightly differently to get the same behavioral
> > results.  Would it solve your issue, if we simply updated the documentation to
> > illustrate how it works now?
> 
> Of course the documentation should be updated asap.
> But I think the major complaint is about a difference in the behaviors of SysRq-c
> and "echo c > /proc/sysrq-trigger".
> 
Ok, I can agree with that.  I'd support a change like what you have above to
bring the keyboard and proc interface behavior in line.

Regards
Neil


> 
> Thanks,
> H.Seto
> 
> 
