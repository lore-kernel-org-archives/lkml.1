Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbZEAOGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbZEAOGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbZEAOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:06:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53997 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZEAOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:06:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH V3] asm-generic: add a generic uaccess.h
Date: Fri, 1 May 2009 16:06:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>
References: <cover.1241105648.git.arnd@arndb.de> <200905011513.25344.arnd@arndb.de> <49FAFD63.2080102@monstr.eu>
In-Reply-To: <49FAFD63.2080102@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905011606.05319.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uXIN6EeItFxbOgyG7zUFYOUBS7kUO812EP+j
 yRXdoqm+4DlBCvKAPqARHu+Y4EtvGV0mxFU/TBTz7CBNQrCl9F
 fDTDo0ugU1dfvvGSKpmLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Michal Simek wrote:
> Arnd Bergmann wrote:
> > +
> > +#include <asm/segment.h>
> > +
> > +#ifndef get_fs
> > +#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
> 
> one line above -> get_fs could be defined in different space
> and this arch could use MAKE_MM_SEG too -> for example powerpc.

I don't think I understand what you are trying to tell me.
How do you think this should look?

> > +
> > +#define VERIFY_READ	0
> > +#define VERIFY_WRITE	1
> > +
> 
> 
> Not sure if any arch do READ/WRITE check but if yes.

I could not find any architecture using it either, but the
API is defined this way.

> #ifndef access_ok
> 
> > +#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
> 
> #endif

right, will change.

> > +
> > +/*
> > + * The architecture should really override this if possible, at least
> > + * doing a check on the get_fs()
> > + */
> 
> If they should really override it but why write it here.

Mostly for documentation purposes, so that an architecture maintainer
can copy the prototype. I see the asm-generic headers as both fallbacks
for architectures and as templates of what should be implemented.

> > +#define get_user(x, ptr)					\
> > +({								\
> > +	might_sleep();						\
> > +	__access_ok(ptr, sizeof (*ptr)) ?			\
> > +		__get_user(x, ptr) :				\
> > +		-EFAULT;					\
> > +})
> 
> I am getting here (for put_user macro too) any error on noMMU. :-(

What kind of error do you see?
 
> > +static inline long
> > +strncpy_from_user(char *dst, const char __user *src, long count)
> > +{
> > +	if (!__access_ok(src, 1))
> > +		return -EFAULT;
> > +	return __strncpy_from_user(dst, src, count);
> > +}
> 
> Is it a good place to add might_sleep() and unlikely(+ some other cases) too?
> We have almost the same code.

Yes, I think so. The unlikely() can probably go into __access_ok() though,
so we don't have to write it every time.

	Arnd <><
