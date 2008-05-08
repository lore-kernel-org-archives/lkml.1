Return-Path: <linux-kernel-owner+w=401wt.eu-S1763645AbYEHN64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763645AbYEHN64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761747AbYEHN5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:57:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763338AbYEHN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:57:48 -0400
Date: Thu, 8 May 2008 06:56:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
Message-ID: <20080508065645.678dda33@infradead.org>
In-Reply-To: <20080508120130.GA2860@elte.hu>
References: <1210131712.3453.43.camel@ymzhang>
	<87lk2mbcqp.fsf@basil.nowhere.org>
	<20080507114643.GR19219@parisc-linux.org>
	<87hcdab8zp.fsf@basil.nowhere.org>
	<alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
	<alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
	<1210214696.3453.87.camel@ymzhang>
	<alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org>
	<1210219729.3453.97.camel@ymzhang>
	<alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org>
	<20080508120130.GA2860@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008 14:01:30 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> 
> The contention comes from the following property of the new semaphore 
> code: the new owner owns the semaphore exclusively, even if it is not 
> running yet.
> 
> So if the old owner, even if just a few instructions later, does a 
> down() [lock_kernel()] again, it will be blocked and will have to
> wait on the new owner to eventually be scheduled (possibly on another
> CPU)! Or if another other task gets to lock_kernel() sooner than the
> "new owner" scheduled, it will be blocked unnecessarily and for a
> very long time when there are 2000 tasks running.

ok sounds like I like the fairness part of the new semaphores (but
obviously not the 67% performance downside; I'd expect to sacrifice a
little performance.. but this much??).

It sucks though; if this were a mutex, we could wake up the owner of
the bugger in the contented acquire path synchronously.... but these 
are semaphores, and don't have an owner ;( bah bah bah
