Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZGWWZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZGWWZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 18:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZGWWZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 18:25:17 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1677 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZGWWZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 18:25:16 -0400
Subject: Re: [PATCH] kernel.h: Verify that arguments to swap() are the same
 type
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090723144738.440f6102.akpm@linux-foundation.org>
References: <1247708061.15087.13.camel@Joe-Laptop.home>
	 <20090723144738.440f6102.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jul 2009 15:25:08 -0700
Message-Id: <1248387908.3498.35.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 14:47 -0700, Andrew Morton wrote:
> On Wed, 15 Jul 2009 18:34:21 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index d6320a3..72878a5 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -637,8 +637,13 @@ static inline void ftrace_dump(void) { }
> >  /*
> >   * swap - swap value of @a and @b
> >   */
> > -#define swap(a, b) \
> > -	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> > +#define swap(a, b)				\
> > +do {						\
> > +	typeof(a) __tmp = (a);			\
> > +	BUILD_BUG_ON(!__same_type(__tmp, (b)));	\
> > +	(a) = (b);				\
> > +	(b) = __tmp;				\
> > +} while (0)
> >  
> 
> I wonder if we can do
> 
> 	typecheck(a, typeof(b));d

Yes.  It generates a warning rather than a build bug.
Maybe that's better.

$ cat -n typeck.c
     1	#define typecheck(type, x)			\
     2	  ({	type __dummy;				\
     3	    typeof(x) __dummy2;				\
     4	    (void)(&__dummy == &__dummy2);		\
     5	    1;						\
     6	  })
     7	
     8	#define swap(a, b)				\
     9	  do { typeof(a) __tmp;				\
    10	    typecheck(typeof(a), (b));			\
    11	    __tmp = (a);				\
    12	    (a) = (b);					\
    13	    (b) = __tmp;				\
    14	  } while (0)
    15	
    16	int main(int argc, char** argv)
    17	{
    18	  int a,b;
    19	  long j,k;
    20	  
    21	  swap(a,b);
    22	  swap(j,k);
    23	  swap(a,j);
    24	}
$ gcc typeck.c
typeck.c: In function ‘main’:
typeck.c:23: warning: comparison of distinct pointer types lacks a cast


