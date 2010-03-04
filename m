Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0CDV3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:29:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1390 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab0CDV3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:29:54 -0500
Subject: Re: [RFC PATCH] printk: Convert pr_<level> macros to functions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100304124943.ce7c1a63.akpm@linux-foundation.org>
References: <1267629618.8926.73.camel@Joe-Laptop.home>
	 <20100304124943.ce7c1a63.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 13:29:52 -0800
Message-ID: <1267738192.12993.48.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 12:49 -0800, Andrew Morton wrote:
> On Wed, 03 Mar 2010 07:20:18 -0800 Joe Perches <joe@perches.com> wrote:
> > Maybe moving printed_len to file scope is racy somehow?
> Yes, printed_len will get corrupted when multiple CPU's are running
> printk/vprintk simultaneously.  That'll need to be fixed.

I think it'll be easier to use the %pV construct that
I posted today:

http://lkml.org/lkml/2010/3/4/19

> Is it possible to reduce the amount of
> code movement in the patch, make it a bit easier to follow?

I can do the move-around separately.

I think it'll be better as:

asmlinkage int pr_emerg(const char *fmt, ...)
{
	struct va_format vaf;
	va_list args;

	va_start(args, fmt);
	vaf.fmt = fmt;
	vaf.va = &args;
	r = printk(KERN_EMERG "%pV", &vaf);
	va_end(args);

	return r;
}
EXPORT_SYMBOL(pr_emerg);

I believe that avoids any racing.

> I think it would be justifiable to cook up a freaky macro and expand it
> eight times to avoid this duplication.  Ugly, but better than lots of
> duplication.

Maybe something like:

#define define_pr_level(function, level)	\
asmlinkage int function(const char *fmt, ...)	\
{						\
	struct va_format vaf;			\
	va_list args;				\
						\
	va_start(args, fmt);			\
	vaf.fmt = fmt;				\
	vaf.va = &args;				\
	r = printk(level "%pV", &vaf);		\
	va_end(args);				\
						\
	return r;				\
}						\
EXPORT_SYMBOL(function)

define_pr_level(pr_emerg,	KERN_EMERG);
define_pr_level(pr_alert,	KERN_ALERT);
define_pr_level(pr_crit,	KERN_CRIT);
define_pr_level(pr_err,		KERN_ERR);
define_pr_level(pr_warning,	KERN_WARNING);
define_pr_level(pr_notice,	KERN_NOTICE);
define_pr_level(pr_info,	KERN_INFO);

I think that's a bit ugly though myself.

> Or perhaps we can do it via a helper function which takes the
> additional argument?
> asmlinkage int pr_everything(char levelchar, const char *fmt, ...)

I believe that could not work.
The symbol names to link against wouldn't be found.


