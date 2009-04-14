Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZDNHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZDNHqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZDNHqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:46:04 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52092 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZDNHqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:46:02 -0400
Date: Tue, 14 Apr 2009 09:45:56 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH] unbreak alpha percpu
Message-ID: <20090414094556.3af71358@skybase>
In-Reply-To: <alpine.LFD.2.00.0904100915010.4583@localhost.localdomain>
References: <20090410151224.GM26366@ZenIV.linux.org.uk>
	<20090410154704.GN26366@ZenIV.linux.org.uk>
	<alpine.LFD.2.00.0904100915010.4583@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 09:21:08 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> Hmm. I certainly personally _much_ prefer this version.
> 
> It looks like this actually simplifies things for S390 too (no more 
> simple_identifier_##var games), and generally just looks better. And 
> seeing that the S390 special case is no longer S390-specific is also a 
> good sign, imho.
> 
> Sorry for including the whole message, but I'm adding s390 and percpu 
> people to the cc. Guys - original uncorrupted patch on lkml.
> > diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
> > index 408d60b..6a71d73 100644
> > --- a/arch/s390/include/asm/percpu.h
> > +++ b/arch/s390/include/asm/percpu.h
> > @@ -13,20 +13,18 @@
> >   */
> >  #if defined(__s390x__) && defined(MODULE)
> >  
> > -#define SHIFT_PERCPU_PTR(ptr,offset) (({			\
> > -	extern int simple_identifier_##var(void);	\
> > +#define SHIFT_PERCPU_PTR(var,offset) (({			\
> >  	unsigned long *__ptr;				\
> >  	asm ( "larl %0, %1@GOTENT"		\
> > -	    : "=a" (__ptr) : "X" (ptr) );		\
> > -	(typeof(ptr))((*__ptr) + (offset));	}))
> > +	    : "=a" (__ptr) : "X" (&per_cpu_var(var)) );		\
> > +	(typeof(&per_cpu_var(var)))((*__ptr) + (offset));	}))
> >  
> >  #else
> >  
> > -#define SHIFT_PERCPU_PTR(ptr, offset) (({				\
> > -	extern int simple_identifier_##var(void);		\
> > +#define SHIFT_PERCPU_PTR(var, offset) (({				\
> >  	unsigned long __ptr;					\
> > -	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
> > -	(typeof(ptr)) (__ptr + (offset)); }))
> > +	asm ( "" : "=a" (__ptr) : "0" (&per_cpu_var(var)) );			\
> > +	(typeof(&per_cpu_var(var))) (__ptr + (offset)); }))
> >  
> >  #endif
> >  

I would like to get rid of that SHIFT_PERCPU_PTR mess. The patch from
Ivan will allow this, it uses a dummy variable to void the effect of a
static modifier for percpu variables in modules. The percpu variable
itself will be defined non-static, my gut feeling is that this is a
dirty little trick that might bite us in the future.
Another solution which I personally would prefer is to ban the use of
static percpu variables. Then the compiler will use the GOT to get the
address of percpu variables without any dirty tricks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

