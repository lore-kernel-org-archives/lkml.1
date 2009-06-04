Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZFDStl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZFDStl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZFDStd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:49:33 -0400
Received: from mail.lang.hm ([64.81.33.126]:43342 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZFDStd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:49:33 -0400
Date: Thu, 4 Jun 2009 11:49:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Philipp Reh <sefi@s-e-f-i.de>,
       linux-kernel@vger.kernel.org
Subject: Re: When does Linux drop UDP packets?
In-Reply-To: <4A281600.7040406@cosmosbay.com>
Message-ID: <alpine.DEB.1.10.0906041148210.7953@asgard>
References: <20090604145347.GA27692@miyuki> <20090604155741.GA8999@goodmis.org> <alpine.DEB.1.10.0906041050290.7953@asgard> <4A281600.7040406@cosmosbay.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009, Eric Dumazet wrote:

> david@lang.hm a ?crit :
>> On Thu, 4 Jun 2009, Steven Rostedt wrote:
>>
>>> On Thu, Jun 04, 2009 at 04:53:47PM +0200, Philipp Reh wrote:
>>>> Dear list,
>>>>
>>>> I have the following setting in which a client that resides on the same
>>>> physical network as a server wants to receive any UDP packet that
>>>> arrives on any of its interfaces sent by that server.
>>>>
>>>> The code sets the broadcast flag, calls bind to INADDR_ANY and
>>>> uses recvfrom from there on.
>>>>
>>>> Let's say the server resides in the subnet 192.168.6.255 and the
>>>> client in 192.168.3.255. The server uses its real IP as the packet's
>>>> sender ip (192.168.6.5).
>>>
>>> You don't say what the client IP is. Let's assume that it is 192.168.3.1
>>> for simplicity.
>>>
>>>>
>>>> Now the first problem I've encountered is the following:
>>>> If the client removes its default route and doesn't have any route
>>>> pointing into the subnet the server is in, the packets get discarded
>>>> (still tcpdump sees them).
>>>>
>>>
>>> Are you saying that the server sent to 192.168.3.1 with source ip of
>>> 192.168.6.5 and the client did not see it?
>>>
>>>> The second problem is that if the server uses the broadcast address as
>>>> its sender address (255.255.255.255), the packets get always discarded
>>>> (again, tcpdump sees them).
>>>
>>> Again, what was the destination IP address?
>>>
>>>> Now if the server fakes its sender address to be in the client's subnet,
>>>> every packet arrives again.
>>>
>>> So the only thing you change is the sender address?
>>>
>>> What tools are you using to read the packets, and how do you know it is
>>> dropped?
>>
>>
>> I have seen the same thing. I have syslog servers on one subnet without
>> a default route. If I configure a server on another subnet to send it
>> logs I can see the packets with tcpdump, but syslogd will not record them.
>>
>> If I configure a route on the recieving box that makes it think that it
>> can get to the sender (note that the route can be completely bogus,
>> pointing at a wrong or non-existing gateway) the kernel is happy and the
>> packets show up to syslogd
>>
>> the systems I am running do _not_ have selinux on them.
>>
>> I have seen this as far back as 2.6.12 so it's not a recent change.
>>
>> if you need examples with IP addresses
>>
>> box 1
>> IP 10.1.1.2
>>
>> router
>> IP 10.1.1.1
>> IP 192.168.1.1
>>
>> box 2
>> IP 192.168.1.2
>>
>> If I configure box 2 to have a route to box1, but do not configure box 1
>> to have any route (including not having a default route) that would get
>> it to a 192.168.1.x subnet tcpdump on box 1 will show the syslog
>> packets, but syslog (and any non-pcap tool) will not see the packets)
>>
>> if I configure a route on box 1 to have a default route of 10.1.1.3
>> (which does not exist, so cannot possibly route packets anywhere) then
>> everything works.
>
> I guess you need to change rp_filter settings
>
> Documentation/networking/ip-sysctl.txt
>
> rp_filter - INTEGER
>
>        0 - No source validation.
>        1 - Strict mode as defined in RFC3704 Strict Reverse Path
>            Each incoming packet is tested against the FIB and if the interface
>            is not the best reverse path the packet check will fail.
>            By default failed packets are discarded.
>        2 - Loose mode as defined in RFC3704 Loose Reverse Path
>            Each incoming packet's source address is also tested against the FIB
>            and if the source address is not reachable via any interface
>            the packet check will fail.
>
>        Current recommended practice in RFC3704 is to enable strict mode
>        to prevent IP spoofing from DDos attacks. If using asymmetric routing
>        or other complicated routing, then loose mode is recommended.
>
>        conf/all/rp_filter must also be set to non-zero to do source validation
>        on the interface
>
>        Default value is 0. Note that some distributions enable it
>        in startup scripts.

thanks, On my Debian based systems I have commented this out of the 
sysctl.conf file, but apparently there is some other script that is 
setting it anyway. I'll have to track down what it's doing.

David Lang

>
>>
>>>> So my real question is:
>>>> When does Linux discard packets and how can I prevent it from doing
>>>> that?
>>
>> for this problem, set a default route that points at a non-existing
>> gateway and I believe that your problem will go away.
>
>
>
