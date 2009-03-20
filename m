Return-Path: <linux-kernel-owner+w=401wt.eu-S1760973AbZCTT2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760973AbZCTT2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760008AbZCTT2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:28:36 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:48040 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365AbZCTT2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:28:35 -0400
X-Greylist: delayed 3605 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 15:28:35 EDT
Message-id: <49C3E03E.10506@acm.org>
Date: Fri, 20 Mar 2009 13:28:14 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Martin Wilck <martin.wilck@fujitsu-siemens.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH] limit CPU time spent in kipmid
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org>
 <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org>
 <20090320174701.GA14823@kroah.com>
In-reply-to: <20090320174701.GA14823@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Mar 20, 2009 at 10:30:45AM -0500, Corey Minyard wrote:
>   
>> Greg KH wrote:
>>     
>>> On Thu, Mar 19, 2009 at 04:31:00PM -0500, Corey Minyard wrote:
>>>   
>>>       
>>>> Martin, thanks for the patch.  I had actually implemented something like 
>>>> this before, and it didn't really help very much with the hardware I had, 
>>>> so I had abandoned this method.  There's even a comment about it in 
>>>> si_sm_result smi_event_handler(). Maybe making it tunable is better, I 
>>>> don't know.  But I'm afraid this will kill performance on a lot of 
>>>> systems.
>>>>
>>>> Did you test throughput on this?  The main problem people had without 
>>>> kipmid was that things like firmware upgrades took a *long* time; adding 
>>>> kipmid improved speeds by an order of magnitude or more.
>>>>
>>>> It's my opinion that if you want this interface to work efficiently with 
>>>> good performance, you should design the hardware to be used efficiently 
>>>> by using interrupts (which are supported and disable kipmid).  With the 
>>>> way the hardware is defined, you cannot have both good performance and 
>>>> low CPU usage without interrupts.
>>>>
>>>> It may be possible to add an option to choose between performance and 
>>>> efficiency, but it will have to default to performance.
>>>>     
>>>>         
>>> I would think that very infrequent things, like firmware upgrades, would
>>> not take priority over a long-term "keep the cpu busy" type system, like
>>> what we currently have.
>>>
>>> Is there any way to switch between the different modes dynamically?
>>>   I like the idea of this change, as I have got a lot of complaints lately
>>> about kipmi taking way too much cpu time up on idle systems, messing up
>>> some user's process accounting rules in their management systems.  But I
>>> worry about making it a module parameter, why can't this be a
>>> "self-tunable" thing?
>>>   
>>>       
>> It's actually already sort of self-tuning.  kipmid sleeps unless there is 
>> IPMI activity.  It only spins if it is expecting something from the 
>> controller.
>>
>> I've been thinking about this a little more.  Assuming that the self-tuning 
>> is working (and it appears to be working fine on my systems), that means 
>> that something is causing the IPMI driver to constantly talk to the 
>> management controller.  I can think of three things:
>>
>>   1. The user is constantly sending messages to management controller.
>>   2. There is something wrong with the hardware, like the ATTN bit is
>>      stuck high, causing the driver to constantly poll the management
>>      controller.
>>   3. The driver either has a bug or needs some more work to account for
>>      something the hardware needs it to do to clear the ATTN bit.
>>
>> If it's #1 above, then I don't know if there is anything we can do about 
>> it.  The patch Martin sent will simply slow things down.
>>     
>
> Does the "normal" ipmi userspace tools do #1?
>   
That depends how they are used and configured.  If you make them 
constantly poll for events or grab sensor values, then they will just 
use CPU.  By default they shouldn't do anything.

> For #2, this might make sense, as I have had reports of some hardware
> working just fine, while others have the load issue.  Both were
> different hardware manufacturers.
>
>   
>> #2 and #3 will require someone to do some debugging.  If the ATTN bit is 
>> stuck, you should see the "attentions" field in /proc/ipmi/0/si_stats 
>> constantly going up.  Actually, the contents of that file would be helpful, 
>> along with /proc/ipmi/0/stats.
>>     
>
> Martin has one of these machines, right?  If not, I can dig and try to
> get some information as well.
>   
I'll wait for Martin, hopefully he can get the info.

Thanks,

-corey
