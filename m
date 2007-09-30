Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbXI3SqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbXI3SqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 14:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbXI3SqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 14:46:02 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:36683 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXI3SqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 14:46:00 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Sun, 30 Sep 2007 21:45:47 +0300
Message-Id: <20070930184547.M90508@nuclearcat.com>
In-Reply-To: <46FFE17C.9020202@cosmosbay.com>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

pi ~ # zcat /proc/config.gz |grep SLUB
# CONFIG_SLUB_DEBUG is not set
CONFIG_SLUB=y


21:27:20     CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal
   %idle    intr/s
21:27:21     all    5.53   21.61    8.54    0.00    0.50    5.03    0.00   
58.79   7147.52
21:27:22     all    6.40   15.76    8.87    0.00    0.49   20.20    0.00   
48.28   6327.00
21:27:23     all    6.53   20.60   12.06    0.00    0.00   52.76    0.00    
8.04    456.44
21:27:24     all    7.00   17.50   10.50    0.00    0.00   53.00    0.00   
12.00    439.00
21:27:25     all    7.50   18.00   12.50    0.50    0.50   52.50    0.00    
8.50    464.00
21:27:26     all    6.64   16.11   11.37    0.00    0.00   58.77    0.00    
7.11    401.90
21:27:27     all    0.00    0.40    0.40    0.00    0.00   99.20    0.00    
0.00    325.20
21:27:28     all    0.00    0.50    0.00    0.00    0.00   99.50    0.00    
0.00    453.47
21:27:29     all    0.00    0.00    0.00    0.00    0.00  100.00    0.00    
0.00    495.10
21:27:30     all    0.00    0.50    0.00    0.00    0.00   99.50    0.00    
0.00    625.74
21:27:31     all    0.00    0.00    0.00    0.00    0.00  100.00    0.00    
0.00    600.97
21:27:32     all    0.00    0.00    0.00    0.00    0.00  100.00    0.00    
0.00    604.95

64 bytes from 127.0.0.1: icmp_seq=15 ttl=64 time=0.031 ms
64 bytes from 127.0.0.1: icmp_seq=16 ttl=64 time=229 ms
64 bytes from 127.0.0.1: icmp_seq=17 ttl=64 time=253 ms
64 bytes from 127.0.0.1: icmp_seq=18 ttl=64 time=257 ms
64 bytes from 127.0.0.1: icmp_seq=19 ttl=64 time=279 ms
64 bytes from 127.0.0.1: icmp_seq=20 ttl=64 time=246 ms
64 bytes from 127.0.0.1: icmp_seq=21 ttl=64 time=246 ms
64 bytes from 127.0.0.1: icmp_seq=22 ttl=64 time=234 ms
64 bytes from 127.0.0.1: icmp_seq=23 ttl=64 time=235 ms

Problem remains. It is another server.


On Sun, 30 Sep 2007 19:48:44 +0200, Eric Dumazet wrote

> > I've moved recently one of my proxies(squid and some compressing 
application) 
> > from 2.6.21 to 2.6.22, and notice huge performance drop. I think this is 
> > important, cause it can cause serious regression on some other workloads 
like 
> > busy web-servers and etc.
> > 
> > After some analysis of different options i can bring more exact numbers:
> > 
> > 2.6.21 able to process 500-550 requests/second and 15-20 Mbit/s of 
traffic, 
> > and working great without any slowdown or instability.
> > 
> > 2.6.22 able to process only 250-300 requests and 8-10 Mbit/s of traffic, 
ssh 
> > and console is "freezing" (there is delay even for typing characters).
> > 
> > Both proxies is on identical hardware(Sun Fire X4100), 
configuration(small 
> > system, LFS-like, on USB flash), different only kernel.
> > 
> > I tried to disable/enable various options and optimisations - it doesn't 
> > change anything, till i reach SLUB/SLAB option.
> > 
> > I've loaded proxy configuration to gentoo PC with 2.6.22 (then upgraded 
it to 
> > 2.6.23-rc8), and having same effect.
> > Additionally, when load reaching maximum i can notice whole system 
slowdown, 
> > for example ssh and scp takes much more time to run, even i do nice -n -5 
for 
> > them.
> > 
> > But even choosing 2.6.23-rc8+SLAB i noticed same "freezing" of ssh (and 
sure 
> > it slowdown other kind of network performance), but much less comparing 
with 
> > SLUB. On top i am seeing ksoftirqd taking almost 100% (sometimes 
ksoftirqd/0, 
> > sometimes ksoftirqd/1).
> > 
> > I tried also different tricks with scheduler (/proc/sys/kernel/sched*), 
but 
> > it's also didn't help.
> > 
> > When it freezes it looks like:
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >     7 root      15  -5     0    0    0 R   64  0.0   2:47.48 ksoftirqd/1
> >  5819 root      20   0  134m 130m  596 R   57  3.3   4:36.78 globax
> >  5911 squid     20   0 1138m 1.1g 2124 R   26 28.9   2:24.87 squid
> >    10 root      15  -5     0    0    0 S    1  0.0   0:01.86 events/1
> >  6130 root      20   0  3960 2416 1592 S    0  0.1   0:08.02 oprofiled
> > 
> > 
> > Oprofile results:
> > 
> > 
> > Thats oprofile with 2.6.23-rc8 - SLUB
> > 
> > 73918    21.5521  check_bytes
> > 38361    11.1848  acpi_pm_read
> > 14077     4.1044  init_object
> > 13632     3.9747  ip_send_reply
> > 8486      2.4742  __slab_alloc
> > 7199      2.0990  nf_iterate
> > 6718      1.9588  page_address
> > 6716      1.9582  tcp_v4_rcv
> > 6425      1.8733  __slab_free
> > 5604      1.6339  on_freelist
> > 
> > 
> > Thats oprofile with 2.6.23-rc8 - SLAB
> > 
> > CPU: AMD64 processors, speed 2592.64 MHz (estimated)
> > Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a 
unit 
> > mask of 0x00 (No unit mask) count 100000
> > samples  %        symbol name
> > 138991   14.0627  acpi_pm_read
> > 52401     5.3018  tcp_v4_rcv
> > 48466     4.9037  nf_iterate
> > 38043     3.8491  __slab_alloc
> > 34155     3.4557  ip_send_reply
> > 20963     2.1210  ip_rcv
> > 19475     1.9704  csum_partial
> > 19084     1.9309  kfree
> > 17434     1.7639  ip_output
> > 17278     1.7481  netif_receive_skb
> > 15248     1.5428  nf_hook_slow
> > 
> > My .config is at http://www.nuclearcat.com/.config (there is SPARSEMEM 
> > enabled, it doesn't make any noticeable difference)
> > 
> > Please CC me on reply, i am not in list.
> >
> 
> Could you try with SLUB but disabling CONFIG_SLUB_DEBUG ?


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

