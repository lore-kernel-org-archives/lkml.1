Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYFXEeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYFXEeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYFXEeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:34:14 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46330 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750836AbYFXEeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:34:12 -0400
Message-ID: <48607931.20908@linux.vnet.ibm.com>
Date: Tue, 24 Jun 2008 10:03:53 +0530
From: Varun Chandramohan <varunc@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, jbarnes@virtuousgeek.org,
       greg@kroah.com, netdev@vger.kernel.org
Subject: Re: Strange problem with e1000 driver - ping packet loss
References: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no> <485A9678.5000707@shaw.ca>
In-Reply-To: <485A9678.5000707@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing netdev

Robert Hancock wrote:
> Srivatsa Vaddagiri wrote:
>> Hi,
>>     I happened to look at a system which was exhibiting poor ping
>> performance with e1000 driver (in 2.6.25) and had some questions 
>> regarding that.
>>
>> Ping test was done between the system and a laptop, which were connected
>> using a straight ethernet cable. Ping reported round trip times running
>> into seconds (!) and also packet loss.
>>
>> Upon some investigation, I found that the interrupt count field in
>> /proc/interrupts (associated with eth1) is not incrementing as fast as
>> it should. Moreover eth1 interrupt line is shared with the hard disk
>> interrupt (ata_piix) as below:
>>
>> # cat /proc/interrupts
>>
>> .
>>
>>  10:       2296    XT-PIC-XT        ata_piix, eth0, eth1
>>
>> .
>>
>> IRQ10 is thus being shared by both the hard disk and eth0/eth1.
>>
>> Here's the strange observation I made:
>>
>> When I initiate some disk activity (ex: dd if=/dev/zero 
>> of=/tmp/file), ping performance suddently shot up (round trip time in 
>> double digits ms, 0% packet loss)! I presume this is because that 
>> e1000 intr handler is called
>> whenever there was a interrupt from hard disk on IRQ10, which polled
>> NIC and processed packets immediately.
>>
>> As soon as I kill the background disk-write intensive job, ping
>> performance again dropped.
>>
>> This meant that e1000 NIC is having trouble interrupting the OS.
>>
>> Before I could jump up and say this is a hardware issue, I was told
>> that Windows works just fine on the server (and as well as 2.4 kernel,
>> which I couldnt verify) :(
>>
>>
>> Some more observations:
>>
>> 1. I tried setting e1000 parameters (RxIntDelay=0, RxAbsIntDelay=0,
>>    TxIntDelay=0, TxAbsIntDelay=0, InterruptThrottleRate=0). None of
>>    them helped.
>>
>> 2. When ping performance was poor, readprofile showed that system
>>    is mostly idle. This confirms that OS is not getting very
>>    frequenty interrupts from eth1 and hence idling.
>>
>> 3. When ping performance was poor, ethtool -S eth1 showed that
>>    rx_bytes was incrementing at a good pace, showing that the    NIC 
>> was receiving ping responses back, but not handing them over
>>    to OS for further processing
>>
>> 4. e1000 chipset is 82546GB
>>
>> 5. e1000e driver didnt work at all (it doesnt recognize the cards).
>>
>>
>> Any advice on how to fix this problem?
>
> Can you post your dmesg output from bootup with no special options 
> (noacpi, etc.) enabled?
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

