Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYDQV1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYDQV1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYDQV10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:27:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbYDQV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:27:25 -0400
Date: Thu, 17 Apr 2008 14:26:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: mingo@elte.hu, hpa@zytor.com, jeremy@goop.org, rostedt@goodmis.org,
       fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-Id: <20080417142614.23c3849f.akpm@linux-foundation.org>
In-Reply-To: <20080417211625.GB803@Krystal>
References: <20080417165839.GA25198@Krystal>
	<20080417165944.GB25198@Krystal>
	<20080417201410.GB31616@Krystal>
	<20080417132919.533e9667.akpm@linux-foundation.org>
	<20080417211625.GB803@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 17:16:25 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> > Should we or should we not make in_interrupt() return true in NMI? 
> > "should", I expect.
> > 
> > If not, we'd need to do something else to communicate the current
> > processing state down to the BUG-handling code.
> > 
> 
> You bring an interesting question. In practice, since this BUG_ON could
> only happen if we have an NMI nested over another NMI or an nmi which
> fails to decrement its HARDNMI_MASK. Given that the HARDIRQ_MASK is
> incremented right after the HARDNMI_MASK increment (the reverse is also
> true), really bad things (TM) must have happened for the BUG_ON to be
> triggered outside of the __irq_enter()/__irq_exit() scope of the NMI
> below the buggy one.
> 
> But since this code is there to extract as much information as possible
> when things go wrong, I would say it's safer to, at least, add
> HARDNMI_MASK to irq_count().
> 
> Instead, though, I think we could add :
> 
> if (in_nmi())
>    panic("Fatal exception in non-maskable interrupt");
> 
> to die().

But that's just one site.  There might be (now, or in the future) other
code under BUG() which tests in_interrupt().

And most of the places where we test for in_interrupt() and in_irq()
probably want that to return true is we're in NMI too.  After all, it's an
interrupt.  

> That would be clearer. I just added it to x86_32, but can't
> find where x86_64 reports the "fatal exception in interrupt" and friends
> message. Any idea ?

Dunno - maybe it just doesn't have it.  Maybe it was never the right thing
to do.

> By dealing with this case specifically, I think we don't really have to
> add HARDNMI_MASK to irq_count(), considering it's normally an HARDIRQ
> too.


