Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbXJRIGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbXJRIGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXJRIGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:06:31 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59841 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbXJRIG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:06:28 -0400
Date: Thu, 18 Oct 2007 13:36:22 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Takenori Nagano <t-nagano@ah.jp.nec.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>, kdb@oss.sgi.com
Subject: Re: [PATCH 0/2] add new notifier function ,take2
Message-ID: <20071018080621.GB8779@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <471700F4.1080200@ah.jp.nec.com> <20071018000651.35b26e42.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018000651.35b26e42.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2007 at 12:06:51AM -0700, Andrew Morton wrote:
> On Thu, 18 Oct 2007 15:45:08 +0900 Takenori Nagano <t-nagano@ah.jp.nec.com> wrote:
> 
> > Hi,
> > 
> > A big thanks to everybody who read and replied to first version. I have tried to
> > incorporate reviewer's comments and suggestions.
> > 
> > changelog take1 -> take2
> > 
> > - Rebased 2.6.23
> > - comment updated
> > - renamed the notifiner name "tunable_notifier" to "tunable_atomic_notifier"
> > - fixed typo
> > 
> > 
> > These patches add new notifier function and implement it to panic_notifier_list.
> > We used the hardcoded notifier chain so far, but it was not flexible. New
> > notifier is very flexible, because user can change a list of order by debugfs.
> > 
> > Thanks,
> > 
> > Example)
> > 
> > # cd /sys/kernel/debug/
> > # ls
> > kprobes  pktcdvd
> > # insmod ipmi_msghandler.ko
> > # ls
> > kprobes  panic_notifier_list  pktcdvd
> > # cd panic_notifier_list/
> > # ls
> > ipmi_msghandler
> > # insmod ipmi_watchdog.ko
> > # ls
> > ipmi_msghandler  ipmi_wdog
> > # cat ipmi_msghandler/priority
> > 200
> > # cat ipmi_wdog/priority
> > 150
> > #
> > Kernel panic - not syncing: panic
> > ipmi_msghandler : notifier calls panic_event().
> > ipmi_watchdog : notifier calls wdog_panic_handler().
> > 
> > .....(reboot)
> > 
> > # cat ipmi_msghandler/priority
> > 200
> > # cat ipmi_wdog/priority
> > 150
> > # echo 300 > ipmi_wdog/priority
> > #
> > Kernel panic - not syncing: panic
> > ipmi_watchdog : notifier calls wdog_panic_handler().
> > ipmi_msghandler : notifier calls panic_event().
> 
> I can sort-of see what this is doing.  Runtime-definable management of
> which notifier functions will be called on a panic?  Or maybe I
> misunderstood.
> 
> But even if I did understand, I don't understand why Linux needs this
> feature - what are the use cases, what is the value to our users?
> 
> Can you please flesh that information out a bit more?
> 

Hi Andrew,

Takenori wants to make kdb and kdump co-exist. Currently after panic()
panic_notifier_list is not executed if kdump is configured. Before list
is executed, system will boot into second kernel to capture the dump. Hence
if even if kdb was registered on panic_notifier_list, it will never get
a chance to run.

One of the ideas was to put all the RAS tools on panic_notifier_list, export
the list to user space and let user determine the order in which these
should be called. That's why this patchset is there.

This does bring in some reliability concerns for kdump as now there is
additional dependency on notifier infrastructure after panic.

Eric, had suggested that kdb can put a break point on panic() to handle
the co-existence issue and no need to bring in additional dependencies in
panic path.

I agree with the idea of kdb putting a break point in panic. If there are
more tools down the line who run into co-existence issue with kdump, then
we can re-visit this idea.

Thanks
Vivek


> The patches are somewhat wordwrapped - please check your email client
> configuration, thanks.
