Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbZCYRnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbZCYRnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761560AbZCYRnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:43:00 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:46428 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759849AbZCYRm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:42:59 -0400
Message-ID: <49CA6D09.1020401@krogh.cc>
Date: Wed, 25 Mar 2009 18:42:33 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: David Rees <drees76@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>	 <49C87B87.4020108@krogh.cc>	 <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>	 <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
In-Reply-To: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rees wrote:
> On Tue, Mar 24, 2009 at 12:32 AM, Jesper Krogh <jesper@krogh.cc> wrote:
>> David Rees wrote:
>> The 480 secondes is not the "wait time" but the time gone before the
>> message is printed. It the kernel-default it was earlier 120 seconds but
>> thats changed by Ingo Molnar back in september. I do get a lot of less
>> noise but it really doesn't tell anything about the nature of the problem.
>>
>> The systes spec:
>> 32GB of memory. The disks are a Nexsan SataBeast with 42 SATA drives in
>> Raid10 connected using 4Gbit fibre-channel. I'll let it up to you to decide
>> if thats fast or slow?
> 
> The drives should be fast enough to saturate 4Gbit FC in streaming
> writes.  How fast is the array in practice?

Thats allways a good question.. This is by far not being the only user
of the array at the time of testing.. (there are 4 FC-channel connected 
to a switch). Creating a fresh slice.. and just dd'ing onto it from 
/dev/zero gives:
jk@hest:~$ sudo dd if=/dev/zero of=/dev/sdh bs=1M count=10000
10000+0 records in
10000+0 records out
10485760000 bytes (10 GB) copied, 78.0557 s, 134 MB/s
jk@hest:~$ sudo dd if=/dev/zero of=/dev/sdh bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB) copied, 8.11019 s, 129 MB/s

Watching using dstat while dd'ing it peaks at 220M/s

If I watch numbers on "dstat" output in production. It gets at peak
around the same(130MB/s) but average is in the 90-100 MB/s range.

It has 2GB of battery backed cache. I'm fairly sure that when it was new 
(and I only had connected one host) I could get it up at around 350MB/s.

>> The strange thing is actually that the above process (updatedb.mlocate) is
>> writing to / which is a device without any activity at all. All activity is
>> on the Fibre Channel device above, but process writing outsid that seems to
>> be effected as well.
> 
> Ah.  Sounds like your setup would benefit immensely from the per-bdi
> patches from Jens Axobe.  I'm sure he would appreciate some feedback
> from users like you on them.
> 
>>> What's your vm.dirty_background_ratio and
>>>
>>> vm.dirty_ratio set to?
>> 2.6.29-rc8 defaults:
>> jk@hest:/proc/sys/vm$ cat dirty_background_ratio
>> 5
>> jk@hest:/proc/sys/vm$ cat dirty_ratio
>> 10
> 
> On a 32GB system that's 1.6GB of dirty data, but your array should be
> able to write that out fairly quickly (in a couple seconds) as long as
> it's not too random.  If it's spread all over the disk, write
> throughput will drop significantly - how fast is data being written to
> disk when your system suffers from large write latency?

Thats another thing. I havent been debugging while hitting it (yet) but 
if I go ind and do a sync on the system manually. Then it doesn't get 
above 50MB/s in writeout (measured using dstat). But even that doesn't 
sum up to 8 minutes .. 1.6GB at 50MB/s ..=> 32 s.

-- 
Jesper

