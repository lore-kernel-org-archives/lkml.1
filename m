Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYETHDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYETHDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYETHDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 03:03:12 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41337 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYETHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 03:03:11 -0400
Message-ID: <483277BE.6060207@bull.net>
Date: Tue, 20 May 2008 09:03:26 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org
Subject: Re: [PATCH 7/9] Make idr_remove rcu-safe
References: <20080507113553.395937000@bull.net> <20080507113737.562143000@bull.net> <20080514195925.GA8994@tpepper-t42p.dolavim.us> <482BE8DD.2020101@bull.net> <20080520052904.GA11326@tpepper-t42p.dolavim.us>
In-Reply-To: <20080520052904.GA11326@tpepper-t42p.dolavim.us>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Pepper wrote:
> On Thu 15 May at 09:40:13 +0200 Nadia.Derbey@bull.net said:
> 
>>Tim Pepper wrote:
>>
>>>On Wed 07 May at 13:36:00 +0200 Nadia.Derbey@bull.net said:
>>>
>>>
>>>>[PATCH 07/09]
>>>>
>>>>This patch introduces the free_layer() routine: it is the one that actually
>>>>frees memory after a grace period has elapsed.
>>>>
>>>>Index: linux-2.6.25-mm1/lib/idr.c
>>>>===================================================================
>>>>--- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 18:06:43.000000000 +0200
>>>>+++ linux-2.6.25-mm1/lib/idr.c	2008-05-07 09:07:31.000000000 +0200
>>>>@@ -424,15 +455,13 @@ void idr_remove_all(struct idr *idp)
>>>>
>>>>		id += 1 << n;
>>>>		while (n < fls(id)) {
>>>>-			if (p) {
>>>>-				memset(p, 0, sizeof *p);
>>>>-				move_to_free_list(idp, p);
>>>>-			}
>>>>+			if (p)
>>>>+				free_layer(p);
>>>>			n += IDR_BITS;
>>>>			p = *--paa;
>>>>		}
>>>>	}
>>>>-	idp->top = NULL;
>>>>+	rcu_assign_pointer(idp->top, NULL);
>>>>	idp->layers = 0;
>>>>}
>>>>EXPORT_SYMBOL(idr_remove_all);
>>>
>>>
>>>Does idr_remove_all() need an rcu_dereference() in the loop preceeding the
>>>above, where it does:
>>>
>>>                while (n > IDR_BITS && p) {
>>>                        n -= IDR_BITS;
>>>                        *paa++ = p;
>>>     ---->              p = p->ary[(id >> n) & IDR_MASK];
>>>                }
>>
>>I assumed here that idr_remove_all() was called in the "typical cleanup 
>>sequence" mentioned in the comment describing the routine.
>>And actually, that's how it is called in drivers/char/drm.
> 
> 
> Sure.  I guess I was thinking out loud that it's maybe somewhat implicit
> that things must be serial at that point and I wasn't sure if it was meant
> to be required or enforced, if it should be clarified with comments or
> by explicitly adding the rcu calls in these couple additional places.

Ok, I'll add a comment to clarify things.

> 
> 
>>>I've been having some machine issues, but hope to give this patch set a run
>>>still on a 128way machine and mainline to provide some additional
>>>datapoints.
>>>
>>
>>That would be kind, indeed (hope I didn't break anything).
> 
> 
> I've had a bunch of machine issues, but I did manage to do some testing.
> 
> I'd started looking at the regression after Anton Blanchard mentioned
> seeing it via this simple bit of code:
>     http://ozlabs.org/~anton/junkcode/lock_comparison.c
> It essentially spawns a number of threads to match the cpu count, each
> thread looping 10000 times, where each loop does some trivial semop()'s.
> Each thread has its own semaphore it is semop()'ing so there's no
> contention.
> 
> To get a little more detail I hacked Anton's code minimally to record
> results for thread counts 1..n and also to optionally have just a single
> semaphore on which all of these threads are contending.  I ran this on
> a 64cpu machine (128 given SMT), but didn't make any effort to force
> clean thread/cpu affinity.
> 
> The contended numbers don't look quite as consistent as they could at
> the high end, but I think this is more quick/dirty test than patch.
> Nevertheless the patch clearly outperforms mainline and despite the
> noise actually looks to perform a more consistently than mainline
> (see graphs).
> 
> Summary numbers from a run (with a bit more detail at the high thread
> side as the numbers had more variation there and just showing the power
> of two numbers for this run incorrectly implies a knee...I can do more
> runs with averages/stats if people need more convincing):
> 
> threads          uncontended                     contended
>                  semop loops                    semop loops
> 
>         2.6.26-rc2      +patchset        2.6.26-rc2      +patchset
> 
> 1	  2243.94	  4436.25	   2063.18	   4386.78
> 2	  2954.11	  5445.12	  67885.16	   5906.72
> 4	  4367.45	  8125.67	  72820.32	  44263.86
> 8	  7440.00	  9842.66	  60184.17	  95677.58
> 16	 12959.44	 20323.97	 136482.42	 248143.80
> 32	 35252.71	 56334.28	 363884.09	 599773.31
> 48	 62811.15	102684.67	 515886.12	1714530.12
> ...
> 57	 81064.99	141434.33	 564874.69	2518078.75
> 58	 79486.08	145685.84	 693038.06	1868813.12
> 59	 83634.19	153087.80	1237576.25	2828301.25
> 60	 91581.07	158207.08	 797796.94	2970977.25
> 61	 89209.40	160529.38	1202135.38	2538114.50
> 62	 89008.45	167843.78	1305666.75	2274845.00
> 63	 97753.17	177470.12	 733957.31	 363952.62
> 64	102556.05	175923.56	1356988.88	 199527.83
> 
> (detail plots from this same run attached...)
> 
> Nadia, you're welcome to add either or both of these to the series if
> you'd like:
> 
> Reviewed-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> Tested-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> 
> 

Indeed, thanks a lot for taking some of your time to pass the tests!
Actually there are 2 numbers that bother me: those for the contended 
loops on the patched kernel (63 and 64 threads) - the last 2 numbers in 
the rightmost column.
Did you have the opportunity to run that same test for 128 threads: this 
is just for me to check whether 64 is not the #of threads we are 
starting to slow down from.

Thanks,
Nadia
