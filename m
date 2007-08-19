Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXHSSYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXHSSYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 14:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXHSSYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 14:24:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:35599 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbXHSSY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 14:24:29 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] [PATCH] x86-64: memset optimization
Date: Sun, 19 Aug 2007 20:24:24 +0200
User-Agent: KMail/1.9.6
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, jh@suse.cz
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net> <200708182055.11277.ak@suse.de> <20070819010430.2c8c31fc@oldman.hemminger.net>
In-Reply-To: <20070819010430.2c8c31fc@oldman.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708192024.24864.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I am looking at current source, built with current (non-experimental) GCC
> from Fedora Core 7. If I dissassemble ether_setup, which is
> 
> void ether_setup(struct net_device *dev)
> {
> ...
> 
> 	memset(dev->broadcast, 0xFF, ETH_ALEN);
> }
> 
> I see a tail recursion (jmp) to memset which is the code in arch/x86_64/lib/memset.S

That is likely gcc then deciding it can't use an inline memset for some reason.
It does that for example if it can't figure out the alignment or similar.
Honza (cc'ed) can probably give you more details why it happens, especially if you
give him a preprocessed self contained test case.

A simple example like
char x[6];

f()
{
        memset(x, 1, 6);
}

gives with gcc 4.1:

        .text
        .p2align 4,,15
.globl f
        .type   f, @function
f:
.LFB2:
        movl    $16843009, x(%rip)
        movw    $257, x+4(%rip)
        ret
.LFE2:

-Andi
