Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0BNPw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 10:52:26 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:63320 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0BNPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 10:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=tvTS2DldhNiLyHTZutnWO9jrlNJ/Iw8tEwY2AJFYVoz2q9nSnm6w/2yxGcE9lLY2/P
         Shl8/iPXwUw2zJaf5mwlppYjZMsK23CNqZG4byZ8D7aO42uukqGL6mK1xMX2P1iPVzxC
         GFk0Snmp3vz072isr0txLOLV8zcMngM1t8MEs=
Date: Sun, 14 Feb 2010 21:23:27 +0530
From: Rabin Vincent <rabin@rab.in>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: Re: [PATCH 08/10] ARM: ftrace: fix and update dynamic ftrace
Message-ID: <20100214155326.GA2842@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-9-git-send-email-rabin@rab.in>
 <20100214110840.GA21357@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100214110840.GA21357@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 12:08:40PM +0100, Uwe Kleine-König wrote:
> > diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
> > index 103f7ee..4a56a2e 100644
> > --- a/arch/arm/include/asm/ftrace.h
> > +++ b/arch/arm/include/asm/ftrace.h
> > @@ -2,12 +2,29 @@
> >  #define _ASM_ARM_FTRACE
> >  
> >  #ifdef CONFIG_FUNCTION_TRACER
> > -#define MCOUNT_ADDR		((long)(mcount))
> > +#define MCOUNT_ADDR		((unsigned long)(__gnu_mcount_nc))
> hhmm, does this work with both the old and the new mcount function?

Yes, MCOUNT_ADDR is not used by the generic ftrace code directly, but is
instead only passed to our arch specific functions.  We determine the
right mcount address to use there:

> +#define OLD_MCOUNT_ADDR	((unsigned long) mcount)
[..]
> +static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
> +{
> +	if (!rec->arch.old_mcount)
> +		return addr;
> +
> +	if (addr == MCOUNT_ADDR)
> +		addr = OLD_MCOUNT_ADDR;
> +	else if (addr == FTRACE_ADDR)
> +		addr = OLD_FTRACE_ADDR;
> +
> +	return addr;
> +}

I changed MCOUNT_ADDR from mcount to __gnu_mcount_nc because we always
build __gnu_mcount_nc in, but don't build mcount when using Thumb-2.

Rabin
