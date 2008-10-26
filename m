Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYJZLmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYJZLmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYJZLmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:42:42 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:36147 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYJZLml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:42:41 -0400
Date: Sun, 26 Oct 2008 13:42:39 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       walt <w41ter@gmail.com>
Subject: Re: [PULL] module, param and stop_machine patches
Message-ID: <20081026124239.GA4787@osiris.boeblingen.de.ibm.com>
References: <200810221005.59874.rusty@rustcorp.com.au> <200810260924.09479.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org> <200810261916.17311.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810261916.17311.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 07:16:16PM +1100, Rusty Russell wrote:
> On Sunday 26 October 2008 09:33:43 Linus Torvalds wrote:
> > On Sun, 26 Oct 2008, Rusty Russell wrote:
> > > Thanks, Heiko tracked this down; he's probably sleeping now but Hugh and
> > > Walt reported this fixes it for them and it makes sense.
> > I'm not seeing any "tracked it down".
> He tracked it down to moving init_workqueues() too early, so he moved that
> back.
> 
> > And it then mixes things up with 'stop_machine_init()' mess. Why does that
> > need to run so early?
> 
> The S/390 guys want to run it stop_machine v. early, so when Heiko introduced
> stop_machine_init() he made it an early_initcall().
> 
> > IOW, I don't think that patch is anything but a "hey, test if it works
> > with this". None of the changes or the problems are explained.
> 
> Indeed.
> 
> Turns out it's the cpu_online_map difference.  If init_workqueues() is called
> too early, only the boot cpu is set.  We then only create_workqueue_thread()
> for the boot cpu.
> 
> If CONFIG_HOTPLUG_CPU=y, it's fine since the hotplug callback will create the
> workqueue threads for the other cpus as they come up.  Without it, the kevent
> workqueues on non-boot cpus don't get processed.
> 
> Still boots for me, but was a bit sick (varying, but no keyboard was one
> symptom).

Yes, it's all my fault. I always think in terms of CONFIG_HOTPLUG_CPU=y, so
I couldn't make any sense of the bug reports and just reverted the
init_workqueues() call move and added an explicit stop_machine_init() call,
so that we don't depend on linkage order.
Thanks for tracking it down, Rusty!

> > Nor do I see a sign-off from Heiko on it.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

But I guess you don't need that anymore since you already committed a
fix for this.

Thanks,
Heiko
