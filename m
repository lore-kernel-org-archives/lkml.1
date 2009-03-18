Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZCRWUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZCRWUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZCRWTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:19:55 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:48662 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZCRWTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:19:54 -0400
Message-ID: <49C17383.2090909@hp.com>
Date: Wed, 18 Mar 2009 15:19:47 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Vernon Mauery <vernux@us.ibm.com>, Eilon Greenstein <eilong@broadcom.com>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
References: <49C12E64.1000301@us.ibm.com> <87prge1rhu.fsf@basil.nowhere.org>	<49C16294.8050101@us.ibm.com>	<1237412732.29116.2.camel@lb-tlvb-eliezer>	<49C16CD4.3010708@us.ibm.com> <20090318215901.GV11935@one.firstfloor.org>
In-Reply-To: <20090318215901.GV11935@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>Thanks.  I will test to see how this affects this lock contention the
>>next time the broadcom hardware is available.
> 
> 
> The other strategy to reduce lock contention here is to use TSO/GSO/USO.
> With that the lock has to be taken less often because there are less packets
> travelling down the stack. I'm not sure how well that works with netperf style 
> workloads though. 

All depends on what the user provides with the test-specific -m option for how 
much data they shove into the socket each time "send" is called, and I suppose if 
they use a test-specific -D option to set TCP_NODELAY in the case of a TCP test 
when they have small values of -m.  Eg

netperf -t TCP_STREAM ... -- -m 64K
vs
netperf -t TCP_STREAM ... -- -m 1024
vs
netperf -t TCP_STREAM ... -- -m 1024 -D
vs
netperf -t UDP_STREAM ... -- -m 1024

etc etc.

If the netperf test is:

netperf -t TCP_RR ... -- -r 1   (single-byte request/response)

then TSO/GSO/USO won't matter at all, and probably still wont matter even if the 
user has ./configure'd netperf with --enable-burst and does:

netperf -t TCP_RR ... -- -r 1 -b 64
or
netperf -t TCP_RR ... -- -r 1 -b 64 -D

which was basically what I was doing for the 32-core scaling stuff I posted about 
a few weeks ago.  That was running on multi-queue NICs, so looking at some of the 
profiles of the "no iptables" data may help show how big/small the problem is, 
keeping in mind that my runs (either the XFrame II runs, or the Chelsio T3C runs 
before them) had one queue per core in the system...and as such may be a best 
case scenario as far as lock contention on a per-queue basis goes.

ftp://ftp.netperf.org/

happy benchmarking,

rick jones

BTW, that setup went "poof" and had to go to other nefarious porpoises.  I'm not 
sure when I can recreate it, but I still have both the XFrame and T3C NICs when 
the HW comes free again.
