Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbYAUX0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbYAUX0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbYAUXZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:25:54 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:51304 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbYAUXZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:25:53 -0500
Message-ID: <479529DF.5030707@nortel.com>
Date: Mon, 21 Jan 2008 17:25:19 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <4794F848.9020402@nortel.com> <47950F1D.4010508@cosmosbay.com>
In-Reply-To: <47950F1D.4010508@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Jan 2008 23:25:23.0177 (UTC) FILETIME=[E5417590:01C85C84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Chris Friesen a écrit :
> 
>> I've done some further digging, and it appears that one of the 
>> problems we may be facing is very high instantaneous traffic rates.
>>
>> Instrumentation showed up to 222K packets/sec for short periods (at 
>> least 1.1 ms, possibly longer), although the long-term average is down 
>> around 14-16K packets/sec.
> 
> 
> Instrumentation done where exactly ?

I added some code to e1000_clean_rx_irq() to track rx_fifo drops, total 
packets received, and an accurate timestamp.

If rx_fifo errors changed, it would dump the information.

>> Is there anything else we can do to minimize the latency of network 
>> packet processing and avoid having to crank the rx ring size up so high?

> You have some tasks that disable softirqs too long. Sometimes, bumping 
> RX ring size is OK (but you will still have delays), sometimes it is not 
> an option, since 4096 is the limit on current hardware.

I added some instrumentation to take timestamps in __do_softirq() as 
well.  Based on these timestamps, I can see the following code sequence:

2374604616 usec, start processing softirqs in __do_softirq()
2374610337 usec, log values in e1000_clean_rx_irq()
2374611411 usec, log values in e1000_clean_rx_irq()

In between the successive calls to e1000_clean_rx_irq() the rx_fifo 
counts went up.

Does anyone have any patchsets to track down what softirqs are taking a 
long time, and/or who's disabling softirqs?

Chris
