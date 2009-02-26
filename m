Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZBZRqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZBZRqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZBZRp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:45:57 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:38121 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZBZRp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:45:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uTizeNnyodTbea9MO5VwKushCYLfe9ME1pO1xfMvHohPIT3gsxwAMkNtPRvuhp8qGJ
         Mcn2ZuNap0jbrDhhREKA7YJ8QpfMyqdb7pF1M46TymjEhalOumU0cAxnLmOVCCQPMzcB
         hs2dcfTfN96zVjD6L8sSyhWeKw5FpSBcVDQmY=
Date: Thu, 26 Feb 2009 18:45:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] add binary printf
Message-ID: <20090226174547.GC5889@nowhere>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com> <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226174303.GC29439@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 06:43:03PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Feb 26, 2009 at 02:02:43PM +0100, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > 
> > > > Impact: Add APIs for binary trace printk infrastructure
> > > > 
> > > > vbin_printf(): write args to binary buffer, string is copied
> > > > when "%s" is occurred.
> > > > 
> > > > bstr_printf(): read from binary buffer for args and format a string
> > > > 
> > > > [fweisbec@gmail.com: ported to latest -tip]
> > > > 
> > > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > > ---
> > > >  include/linux/string.h |    7 +
> > > >  lib/Kconfig            |    3 +
> > > >  lib/vsprintf.c         |  442 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 452 insertions(+), 0 deletions(-)
> > > 
> > > OK, it's a nice idea and speedup for printf based tracing - 
> > > which is common and convenient. Would you mind to post the 
> > > performance measurements you've done using the new bstr_printf() 
> > > facility? (the nanoseconds latency figures you did in the timer 
> > > irq in a system under load and on a system that is idle)
> > 
> > 
> > Ok.
> > 
> >  
> > > The new printf code itself should be done cleaner i think and is 
> > > not acceptable in its current form.
> > > 
> > > These two new functions:
> > > 
> > > > +#ifdef CONFIG_BINARY_PRINTF
> > > > +/*
> > > > + * bprintf service:
> > > > + * vbin_printf() - VA arguments to binary data
> > > > + * bstr_printf() - Binary data to text string
> > > > + */
> > > 
> > > Duplicate hundreds of lines of code into three large functions 
> > > (vsnprintf, vbin_printf, bstr_printf). These functions only have 
> > > a difference in the way the argument list is iterated and the 
> > > way the parsed result is stored:
> > > 
> > >   vsnprintf:   iterates va_list, stores into string
> > >   bstr_printf: iterates bin_buf, stores into string
> > >   vbin_printf: iterates va_list, stores into bin_buf
> > > 
> > > We should try _much_ harder at unifying these functions before 
> > > giving up and duplicating them...
> > > 
> > > An opaque in_buf/out_buf handle plus two helper function 
> > > pointers passed in would be an obvious implementation.
> > > 
> > > That way we'd have a single generic (inline) function that knows 
> > > about the printf format itself:
> > > 
> > >  __generic_printf(void *in_buf,
> > > 		  void *out_buf,
> > > 		  void * (*read_in_buf)(void **),
> > > 		  void * (*store_out_buf)(void **));
> > > 
> > > And we'd have various variants for read_in_buf and 
> > > store_out_buf. The generic function iterates the following way:
> > > 
> > > 	in_val = read_in_buf(&in_buf);
> > > 	...
> > > 	store_out_buf(&out_buf, in_val);
> > > 
> > > (where in_val is wide enough to store a single argument.) The 
> > > iterators modify the in_buf / out_buf pointers. Argument 
> > > skipping can be done by reading the in-buf and not using it. I 
> > > think we can do it with just two iterator methods.
> > > 
> > > Or something like that - you get the idea. It can all be inlined 
> > > so that we'd end up with essentially the same vsnprint() 
> > > instruction sequence we have today.
> > > 
> > > 	Ingo
> > 
> > 
> > Ok, I just looked deeply inside vsnprintf, and I don't think 
> > such a generic interface would allow that. We need to know the 
> > size of the argument, it's precision, width and flags.... And 
> > we need to know if we want to skip the non format char.
> > 
> > 
> > What do you think of the following:
> > 
> > __ generic_printf(void *in,
> > 		  void *out,
> > 		  void *(*read_in)(void **buf, int size),
> > 		  void *(store_char)(char *dst, char *end, char val, int field_width, int flags),
> > 		  void *(*store_string)(char *dst, char *end, char *val, int field_width, int precision, int flags),
> > 		  void *(*store_pointer)(char type, char *dst, char *end, void *val,
> > 					int field_width, int precision, int flags),
> > 		  void *(*store_number)(char *dst, char *size, int base,int field_width, int precision, int flags),
> > 		  bool skip_non_format
> > 		  )
> > 
> > 
> > Well, something like that...
> > 
> > read_in can advance the pointer to the buffer itself (buf can 
> > be a va_args or u32 *) and it returns a value, void * is 
> > generic for the type.
> > 
> > The storage functions are more specialized because of the 
> > interpretation of flags, precision... So we can easily pass 
> > the usual string(), pointer(), .... that are already present 
> > in vsnprintf.c or use custom ones. They return the advanced 
> > dst pointer.
> > 
> > And at last, skip_non_format will decide if we want to 
> > consider non-format characters from fmt to be copied as common 
> > %c characters or if we want to ignore them (useful for 
> > vbin_printf()).
> 
> hm, that indeed looks very wide - storing into a binary buffer 
> does complicate the iterator interface significantly.
> 
> But at least vsnprintf() and bstr_printf() could be unified - 
> they both output into a string buffer, just have different 
> methods to iterate arguments.
> 
> 	Ingo

Right, ok I'm on it.

