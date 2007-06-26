Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbXFZR0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbXFZR0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbXFZR0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:26:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978AbXFZR0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:26:46 -0400
Date: Tue, 26 Jun 2007 10:23:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <4680D162.9050603@yahoo.com.au>
Message-ID: <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <4680D162.9050603@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Jun 2007, Nick Piggin wrote:
> 
> Hmm, not that I have a strong opinion one way or the other, but I
> don't know that they would encourage bad code. They are not going to
> reduce latency under a locked section, but will improve determinism
> in the contended case.

xadd really generally *is* slower than an add. One is often microcoded, 
the other is not.

But the real problem is that your "unlock" sequence is now about two 
orders of magnitude slower than it used to be. So it used to be that a 
spinlocked sequence only had a single synchronization point, now it has 
two. *That* is really bad, and I guarantee that it makes your spinlocks 
effectively twice as slow for the non-contended parts.

But your xadd thing might be worth looking at, just to see how expensive 
it is. As an _alternative_ to spinlocks, it's certainly viable.

(Side note: why make it a word? Word operations are slower on many x86 
implementations, because they add yet another prefix. You only need a 
byte)

			Linus
