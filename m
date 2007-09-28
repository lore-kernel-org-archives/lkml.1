Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXI1JfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXI1JfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbXI1JfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:35:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbXI1JfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:35:07 -0400
Date: Fri, 28 Sep 2007 02:34:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:397
 smp_call_function_mask()
Message-Id: <20070928023422.77be1e71.akpm@linux-foundation.org>
In-Reply-To: <46FCC6F5.2030109@bull.net>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	<390947257.08622@ustc.edu.cn>
	<46FCC0B8.7090403@bull.net>
	<20070928020950.bdcad2c2.akpm@linux-foundation.org>
	<46FCC6F5.2030109@bull.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 11:18:45 +0200 Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> Andrew Morton wrote:
> > On Fri, 28 Sep 2007 10:52:08 +0200 Laurent Vivier <Laurent.Vivier@bull.net> wrote:
> >>
> >> Andi, is this correct ?
> >> Andrew, should I send a patch implementing this change ?
> > 
> > umm, I think all the smp_call_function fucntions are deadlocky if called
> > with local interrupts disabled, regardless of whether the calling CPU is in
> > the mask.
> > 
> > If CPU A is sending a cross-cpu call to CPU B and CPU B is sending a
> > cross-cpu call to CPU A, and they both have local interrupts disabled...
> 
> OK, so there are two errors:
> 
> 1- one I introduce myself (without any help from anyone) where
> smp_call_function() calls all online CPUs instead of calling all CPUs except itself.

I'd be pretty surprised if one was able to write a bug like that.  You mean
the CPU sends an IPI to itself and then loops around until it has serviced
that IPI?  And this works?  Wow.

And on_each_cpu() can call the handler function twice?

hm

> 2- one in global_flush_tlb() which calls smp_call_function() with irqs disabled.

That would be a big bug, and surely we would already have picked it up.

<looks>

argh, mainline's x86_64 smp_call_function() doesn't do the check.  We've
had *heaps* of bugs in i386 where people were running smp_call_foo() under
local_irq_disable().  I wonder how many there are in x86_64?

> I think I should at least correct #1 ?

I think we should correct all bugs ;)
