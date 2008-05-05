Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbYEECgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbYEECgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 22:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYEECgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 22:36:44 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:28248 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753438AbYEECgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 22:36:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=p7V1yKCobX5aemqeVNoMHxebciVprEQ1TCcgHMka0fxRmrUKpOJUCflUKf8HHdx71NaH6GF5EnDc3NSGs8KSI0agi+ytUtJOsuKWNr/CKeZ3NFRcIkd1KrWkHoIL9NNT5yuN9Ur6gld35BaABRvFqjgeEBCPvhYIivCe4eHBGQc=  ;
X-YMail-OSG: xt766asVM1nOz5Fs19Y.VSleRqJeVOHakxKDR6wFjKLtSI2OErfhjNw.nvPnPKmweTy20WrNuH47O_rfyOae5CfYRZg5WidZ7pztA_sDnUErvXk2hc1pFrP0BltLb31aTPA-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Mon, 5 May 2008 12:36:28 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080425.021301.193689806.davem@davemloft.net> <alpine.LFD.1.10.0804250915340.2779@woody.linux-foundation.org> <48121F43.3060902@goop.org>
In-Reply-To: <48121F43.3060902@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051236.31160.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 04:13, Jeremy Fitzhardinge wrote:
> Linus Torvalds wrote:
> > With each invocation being thousands of instructions and a cross-CPU IPI
> > for the tlb flush, that kind of stuff adds up. We're likely talking real
> > fractions of a second, rather than milliseconds.
>
> Doesn't vunmap batch the cross-CPU tlb flushes to amortize the cost?
> Hm, no, it doesn't seem to.  Oh, right, it was one of Nick's TBDs.

Yeah and I do have patches... posted a few months ago IIRC. I forget
offhand the exact details of the batching, but yes it should batch this
case of Linus's. I think I set it to batch 1024 vunmaps or xxxxKB per
IPI flush. With those patches it basically removed IPI flushing
completely from profiles of vmap intensive workloads.

The problem with vmap (outside this particular issue of text poking,
which should be single-threaded anyway), really is that it is a single
threaded allocator. The locking actually ends up hurting much more than
the IPIs for non-trivial uses of vmap (like xfs with directories larger
than PAGE_SIZE). Fortunately I have patches for that too ;)
