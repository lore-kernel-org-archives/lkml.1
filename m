Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0CJQtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 11:49:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1596 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab0CJQta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 11:49:30 -0500
Subject: Re: [PATCH 15/15] Staging: comedi: fix macro coding style issue in
 adl_pci9111.c
From: Joe Perches <joe@perches.com>
To: Maurice Dawson <mauricedawson2699@googlemail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1268229735-5387-1-git-send-email-mauricedawson2699@googlemail.com>
References: <1268229735-5387-1-git-send-email-mauricedawson2699@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 08:49:28 -0800
Message-ID: <1268239768.1545.292.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 14:02 +0000, Maurice Dawson wrote: 
> fixes, ERROR: Macros with multiple statements
> should be enclosed in a do - while block,
> found by the checkpatch.pl tool

Hello Maurice.

do {} while (0) macros should not use a trailing semicolon.
This allows the macro to be used in single statement if/else.

for example:

#define foo(a, b, c)	\
do {			\
	x = (a);	\
	y = (b);	\
	z = (c);	\
} while (0)

use:

	if (test)
		foo(1, 2, 3);
	else
		foo(4, 5, 6);

> #define pci9111_fifo_reset() \
> -  outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
> -    PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
> -  outb(PCI9111_FFEN_SET_FIFO_DISABLE, \
> -    PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
> -  outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
> -    PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
> +	do { \
> +		outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
> +			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
> +		outb(PCI9111_FFEN_SET_FIFO_DISABLE, \
> +			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
> +		outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
> +			PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
> +	} while (0);

etc.

Also, there's a lot of uppercase and variable reuse in this macro
that makes it a bit difficult to parse and verify.

A couple more defines or a static inline could help.

Perhaps something like:

static inline void pci9111_fifo_reset(void)
{
	unsigned long addr = PCI9111_IO_BASE + PCI9111_REGISTER_INTERRUPT_CONTROL;

	outb(PCI9111_FFEN_SET_FIFO_ENABLE, addr);
	outb(PCI9111_FFEN_SET_FIFO_DISABLE, addr);
	outb(PCI9111_FFEN_SET_FIFO_ENABLE, addr);
}


