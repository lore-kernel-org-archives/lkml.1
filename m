Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbXHTPxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbXHTPxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbXHTPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:53:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721AbXHTPxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:53:38 -0400
Date: Mon, 20 Aug 2007 08:52:53 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, jh@suse.cz
Subject: Re: [discuss] [PATCH] x86-64: memset optimization
Message-ID: <20070820085253.5f589e58@freepuppy.rosehill.hemminger.net>
In-Reply-To: <200708192024.24864.ak@suse.de>
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
	<200708182055.11277.ak@suse.de>
	<20070819010430.2c8c31fc@oldman.hemminger.net>
	<200708192024.24864.ak@suse.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 20:24:24 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > I am looking at current source, built with current (non-experimental) GCC
> > from Fedora Core 7. If I dissassemble ether_setup, which is
> > 
> > void ether_setup(struct net_device *dev)
> > {
> > ...
> > 
> > 	memset(dev->broadcast, 0xFF, ETH_ALEN);
> > }
> > 
> > I see a tail recursion (jmp) to memset which is the code in arch/x86_64/lib/memset.S
> 
> That is likely gcc then deciding it can't use an inline memset for some reason.
> It does that for example if it can't figure out the alignment or similar.
> Honza (cc'ed) can probably give you more details why it happens, especially if you
> give him a preprocessed self contained test case.
> 
> A simple example like
> char x[6];
> 
> f()
> {
>         memset(x, 1, 6);
> }
> 
> gives with gcc 4.1:
> 
>         .text
>         .p2align 4,,15
> .globl f
>         .type   f, @function
> f:
> .LFB2:
>         movl    $16843009, x(%rip)
>         movw    $257, x+4(%rip)
>         ret
> .LFE2:
> 
> -Andi

The problem is with the optimization flags: passing -Os causes the compiler
to be stupid and not inline any memset/memcpy functions.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
