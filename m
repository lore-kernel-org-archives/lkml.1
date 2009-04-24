Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbZDXQtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbZDXQtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZDXQsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:48:54 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52339 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZDXQsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:48:53 -0400
Date: Sat, 25 Apr 2009 01:48:50 +0900 (JST)
Message-Id: <20090425.014850.93020801.anemo@mba.ocn.ne.jp>
To: alessandro.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, david-b@pacbell.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, vapier@gentoo.org,
       rongkai.zhan@windriver.com, balajirrao@openmoko.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with
 irqs enabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090424131334.10959f78@i1501.lan.towertech.it>
References: <20090424120100.76797d20@i1501.lan.towertech.it>
	<200904240410.52543.david-b@pacbell.net>
	<20090424131334.10959f78@i1501.lan.towertech.it>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009 13:13:34 +0200, Alessandro Zummo <alessandro.zummo@towertech.it> wrote:
> > >  use spin_lock() in the IRQ handler and spin_lock_irq/irq_save
> > >  in the setup functions.  
> > 
> > I think you're describing how the *current* scheme is supposed
> > to work ... except that some IRQ handlers aren't calling the
> > rtc_update_irq() routine with IRQs blocked.
> > 
> > Yes, that current scheme works ... modulo those buggy handlers.
> 
>  ok, but why it's necessary to disable the interrupts? Only because
>  the specs says so or because there's a locking issue I'm missing?

Here is a possible example:

1. RTC alarm interrupt handler takes rtc->irq_lock by spin_lock()
2. A timer interrupt handler calls rtc_uie_timer() for UIE emulation
3. rtc_uie_timer() waits on rtc->irq_lock .... deadlock!

This sort of deadlock can happen if a spin lock was used by multple
interrupt handlers.

---
Atsushi Nemoto
