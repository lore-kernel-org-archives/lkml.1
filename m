Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYCKEVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYCKEVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYCKEV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:21:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYCKEV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:21:29 -0400
Date: Mon, 10 Mar 2008 21:21:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] lib: introduce call_once()
Message-Id: <20080310212108.5882011e.akpm@linux-foundation.org>
In-Reply-To: <200803111510.52761.nickpiggin@yahoo.com.au>
References: <20080310145704.GA6396@APFDCB5C>
	<20080310204853.3108d21c.akpm@linux-foundation.org>
	<200803111510.52761.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 15:10:52 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 11 March 2008 14:48, Andrew Morton wrote:
> > On Mon, 10 Mar 2008 23:57:05 +0900 Akinobu Mita <akinobu.mita@gmail.com> 
> wrote:
> > > call_once() is an utility function which has similar functionality of
> > > pthread_once().
> > >
> > > +/*
> > > + * call_once - call the initialization function only once
> > > + *
> > > + * @once_control: guarantee that the init_routine will be called only
> > > once + * @init_routine: initialization function
> > > + *
> > > + * The first call to call_once(), with a given once_control, shall call
> > > the + * init_routine with no arguments and return the value init_routine
> > > returned. + * If the init_routine returns zero which indicates the
> > > initialization + * succeeded, subsequent calls of call_once() with the
> > > same once_control shall + * not call the init_routine and return zero.
> > > + */
> > > +
> > > +static inline int call_once(struct once_control *once_control,
> > > +			    int (*init_rouine)(void))
> > > +{
> > > +	return likely(once_control->done) ? 0
> > > +			: call_once_slow(once_control, init_rouine);
> > > +}
> >
> > I don't believe that this shold be described in terms of an "init_routine".
> > This mechanism can be used for things other than initialisation routines.
> >
> > It is spelled "routine", not "rouine".
> >
> >
> > Would it not be simpler and more general to do:
> >
> > #define ONCE()						\
> > 	({						\
> > 		static long flag;			\
> > 							\
> > 		return !test_and_set_bit(0, flag);	\
> > 	})
> >
> > and then callers can do
> >
> > 	if (ONCE())
> > 		do_something();
> >
> > ?
> 
> Isn't this usually going to be buggy if you have concurrent access
> here? I'd prefer to keep synchronisation details in the caller and
> not have this call_once at all.

Well, I'm a bit dubious about the calue of all of this (althoug I didn't
review the callers).

But the above code is guaranteed race-free ;)
