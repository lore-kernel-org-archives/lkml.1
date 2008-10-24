Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYJXWSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYJXWSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYJXWR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:17:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34039 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752431AbYJXWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:17:57 -0400
Message-ID: <490249CF.2080308@sgi.com>
Date: Fri, 24 Oct 2008 15:18:55 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz>	<20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org>
In-Reply-To: <87mygt9815.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Mike Travis <travis@sgi.com> writes:
>> I do use the timer mechanism (once per second) to update the scir state.
>> Unfortunately, the state is *always* not idle during the timer callback
>> (since we are actively executing), so I needed some way of knowing the
>> idle state prior to the timer callback.
> 
> The idle thread always has pid 0. So if the timer sees current->pid == 0
> it interrupted idle.
> 
> But sampling only once a second would be presumably not very accurate.
> You could just check the per cpu statistics the kernel keeps
> anyways in the timer.
> 
> I agree with Ingo that this doesn't belong in a idle notifier.
> 
> -Andi

Cool, thanks!  I rewrote the patch to use current->pid, removing the
idle callback.

On ia64 the activity indicator was kept up to date by modifying the
register state every time the cpu went into and out of idle.  Ingo
thought this was excessive I/O overhead and since then, I've learned
that the UV system has a FIFO for these registers.  So flipping the
bit every time we changed idle state would quickly fill the FIFO and
wouldn't be keeping in sync with the companion bit which indicates
that the cpu is interruptible.

So the hw group decided that having a once per second indicator, even
if it's only a very narrow (instant) sampling period, would meet their 
requirements.

Thanks!
Mike
