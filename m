Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZH0VdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZH0VdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 17:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZH0VdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 17:33:10 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40520 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbZH0VdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 17:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=a0kL3xq5gShKyE8BqfH8jUVpBc9LMPQMjYxdfKkBKSmTz+QHizn8ZO7kqjKjz126VZ
         yI8UfVrGk9Hqh53j89SfwCMNtbgqKn70+/rzi1q9QMi7vSHV0bd/bl1acpC4bzH1Xkal
         YngPMMb/AtVHPcfEnOIDOkJyCmCILAcSoPvP4=
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: raz ben yehuda <raziebe@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <4A96B997.1070001@nortel.com>
References: <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop>	<1251298443.4791.7.camel@raz>
	 <1251300625.18584.18.camel@twins>
	 <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
	 <1251302598.18584.31.camel@twins>
	 <alpine.DEB.1.10.0908261211340.9933@gentwo.org>
	 <20090826180407.GA13632@elte.hu>
	 <alpine.DEB.1.10.0908261509580.9933@gentwo.org>
	 <20090826193252.GA14721@elte.hu>
	 <alpine.DEB.1.10.0908261627110.5554@gentwo.org>
	 <20090826135041.e6169d18.akpm@linux-foundation.org>
	 <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz>
	 <4A96B997.1070001@nortel.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 00:33:05 +0300
Message-Id: <1251408785.3700.22.camel@raz>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-08-27 at 10:51 -0600, Chris Friesen wrote:
> On 08/26/2009 03:37 PM, raz ben yehuda wrote:
> > 
> > On Wed, 2009-08-26 at 15:15 -0600, Chris Friesen wrote:
> 
> >> We gave it as close to a whole cpu as we could using cpu and irq
> >> affinity and we used message queues in shared memory to allow another
> >> cpu to handle I/O.  In our case we still had kernel threads running on
> >> the app cpu, but if we'd had a straightforward way to avoid them we
> >> would have used it.
> 
> > Chris. I offer myself to help anyone wishes to apply OFFSCHED.
> 
> I just went and read the docs.  One of the things I noticed is that it
> says that the offlined cpu cannot run userspace tasks.  For our
> situation that's a showstopper, unfortunately.
Given that your entire software is T size , and T' is the amount of real
time size, what is the relation T'/T ?
If T'/T << 1 then dissect it, and put the T' in OFFSCHED. 
My software T's is about 100MB while the real time section is about 60K.
They communicate through a simple ioctls.  

              CPU isolation example: a transmission engine.

In the image bellow, I am presenting 4 streaming engines, over 4 Intels
82598EB 10Gbps. A streaming engine is actually a Xeon E5420 2.5GHz.
Each engine has ***full control*** over its own interface. So you can:

1. fully control the processor's usage.

2. know **exactly*** how much each single packet transmission costs. for
example, in this case in processor 3 a single packet average
transmission is 1974tscs, which is ~700ns.

3. know how many packets fails to transmit right **on time** ( the Lates
counter) . and on time in this case means within the 122us jitter. 

4. There are 8 cores in this machine. The rest 4 OS cores are ~95% idle.
The only resource these cores share is the bus. 



State: kstreamer UP. Started at October 05 05:19:51
******************************************************
CPU 3,63% usage,Sessions 1499,6124301 kbps 
CPU 5,77% usage,Sessions 1499,6123859 kbps 
CPU 6,78% usage,Sessions 1498,6123709 kbps 
CPU 7,73% usage,Sessions 1498,6117766 kbps 
Summary: Throughput=24.489Gbps Sessions =5994
******************************************************

Streaming Processor 3
Tx Count       : Tot=399990164  Good=399990164 Bad=0 ERR=0(LOC=0,FULL=0)
Time 	       : GoodSendTsc( Max 1565895 Avg 1974) Lates=649
Flow Errors    : Underflow (0,0) NotResched=0 GenErr=0
Sessions       : Cur 1499(RTP=1499,UDP=0,MCAST=0,ENCRYPT=0) PAUSED=0 
CPU            : 63% usage
Queue          : Max Size 92 Avg 69 Csc=79
Throughput (bps) : Tot  6271285040 MPEG 5988905440
Throughput (Mbps): Tot Mbps 6271 MPEG Mbps 5988
Throughput       : Packets/sec 568855 

Streaming Processor 5
Tx Count       : Tot=399944597  Good=399944595 Bad=2 ERR=2(LOC=0,FULL=2)
Time 	       : GoodSendTsc( Max 1566052 Avg 2464) Lates=5521
Flow Errors    : Underflow (0,0) NotResched=0 GenErr=0
Sessions       : Cur 1499(RTP=1499,UDP=0,MCAST=0,ENCRYPT=0) PAUSED=0 
CPU            : 77% usage
Queue          : Max Size 95 Avg 69 Csc=79
Throughput (bps) : Tot  6270832416 MPEG 5988473792
Throughput (Mbps): Tot Mbps 6270 MPEG Mbps 5988
Throughput       : Packets/sec 568814 

Streaming Processor 6
Tx Count       : Tot=399898586  Good=399898585 Bad=0 ERR=0(LOC=0,FULL=0)
Time 	       : GoodSendTsc( Max 1661385 Avg 2474) Lates=8064
Flow Errors    : Underflow (0,0) NotResched=0 GenErr=0
Sessions       : Cur 1498(RTP=1498,UDP=0,MCAST=0,ENCRYPT=0) PAUSED=0 
CPU            : 78% usage
Queue          : Max Size 91 Avg 69 Csc=87
Throughput (bps) : Tot  6270678560 MPEG 5988326400
Throughput (Mbps): Tot Mbps 6270 MPEG Mbps 5988
Throughput       : Packets/sec 568800 

Streaming Processor 7
Tx Count       : Tot=399845166 Good=399845100 Bad=66
ERR=66(LOC=0,FULL=66)
Time 	       : GoodSendTsc( Max 2962620 Avg 2377) Lates=42626
Flow Errors    : Underflow (0,0) NotResched=0 GenErr=0
Sessions       : Cur 1498(RTP=1498,UDP=0,MCAST=0,ENCRYPT=0) PAUSED=0 
CPU            : 73% usage
Queue          : Max Size 94 Avg 69 Csc=66
Throughput (bps) : Tot  6264592672 MPEG 5982514944
Throughput (Mbps): Tot Mbps 6264 MPEG Mbps 5982
Throughput       : Packets/sec 568248 
--------------- Reservation Load Balancer ------------------
eth2 : 5994501 kbps
eth3 : 5994501 kbps
eth4 : 5990502 kbps
eth5 : 5990502 kbps














 

> Chris
> 

