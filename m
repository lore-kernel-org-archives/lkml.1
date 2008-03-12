Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYCLRUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYCLRUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYCLRUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:20:39 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:39249 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbYCLRUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:20:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/6] kernel: add clamp(), clamp_t() and clamp_val() macros
Date: Wed, 12 Mar 2008 18:20:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1205269894.22317.32.camel@brick> <200803121613.09172.mb@bu3sch.de> <1205340866.8603.9.camel@brick>
In-Reply-To: <1205340866.8603.9.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121820.14883.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 17:54:26 Harvey Harrison wrote:
> On Wed, 2008-03-12 at 16:13 +0100, Michael Buesch wrote:
> > So why not call it clamp_const()?
> > One could even use __builtin_constant_p() and make clamp() use
> > either clamp_const() or clamp_nonconst() from above automagically.
> > I'd prefer that.
> 
> Did you mean something like this?  No more clamp_val, just clamp and
> clamp_t.  clamp_t forces all the types, clamp looks at the min and max
> args, and if they are constants, uses the type of val instead.  If not
> a constant, the strict typechecking is done.

> +#define clamp(val, min, max) ({				\
> +	typeof(val) __val = (val);			\
> +							\
> +	if (__builtin_constant_p(min)) {		\
> +		typeof(val) __min = (min);		\
> +		__val = __val < __min ? __min: __val;	\
> +	} else {					\
> +		typeof(min) __min = (min);		\
> +		(void) (&__val == &__min);		\
> +		__val = __val < __min ? __min: __val;	\
> +	}						\
> +							\
> +	if (__builtin_constant_p(max)) {		\
> +		typeof(val) __max = (max);		\
> +		__val > __max ? __max: __val;		\
> +	} else {					\
> +		typeof(max) __max = (max);		\
> +		(void) (&__val == &__max);		\
> +		__val > __max ? __max: __val;		\
> +	} })

Yeah, something like that.
Does returning of the value work over an indentation level, too?
I dunno this detail of the language.
But I'd prefer the following for readability anyway:

+       if (__builtin_constant_p(max)) {                \
+               typeof(val) __max = (max);              \
+               __val = __val > __max ? __max: __val;           \
+       } else {                                        \
+               typeof(max) __max = (max);              \
+               (void) (&__val == &__max);              \
+               __val = __val > __max ? __max: __val;           \
+       }
+	__val; })

Probably you can also only put the pointer check into the constant check:

+#define clamp(val, min, max) ({                \
+       typeof(val) __val = (val);              \
+       typeof(min) __min = (min);              \
+       typeof(max) __max = (max);              \
+       if (!__builtin_constant_p(min))         \
+               (void) (&__val == &__min);      \
+       __val = __val < __min ? __min: __val;   \
+       if (!__builtin_constant_p(max))         \
+               (void) (&__val == &__max);      \
+       __val = __val > __max ? __max: __val;   \
+       __val; })

But it seems that this evaluates the arguments twice, so my idea turns out
to be not too good anyway. hm..

-- 
Greetings Michael.
