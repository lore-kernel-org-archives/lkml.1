Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZEEIwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZEEIwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZEEIwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:52:40 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48549 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZEEIwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:52:39 -0400
Message-ID: <49FFFE2D.9080509@cosmosbay.com>
Date: Tue, 05 May 2009 10:51:57 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Matthias Saou 
	<thias@spam.spam.spam.spam.spam.spam.spam.egg.and.spam.freshrpms.net>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Wrong network usage reported by /proc
References: <20090504171408.3e13822c@python3.es.egwn.lan>	<49FF2BB2.4030700@cosmosbay.com>	<20090504211151.74622f29@python3.es.egwn.lan>	<20090505050435.GK570@1wt.eu>	<49FFCD08.7050600@cosmosbay.com>	<20090505055032.GA29582@1wt.eu> <20090505100939.1e0932c4@python3.es.egwn.lan>
In-Reply-To: <20090505100939.1e0932c4@python3.es.egwn.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 05 May 2009 10:51:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Saou a écrit :
> Willy Tarreau wrote :
> 
>> On Tue, May 05, 2009 at 07:22:16AM +0200, Eric Dumazet wrote:
>>> Willy Tarreau a écrit :
>>>> On Mon, May 04, 2009 at 09:11:51PM +0200, Matthias Saou wrote:
>>>>> Eric Dumazet wrote :
>>>>>
>>>>>> Matthias Saou a écrit :
>>>>>>> Hi,
>>>>>>>
>>>>>>> I'm posting here as a last resort. I've got lots of heavily used RHEL5
>>>>>>> servers (2.6.18 based) that are reporting all sorts of impossible
>>>>>>> network usage values through /proc, leading to unrealistic snmp/cacti
>>>>>>> graphs where the outgoing bandwidth used it higher than the physical
>>>>>>> interface's maximum speed.
>>>>>>>
>>>>>>> For some details and a test script which compares values from /proc
>>>>>>> with values from tcpdump :
>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=489541
>>>>>>>
>>>>>>> The values collected using tcpdump always seem realistic and match the
>>>>>>> values seen on the remote network equipments. So my obvious conclusion
>>>>>>> (but possibly wrong given my limited knowledge) is that something is
>>>>>>> wrong in the kernel, since it's the one exposing the /proc interface.
>>>>>>>
>>>>>>> I've reproduced what seems to be the same problem on recent kernels,
>>>>>>> including the 2.6.27.21-170.2.56.fc10.x86_64 I'm running right now. The
>>>>>>> simple python script available here allows to see it quite easily :
>>>>>>> https://www.redhat.com/archives/rhelv5-list/2009-February/msg00166.html
>>>>>>>
>>>>>>>  * I run the script on my Workstation, I have an FTP server enabled
>>>>>>>  * I download a DVD ISO from a remote workstation : The values match
>>>>>>>  * I start ping floods from remote workstations : The values reported
>>>>>>>    by /proc are much higher than the ones reported by tcpdump. I used
>>>>>>>    "ping -s 500 -f myworkstation" from two remote workstations
>>>>>>>
>>>>>>> If there's anything flawed in my debugging, I'd love to have someone
>>>>>>> point it out to me. TIA to anyone willing to have a look.
>>>>>>>
>>>>>>> Matthias
>>>>>>>
>>>>>> I could not reproduce this here... what kind of NIC are you using on
>>>>>> affected systems ? Some ethernet drivers report stats from card itself,
>>>>>> and I remember seeing some strange stats on some hardware, but I cannot
>>>>>> remember which one it was (we were reading NULL values instead of
>>>>>> real ones, once in a while, maybe it was a firmware issue...)
>>>>> My workstation has a Broadcom BCM5752 (tg3 module). The servers which
>>>>> are most affected have Intel 82571EB (e1000e). But the issue is that
>>>>> with /proc, the values are a lot _higher_ than with tcpdump, and the
>>>>> tcpdump values seem to be the correct ones.
>>>> the e1000 chip reports stats every 2 seconds. So you have to collect
>>>> stats every 2 seconds otherwise you get "camel-looking" stats.
>>>>
>>> I looked at e1000e driver, and apparently tx_packets & tx_bytes are computed
>>> by the TX completion routine, not by the chip.
>> Ah I thought that was the chip which returned those stats every 2 seconds,
>> otherwise I don't see the reason to delay their reporting. Wait, I'm speaking
>> about e1000, never tried e1000e. Maybe there have been changes there. Anyway,
>> Matthias talked about RHEL5's 2.6.18 in which I don't think there was e1000e.
>>
>> Anyway we did not get any concrete data for now, so it's hard to tell (I
>> haven't copy-pasted the links above in my browser yet).
> 
> If you need any more data, please just ask. What makes me wonder most,
> though, is that tcpdump and iptraf report what seem to be correct
> bandwidth values (they seem to use the same low level access for their
> counters) whereas snmp and ifconfig (which seem to use /proc for
> theirs) report unrealistically high values.
> 
> The tcpdump vs. /proc would be the first thing to look at, since it
> might give hints as to where the problem might lie, no?
> 
> From there, I could collect any data one might find relevant to
> diagnose further.
> 
> I'm attaching the simple python script I've used for testing.
> 
> Matthias
> 
> 

Your python script is buggy, since space after ':' is optional

# cat /proc/net/dev | cut -c1-80
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packe
    lo:   16056      36    0    0    0     0          0         0    16056
  eth0:624245505 7370445    0    0    0     0          0       108 586782291 737
  eth1:2512329067 11360819    0    0    0     0          0         0 2521050992
 bond0:3378296009 15279963    0    0    0     0          0         0 3390533080
 bond1:       0       0    0    0    0     0          0         0        0
  eth2:865966942 3919144    0    0    0     0          0         0 869482088 391
  eth3:       0       0    0    0    0     0          0         0        0
vlan.103: 1277511   18134    0    0    0     0          0         0  3439082   1
vlan.825:3095633732 15533200    0    0    0     0          0         0 332349968


So your read_proc() is wrong, since is uses line.split

def read_proc(interface):
    f = open('/proc/net/dev')
    for line in f:
        values = line.split()
        i = values[0].split(':')[0]
        if interface == i:
            bytes = int(values[8])
            # received bytes
            # bytes = int(values[0].split(':')[1])
            f.close()
            return bytes
    f.close()


BTW, your tcpdump might report lower values too, since it doesnt account for all headers, nor
non IP frames, or forwarded frames (source IP is then not your host IP)



