Return-Path: <linux-kernel-owner+w=401wt.eu-S1764453AbXHAKE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764453AbXHAKE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 06:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbXHAKEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 06:04:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44171 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761420AbXHAKEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 06:04:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de>
	<20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de>
	<20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de>
	<20070726155444.GC15969@in.ibm.com> <46A92E30.8070703@ah.jp.nec.com>
	<20070730091624.GB6071@in.ibm.com>
	<m16442vwgs.fsf@ebiederm.dsl.xmission.com>
	<46AECEE0.3000307@ah.jp.nec.com>
	<m1fy35t665.fsf@ebiederm.dsl.xmission.com>
	<46B051B5.6020207@ah.jp.nec.com>
Date: Wed, 01 Aug 2007 04:00:48 -0600
In-Reply-To: <46B051B5.6020207@ah.jp.nec.com> (Takenori Nagano's message of
	"Wed, 01 Aug 2007 18:26:13 +0900")
Message-ID: <m18x8vpoa7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takenori Nagano <t-nagano@ah.jp.nec.com> writes:

>> No.  The problem with your patch is that it doesn't have a code
>> impact.  We need to see who is using this and why.
>
> My motivation is very simple. I want to use both kdb and kdump, but I think it
> is too weak to satisfy kexec guys. Then I brought up the example enterprise
> software. But it isn't a lie. I know some drivers which use panic_notifier.
> IMHO, they use only major distribution, and they has the workaround or they
> don't notice this problem yet. I think they will be in trouble if all
> distributions choose only kdump.

Possibly.

> BTW, I use kdb and lkcd now, but I want to use kdb and kdump. I sent a patch to
> kdb community but it was rejected. kdb maintainer Keith Owens said,

>> Both KDB and crash_kexec should be using the panic_notifier_chain, with
>> KDB having a higher priority than crash_exec.  The whole point of
>> notifier chains is to handle cases like this, so we should not be
>> adding more code to the panic routine.
>>
>> The real problem here is the way that the crash_exec code is hard coded
>> into various places instead of using notifier chains.  The same issue
>> exists in arch/ia64/kernel/mca.c because of bad coding practices from
>> kexec.

I respectfully disagree with his opinion, as using notifier chains
assumes more of the kernel works.  Although following it's argument
to it's logical conclusion we should call crash_kexec as the very
first thing inside of panic.  Given how much state something like
bust_spinlocks messes up that might not be a bad idea.

It does make adding an alternative debug mechanism in there difficult.
Does anyone know if this also affects kgdb?

> Then I gave up to merge my patch to kdb, and I tried to send another patch to
> kexec community. I can understand his opinion, but it is very difficult to
> modify that kdump is called from panic_notifier. Because it has a reason why
> kdump don't use panic_notifier. So, I made this patch.
>
> Please do something about this problem.

Hmm.  Tricky.  These appear to be two code bases with a completely different
philosophy on what errors are being avoided.

The kexec on panic assumption is that the kernel is broken and we better not
touch it something horrible has gone wrong.  And this is the reason why
kexec on panic is replacing lkcd.  Because the strong assumption results
in more errors getting captured with less likely hood of messing up your
system.

The kdb assumption appears to be that the kernel is mostly ok, and that there
are just some specific thing that is wrong.

The easiest way I can think to resolve this is for kdb to simply set
a break point at the entry point of panic() when it initializes.  Then
it wouldn't even need to be on the panic_list.  That approach would probably
even give better debug information because you would not have the effects
of bust_spinlocks to undo.

Is there some reason why kdb doesn't want to hook panic with a some
kind of break point?

Eric
