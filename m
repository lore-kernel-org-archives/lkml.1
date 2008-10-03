Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYJCPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYJCPgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYJCPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:36:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYJCPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:36:04 -0400
Date: Fri, 3 Oct 2008 11:35:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       ath9k-devel@venema.h4ckr.net, lrodriguez@atheros.com,
       linux-wireless@vger.kernel.org
Subject: Re: ath9k: panic on tip/master
Message-ID: <20081003153523.GC3368@tuxdriver.com>
References: <f488382f0810030256x2859fbf6j3f657621c567287f@mail.gmail.com> <20081003100211.GA29841@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003100211.GA29841@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 12:02:11PM +0200, Ingo Molnar wrote:
> 
> * Steven Noonan <steven@uplinklabs.net> wrote:
> 
> > Hey folks,
> > 
> > Just got a panic on tip. According to the stack trace, ath9k is what 
> > decided to bomb.
> > 
> > http://www.uplinklabs.net/~tycho/linux/ath9k_panic_tip_10.3.2008.jpg
> > 
> > Note: Although it says 'sudo modprobe radeon' on the bash prompt above 
> > the panic, I never got to hit 'enter' on that command before the panic 
> > occurred.
> 
> it appears to me that ath9k's eth_rx_input() takes a spinlock that is 
> not initialized (or already destroyed by the allocator).
 
Seems reasonable...

> this would be consistent with an IRQ storm hitting some race in the 
> ath9k driver init sequence. For example if request_irq() is done before 
> all structures that the IRQ handler relies on are properly initialized.
> 
> i.e. this has the signature of a genuine ath9k bug.

Agreed, although I don't see anything specifically relating to
request_irq or the like.

I think the spin_lock call may actually be in ath_ampdu_input (called
from ath_rx_input), which perhaps is getting called simultaneous
with ath_rx_node_init still running?  With no locks in between them,
it seems like this could be the culprit?

Sorry to not be more immediately helpful, but I'm going to have to
run in a few minutes.  Perhaps this insight is helpful for someone
more familiar with the internals of this driver?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
