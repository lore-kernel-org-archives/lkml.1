Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYK1TxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYK1TxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYK1Tw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:52:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbYK1Tw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:52:57 -0500
Date: Fri, 28 Nov 2008 11:52:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] warn: print the DMI board info name in a
 WARN/WARN_ON
Message-Id: <20081128115247.bfcb603c.akpm@linux-foundation.org>
In-Reply-To: <20081128170029.GD10487@elte.hu>
References: <20081128083525.092e9859@linux.intel.com>
	<20081128083609.2a254c06@linux.intel.com>
	<20081128170029.GD10487@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 18:00:29 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
> > From acdc8771dfaf6e8236b9122364301f65f46d4b59 Mon Sep 17 00:00:00 2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Fri, 28 Nov 2008 08:32:44 -0800
> > Subject: [PATCH] warn: print the DMI board info name in a WARN/WARN_ON
> > 
> > it's very useful for many low level WARN_ON's to find out which
> > motherboard has the broken BIOS etc... this patch adds a printk
> > to the WARN_ON code for this.
> > On architectures without DMI, gcc should optimize the code out.
> > 
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > ---
> >  kernel/panic.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/panic.c b/kernel/panic.c
> > index 2b913aa..9c1b7e0 100644
> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/debug_locks.h>
> >  #include <linux/random.h>
> >  #include <linux/kallsyms.h>
> > +#include <linux/dmi.h>
> >  
> >  int panic_on_oops;
> >  static unsigned long tainted_mask;
> > @@ -328,12 +329,16 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
> >  {
> >  	va_list args;
> >  	char function[KSYM_SYMBOL_LEN];
> > +	const char *board;
> >  	unsigned long caller = (unsigned long)__builtin_return_address(0);
> >  	sprint_symbol(function, caller);
> >  
> >  	printk(KERN_WARNING "------------[ cut here ]------------\n");
> >  	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
> >  		line, function);
> > +	board = dmi_get_system_info(DMI_PRODUCT_NAME);
> > +	if (board)
> > +		printk(KERN_WARNING "Hardware name: %s\n", board);
> >  
> >  	if (fmt) {
> >  		va_start(args, fmt);
> 
> nice idea - applied to tip/core/debug.
> 
> On architectures (or systems) where there's no DMI_PRODUCT_NAME string 
> available, we'll print nothing. It's also a simple lockless call so can 
> be called from any context.
> 
> Andrew, any objections?
> 

Nope.  This is the first time we've included dmi.h from such a core
place, but afaict all architectures should have encountered that file
by now.

