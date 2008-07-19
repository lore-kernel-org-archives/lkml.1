Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYGSVzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYGSVzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbYGSVzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:55:01 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:54066 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbYGSVzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:55:00 -0400
Date: Sat, 19 Jul 2008 17:54:59 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Guy Martin <gmsoft@tuxicoman.be>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 64bit kernel not booting with CONFIG_PRINTK_TIME=y
Message-ID: <20080719215459.GA2550@phobos.i.cabal.ca>
References: <20080717190502.74c238d5@bleh.bxl.tuxicoman.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717190502.74c238d5@bleh.bxl.tuxicoman.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 07:05:02PM +0200, Guy Martin wrote:
> 
> Recompiling with CONFIG_PRINTK_TIME=n makes it works straight away.
>

The problem is kernel/printk.c around line 731.

t = jiffies * (NSEC_PER_SEC / HZ);
do_div(t, 10000000000); is doing some badness (which is hard as hell to
debug since printk isn't working.)

It's doing some sort of bollocks when jiffies is between 9 and 10...

do_div being:

# define do_div(n,base) ({                                      \
        uint32_t __base = (base);                               \
        uint32_t __rem;                                         \
        __rem = ((uint64_t)(n)) % __base;                       \
        (n) = ((uint64_t)(n)) / __base;                         \
        __rem;                                                  \
 })

I'm *guessing* that umoddi3 or udivdi3 is doing an xmpyu or something,
which since this is probably before fpu init, is trapping, which is
trying to printk, which is recursively exploding.

regards, Kyle
