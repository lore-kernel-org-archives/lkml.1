Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYAVFwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYAVFwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 00:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYAVFwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 00:52:38 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:51291
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbYAVFwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 00:52:36 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 00:52:36 EST
Message-ID: <47958345.7070807@cosmosbay.com>
Date: Tue, 22 Jan 2008 06:46:45 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <4794F848.9020402@nortel.com> <47950F1D.4010508@cosmosbay.com> <479529DF.5030707@nortel.com>
In-Reply-To: <479529DF.5030707@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :
> Eric Dumazet wrote:
>> Chris Friesen a écrit :
>>
>>> I've done some further digging, and it appears that one of the 
>>> problems we may be facing is very high instantaneous traffic rates.
>>>
>>> Instrumentation showed up to 222K packets/sec for short periods (at 
>>> least 1.1 ms, possibly longer), although the long-term average is 
>>> down around 14-16K packets/sec.
>>
>>
>> Instrumentation done where exactly ?
> 
> I added some code to e1000_clean_rx_irq() to track rx_fifo drops, total 
> packets received, and an accurate timestamp.
> 
> If rx_fifo errors changed, it would dump the information.
> 
>>> Is there anything else we can do to minimize the latency of network 
>>> packet processing and avoid having to crank the rx ring size up so high?
> 
>> You have some tasks that disable softirqs too long. Sometimes, bumping 
>> RX ring size is OK (but you will still have delays), sometimes it is 
>> not an option, since 4096 is the limit on current hardware.
> 
> I added some instrumentation to take timestamps in __do_softirq() as 
> well.  Based on these timestamps, I can see the following code sequence:
> 
> 2374604616 usec, start processing softirqs in __do_softirq()
> 2374610337 usec, log values in e1000_clean_rx_irq()
> 2374611411 usec, log values in e1000_clean_rx_irq()
> 
> In between the successive calls to e1000_clean_rx_irq() the rx_fifo 
> counts went up.
> 
> Does anyone have any patchsets to track down what softirqs are taking a 
> long time, and/or who's disabling softirqs?
> 

Not for linux-2.6.10 unfortunatly.

Check net/ipv4/route.c, where many improvements can be done, especially if you 
have a large rt cache

grep . /proc/sys/net/ipv4/route/*

