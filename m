Return-Path: <linux-kernel-owner+w=401wt.eu-S933601AbYD3Vw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601AbYD3Vw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbYD3VwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:52:08 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:37620 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbYD3VwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:52:06 -0400
Date: Wed, 30 Apr 2008 14:52:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mike Galbraith <efault@gmx.de>, sfr@canb.auug.org.au,
       video4linux-list@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, mchehab@infradead.org,
       linux-dvb-maintainer@linuxtv.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, David Miller <davem@davemloft.net>
Subject: Re: [v4l-dvb-maintainer] [patch,	-git] drivers/media build fix for
 modular builds
In-Reply-To: <20080430044009.6c5bbc8d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0804301442010.9894@shell4.speakeasy.net>
References: <20080429185009.716c3284@gaivota> <20080430074807.GA11224@elte.hu>
 <20080430.005212.46815036.davem@davemloft.net> <20080430081345.GA16519@elte.hu>
 <1209544030.30990.2.camel@marge.simson.net> <1209544951.15609.3.camel@marge.simson.net>
 <1209545784.31419.2.camel@marge.simson.net> <1209547231.4898.2.camel@marge.simson.net>
 <20080430044009.6c5bbc8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008, Andrew Morton wrote:
> Does this make it feel better?
>
> --- a/drivers/media/video/tuner-core.c~a
> +++ a/drivers/media/video/tuner-core.c
> @@ -40,11 +40,11 @@
>  	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
>  	if (__a) { \
>  		__r = (int) __a(ARGS); \
> +		symbol_put(FUNCTION); \
>  	} else { \
>  		printk(KERN_ERR "TUNER: Unable to find " \
>  				"symbol "#FUNCTION"()\n"); \
>  	} \
> -	symbol_put(FUNCTION); \
>  	__r; \
>  })

Should the symbol_put be done at all?  When I wrote the code this is based
on, it would check if FUNCTION failed or not.  If it failed, the symbol was
put.  But if it worked, then one was returned a handle into FUNCTION's
module, and so the symbol was not put.  If it was, the module's refcount
would be zero but the caller would have a handle into the module.

So if FUNCTION does anything that creates references to the module, and it
doesn't inc it's own refcount, then the symbol_put shouldn't be done.
