Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbXHWSrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbXHWSrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 14:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764806AbXHWSra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 14:47:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52309 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764769AbXHWSr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 14:47:29 -0400
Subject: Re: gettimeofday() jumping into the future
From: john stultz <johnstul@us.ibm.com>
To: Michael Smith <msmith@xiph.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andy Wingo <wingo@fluendo.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3c1737210708230520l7dee896crc614f7fc60ac7a1a@mail.gmail.com>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
	 <1187869632.6114.368.camel@twins>
	 <3c1737210708230520l7dee896crc614f7fc60ac7a1a@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-LYuB+A/0GKEItu5ZGwy6"
Date: Thu, 23 Aug 2007 11:47:02 -0700
Message-Id: <1187894822.6024.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LYuB+A/0GKEItu5ZGwy6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-08-23 at 14:20 +0200, Michael Smith wrote:
> On 8/23/07, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2007-08-23 at 13:08 +0200, Michael Smith wrote:
> > > We've been seeing some strange behaviour on some of our applications
> > > recently. I've tracked this down to gettimeofday() returning spurious
> > > values occasionally.
> > >
> > > Specifically, gettimeofday() will suddenly, for a single call, return
> > > a value about 4398 seconds (~1 hour 13 minutes) in the future. The
> > > following call goes back to a normal value.
> > >
> > > This seems to be occurring when the clock source goes slightly
> > > backwards for a single call. In
> > > kernel/time/timekeeping.c:__get_nsec_offset(), we have this:
> > >  cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
> > >
> > > So a small decrease in time here will (this is all unsigned
> > > arithmetic) give us a very large cycle_delta. cyc2ns() then multiplies
> > > this by some value, then right shifts by 22. The resulting value (in
> > > nanoseconds) is approximately 4398 seconds; this gets added on to the
> > > xtime value, giving us our jump into the future. The next call to
> > > gettimeofday() returns to normal as we don't have this huge nanosecond
> > > offset.
> > >
> > > This system is a 2-socket core 2 quad machine (8 cpus), running 32 bit
> > > mode. It's a dell poweredge 1950. The kernel selects the TSC as the
> > > clock source, having determined that the tsc runs synchronously on
> > > this system. Switching the systems to use a different time source
> > > seems to make the problem go away (which is fine for us, but we'd like
> > > to get this fixed properly upstream).


Hmm. That does sound like unsycned TSCs. Normally Intel systems don't
skew unless they are NUMA systems or you're entering low power states.
We try to catch both of those cases, so I'm not sure how you box is
slipping through.

Can you run the following test to verify that the TSCs are skewed?

thanks
-john



--=-LYuB+A/0GKEItu5ZGwy6
Content-Disposition: attachment; filename=tsc-check.c
Content-Type: text/x-csrc; name=tsc-check.c; charset=utf-8
Content-Transfer-Encoding: 7bit

/* TSC sync test
 *		by: john stultz (johnstul@us.ibm.com)
 *		(C) Copyright IBM 2003, 2005
 *		Licensed under the GPL
 */


#include <stdio.h>
#include <sys/time.h>

#define CALLS_PER_LOOP 64

# define	rdtscll(val)	__asm__ __volatile__("rdtsc" : "=A" (val))

int main(int argc, char *argv[])
{
	unsigned long long list[CALLS_PER_LOOP];
	int i, inconsistent;


	/* timestamp start of test */
	system("date");
	while(1){
		inconsistent = 0;

		/* Fill list */
		for(i=0; i < CALLS_PER_LOOP; i++)
			rdtscll(list[i]);
		
		/* Check for inconsistencies */
		for(i=0; i < CALLS_PER_LOOP-1; i++)
			if(list[i] > list[i+1])
				inconsistent = i+1;

		/* display inconsistency */
		if(inconsistent){
			inconsistent--;
			for(i=0; i < CALLS_PER_LOOP; i++){
				if(i == inconsistent)
					printf("--------------------\n");
				printf("%llu\n",list[i]);
				if(i == inconsistent + 1 )
					printf("--------------------\n");
			}
			fflush(0);
			/* timestamp inconsistency*/
			system("date");	
		}

	}
	return 0;
}

--=-LYuB+A/0GKEItu5ZGwy6--

