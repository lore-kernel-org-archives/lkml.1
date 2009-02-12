Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbZBLTaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbZBLTaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbZBLT3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:29:55 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:35471 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320AbZBLT3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:29:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAP8HlElMQWt2/2dsb2JhbACBbtJKhBgG
Date: Thu, 12 Feb 2009 14:29:41 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212192941.GC2047@Krystal>
References: <20090211153246.GA6694@linux.vnet.ibm.com> <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090212164621.GC6759@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:47:47 up 42 days, 18:45,  6 users,  load average: 0.22, 0.27,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> diff --git a/urcu.c b/urcu.c
> index f2aae34..a696439 100644
> --- a/urcu.c
> +++ b/urcu.c
> @@ -99,7 +99,8 @@ static void force_mb_single_thread(pthread_t tid)
>  	 * BUSY-LOOP.
>  	 */
>  	while (sig_done < 1)
> -		smp_rmb();	/* ensure we re-read sig-done */
> +		barrier();	/* ensure compiler re-reads sig-done */
> +				/* cache coherence guarantees CPU re-read. */

OK, this is where I think our points of view differ. Please refer to
http://lkml.org/lkml/2007/6/18/299.

Basically, cpu_relax() used in the Linux kernel has an
architecture-specific implementation which *could* include a smp_rmb()
if the architecture doesn't notice writes done by other CPUs. I think
Blackfin is the only architecture currently supported by the Linux
kernel which defines cpu_relax() as a smp_mb(), because it does not have
cache coherency.

Therefore, I propose that we create a memory barrier macro which is
defined as a 
  barrier()   when the cpu has cache coherency
  cache flush when the cpu does not have cache coherency and is
              compiled with smp support.

We could call that

  smp_wmc() (for memory-coherency or memory commit)
  smp_rmc()
  smp_mc()

It would be a good way to identify the location where data exchange
between memory and the local cache are is required in the algorithm.
What do you think ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
