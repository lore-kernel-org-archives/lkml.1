Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYCUBhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYCUBhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 21:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYCUBhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 21:37:35 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:39583 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYCUBhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 21:37:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Date: Fri, 21 Mar 2008 02:36:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       netdev@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, video4linux-list@redhat.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, lm-sensors@lm-sensors.org
References: <Pine.LNX.4.44L0.0803202126240.11234-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803202126240.11234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803210236.52063.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 March 2008 02:31:44 Alan Stern wrote:
> On Thu, 20 Mar 2008, Andrew Morton wrote:
> 
> > On Thu, 20 Mar 2008 21:36:04 -0300 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > 
> > > Well, so far so good for LEDs, but what about the other users of in_atomic
> > > that apparently should not be doing it either?
> > 
> > Ho hum.  Lots of cc's added.
> 
> ...
> 
> > The usual pattern for most of the above is
> > 
> > 	if (!in_atomic())
> > 		do_something_which_might_sleep();
> > 
> > problem is, in_atomic() returns false inside spinlock on non-preptible
> > kernels.  So if anyone calls those functions inside spinlock they will
> > incorrectly schedule and another task can then come in and try take the
> > already-held lock.
> > 
> > Now, it happens that in_atomic() returns true on non-preemtible kernels
> > when running in interrupt or softirq context.  But if the above code really
> > is using in_atomic() to detect am-i-called-from-interrupt and NOT
> > am-i-called-from-inside-spinlock, they should be using in_irq(),
> > in_softirq() or in_interrupt().
> 
> Presumably most of these places are actually trying to detect 
> am-i-allowed-to-sleep.  Isn't that what in_atomic() is supposed to do?  

No, I think there is no such check in the kernel. Most likely for performance
reasons, as it would require a global flag that is set on each spinlock.
You simply must always _know_, if you are allowed to sleep or not. This is
done by defining an API. The call-context is part of any kernel API.

-- 
Greetings Michael.
