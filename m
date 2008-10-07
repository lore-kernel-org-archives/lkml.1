Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYJGQ2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYJGQ2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYJGQ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:27:57 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:23614 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753361AbYJGQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:27:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WB4fJHETrWxvN24zHvSGSKmGdVnTuLIH9ddCErfdkgIAOD1dn8Mgjbm2d3RMMqPaAZg5Ln+1DEOzLl/TcN4Y8DLMsqr0sGaeeU2p0YU9SpqU/HQ42Lq1JlqSSgVH30ALTN+HVxnrg4HCZc/yvfiWCXeHr/N+vqPK5qBrVWLBsfI=  ;
X-YMail-OSG: 5rQ2mggVM1mS4yta5isBYJjbPH7FeGgzJ5PS9jVUwhwoywnRWoRv4C399EwXwgfRHWSPsk.vwACnnmuoadzXSLxAi4UOD4QqnY5y.9RJcYBo2zjvCz5TKevZVSQ5.2q1GBGwpIK9I.4IxwNj88k576KapLdg6g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Date: Wed, 8 Oct 2008 03:27:44 +1100
User-Agent: KMail/1.9.5
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <6.0.0.20.2.20081007183452.0f052210@172.19.0.2> <20081007102942.GE20740@one.firstfloor.org>
In-Reply-To: <20081007102942.GE20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080327.44530.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2008 21:29, Andi Kleen wrote:
> > Maybe cmpxchg8b is good for i486 or later x86, but i386 or other
> > architectures that do not have similar instruction needs some locking
> > primitive. I think lazy
>
> We have a cmpxchg emulation on 386. That works because only UP 386s are
> supported, so it can be done in software.
>
> > seqlock is one option for making file->f_pos access atomic.
>
> The question is if it's the right option. At least all the common
> operations on fds (read/write) are all writers, not readers.

Common operations are read, do something, write. So seqlocks then cost
one atomic operation, a couple of memory barriers (all noops on x86),
and some predictable branches etc.

cmpxchg based would require 2 lock ; cmpxchg8b on 32-bit. Fairly heavy.
Also I don't think we have generic accessors to do this, so I think
that is for another project.

Anyway, I think importantly this creates some usable accessors for the
f_pos problem. I think we actually need to touch a _lot_ of code to
cover all f_pos accesses in the kernel, but I guess this gets the ball
rolling.

So.. is everyone agreed that corrupting f_pos is a bad thing? (serious
question) If so, then we should get something like this merged sooner
rather than later.
