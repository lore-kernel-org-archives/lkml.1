Return-Path: <linux-kernel-owner+w=401wt.eu-S1761833AbXHTTiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761833AbXHTTiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXHTTiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:38:13 -0400
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:51758 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXHTTiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:38:12 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 15:38:12 EDT
Message-ID: <46C9E899.9020609@hp.com>
Date: Mon, 20 Aug 2007 12:16:41 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Felix Marti <felix@chelsio.com>, David Miller <davem@davemloft.net>,
       sean.hefty@intel.com, netdev@vger.kernel.org, rdreier@cisco.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom
 the host TCP port space.
References: <8A71B368A89016469F72CD08050AD334018E20BC@maui.asicdesigners.com>	<20070819.174017.77241227.davem@davemloft.net>	<8A71B368A89016469F72CD08050AD334018E20BE@maui.asicdesigners.com>	<20070819.180540.74750322.davem@davemloft.net>	<8A71B368A89016469F72CD08050AD334018E20C1@maui.asicdesigners.com> <p733aye1n39.fsf@bingen.suse.de>
In-Reply-To: <p733aye1n39.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> TSO is beneficial for the software again. The linux code currently
> takes several locks and does quite a few function calls for each 
> packet and using larger packets lowers this overhead. At least with
> 10GbE saving CPU cycles is still quite important.

Some quick netperf TCP_RR tests between a pair of dual-core rx6600's running 
2.6.23-rc3.  the NICs are dual-core e1000's connected back-to-back with the 
interrupt throttle disabled.  I like using TCP_RR to tickle path-length 
questions because it rarely runs into bandwidth limitations regardless of the 
link-type.

First, with TSO enabled on both sides, then with it disabled, netperf/netserver 
bound to the same CPU as takes interrupts, which is the "best" place to be for a 
TCP_RR test (although not always for a TCP_STREAM test...):

:~# netperf -T 1 -t TCP_RR -H 192.168.2.105 -I 99,1 -c -C
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.2.105 
(192.168.2.105) port 0 AF_INET : +/-0.5% @ 99% conf.  : first burst 0 : cpu bind
!!! WARNING
!!! Desired confidence was not achieved within the specified iterations.
!!! This implies that there was variability in the test environment that
!!! must be investigated before going further.
!!! Confidence intervals: Throughput      :  0.3%
!!!                       Local CPU util  : 39.3%
!!!                       Remote CPU util : 40.6%

Local /Remote
Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
Send   Recv   Size    Size   Time    Rate     local  remote local   remote
bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr

16384  87380  1       1      10.01   18611.32  20.96  22.35  22.522  24.017
16384  87380
:~# ethtool -K eth2 tso off
e1000: eth2: e1000_set_tso: TSO is Disabled
:~# netperf -T 1 -t TCP_RR -H 192.168.2.105 -I 99,1 -c -C
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.2.105 
(192.168.2.105) port 0 AF_INET : +/-0.5% @ 99% conf.  : first burst 0 : cpu bind
!!! WARNING
!!! Desired confidence was not achieved within the specified iterations.
!!! This implies that there was variability in the test environment that
!!! must be investigated before going further.
!!! Confidence intervals: Throughput      :  0.4%
!!!                       Local CPU util  : 21.0%
!!!                       Remote CPU util : 25.2%

Local /Remote
Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
Send   Recv   Size    Size   Time    Rate     local  remote local   remote
bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr

16384  87380  1       1      10.01   19812.51  17.81  17.19  17.983  17.358
16384  87380

While the confidence intervals for CPU util weren't hit, I suspect the 
differences in service demand were still real.  On throughput we are talking 
about +/- 0.2%, for CPU util we are talking about +/- 20% (percent not 
percentage points) in the first test and 12.5% in the second.

So, in broad handwaving terms, TSO increased the per-transaction service demand 
by something along the lines of (23.27 - 17.67)/17.67 or ~30% and the 
transaction rate decreased by ~6%.

rick jones
bitrate blindless is a constant concern
