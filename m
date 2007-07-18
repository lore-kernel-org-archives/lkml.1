Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbXGRQ25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbXGRQ25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932777AbXGRQ2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:28:46 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:34785 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933324AbXGRQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:28:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NwjKvfUD2XDON8oWjYNAm3UOitePrJReYCB+/tCHf+dWAHpxg4asLIJ7vwZjvC+UJ2qzQJWYnYmFAqHqgZQ5WuPYWXxV0eblvWeimTZIjMAsFUEYTuJuSlNOpvImo5qF7ybw4TimEdIpaYwfMC1qR3OHbF9fyTvE7HTik8NJNjk=
Message-ID: <961aa3350707180928t418bc755i486bf87453bf6bd6@mail.gmail.com>
Date: Thu, 19 Jul 2007 01:28:43 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: ego@in.ibm.com
Subject: Re: [PATCH 4/10] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed callbacks with CPU_UP_PREPARE
Cc: linux-kernel@vger.kernel.org, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Dmitriy Zavin" <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ashok Raj" <ashok.raj@intel.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, heiko.carstens@de.ibm.com,
       kiran@scalex86.org, clameter@sgi.com,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070718065404.GA1982@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716134855.GA1858@APFDCB5C> <20070716135347.GD2040@APFDCB5C>
	 <20070717082331.GA12231@in.ibm.com>
	 <961aa3350707171018i58a47b7asb4a92e1bcd146adf@mail.gmail.com>
	 <20070718065404.GA1982@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > >[...] However, it might break slab.
> > >If I am not mistaken, slab code initializes multiple objects in
> > >CPU_UP_PREPARE and relies on the CPU_UP_CANCELLED to destroy the
> > >objects which successfully got initialized before the some object's
> > >initialization went bad.
> >
> > My testing machine is ordinary dual core non numa box. So it might not
> > trigger the problem that you are warried about under heavy slab alloc
> > failure injection.
> >
> > At first glance I couln't find the problem in cpu hottplug code in slab.c
> > yet,
> > but found some memory leak path. (it doesn't break slab though)
>
> That's what I meant. I shouldn't have used the word "break" :-)
> In case of slab, freeing up of resources on an error during CPU_UP_PREPARE,
> is currently handled in CPU_UP_CANCELLED.

Now I perfectly understand your concern. The last memleak fix
patch did not cover for each cachep->array[cpu] in cache_chain.
So cpu hotplug error handling in slab becomes worse by this change.

> But, like you reasoned out, it makes more sense for such a subsystem
> to free up all the correctly allocated resources before sending a
> NOTIFY_BAD, rather than handling it in CPU_UP_CANCELLED. And slab
> needed that fix, which you've provided, before we send the notification
> to (nr_calls - 1) callers.
>
> So could you add this patch to series?

Sure, and I'll CC you on the slab change.
