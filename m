Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYFSR2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYFSR2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYFSR2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:28:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15071 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYFSR2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:28:12 -0400
Date: Thu, 19 Jun 2008 11:25:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Strange problem with e1000 driver - ping packet loss
In-reply-to: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no>
To: vatsa@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       varunc@linux.vnet.ibm.com, jbarnes@virtuousgeek.org, greg@kroah.com
Message-id: <485A9678.5000707@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QBOn2aWyqGnBJJticG4h09lpxD0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> Hi,
> 	I happened to look at a system which was exhibiting poor ping
> performance with e1000 driver (in 2.6.25) and had some questions regarding that.
> 
> Ping test was done between the system and a laptop, which were connected
> using a straight ethernet cable. Ping reported round trip times running
> into seconds (!) and also packet loss.
> 
> Upon some investigation, I found that the interrupt count field in
> /proc/interrupts (associated with eth1) is not incrementing as fast as
> it should. Moreover eth1 interrupt line is shared with the hard disk
> interrupt (ata_piix) as below:
> 
> # cat /proc/interrupts
> 
> .
> 
>  10:       2296    XT-PIC-XT        ata_piix, eth0, eth1
> 
> .
> 
> IRQ10 is thus being shared by both the hard disk and eth0/eth1.
> 
> Here's the strange observation I made:
> 
> When I initiate some disk activity (ex: dd if=/dev/zero of=/tmp/file), ping 
> performance suddently shot up (round trip time in double digits ms, 0% packet 
> loss)! I presume this is because that e1000 intr handler is called
> whenever there was a interrupt from hard disk on IRQ10, which polled
> NIC and processed packets immediately.
> 
> As soon as I kill the background disk-write intensive job, ping
> performance again dropped.
> 
> This meant that e1000 NIC is having trouble interrupting the OS.
> 
> Before I could jump up and say this is a hardware issue, I was told
> that Windows works just fine on the server (and as well as 2.4 kernel,
> which I couldnt verify) :(
> 
> 
> Some more observations:
> 
> 1. I tried setting e1000 parameters (RxIntDelay=0, RxAbsIntDelay=0,
>    TxIntDelay=0, TxAbsIntDelay=0, InterruptThrottleRate=0). None of
>    them helped.
> 
> 2. When ping performance was poor, readprofile showed that system
>    is mostly idle. This confirms that OS is not getting very
>    frequenty interrupts from eth1 and hence idling.
> 
> 3. When ping performance was poor, ethtool -S eth1 showed that
>    rx_bytes was incrementing at a good pace, showing that the 
>    NIC was receiving ping responses back, but not handing them over
>    to OS for further processing
> 
> 4. e1000 chipset is 82546GB
> 
> 5. e1000e driver didnt work at all (it doesnt recognize the cards).
> 
> 
> Any advice on how to fix this problem?

Can you post your dmesg output from bootup with no special options 
(noacpi, etc.) enabled?
