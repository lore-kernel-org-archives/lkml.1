Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZEEFXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZEEFXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 01:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZEEFW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 01:22:59 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:60683 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZEEFW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 01:22:58 -0400
Message-ID: <49FFCD08.7050600@cosmosbay.com>
Date: Tue, 05 May 2009 07:22:16 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Matthias Saou 
	<thias@spam.spam.spam.spam.spam.spam.spam.egg.and.spam.freshrpms.net>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Wrong network usage reported by /proc
References: <20090504171408.3e13822c@python3.es.egwn.lan> <49FF2BB2.4030700@cosmosbay.com> <20090504211151.74622f29@python3.es.egwn.lan> <20090505050435.GK570@1wt.eu>
In-Reply-To: <20090505050435.GK570@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 05 May 2009 07:22:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau a écrit :
> On Mon, May 04, 2009 at 09:11:51PM +0200, Matthias Saou wrote:
>> Eric Dumazet wrote :
>>
>>> Matthias Saou a écrit :
>>>> Hi,
>>>>
>>>> I'm posting here as a last resort. I've got lots of heavily used RHEL5
>>>> servers (2.6.18 based) that are reporting all sorts of impossible
>>>> network usage values through /proc, leading to unrealistic snmp/cacti
>>>> graphs where the outgoing bandwidth used it higher than the physical
>>>> interface's maximum speed.
>>>>
>>>> For some details and a test script which compares values from /proc
>>>> with values from tcpdump :
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=489541
>>>>
>>>> The values collected using tcpdump always seem realistic and match the
>>>> values seen on the remote network equipments. So my obvious conclusion
>>>> (but possibly wrong given my limited knowledge) is that something is
>>>> wrong in the kernel, since it's the one exposing the /proc interface.
>>>>
>>>> I've reproduced what seems to be the same problem on recent kernels,
>>>> including the 2.6.27.21-170.2.56.fc10.x86_64 I'm running right now. The
>>>> simple python script available here allows to see it quite easily :
>>>> https://www.redhat.com/archives/rhelv5-list/2009-February/msg00166.html
>>>>
>>>>  * I run the script on my Workstation, I have an FTP server enabled
>>>>  * I download a DVD ISO from a remote workstation : The values match
>>>>  * I start ping floods from remote workstations : The values reported
>>>>    by /proc are much higher than the ones reported by tcpdump. I used
>>>>    "ping -s 500 -f myworkstation" from two remote workstations
>>>>
>>>> If there's anything flawed in my debugging, I'd love to have someone
>>>> point it out to me. TIA to anyone willing to have a look.
>>>>
>>>> Matthias
>>>>
>>> I could not reproduce this here... what kind of NIC are you using on
>>> affected systems ? Some ethernet drivers report stats from card itself,
>>> and I remember seeing some strange stats on some hardware, but I cannot
>>> remember which one it was (we were reading NULL values instead of
>>> real ones, once in a while, maybe it was a firmware issue...)
>> My workstation has a Broadcom BCM5752 (tg3 module). The servers which
>> are most affected have Intel 82571EB (e1000e). But the issue is that
>> with /proc, the values are a lot _higher_ than with tcpdump, and the
>> tcpdump values seem to be the correct ones.
> 
> the e1000 chip reports stats every 2 seconds. So you have to collect
> stats every 2 seconds otherwise you get "camel-looking" stats.
> 

I looked at e1000e driver, and apparently tx_packets & tx_bytes are computed
by the TX completion routine, not by the chip.

static bool e1000_clean_tx_irq(struct e1000_adapter *adapter)
{
...

                        if (cleaned) {
                                struct sk_buff *skb = buffer_info->skb;
                                unsigned int segs, bytecount;
                                segs = skb_shinfo(skb)->gso_segs ?: 1;
                                /* multiply data chunks by size of headers */
                                bytecount = ((segs - 1) * skb_headlen(skb)) +
                                            skb->len;
// maybe bytecount is wrong on some skbs ?
                                total_tx_packets += segs;
                                total_tx_bytes += bytecount;
                        }

...
    adapter->net_stats.tx_bytes += total_tx_bytes;
    adapter->net_stats.tx_packets += total_tx_packets;
...
}

and driver get_stats() does return this adapter->net_stats structure to caller

static struct net_device_stats *e1000_get_stats(struct net_device *netdev) 
{
	struct e1000_adapter *adapter = netdev_priv(netdev);

	/* only return the current stats */
	return &adapter->net_stats;
}

Could be converted to use netdev->stats... Oh well...

