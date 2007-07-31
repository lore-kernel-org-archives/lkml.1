Return-Path: <linux-kernel-owner+w=401wt.eu-S940453AbXGaF43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940453AbXGaF43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbXGaF4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:56:21 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60384 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbXGaF4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:56:20 -0400
Message-ID: <46AECEE0.3000307@ah.jp.nec.com>
Date: Tue, 31 Jul 2007 14:55:44 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de>	<20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de>	<20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de>	<20070726155444.GC15969@in.ibm.com> <46A92E30.8070703@ah.jp.nec.com>	<20070730091624.GB6071@in.ibm.com> <m16442vwgs.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m16442vwgs.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@in.ibm.com> writes:
> 
>>> Bernhard's idea (kdump uses panic_notifier) is very good for me. But it isn't
>>> good for kdump user, because they want to take a dump ASAP when panicked.
>>>
>> This one is better than registering kdump as one of the users of a
>> panic_notifier() list. 
>>
>> I think if there are any crash specific actions, they should be taken care
>> in next kernel while it is booting.
>>
>> If something is really very time critical, and has to be done immediately
>> after panic (I am not sure how can one ensure that given the fact any number
>> of users can register on panic_notifier_list and you are not sure about your
>> order in the list and when one will get the control), then probably that
>> piece of code should be in kernel and called before crash_kexec().
>>
>> What is that specific piece of action which you can't do in second kernel?
>>
>> Eric, do you have any thoughts on this. I think these guys are referring
>> to failover problem where immediately after panic() they want to send
>> message to other node.
> 
> My thoughts are roughly the same as they were last time this was suggested.
> I think adding a notifier to the kexec on panic path is a bad idea.
> This functionality  sounds wrong, because it makes it hard to ensure
> reliability of the kexec on panic code path.  We are still doing to
> much on it as it stands. The working assumption on that code path
> needs to be the kernel is broken. Anything else is just asking for
> trouble.
> 
> Currently we do have a hook in place for code to be called. It is called
> the purgatory section of /sbin/kexec.  And it's user space so you can
> do whatever you want there.  Or you can wait until the second kernel
> gets more fully booted.
> 
> If we really need to do something in the kernel we can patch the kernel
> to make a function call from crash_kexec.  We don't need any notifiers
> to do this.
> 
> A further problem with notifiers is they mess up the state we would
> like to debug.  Which again makes them a problem.
> 
> 
> So at least until a specific case is made for a specific piece of code
> to get in I am totally opposed to the idea.

Hi all,

IMHO, most users don't use kdump, kdump users are only kernel developers and
enterprise users. I think enterprise users want the notifier function, because
they use some driver and software (hardware monitering driver, clustering
software, heartbeat driver, etc...) to raise their system availability.

Some popular distributers added the dump function to their own kernel. We can
use panic_notifier on LKCD (http://lkcd.sourceforge.net/), and diskdump
(http://sourceforge.net/projects/lkdump) provides own notifier function
disk_dump_notifier.

Now, kdump was merged mainline kernel. Then some distributers chose kdump.
I think kdump is greater than other dump function, but kdump has no notifier
function. This is a large problem for enterprise users.

Solutions
 1: my patch
 2: Bernhard's idea
 3: add kdump_notifier_list

I think my patch is better than other solutions, because it has only very few
impact. Vivek, Eric, how do you think?

Thanks.

