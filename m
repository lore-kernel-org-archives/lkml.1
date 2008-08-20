Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYHTVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYHTVEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYHTVEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:04:21 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52302 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751912AbYHTVEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:04:20 -0400
X-SourceIP: 80.57.229.25
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, adobriyan@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <2c0942db0808201358t1126f4bwd745402f6e9b42d2@mail.gmail.com>
References: <1912217169.25608.228.camel@ymzhang>
	 <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
	 <1219252901.8651.63.camel@twins>
	 <200808210355.55597.nickpiggin@yahoo.com.au>
	 <2c0942db0808201115v3025e5f6r6c882783fa9e29f3@mail.gmail.com>
	 <1219264236.8651.76.camel@twins>
	 <2c0942db0808201358t1126f4bwd745402f6e9b42d2@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 23:04:03 +0200
Message-Id: <1219266243.8651.86.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 13:58 -0700, Ray Lee wrote:
> On Wed, Aug 20, 2008 at 1:30 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Nick is right, try:
> >
> > int main(int argc, char **argv)
> > {
> >        unsigned int x = 7, y = 5;
> >        printf("%d\n", avg(x,y));
> >        return 0;
> > }
> >
> > It fails because 5-7 = -2, which needs a signed division or sign
> > extending right shift.
> >
> > we'd need something like:
> >
> > #define avg(x, y) ({                            \
> >        typeof(x) _avg1 = (x);                  \
> >        typeof(y) _avg2 = (y);                  \
> >        (void) (&_avg1 == &_avg2);              \
> >        _avg1 + (signed typeof(x))(_avg2 - _avg1)/2; })
> >
> > except that typeof() doesn't work that way.
> >
> > #define avg(x, y) ({                            \
> >        typeof(x) _avg1 = (x);                  \
> >        typeof(y) _avg2 = (y);                  \
> >        (void) (&_avg1 == &_avg2);              \
> >        _avg1 + (long)(_avg2 - _avg1)/2; })
> >
> > works for the above example, but when I make it long long, so as to
> > match the longest supported type, it goes boom again - for as of yet
> > unknown reasons.
> 
> I think you'd want to cast it with a (signed) instead? as in:
> 
> #include <stdio.h>
> 
> #define avg(x, y) ({            \
>        typeof(x) _x = (x);      \
>        typeof(y) _y = (y);      \
>        (void) (&_x == &_y);     \
>        _x + (signed)(_y - _x)/2; })

signed is short for signed int, which is too short for say long or long
long input.

Anyway, see my previous mail in which I explained that I got the cast
order wrong.

