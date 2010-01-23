Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223Ab0AWTkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0AWTkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 14:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722Ab0AWTkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 14:40:07 -0500
Received: from ns.penguin.cz ([84.21.108.25]:56334 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab0AWTkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 14:40:02 -0500
Subject: Re: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
From: Stanislav Brabec <utx@penguin.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, thommycheck@gmail.com,
       dbaryshkov@gmail.com, dtor@mail.ru, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Cyril Hrubis <metan@ucw.cz>,
       Dirk@opfer-online.de, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, linux-input@vger.kernel.org,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
References: <20100106071026.GD1382@ucw.cz>
	 <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
	 <20100107065230.GA1303@ucw.cz>
	 <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Sat, 23 Jan 2010 20:41:09 +0100
Message-Id: <1264275669.9100.11.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:
> >
> > I don't get it; what is pxa27x_keypad used on? It looks like
> > matrix-keypad subset.

> pxa27x has its own specific keypad controller. And since we now
> use enable_irq_wake, and the keypad controller has only one
> such IRQ_KEYPAD, will have to setup the keypad GPIO wakeup
> as a whole.

Looking deeper into it, the problem seems to be elsewhere:
I just added debug message to start and end of set_irq_wake().

And here is what I got during suspend:

set_irq_wake() started IRQ: 191 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 191 to 1, desc->wake_depth: 0
set_irq_wake() started IRQ: 108 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 108 to 1, desc->wake_depth: 1
set_irq_wake() started IRQ: 113 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 113 to 1, desc->wake_depth: 0
set_irq_wake() started IRQ: 187 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 187 to 1, desc->wake_depth: 0
set_irq_wake() started IRQ: 130 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 130 to 1, desc->wake_depth: 0
set_irq_wake() started IRQ: 132 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 132 to 1, desc->wake_depth: 0
set_irq_wake() started IRQ: 134 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 134 to 1, desc->wake_depth: 0
set_irq_wake() started IRQ: 135 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 135 to 1, desc->wake_depth: 0
set_irq_wake() started IRQ: 31 to 1, desc->wake_depth: 0
set_irq_wake() done IRQ: 31 to 1, desc->wake_depth: 1

I think that if (desc->wake_depth == 0) when set_irq_wake(foo, 1) is
done, then something went wrong. And it is not surprise, that it reports
Unbalanced IRQ on resume.

Note that other people (Cyril Hrubi¹) with a bit different .config
report success with gpio keys driver turned on.

My config:
http://www.penguin.cz/~utx/zaurus/feed/images/spitz/config-2.6.33-rc4-spitz

OT: Serial console resume did not work properly even with
no_console_suspend and my patch:
[PATCH 4/8] serial-core: resume serial hardware with no_console_suspend


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

