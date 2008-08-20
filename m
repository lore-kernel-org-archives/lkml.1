Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbYHTU5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbYHTU5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 16:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYHTU5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 16:57:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:46872 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYHTU5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 16:57:11 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, adobriyan@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <1219264236.8651.76.camel@twins>
References: <1912217169.25608.228.camel@ymzhang>
	 <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
	 <1219252901.8651.63.camel@twins>
	 <200808210355.55597.nickpiggin@yahoo.com.au>
	 <2c0942db0808201115v3025e5f6r6c882783fa9e29f3@mail.gmail.com>
	 <1219264236.8651.76.camel@twins>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 22:56:38 +0200
Message-Id: <1219265798.8651.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 22:30 +0200, Peter Zijlstra wrote:
> On Wed, 2008-08-20 at 11:15 -0700, Ray Lee wrote:
> > On Wed, Aug 20, 2008 at 10:55 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Thursday 21 August 2008 03:21, Peter Zijlstra wrote:
> > >> Ok, so one last time (I hope!)..
> > >>
> > >> Everybody happy with this?
> > >
> > >
> > >> Index: linux-2.6/include/linux/kernel.h
> > >> ===================================================================
> > >> --- linux-2.6.orig/include/linux/kernel.h
> > >> +++ linux-2.6/include/linux/kernel.h
> > >> @@ -367,6 +367,12 @@ static inline char *pack_hex_byte(char *
> > >>       (void) (&_max1 == &_max2);              \
> > >>       _max1 > _max2 ? _max1 : _max2; })
> > >>
> > >> +#define avg(x, y) ({                         \
> > >> +     typeof(x) _avg1 = (x);                  \
> > >> +     typeof(y) _avg2 = (y);                  \
> > >> +     (void) (&_avg1 == &_avg2);              \
> > >> +     _avg1 + (_avg2 - _avg1)/2; })
> > >
> > > That's not going to work with unsigned types.
> > 
> > Uhm, I think it works fine, even with unsigned, even where _avg2 is
> > smaller than _avg1. Underflow is a good thing here. And I mocked up a
> > little test harness and it gives the correct answers for a half dozen
> > sets of values I tossed at it
> > 
> > But maybe I'm forgetting an obscure unsigned or signed int type
> > widening rule, so, care to elaborate?
> 
> Nick is right, try:
> 
> int main(int argc, char **argv)
> {
>         unsigned int x = 7, y = 5;
>         printf("%d\n", avg(x,y));
>         return 0;
> }
> 
> It fails because 5-7 = -2, which needs a signed division or sign
> extending right shift.
> 
> we'd need something like:
> 
> #define avg(x, y) ({                            \
>         typeof(x) _avg1 = (x);                  \          
>         typeof(y) _avg2 = (y);                  \
>         (void) (&_avg1 == &_avg2);              \
>         _avg1 + (signed typeof(x))(_avg2 - _avg1)/2; })
> 
> except that typeof() doesn't work that way.
> 
> #define avg(x, y) ({                            \
>         typeof(x) _avg1 = (x);                  \          
>         typeof(y) _avg2 = (y);                  \
>         (void) (&_avg1 == &_avg2);              \
>         _avg1 + (long)(_avg2 - _avg1)/2; })
> 
> works for the above example, but when I make it long long, so as to
> match the longest supported type, it goes boom again - for as of yet
> unknown reasons.

Ok, people pointed out I got my promotion rules mixed up, I casted the
result of the division to signed, instead of ending up with a signed
division.

#define avg(x, y) ({                            \
        typeof(x) _avg1 = (x);                  \
        typeof(y) _avg2 = (y);                  \
        (void) (&_avg1 == &_avg2);              \
        (typeof(x))(_avg1 + ((long long)_avg2 - _avg1)/2); })

seems to work.

