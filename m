Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYDQVQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYDQVQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYDQVQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:16:28 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:48645 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYDQVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:16:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACtbB0hMROPA/2dsb2JhbACBYKt6
Date: Thu, 17 Apr 2008 17:16:25 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, hpa@zytor.com, jeremy@goop.org, rostedt@goodmis.org,
       fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-ID: <20080417211625.GB803@Krystal>
References: <20080417165839.GA25198@Krystal> <20080417165944.GB25198@Krystal> <20080417201410.GB31616@Krystal> <20080417132919.533e9667.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080417132919.533e9667.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:50:16 up 48 days, 17:01,  4 users,  load average: 0.27, 0.14,
	0.19
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 17 Apr 2008 16:14:10 -0400
> Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > +#define nmi_enter()					\
> > +	do {						\
> > +		lockdep_off();				\
> > +		BUG_ON(hardnmi_count());		\
> > +		add_preempt_count(HARDNMI_OFFSET);	\
> > +		__irq_enter();				\
> > +	} while (0)
> 
> <did it _have_ to be a macro?>
> 

isn't this real macro art work ? ;) I kept the same coding style that
was already there, which mimics the irq_enter/irq_exit macros. Changing
all of them at once could be done in a separate patch.

> Doing BUG() inside an NMI should be OK most of the time.  But the
> BUG-handling code does want to know if we're in interrupt context - at
> least for the "fatal exception in interrupt" stuff, and probably other
> things.
> 
> But afacit the failure to include HARDNMI_MASK in
> 
>  #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))
> 
> will prevent that.
> 
> So.
> 
> Should we or should we not make in_interrupt() return true in NMI? 
> "should", I expect.
> 
> If not, we'd need to do something else to communicate the current
> processing state down to the BUG-handling code.
> 

You bring an interesting question. In practice, since this BUG_ON could
only happen if we have an NMI nested over another NMI or an nmi which
fails to decrement its HARDNMI_MASK. Given that the HARDIRQ_MASK is
incremented right after the HARDNMI_MASK increment (the reverse is also
true), really bad things (TM) must have happened for the BUG_ON to be
triggered outside of the __irq_enter()/__irq_exit() scope of the NMI
below the buggy one.

But since this code is there to extract as much information as possible
when things go wrong, I would say it's safer to, at least, add
HARDNMI_MASK to irq_count().

Instead, though, I think we could add :

if (in_nmi())
   panic("Fatal exception in non-maskable interrupt");

to die(). That would be clearer. I just added it to x86_32, but can't
find where x86_64 reports the "fatal exception in interrupt" and friends
message. Any idea ?

By dealing with this case specifically, I think we don't really have to
add HARDNMI_MASK to irq_count(), considering it's normally an HARDIRQ
too.

Mathieu



-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
