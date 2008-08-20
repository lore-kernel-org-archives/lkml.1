Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYHTJlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYHTJlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYHTJlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:41:03 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:42687 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750862AbYHTJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:41:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OG3GiSUSNJbEfV2gwTFCrNkqAfGjmmRURSYPH2/Axm/8JAnudXLZ3FZpfJZf9JbFc6QLrROUbH+CNB6EC21l5YlLlk/yVFy/J2wnBw1l5y3U761Q8UMA/OtBWGR0rxyERmV9HPJvxL5Ci9C8d2zV5eypVNXC4fCxU2MeDWrsEjU=  ;
X-YMail-OSG: w_9VMgkVM1lyyl51cDz_ibDCObwryQv51aywc5kyejyTA5gXgQ2cRR5OQREVeAZoM9jemIWcVa7odu8dCKkDiBlp0_fD6O3ifYYBgFYIsWr9HIWB0RmvowSoq6JBXys6HBsgB5kohFDQ76Z8GAxFr_pw
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: ftrace introduces instability into kernel 2.6.27(-rc2,-rc3)
Date: Wed, 20 Aug 2008 19:40:51 +1000
User-Agent: KMail/1.9.5
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Eran Liberty <liberty@extricom.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <48A9901B.1080900@redhat.com> <20080819173453.GA28239@Krystal> <alpine.DEB.1.10.0808191705590.4957@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808191705590.4957@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201940.51916.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2008 07:08, Steven Rostedt wrote:
> On Tue, 19 Aug 2008, Mathieu Desnoyers wrote:
> > Ok, there are two cases where it's ok :
> >
> > 1 - in stop_machine, considering we are not touching code executed in
> > NMI handlers.
> > 2 - when using my replace_instruction_safe() which uses a temporary
> > breakpoint when doing the instruction replacement.
> >
> > In those cases you could use text_poke_early().
> >
> > See
> > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=b
> >lob;f=arch/x86/kernel/immediate.c;h=7789e2c75bf03e645f15759d5dff0c1698493f
> >92;hb=HEAD
> >
> > For a use example. Basically it looks like :
> >
> >
> > 360                 pages[0] = virt_to_page((void *)bypass_eip);
> > 361                 vaddr = vmap(pages, 1, VM_MAP, PAGE_KERNEL);
> > 362                 BUG_ON(!vaddr);
> > 363                 text_poke_early(&vaddr[bypass_eip & ~PAGE_MASK],
> > 364                         (void *)addr, size);
> > 365                 /*
> > 366                  * Fill the rest with nops.
> > 367                  */
> > 368                 len = NR_NOPS - size;
> > 369                 add_nops((void *)
> > 370                         &vaddr[(bypass_eip & ~PAGE_MASK) + size],
> > 371                         len);
> > 372                 print_dbg_bytes("inserted nops",
> > 373                         &vaddr[(bypass_eip & ~PAGE_MASK) + size],
> > len); 374                 vunmap(vaddr);
>
> vunmap can not be called with interrupts disabled, and this is exactly
> what my code does.

It could be after the vmap rewrite (with a few other small tweaks).
But a) it would be less robust when called from interrupt context
and this code looks broken as it is WRT error handling; and b) it
still costs several thousand cycles to vmap+touch+vunmap...
