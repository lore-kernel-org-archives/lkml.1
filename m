Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYJCOzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYJCOzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbYJCOyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:54:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbYJCOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:54:52 -0400
Date: Fri, 3 Oct 2008 07:52:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
In-Reply-To: <200810031041.49350.borntraeger@de.ibm.com>
Message-ID: <alpine.LFD.2.00.0810030746430.3230@nehalem.linux-foundation.org>
References: <200810031041.49350.borntraeger@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Oct 2008, Christian Borntraeger wrote:
> 
> This is caused by holding a spinlock (__driver_attach) and checking for 
> preempt_count (e1000_acquire_swflag_ich8lan).

Which spinlock is it? It sure shouldn't be anything in the generic drievr 
layer: __driver_attach takes a lock, but it's a semaphore (dev->sem), not 
a spinlock. In fact, al lot of drivers will sleep or do allocations, so if 
the driver layer were to call the probe function with a spinlock held, 
things would be really broken.

The callchain has "spin_lock_irqsave" in it, but that's stale stack data. 

			Linus
