Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYEHQDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYEHQDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYEHQDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:03:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093AbYEHQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:03:06 -0400
Date: Thu, 8 May 2008 09:02:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
In-Reply-To: <20080508122802.GA4880@elte.hu>
Message-ID: <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org>
References: <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
 <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu>
 <20080508122802.GA4880@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Ingo Molnar wrote:
> 
> Peter pointed it out that because sem->count is u32, the <= 0 is in fact 
> a "== 0" condition - the patch below does that. As expected gcc figured 
> out the same thing too so the resulting code output did not change. (so 
> this is just a cleanup)

Why don't we just make it do the same thing that the x86 semaphores used 
to do: make it signed, and decrement unconditionally. And callt eh 
slow-path if it became negative.

IOW, make the fast-path be

	spin_lock_irqsave(&sem->lock, flags);
	if (--sem->count < 0)
		__down();
	spin_unlock_irqrestore(&sem->lock, flags);

and now we have an existing known-good implementation to look at?

Rather than making up a totally new and untested thing.

		Linus
