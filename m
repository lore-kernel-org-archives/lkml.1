Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZBXFni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZBXFni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 00:43:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZBXFn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 00:43:29 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2335 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZBXFn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 00:43:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uIEPCdJRhP5N0DdzV5H+zQdyto0i0AiOPhgrMN+/IX9ITagg87CwDfFD/PuJ6mYtS
	KdnM4AeLmMHLTrR/5kDHQ==
MIME-Version: 1.0
In-Reply-To: <200902241510.33911.nickpiggin@yahoo.com.au>
References: <20090224020304.GA4496@google.com>
	 <200902241510.33911.nickpiggin@yahoo.com.au>
Date: Mon, 23 Feb 2009 21:43:23 -0800
Message-ID: <4352991a0902232143o7c6c3c53h5f78ffc0758472e4@mail.gmail.com>
Subject: Re: Performance regression in write() syscall
From: Salman Qazi <sqazi@google.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 8:10 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>
> added some ccs
>
> On Tuesday 24 February 2009 13:03:04 Salman Qazi wrote:
> > While the introduction of __copy_from_user_nocache (see commit:
> > 0812a579c92fefa57506821fa08e90f47cb6dbdd) may have been an improvement
> > for sufficiently large writes, there is evidence to show that it is
> > deterimental for small writes.  Unixbench's fstime test gives the
> > following results for 256 byte writes with MAX_BLOCK of 2000:
> >
> >     2.6.29-rc6 ( 5 samples, each in KB/sec ):
> >     283750, 295200, 294500, 293000, 293300
> >
> >     2.6.29-rc6 + this patch (5 samples, each in KB/sec):
> >     313050, 3106750, 293350, 306300, 307900
> >
> >     2.6.18
> >     395700, 342000, 399100, 366050, 359850
>
> What does unixbench's fstime test do? If it is just writing to the
> pagecache, then this would be unexpected. If it is reading and writing,
> then perhaps this could be a problem, but how realistic is it for a
> performance critical application to read data out of the pagecache that
> it has recently written? Do you have something at google actually doing
> real work that speeds up with this patch?

It has 3 parts, each producing a number corresponding to write, read
and copy.  The first one only does writes and lseeks.  This produces
the numbers that I have provided.  We are actually not sure at this
point if this slows down one of our real application.  We noticed that
Unixbench fstime, which is part of our automated testing was slower,
and upon investigation this was one of the causes.  We will be
forthcoming with at least one other regressions in this exact usage of
write() system call shortly (I am gathering relevant numbers  for
upstream kernels now).  In both cases, the regression was noticed for
sub page writes.

>
>
> >     See w_test() in src/fstime.c in unixbench version 4.1.0.  Basically,
> > the above test consists of counting how much we can write in this manner:
> >
> >     alarm(10);
> >     while (!sigalarm) {
> >             for (f_blocks = 0; f_blocks < 2000; ++f_blocks) {
> >                    write(f, buf, 256);
> >             }
> >             lseek(f, 0L, 0);
> >     }
> >
> > I realised that there are other components to the write syscall regression
> > that are not addressed here.  I will send another email shortly stating the
> > source of another one.
> >
> > Signed-off-by: Salman Qazi <sqazi@google.com>
> > ---
> > diff --git a/arch/x86/include/asm/uaccess_64.h
> > b/arch/x86/include/asm/uaccess_64.h index 84210c4..efe7315 100644
> > --- a/arch/x86/include/asm/uaccess_64.h
> > +++ b/arch/x86/include/asm/uaccess_64.h
> > @@ -192,14 +192,20 @@ static inline int __copy_from_user_nocache(void *dst,
> > const void __user *src, unsigned size)
> >  {
> >       might_sleep();
> > -     return __copy_user_nocache(dst, src, size, 1);
> > +     if (likely(size >= PAGE_SIZE))
> > +             return __copy_user_nocache(dst, src, size, 1);
> > +     else
> > +             return __copy_from_user(dst, src, size);
> >  }
> >
> >  static inline int __copy_from_user_inatomic_nocache(void *dst,
> >                                                   const void __user *src,
> >                                                   unsigned size)
> >  {
> > -     return __copy_user_nocache(dst, src, size, 0);
> > +     if (likely(size >= PAGE_SIZE))
> > +             return __copy_user_nocache(dst, src, size, 0);
> > +     else
> > +             return __copy_from_user_inatomic(dst, src, size);
> >  }
> >
> >  unsigned long
>
>
