Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYHUNIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYHUNIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbYHUNIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:08:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbYHUNIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:08:14 -0400
Date: Thu, 21 Aug 2008 10:07:37 -0300
From: Glauber Costa <glommer@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Glauber Costa <gcosta@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [GIT PULL] time.c - respin
Message-ID: <20080821130737.GA28568@poweredge.glommer>
References: <200808201507.m7KF79Fk021224@int-mx1.corp.redhat.com> <20080821102222.GA31922@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821102222.GA31922@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 12:22:22PM +0200, Ingo Molnar wrote:
> 
> * Glauber Costa <gcosta@redhat.com> wrote:
> 
> > Ingo, please pull the latest master git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> > 
> > into your tree. It solves a bisectability issue, but I can't, 
> > unfortunately, reproduce the problem you report. So hopefuly you'll 
> > now be able to bisect your problems to a point we can find out what's 
> > going on
> 
> i've tried it, and -tip testing found a hang on 64-bit x86.
> 
> It hangs here:
> 
> [    0.340029] calling  tc_filter_init+0x0/0x4c
> [    0.340029] initcall tc_filter_init+0x0/0x4c returned 0 after 0 msecs
> [    0.340029] calling  genl_init+0x0/0xd8
> [ hard hang ]
> 
> it should have continued with:
> 
> [    2.976346] initcall genl_init+0x0/0xd8 returned 0 after 15 msecs
> [    2.982303] calling  cipso_v4_init+0x0/0x88
> [ ... etc ... ]
> 
> i've bisected the hang back to:
> 
> 0de577d0dd2d1101431d3438d0880fa32a6188d6 is first bad commit
> commit 0de577d0dd2d1101431d3438d0880fa32a6188d6
> Author: Glauber Costa <gcosta@redhat.com>
> Date:   Fri Jul 11 15:43:19 2008 -0300
> 
>     x86: use generic intr_init call
> 
>     Replace apic initialization code with generic intr_init_hook().
> 
>     Signed-off-by: Glauber Costa <gcosta@redhat.com>
> 
> the config is at:
> 
>  http://redhat.com/~mingo/misc/config-Thu_Aug_21_11_14_36_CEST_2008.bad
> 
> but the bug is rather obvious:
> 
> -       apic_intr_init();
> -
> -       if (!acpi_ioapic)
> -               setup_irq(2, &irq2);
> +       intr_init_hook();
> 
> why exactly did you remove the cascade IRQ registration? If it remains 
> unallocated and a driver happens to use it funny things might occur.
> 
> Also, the commit log does not declare why it's removed.

Because it's not (was not supposed to be) removed. It used to be done by
intr_init_hook(), so we're just using the same function for both architectures.
Commit 2ae111cdd8d83ebf9de72e36e68a8c84b6ebbeea changed this behaviour without
me noticing (and my tests didn't hit it)

It this is the way things gonna stay, so we'd probably want to drop this patch
completely. Can you remove it cleanly, or it triggers dependency problems?
