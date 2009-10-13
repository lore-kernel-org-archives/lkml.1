Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbZJMSqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbZJMSqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbZJMSqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:46:11 -0400
Received: from www.tglx.de ([62.245.132.106]:44688 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760087AbZJMSqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:46:10 -0400
Date: Tue, 13 Oct 2009 20:45:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Blaise Gassend <blaise@willowgarage.com>,
       Jeremy Leibs <leibs@willowgarage.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "lkml," <linux-kernel@vger.kernel.org>
Subject: Re: ERESTARTSYS escaping from sem_wait with RTLinux patch
In-Reply-To: <4AD49928.40600@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0910132042150.9428@localhost.localdomain>
References: <1255165747.6385.117.camel@doodleydee> <alpine.LFD.2.00.0910101931080.9428@localhost.localdomain> <92be2ef30910102248t70d5e683tc525580fbf902af1@mail.gmail.com> <4AD33A4D.4070006@us.ibm.com> <1255384010.10236.123.camel@lts.willowgarage.com>
 <4AD3BD57.6080703@us.ibm.com> <4AD3D6AE.2050609@us.ibm.com> <4AD3FFB0.5030405@us.ibm.com>  <4AD4080C.20703@us.ibm.com> <1255424204.12737.233.camel@doodleydee> <4AD49928.40600@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Darren Hart wrote:
> Talking with Thomas a bit more we're not sure the patch that introduced this
> lockless waking actually does any good, as the normal wakeup path doesn't take
> the hb->lock anyway, it's more likely the contention was due to an app like
> this that wakes a task and almost immediately puts it back to sleep on a futex
> before the waker has a chance to drop the hb->lock.

The patch was done before we restructured the wakeup code in mainline
and it's not necessary anymore.
 
> The futex wake-up path is complicated enough as it is, in my personal opinion,
> we are better off dropping the "lockless wake-up" patch and removing the race
> and simplifying the wake-up path at the same time.

Nevertheless we need graceful handling of spurious wakeups in the
waiter code. I'm working on a fix for mainline, which will be in the
next -rt release as well (after I reverted the no longer valid wakeup
optimization)

Thanks folks for debugging that.

       tglx
