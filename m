Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXHSQhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXHSQhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 12:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXHSQhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 12:37:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbXHSQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 12:37:45 -0400
Date: Sun, 19 Aug 2007 01:04:30 -0400
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, jh@suse.cz
Subject: Re: [PATCH] x86-64: memset optimization
Message-ID: <20070819010430.2c8c31fc@oldman.hemminger.net>
In-Reply-To: <200708182055.11277.ak@suse.de>
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
	<200708181146.24399.ak@suse.de>
	<20070818075602.34350b25@freepuppy.rosehill.hemminger.net>
	<200708182055.11277.ak@suse.de>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007 20:55:11 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > The problem is that on x86-64 you are overriding memset() 
> 
> I don't.  You must be looking at old source
> 
> asm-x86_64/string.h 2.6.23rc3:
> 
> #define __HAVE_ARCH_MEMSET
> void *memset(void *s, int c, size_t n);
> 
> I wanted to do the same on i386 too, but there were some minor obstacles.
> The problem is that the out of line fallback i386 memset is currently
> quite dumb and needs to be rewritten to expand the fill char on its
> own like the x86-64 version. Probably best would be just to port
> the x86-64 version. I just hadn't had time for that.
> 
> [Patches welcome, but if you do ask me for my old memset test harness]
> 
> -Andi

I am looking at current source, built with current (non-experimental) GCC
from Fedora Core 7. If I dissassemble ether_setup, which is

void ether_setup(struct net_device *dev)
{
...

	memset(dev->broadcast, 0xFF, ETH_ALEN);
}

I see a tail recursion (jmp) to memset which is the code in arch/x86_64/lib/memset.S

