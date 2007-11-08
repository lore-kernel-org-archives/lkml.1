Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbXKHXle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbXKHXle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 18:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761488AbXKHXl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 18:41:27 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:58896 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761426AbXKHXl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 18:41:26 -0500
Date: Thu, 8 Nov 2007 15:25:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: Some interesting observations when trying to optimize vmstat
 handling
In-Reply-To: <200711090007.43424.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711081522040.11074@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711081141180.9694@schroedinger.engr.sgi.com>
 <200711090007.43424.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Andi Kleen wrote:

> 
> > There is an interrupt enable overhead of 48 cycles that would be good to
> > be able to eliminate (Kernel code usually moves counter increments into
> > a neighboring interrupt disable section so that __ function can be used).
> 
> Replace the push flags ; popf  with test $IFMASK,flags ; jz 1f; sti ; 1:
> That will likely make it much faster (but also bigger) 

Well maybe we should change local_irq_save/restore in general?

The result would be:


if (!in_interrupt())
	local_irq_disable()

<critical section>

if (!in_interrupt())
	local_irq_enable();



Somehow we need to remember that we disabled interrupts.

Then it get more complicated.


int interrupts_disabled = 0;

if (!in_interrupt()) {
	local_irq_disable():
	interrrupts_disabled = 1;
}

<critical section>

if (interrupts_disabled)
	local_irq_enable();



Not sure that this actually better.


> The only problem is that there might be some code who relies on 
> restore_flags() restoring other flags that IF, but at least for interrupts
> and local_irq_save/restore it should be fine to change.

The statistics code surely does not rely on that.

