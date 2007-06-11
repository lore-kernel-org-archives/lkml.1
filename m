Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbXFKTSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbXFKTSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXFKTSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:18:08 -0400
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:51943 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbXFKTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:18:07 -0400
Message-ID: <466D9FDB.2010305@cs.cmu.edu>
Date: Mon, 11 Jun 2007 15:17:47 -0400
From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
User-Agent: Icedove 1.5.0.8 (X11/20061208)
MIME-Version: 1.0
To: linux@horizon.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
References: <20070611075321.8887.qmail@science.horizon.com>
In-Reply-To: <20070611075321.8887.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
> /* Majority: (x^y)|(y&z)|(z&x) = (x & z) + ((x ^ z) & y)
> #define F3(x,y,z,dest)		\
> 	movl	z, TMP;		\
> 	andl	x, TMP;		\
> 	addl	TMP, dest;	\
> 	movl	z, TMP;		\
> 	xorl	x, TMP;		\
> 	andl	y, TMP;		\
> 	addl	TMP, dest
> 
> Since y is the most recently computed result (it's rotated in the
> previous round), I arranged the code to delay its use as late as
> possible.
> 
> 
> Now you have one more register to play with.

Okay, thanks.  It doesn't actually give one more register except in the 
F3 rounds (TMP2 is normally used to hold the magic constants) but it's a 
good cleanup.

> A faster way is to unroll 5 iterations and do:
> 	e += F(b, c, d) + K + rol32(a, 5) + W[i  ]; b = rol32(b, 30);
> 	d += F(a, b, c) + K + rol32(e, 5) + W[i+1]; a = rol32(a, 30);
> 	c += F(e, a, b) + K + rol32(d, 5) + W[i+2]; e = rol32(e, 30);
> 	b += F(d, e, a) + K + rol32(c, 5) + W[i+3]; d = rol32(d, 30);
> 	a += F(c, d, e) + K + rol32(b, 5) + W[i+4]; c = rol32(c, 30);
> then loop over that 4 times each.  This is somewhat larger, but
> still reasonably compact; only 20 of the 80 rounds are written out
> long-hand.

I got this code from Nettle, originally, and I never looked at the SHA-1 
round structure very closely.  I'll give that approach a try.

Thanks
--Benjamin Gilbert
