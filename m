Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab0CDUts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:49:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079Ab0CDUtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:49:46 -0500
Date: Thu, 4 Mar 2010 12:49:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] printk: Convert pr_<level> macros to functions
Message-Id: <20100304124943.ce7c1a63.akpm@linux-foundation.org>
In-Reply-To: <1267629618.8926.73.camel@Joe-Laptop.home>
References: <1267629618.8926.73.camel@Joe-Laptop.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Mar 2010 07:20:18 -0800
Joe Perches <joe@perches.com> wrote:

> printk is defined asmlinkage (extern "C")
> For this RFC patch, pr_<level> calls are as well.
> Is this declaration style really necessary?
> Maybe moving printed_len to file scope is racy somehow?

Yes, printed_len will get corrupted when multiple CPU's are running
printk/vprintk simultaneously.  That'll need to be fixed.

> Save 3 bytes per pr_<level> use after printk overhead
> 
> Does not store the KERN_<level> string as constant string
> when using pr_<level> calls
> 
> printk.o increases ~200 bytes
> defconfig decreases ~700 bytes
> 
> Minor printk neatening, moving comments above function declaration
> Renamed vprint to __vprintk, added vprintk wrapper
> Moved automatic printed_len to file static
> Moved EXPORT_SYMBOL after functions
> 

Looks good at the first peek.  Is it possible to reduce the amount of
code movement in the patch, make it a bit easier to follow?  Maybe do
it as two patches, with the move-stuff-around patch being [1/2]?

>
> ...
>
> +asmlinkage int pr_emerg(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('0', fmt, args);
> +	r = __vprintk(fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_emerg);
> +
> +asmlinkage int pr_alert(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('1', fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_alert);
> +
> +asmlinkage int pr_crit(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('2', fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_crit);
> +
> +asmlinkage int pr_err(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('3', fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_err);
> +
> +asmlinkage int pr_warning(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('4', fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_warning);
> +
> +asmlinkage int pr_notice(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('5', fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_notice);
> +
> +asmlinkage int pr_info(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('6', fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_info);
> +
> +asmlinkage int pr_cont(const char *fmt, ...)
> +{
> +	va_list args;
> +	int r;
> +
> +	va_start(args, fmt);
> +	r = pr_printk('c', fmt, args);
> +	va_end(args);
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(pr_cont);

I think it would be justifiable to cook up a freaky macro and expand it
eight times to avoid this duplication.  Ugly, but better than lots of
duplication.

Or perhaps we can do it via a helper function which takes the
additional argument?

asmlinkage int pr_everything(char levelchar, const char *fmt, ...)

?

