Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXIUQCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXIUQCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXIUQCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:02:32 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:34382 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751143AbXIUQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:02:32 -0400
Message-ID: <46F3EB15.3050706@grupopie.com>
Date: Fri, 21 Sep 2007 17:02:29 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: gilboad@gmail.com
CC: linux-kernel@vger.kernel.org, Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage. (v3)
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>	 <1189879681.18191.93.camel@gilboa-home-dev.localdomain> <1190384893.30016.42.camel@gilboa-home-dev.localdomain>
In-Reply-To: <1190384893.30016.42.camel@gilboa-home-dev.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gilboa Davara wrote:
> Hello all,

Hi, Gilboa

> (1) Problem:
> I. When CONFIG_4KSTACKS and CONFIG_DEBUG_STACKOVERFLOW are enabled on
> i386 kernels, do_IRQ calls dump_stack which, down the path, uses
> print_symbol (display) and  sprint_symbol (format) to format and display
> the function name/address/module.
> Both function use stack based char array (~350 bytes) that, given the
> initial state (<512 bytes of stack space) may overrun the stack.
> II. (Comments - previous patches) Using spinlock protected static
> storage within these functions might block or even deadlock dump_stack
> (E.g. Crash within dump_stack itself)
> 
> (2) Solution:
> I. Break sprint_symbol into sprint_symbol (API functions; keeps the
> current interface) and sprint_symbol_helper (helper function with
> minimal local storage). 
> II. Replace the char array in __print_symbol with two spinlock protected
> static char arrays; call the __sprint_symbol helper function instead of
> sprint_symbol.
> III. Ignore the spinlock if oops_in_progress is set.

This is getting more and more convoluted :(

The problem with the spinlock isn't just that during a panic, we can not 
trust the kernel structures enough to use spinlocks. It might well 
happen that lockdep code might want to use print_symbol (and I think it 
does, so this is not just theoretical) to dump the stack when someone 
calls spin_lock_irqsave.

But now, because print_symbol itself uses spin_lock_irqsave, we might 
get into a recursive situation and a produce a deadlock.

On the other hand, if you take the other approach of reducing the stack 
usage by creating a printk_symbol interface, the stack usage would drop 
from 350 bytes to 128 bytes and your problem would go away entirely.

-- 
Paulo Marques - www.grupopie.com

"All I ask is a chance to prove that money can't make me happy."
