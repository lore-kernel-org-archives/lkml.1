Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbXIUQTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbXIUQTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757959AbXIUQTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:19:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:8180 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267AbXIUQTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QXkZ8KPqt7lJ069PYQWAHcxN6B6xTr1MPSYvdHkdaqOFHB49BtEyUHHQVkGmtYt6/FBwI37BQwtCvioTQgfxY7La+In8al3LMxmtrk3g8PkBIBk8WG4hTvdGUH4rPsEMwafYIrbPZ6Wb/1UMa2ZI30kvNYrMj/tZ3i7DtVwyfeo=
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage. (v3)
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: linux-kernel@vger.kernel.org, Satyam Sharma <satyam.sharma@gmail.com>
In-Reply-To: <46F3EB15.3050706@grupopie.com>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>
	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
	 <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
	 <1190384893.30016.42.camel@gilboa-home-dev.localdomain>
	 <46F3EB15.3050706@grupopie.com>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 18:19:08 +0200
Message-Id: <1190391548.30016.99.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 17:02 +0100, Paulo Marques wrote:
> Gilboa Davara wrote:
> > Hello all,
> 
> Hi, Gilboa
> 
> > (1) Problem:
> > I. When CONFIG_4KSTACKS and CONFIG_DEBUG_STACKOVERFLOW are enabled on
> > i386 kernels, do_IRQ calls dump_stack which, down the path, uses
> > print_symbol (display) and  sprint_symbol (format) to format and display
> > the function name/address/module.
> > Both function use stack based char array (~350 bytes) that, given the
> > initial state (<512 bytes of stack space) may overrun the stack.
> > II. (Comments - previous patches) Using spinlock protected static
> > storage within these functions might block or even deadlock dump_stack
> > (E.g. Crash within dump_stack itself)
> > 
> > (2) Solution:
> > I. Break sprint_symbol into sprint_symbol (API functions; keeps the
> > current interface) and sprint_symbol_helper (helper function with
> > minimal local storage). 
> > II. Replace the char array in __print_symbol with two spinlock protected
> > static char arrays; call the __sprint_symbol helper function instead of
> > sprint_symbol.
> > III. Ignore the spinlock if oops_in_progress is set.
> 
> This is getting more and more convoluted :(
> 
> The problem with the spinlock isn't just that during a panic, we can not 
> trust the kernel structures enough to use spinlocks. It might well 
> happen that lockdep code might want to use print_symbol (and I think it 
> does, so this is not just theoretical) to dump the stack when someone 
> calls spin_lock_irqsave.
> But now, because print_symbol itself uses spin_lock_irqsave, we might 
> get into a recursive situation and a produce a deadlock.
> 
> On the other hand, if you take the other approach of reducing the stack 
> usage by creating a printk_symbol interface, the stack usage would drop 
> from 350 bytes to 128 bytes and your problem would go away entirely.
> 

OK. I'll wait for additional comments while thinking about a third
route. (Following your suggestion)

- Gilboa

