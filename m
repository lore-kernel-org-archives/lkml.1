Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbZCEHx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbZCEHx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZCEHxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:53:18 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:45367 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZCEHxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kxl9IP8R3nt5O61UofS7k6Omgb52sx3xHY3EE2gVsKtuP3wWqVXUvmbdH19y4L8qGh
         OOrwcoMYk8FLyKNDQricIpuw30YwN4kK5EjmzgBQpdN+0xFWVkJNhflc0iOSciQ0uHgs
         78ATe8jC97fpiO7OzAWl0BPumcGVDX9eo+Jdo=
MIME-Version: 1.0
In-Reply-To: <49af5f1b.1818d00a.209c.ffff9783@mx.google.com>
References: <49af5f1b.1818d00a.209c.ffff9783@mx.google.com>
Date: Thu, 5 Mar 2009 08:53:14 +0100
Message-ID: <19f34abd0903042353i58c8e72eh33be515bf09a36f@mail.gmail.com>
Subject: Re: [PATCH 5/5 v3] vsprintf: unify the format decoding layer for its 
	3 users
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/5 Frederic Weisbecker <fweisbec@gmail.com>:
> An new optimization is making its way to ftrace. Its purpose is to
> make ftrace_printk() consuming less memory and be faster.
>
> Written by Lai Jiangshan, the approach is to delay the formatting
> job from tracing time to output time.
> Currently, a call to ftrace_printk will format the whole string and
> insert it into the ring buffer. Then you can read it on /debug/tracing/trace
> file.
>
> The new implementation stores the address of the format string and
> the binary parameters into the ring buffer, making the packet more compact
> and faster to insert.
> Later, when the user exports the traces, the format string is retrieved
> with the binary parameters and the formatting job is eventually done.
>
> The new implementation rewrites a lot of format decoding bits from
> vsnprintf() function, making now 3 differents functions to maintain
> in their duplicated parts of printf format decoding bits.
>
> Suggested by Ingo Molnar, this patch tries to factorize the most
> possible common bits from these functions.
> The real common part between them is the format decoding. Although
> they do somewhat similar jobs, their way to export or import the parameters
> is very different. Thus, only the decoding layer is extracted, unless you see
> other parts that could be worth factorized.
>

Just one small nit from me :-)

> @@ -726,18 +961,9 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
>  int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  {
>        unsigned long long num;
> -       int base;
>        char *str, *end, c;
> -
> -       int flags;              /* flags to number() */
> -
> -       int field_width;        /* width of output field */
> -       int precision;          /* min. # of digits for integers; max
> -                                  number of chars for from string */
> -       int qualifier;          /* 'h', 'l', or 'L' for integer fields */
> -                               /* 'z' support added 23/7/1999 S.H.    */
> -                               /* 'z' changed to 'Z' --davidm 1/25/99 */
> -                               /* 't' added for ptrdiff_t */
> +       int read;
> +       struct printf_spec spec = {0};
>
>        /* Reject out-of-range values early.  Large positive sizes are
>           used for unknown buffer sizes. */
> @@ -758,184 +984,144 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>                size = end - buf;
>        }
>
> -       for (; *fmt ; ++fmt) {
> -               if (*fmt != '%') {
> -                       if (str < end)
> -                               *str = *fmt;
> -                       ++str;
> -                       continue;
> -               }
> +       while (*fmt) {
> +               char *old_fmt = (char *)fmt;

This looks a bit strange. We can't ever change the format string, so
it doesn't make sense to try to use it as a non-const pointer anyway.
Why not make the variable "const char *" and drop the cast?

The same for another case.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
