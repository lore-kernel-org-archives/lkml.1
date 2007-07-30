Return-Path: <linux-kernel-owner+w=401wt.eu-S935679AbXG3JRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935679AbXG3JRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763226AbXG3JRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:17:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47414 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761793AbXG3JRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:17:33 -0400
Date: Mon, 30 Jul 2007 14:46:24 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       k-miyoshi@cb.jp.nec.com, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070730091624.GB6071@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de> <20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de> <20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de> <20070726155444.GC15969@in.ibm.com> <46A92E30.8070703@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46A92E30.8070703@ah.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 08:28:48AM +0900, Takenori Nagano wrote:
> Hi Vivek,
> 
> Vivek Goyal wrote:
> > On Thu, Jul 26, 2007 at 05:47:18PM +0200, Bernhard Walle wrote:
> >> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-26 17:44]:
> >>>> Of course, but that's why the patch doesn't change this by default but
> >>>> gives the user the choice.
> >>>>
> >>> What value will distro set it to by default?
> >> 0.
> >>
> >>> Can we be more specific in terms of functionality and code that exactly
> >>> what we are trying to do after panic?
> >> Well, KDB, but now everybody answers with “not mainline -- doesn't
> >> count”.
> >>
> > 
> > That's true. Its not mainline. We had similar discussion in the past
> > also. I think we should allow only audited code to be run after panic().
> > Leaving it open to modules or unaudited code makes this solution
> > something like LKCD where whole lot of code used to run after the crash,
> > hence was unreliable.
> 
> It is *not* KDB specific problem. Please grep in mainline kernel. You can find
> some function using panic_notifier_list. (IPMI, softdog, heartbeat, etc...)
> My patch gives a chance to use kdump for panic_notifier user. It is good for
> kdump too, because kdump user goes to increase. :-)

I grepped for couple of items. Heartbeat functionality of for stopping
responding to service processsor in case of panic so that service processor
knows that system has crashed and it needs to reboot the machine. But if
somebody has configured and enabled kdump then we don't want service 
processor to stop responding to heartbeat otherwise service processor
will reboot the machine and we will not be able to capture the dump.

In case of detecting softlockup, panic notifier is used so that in case
of panic we don't want to flag other threads are not being scheduled and
it is a softlockup. In case of kdump this condition is not valid. Immediately
after kdump we will boot to next OS and previous kernel's context is wiped
off.

Can you please be specific what exactly is the problem you are facing? In
what situation is this call creating the problem?

> 
> Bernhard's idea (kdump uses panic_notifier) is very good for me. But it isn't
> good for kdump user, because they want to take a dump ASAP when panicked.
> 

This one is better than registering kdump as one of the users of a
panic_notifier() list. 

I think if there are any crash specific actions, they should be taken care
in next kernel while it is booting.

If something is really very time critical, and has to be done immediately
after panic (I am not sure how can one ensure that given the fact any number
of users can register on panic_notifier_list and you are not sure about your
order in the list and when one will get the control), then probably that
piece of code should be in kernel and called before crash_kexec().

What is that specific piece of action which you can't do in second kernel?

Eric, do you have any thoughts on this. I think these guys are referring
to failover problem where immediately after panic() they want to send
message to other node.

Thanks
Vivek
