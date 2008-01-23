Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbYAWQtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbYAWQtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYAWQsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:48:54 -0500
Received: from as2.cineca.com ([130.186.84.242]:35681 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbYAWQsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:48:53 -0500
Message-ID: <47976FE9.5030600@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrea Righi <righiandr@users.sourceforge.net>,
       Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [RFC] [PATCH] cgroup: limit network bandwidth
References: <47970448.7010609@users.sourceforge.net> <20080123092417.GA4542@balbir.in.ibm.com>
In-Reply-To: <20080123092417.GA4542@balbir.in.ibm.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Jan 2008 17:48:41 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Andrea Righi <righiandr@users.sourceforge.net> [2008-01-23 10:09:28]:
> 
>> Allow to limit the network bandwidth for specific process containers (cgroups)
>> imposing additional delays in the sockets' sendmsg()/recvmsg() calls made by
>> those processes that exceed the limits defined in the control group filesystem.
>>
>> Example:
>>   # mkdir /dev/cgroup
>>   # mount -t cgroup -onet net /dev/cgroup
>>   # cd /dev/cgroup
>>   # mkdir foo
>>   --> the cgroup foo has been created
>>   # /bin/echo $$ > foo/tasks
>>   # /bin/echo 1024 > foo/net.tcp
>>   # /bin/echo 2048 > foo/net.tot
>>   # sh
>>   --> the subshell 'sh' is running in cgroup "foo" that has a maximum network
>>       bandwidth for TCP traffic of 1MB/s and 2MB/s for total network
>>       activities.
>>
>> The netlimit approach can be easily extended to support additional network
>> protocols or different socket families or types (PF_UNIX, PF_BLUETOOTH,
>> SOCK_SEQPACKET, etc.).
>>
>> Signed-off-by: Andrea Righi <a.righi@cineca.it>
> 
> Hi, Andrea,
> 
> I took a quick look at the patches and it looks like we throttle
> network (by forcing a schedule_timeout()), if we exceed our bandwidth
> limit. That is one way of doing it, but it has some disadvantages, it
> does not scale to 
> 
> 1. Implementation of soft limits (limit on contention of resource)
>    gets harder

Why? do you mean implementing a grace time when the soft-limit is
exceeded? this could be done in cgroup_nl_throttle() introducing 3 
additional attributes to struct netlimit (i.e. hard_limit,
last_time_exceeded grace_time) and perform something like:
...
	if ((current_rate > hard_limit) ||
	    time_after(jiffies, last_time_exceeded + grace_time))
			schedule_timeout(sleep);
...

> 2. Why dont use the existing infrastructure for bandwidth limitation
>    for implementing the network controller?
> 

Yes, the integration with iptables (as Paul said), and traffic shaping
rules would be absolutely the right way(tm) in perspective. I was just
proposing a possible simple API to implement the limiting stuff.

-Andrea
