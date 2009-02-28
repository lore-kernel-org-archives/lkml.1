Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZB1Wh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZB1Wh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZB1WhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:37:11 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:33665 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753211AbZB1WhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:37:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1dAlde9O0B54TbM/jv1Zz7j2rzHecMl12VC6OL7uOSnBuahC9NFfn594dQgX0AKX2VPyX+vPYUp3w+ZJ0Rg1rCp4Lgsh+4WqjQv1qNjV8RCWDJKUX6wXzd2qLqM7bISua1KZIsovqt16wF4ny4XCcO8vrwJX/LG7DanWHldMDrM=  ;
X-YMail-OSG: 1FayFRQVM1nuNcFcuBEFMBZryXvI1VpvMfe1Kd.PmTZGofjsj.27fCVJmMv3m2Cfek1SprkpSXtbfq5p_3ukg2X09ikrxoQU2LkxwX8NOrbsltDv24x0i_MdJrTAUFvNhA4iJaxFzA4BywzZcSzYkw0elX6dS7lDDWHGzIEVmaR1e.FPqigVqHBxXY4l
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Sat, 28 Feb 2009 14:37:05 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <alpine.LFD.2.00.0902282149290.29264@localhost.localdomain> <alpine.LFD.2.00.0902282209450.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902282209450.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902281437.05827.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Thomas Gleixner wrote:
> > needs to run in a thread as well. Usually demux handlers just have a
> > fast path kicking the particular real handlers.
> 
> I looked at the code in twl4030-irq.c and I don't think that the demux
> handler needs to be setup as a chained handler at all. 
> 
> Just register it as a standard handler and let it wakeup the other irq
> threads

Not clear what you mean by that.  Did I miss a "wakeup an
irq thread" operation?  You've coupled the task to the
irqaction, not to the irq_desc.


> or is there a particular requirement that the demuxed handlers 
> need to run in the same thread context as the demux handler itself ?

The toplevel IRQ shouldn't be re-enabled until all the chained
handlers have actually handled their events ... some of those
events are level triggered too.  That needs synchronization, and
the simplest synch is to just process those demuxed events in
the same thread.

The TWL4030 family chips are a little bit quirky with respect
to IRQ handling (PIH vs SIH, SIH_CTRL.COR inconsistency, etc),
but they aren't the only chips with such requirements for their
internal IRQ controllers.

- Dave
