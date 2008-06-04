Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYFDC0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYFDC0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750695AbYFDC0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:26:06 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:36441 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751847AbYFDC0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:26:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=zKej/lgfMgFnlap2p4pfXxPV2y63xdaeOhQ0LCSs//0SQCptLlptvu/eSFnqDQbGl4ZCi5/QyTZe6MB2fStWGBuojyTcsUvtAG6NTMzCx51HUVsLdsxJONwdI0Kha8K9HvCWuzZlLdtF20zy4KndT+OLrvi18SCSm754yVo1E8A=  ;
X-YMail-OSG: i1bkcX4VM1nB5EcGlMwiGOeqLQ5E7N2dTQ0YyzYxWQ0IihTgIaYe9PCTbr0VEgZYcyy8x4TReg2AM9TRNhKx3jwNjfPzaBVIUrrhJA3JWDYWKc7EfxJDJu.S.zQCMMHJ5K8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: MMIO and gcc re-ordering issue
Date: Wed, 4 Jun 2008 12:25:49 +1000
User-Agent: KMail/1.9.5
Cc: Matthew Wilcox <matthew@wil.cx>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <20080603213310.GC3549@parisc-linux.org> <Pine.LNX.4.64.0806031439520.3242@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0806031439520.3242@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806041225.50058.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 07:44, Trent Piepho wrote:
> On Tue, 3 Jun 2008, Matthew Wilcox wrote:

> > I don't understand why you keep talking about DMA.  Are you talking
> > about ordering between readX() and DMA?  PCI proides those guarantees.
>
> I guess you haven't been reading the whole thread.  The reason it started
> was because gcc can re-order powerpc (and everyone else's too) IO accesses
> vs accesses to cachable memory (but not spin-locks), which ends up only
> being a problem with coherent DMA.

I don't think it is only a problem with coherent DMA.

CPU0                         CPU1
mutex_lock(mutex);
writel(something, DATA_REG);
writel(GO, CTRL_REG);
started = 1;
mutex_unlock(mutex);
                             mutex_lock(mutex);
                             if (started)
                               /* oops, this can reach device before GO */
                               writel(STOP, CTRL_REG);
                               
