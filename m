Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXI3WFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXI3WFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXI3WFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:05:07 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:52251 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbXI3WFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:05:05 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Mon, 1 Oct 2007 01:04:52 +0300
Message-Id: <20070930220452.M25621@nuclearcat.com>
In-Reply-To: <200709301425.37564.nickpiggin@yahoo.com.au>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com> <200709301425.37564.nickpiggin@yahoo.com.au>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick

There is no numbers for sure now, it is just instability.

I am bisecting kernel now (from 2.6.21 to 2.6.22-rc1), i think it is caused 
by some patch, and maybe not related to CFS. Anyways, let's see when i finish 
bisect. Just i was thinking, maybe anyone else have similar issues or some 
ideas in mind.

The only one case - it is very difficult to track, and i have to do it on 
live server with thousands of users. At night load is much lower, so possible 
by mistake i will miss a point (it can detect bug easily, IF softirq in 
mpstat 1 will jump up to 30+%. On 2.6.21 it is always staying +-10%, on 
"buggy" version it jumps up to 100%. Now cause less load at night up to 30-
50%, so on hardware it is not very noticeable (thats why maybe not much 
feedbacks), i am trying to utilise hardware maximum as possible - so i feel 
regressions much more.

Anyway, possible i will have news after 2-3 hours max.


On Sun, 30 Sep 2007 14:25:37 +1000, Nick Piggin wrote
> Hi Denys, thanks for reporting (btw. please reply-to-all when 
> replying on lkml).
> 
> You say that SLAB is better than SLUB on an otherwise identical 
> kernel, but I didn't see if you quantified the actual numbers? It 
> sounds like there is still a regression with SLAB?
> 
> On Monday 01 October 2007 03:48, Eric Dumazet wrote:
> > Denys a  :
> > > I've moved recently one of my proxies(squid and some compressing
> > > application) from 2.6.21 to 2.6.22, and notice huge performance drop. I
> > > think this is important, cause it can cause serious regression on some
> > > other workloads like busy web-servers and etc.
> > >
> > > After some analysis of different options i can bring more exact numbers:
> > >
> > > 2.6.21 able to process 500-550 requests/second and 15-20 Mbit/s of
> > > traffic, and working great without any slowdown or instability.
> > >
> > > 2.6.22 able to process only 250-300 requests and 8-10 Mbit/s of traffic,
> > > ssh and console is "freezing" (there is delay even for typing
> > > characters).
> > >
> > > Both proxies is on identical hardware(Sun Fire X4100),
> > > configuration(small system, LFS-like, on USB flash), different only
> > > kernel.
> > >
> > > I tried to disable/enable various options and optimisations - it doesn't
> > > change anything, till i reach SLUB/SLAB option.
> > >
> > > I've loaded proxy configuration to gentoo PC with 2.6.22 (then upgraded
> > > it to 2.6.23-rc8), and having same effect.
> > > Additionally, when load reaching maximum i can notice whole system
> > > slowdown, for example ssh and scp takes much more time to run, even i do
> > > nice -n -5 for them.
> > >
> > > But even choosing 2.6.23-rc8+SLAB i noticed same "freezing" of ssh (and
> > > sure it slowdown other kind of network performance), but much less
> > > comparing with SLUB. On top i am seeing ksoftirqd taking almost 100%
> > > (sometimes ksoftirqd/0, sometimes ksoftirqd/1).
> > >
> > > I tried also different tricks with scheduler (/proc/sys/kernel/sched*),
> > > but it's also didn't help.
> > >
> > > When it freezes it looks like:
> > >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> > >     7 root      15  -5     0    0    0 R   64  0.0   2:47.48 ksoftirqd/1
> > >  5819 root      20   0  134m 130m  596 R   57  3.3   4:36.78 globax
> > >  5911 squid     20   0 1138m 1.1g 2124 R   26 28.9   2:24.87 squid
> > >    10 root      15  -5     0    0    0 S    1  0.0   0:01.86 events/1
> > >  6130 root      20   0  3960 2416 1592 S    0  0.1   0:08.02 oprofiled
> > >
> > >
> > > Oprofile results:
> > >
> > >
> > > Thats oprofile with 2.6.23-rc8 - SLUB
> > >
> > > 73918    21.5521  check_bytes
> > > 38361    11.1848  acpi_pm_read
> > > 14077     4.1044  init_object
> > > 13632     3.9747  ip_send_reply
> > > 8486      2.4742  __slab_alloc
> > > 7199      2.0990  nf_iterate
> > > 6718      1.9588  page_address
> > > 6716      1.9582  tcp_v4_rcv
> > > 6425      1.8733  __slab_free
> > > 5604      1.6339  on_freelist
> > >
> > >
> > > Thats oprofile with 2.6.23-rc8 - SLAB
> > >
> > > CPU: AMD64 processors, speed 2592.64 MHz (estimated)
> > > Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a
> > > unit mask of 0x00 (No unit mask) count 100000
> > > samples  %        symbol name
> > > 138991   14.0627  acpi_pm_read
> > > 52401     5.3018  tcp_v4_rcv
> > > 48466     4.9037  nf_iterate
> > > 38043     3.8491  __slab_alloc
> > > 34155     3.4557  ip_send_reply
> > > 20963     2.1210  ip_rcv
> > > 19475     1.9704  csum_partial
> > > 19084     1.9309  kfree
> > > 17434     1.7639  ip_output
> > > 17278     1.7481  netif_receive_skb
> > > 15248     1.5428  nf_hook_slow
> > >
> > > My .config is at http://www.nuclearcat.com/.config (there is SPARSEMEM
> > > enabled, it doesn't make any noticeable difference)
> > >
> > > Please CC me on reply, i am not in list.
> >
> > Could you try with SLUB but disabling CONFIG_SLUB_DEBUG ?


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

