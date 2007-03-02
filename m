Return-Path: <linux-kernel-owner+w=401wt.eu-S2992599AbXCBQgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992599AbXCBQgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:36:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992601AbXCBQgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:36:01 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:45696 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992599AbXCBQgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:36:00 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH (update 3)] timer: Run calc_load halfway through each round_jiffies second
Date: Fri, 2 Mar 2007 17:35:55 +0100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Bill Irwin <bill.irwin@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       arjan@linux.intel.com
References: <45E0577C.9020409@simon.arlott.org.uk> <45E7F92E.7090407@simon.arlott.org.uk> <45E83F7A.9030307@simon.arlott.org.uk>
In-Reply-To: <45E83F7A.9030307@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703021735.55142.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 16:15, Simon Arlott wrote:
> Whenever jiffies is started at a multiple of 5*HZ or wraps, calc_load is
> run exactly on the second which is when tasks using round_jiffies will
> be scheduled to run. This has a bad effect on the load average, making
> it tend towards 1.00 if a task happens to run every time the load is
> being calculated.
>
> This changes calc_load so that it updates load half a second after any
> tasks scheduled using round_jiffies.
>

Simon

I believe this patch is too complex/hazardous and may break exp decay 
computation.
(Even if nobody care about avenrun[] those days :), do you ? )

You could just change LOAD_FREQ from (5*HZ) to (5*HZ+1)


#define LOAD_FREQ   (5*HZ+1)


Mathematical proof (well... sort of)

$ cat prog.c
#define FSHIFT          11              /* nr of bits of precision */
#define FIXED_1         ((double)(1<<FSHIFT))   /* 1.0 as fixed-point */

#include <math.h>
#include <stdio.h>
int main()
{
printf("Old values :\n");
printf("#define EXP_1  %g\n", FIXED_1/exp(5.0/60.0));
printf("#define EXP_5  %g\n", FIXED_1/exp(5.0/(5*60.0)));
printf("#define EXP_15 %g\n", FIXED_1/exp(5.0/(15*60.0)));
printf("New values :\n");
printf("%g\n", FIXED_1/exp(5.01/60.0));
printf("%g\n", FIXED_1/exp(5.01/(5*60.0)));
printf("%g\n", FIXED_1/exp(5.01/(15*60.0)));
return 0;
}

# gcc -o prog prog.c -lm
# ./prog
Old values :
#define EXP_1  1884.25
#define EXP_5  2014.15
#define EXP_15 2036.65
New values :
1883.94
2014.08
2036.63

You can see that 5.01 instead of 5.00 second gives the same EXP_xx values.

So (5*HZ + 1) is safe. (because HZ >= 100)

Eric
