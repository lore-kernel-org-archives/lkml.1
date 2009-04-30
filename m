Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbZD3KuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbZD3KuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZD3Kt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:49:58 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:35920 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZD3Kt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:49:57 -0400
Message-ID: <49F9821C.5010802@cosmosbay.com>
Date: Thu, 30 Apr 2009 12:49:00 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jesse.brandeburg@intel.com, netdev@vger.kernel.org, haoki@redhat.com,
       mchan@broadcom.com, davidel@xmailserver.org
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
References: <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com> <alpine.DEB.1.10.0904281501300.13862@qirst.com> <49F76174.6060009@cosmosbay.com> <alpine.DEB.1.10.0904281612560.13862@qirst.com> <49F767FD.2040205@cosmosbay.com> <alpine.DEB.1.10.0904281629090.15947@qirst.com> <49F76F6C.80005@cosmosbay.com> <49F77108.7060509@cosmosbay.com> <20090429091130.GA27857@elte.hu>
In-Reply-To: <20090429091130.GA27857@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 30 Apr 2009 12:49:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> On uddpping, I had prior to the patch about 49000 wakeups per 
>> second, and after patch about 26000 wakeups per second (matches 
>> number of incoming udp messages per second)
> 
> very nice. It might not show up as a real performance difference if 
> the CPUs are not fully saturated during the test - but it could show 
> up as a decrease in CPU utilization.
> 
> Also, if you run the test via 'perf stat -a ./test.sh' you should 
> see a reduction in instructions executed:
> 
> aldebaran:~/linux/linux> perf stat -a sleep 1
> 
>  Performance counter stats for 'sleep':
> 
>    16128.045994  task clock ticks     (msecs)
>           12876  context switches     (events)
>             219  CPU migrations       (events)
>          186144  pagefaults           (events)
>     20911802763  CPU cycles           (events)
>     19309416815  instructions         (events)
>       199608554  cache references     (events)
>        19990754  cache misses         (events)
> 
>  Wall-clock time elapsed:  1008.882282 msecs
> 
> With -a it's measured system-wide, from start of test to end of test 
> - the results will be a lot more stable (and relevant) statistically 
> than wall-clock time or CPU usage measurements. (both of which are 
> rather imprecise in general)

I tried this perf stuff and got strange results on a cpu burning bench, 
saturating my 8 cpus with a "while (1) ;" loop


# perf stat -a sleep 10

 Performance counter stats for 'sleep':

   80334.709038  task clock ticks     (msecs)
          80638  context switches     (events)
              4  CPU migrations       (events)
            468  pagefaults           (events)
   160694681969  CPU cycles           (events)
   160127154810  instructions         (events)
         686393  cache references     (events)
         230117  cache misses         (events)

 Wall-clock time elapsed: 10041.531644 msecs

So its about 16069468196 cycles per second for 8 cpus
Divide by 8 to get 2008683524 cycles per second per cpu,
which is not       3000000000  (E5450  @ 3.00GHz)

It seems strange a "jmp myself" uses one unhalted cycle per instruction 
and 0.5 halted cycle ...

Also, after using "perf stat", tbench results are 1778 MB/S
instead of 2610 MB/s. Even if no perf stat running.



