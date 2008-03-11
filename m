Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYCKEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYCKEST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYCKESJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:18:09 -0400
Received: from n58.bullet.mail.sp1.yahoo.com ([98.136.44.46]:47321 "HELO
	n58.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751213AbYCKESI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:18:08 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 00:18:08 EDT
X-Yahoo-Newman-Id: 593717.23607.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bIvUk5kOKYD20yFIdulZZcnNowBZyUIrAwhVLu6x0xN9j0j9NZYHA+8ZXfg9Dr5JI2TIZa7z2j7IrbuzOaB5V9MJwKqoAvs8rB+q2terMZi4vmu4Hx6V2yrNLylPVoDUlq9BhVVESbmJ3ZpjV12awycVaba0yCbkW5kGCG1vx20=  ;
X-YMail-OSG: I4BN3MkVM1k5DlhEJQoy4bgBci.qT4l_AT2qINZ0tOGxVaoz7ioGLMer0Csf3fyBoStqkkN0sw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Date: Tue, 11 Mar 2008 15:10:52 +1100
User-Agent: KMail/1.9.5
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
References: <20080310145704.GA6396@APFDCB5C> <20080310204853.3108d21c.akpm@linux-foundation.org>
In-Reply-To: <20080310204853.3108d21c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803111510.52761.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 14:48, Andrew Morton wrote:
> On Mon, 10 Mar 2008 23:57:05 +0900 Akinobu Mita <akinobu.mita@gmail.com> 
wrote:
> > call_once() is an utility function which has similar functionality of
> > pthread_once().
> >
> > +/*
> > + * call_once - call the initialization function only once
> > + *
> > + * @once_control: guarantee that the init_routine will be called only
> > once + * @init_routine: initialization function
> > + *
> > + * The first call to call_once(), with a given once_control, shall call
> > the + * init_routine with no arguments and return the value init_routine
> > returned. + * If the init_routine returns zero which indicates the
> > initialization + * succeeded, subsequent calls of call_once() with the
> > same once_control shall + * not call the init_routine and return zero.
> > + */
> > +
> > +static inline int call_once(struct once_control *once_control,
> > +			    int (*init_rouine)(void))
> > +{
> > +	return likely(once_control->done) ? 0
> > +			: call_once_slow(once_control, init_rouine);
> > +}
>
> I don't believe that this shold be described in terms of an "init_routine".
> This mechanism can be used for things other than initialisation routines.
>
> It is spelled "routine", not "rouine".
>
>
> Would it not be simpler and more general to do:
>
> #define ONCE()						\
> 	({						\
> 		static long flag;			\
> 							\
> 		return !test_and_set_bit(0, flag);	\
> 	})
>
> and then callers can do
>
> 	if (ONCE())
> 		do_something();
>
> ?

Isn't this usually going to be buggy if you have concurrent access
here? I'd prefer to keep synchronisation details in the caller and
not have this call_once at all.

