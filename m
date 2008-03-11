Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYCKM1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYCKM1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYCKM1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:27:33 -0400
Received: from hs-out-0708.google.com ([64.233.178.241]:46092 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYCKM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HqGUrvUwQRPtMZYz/ZQAU9D7z0SSTUMWvwmZPO7fKinQTW5p2Zlh4llqb2Le7lIbtJLZ2eRZbQzgGUZqdWx+/TujA9oVHWPhNyJR+UCrPYRhTXqm43xwIagVxnSHxc+Xv8HaMvQMI/7dN48zUxQto7T2qBYZnPb1pLj351XEreg=
Message-ID: <961aa3350803110527g4d6654ew34847807e46da315@mail.gmail.com>
Date: Tue, 11 Mar 2008 21:27:30 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <20080310212108.5882011e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310145704.GA6396@APFDCB5C>
	 <20080310204853.3108d21c.akpm@linux-foundation.org>
	 <200803111510.52761.nickpiggin@yahoo.com.au>
	 <20080310212108.5882011e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/11, Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 11 Mar 2008 15:10:52 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>
>  > On Tuesday 11 March 2008 14:48, Andrew Morton wrote:
>  > > On Mon, 10 Mar 2008 23:57:05 +0900 Akinobu Mita <akinobu.mita@gmail.com>
>  > wrote:
>  > > > call_once() is an utility function which has similar functionality of
>  > > > pthread_once().
>  > > >
>  > > > +/*
>  > > > + * call_once - call the initialization function only once
>  > > > + *
>  > > > + * @once_control: guarantee that the init_routine will be called only
>  > > > once + * @init_routine: initialization function
>  > > > + *
>  > > > + * The first call to call_once(), with a given once_control, shall call
>  > > > the + * init_routine with no arguments and return the value init_routine
>  > > > returned. + * If the init_routine returns zero which indicates the
>  > > > initialization + * succeeded, subsequent calls of call_once() with the
>  > > > same once_control shall + * not call the init_routine and return zero.
>  > > > + */
>  > > > +
>  > > > +static inline int call_once(struct once_control *once_control,
>  > > > +                     int (*init_rouine)(void))
>  > > > +{
>  > > > + return likely(once_control->done) ? 0
>  > > > +                 : call_once_slow(once_control, init_rouine);
>  > > > +}
>  > >
>  > > I don't believe that this shold be described in terms of an "init_routine".
>  > > This mechanism can be used for things other than initialisation routines.
>  > >
>  > > It is spelled "routine", not "rouine".
>  > >
>  > >
>  > > Would it not be simpler and more general to do:
>  > >
>  > > #define ONCE()                                              \
>  > >     ({                                              \
>  > >             static long flag;                       \
>  > >                                                     \
>  > >             return !test_and_set_bit(0, flag);      \
>  > >     })
>  > >
>  > > and then callers can do
>  > >
>  > >     if (ONCE())
>  > >             do_something();
>  > >
>  > > ?

This cannot be used directly in the conversions of patch 2 - 5.
Because the callers of call_once() in patch 2 - 5 need to wait for the
complition of "init_routine". Some blocking mechanism is needed.

>  > Isn't this usually going to be buggy if you have concurrent access
>  > here? I'd prefer to keep synchronisation details in the caller and
>  > not have this call_once at all.
>
>
> Well, I'm a bit dubious about the calue of all of this (althoug I didn't
>  review the callers).
>

I'll try to find another conversions to back up the necessity...
