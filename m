Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYJHGaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYJHGaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYJHGaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:30:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbYJHGaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:30:01 -0400
Date: Tue, 7 Oct 2008 23:28:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
 arch
Message-Id: <20081007232838.0321e6d4.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
	<20081007105056.16d9e785.akpm@linux-foundation.org>
	<1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
	<200810081335.44576.nickpiggin@yahoo.com.au>
	<6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Oct 2008 13:48:10 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> 
> At 11:35 08/10/08, Nick Piggin wrote:
> >On Wednesday 08 October 2008 05:59, Peter Zijlstra wrote:
> >>
> >> The whole point is that such usage is outside the specification and thus
> >> we don't strictly need to fix this.
> >>
> >> So the question Nick is asking is, do we want to slow down the kernel
> >> for a few broken user-space applications. Esp. since the race doesn't
> >> affect anybody else except the broken users of the file descriptor.
> >
> >Right you are. That's the fundamental question. The actual details of
> >the fix and how likely the race is don't really matter until we
> >answer the first question (except to say that the "fix" is never going
> >to be free).
> 
> Simultaneous access by two or more writer can corrupt file content,
> so this case needs some locks(flock or fcntl) to preserve synchronization
> of file content. This is responsibility of user-space application.
> But file->f_pos race issue can occur even if multiple threads just read 
> simultaneously.

But how could that userspace code possibly be reliable even if f_pos
updates were atomic?  The two threads/processes will still read
either the same data, or one will get "A" and the other will get "B" or
one will get "B" and the other will get "A".

And when that application gets fixed, so too does this f_pos problem?

 I think this is not responsibility of user-space application. 
> To avoid this currently, an application needs some locks to protect file offset
> even if it just read a file. So I think f_pos race should be fixed.
