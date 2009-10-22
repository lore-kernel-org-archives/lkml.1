Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZJVQqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZJVQqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZJVQqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:46:06 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:49089 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZJVQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:46:05 -0400
Message-id: <4AE08C42.9020305@acm.org>
Date: Thu, 22 Oct 2009 11:45:54 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: ipmi: use round_jiffies	on timers to reduce timer overhead/wakeups
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
 <20091021114210.4d7e1ea9@linux.intel.com>	<4ADF57D7.7010808@intel.com>
 <20091021130348.cd521b0c.randy.dunlap@oracle.com>	<4ADF6D76.7070409@acm.org>
 <4ADF75A2.50202@linux.intel.com>
 <20091022025013.GB20467@auslistsprd01.us.dell.com>
In-reply-to: <20091022025013.GB20467@auslistsprd01.us.dell.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
> On Thu, Oct 22, 2009 at 05:57:06AM +0900, Arjan van de Ven wrote:
>   
>> Corey Minyard wrote:
>>     
>>> Certainly.  Yes, some (probably most) IPMI hardware does not use
>>> interrupts, and unfortunately, it's not just older machines.  The driver
>>> used to poll more slowly, but in many cases the performance was
>>> unacceptable.
>>>       
>> ... but now it burns quite a bit of power (I'd not be surprised if it is 10 
>> Watts extra on a 70W server)
>>
>> is there any way to poll slowly until there is active ipmi traffic, during 
>> which we can then poll a bit faster.
>> ... and then go back to slow polling when there is an ipmi idle period ?
>>     
>
> I believe that's what the thread does already.  Depending on what
> userspace apps are generating IPMI requests though, there may not be a
> whole lot of time between requests.  Dell OpenManage software does a
> poll of the IPMI sensors, SEL logs, etc. at regular intervals, on the
> order of minutes between runs, but during each run there's almost
> always an outstanding IPMI command.
>   
In addition to userland work, the upper layer of the driver polls for 
events once a second.  This is another unfortunate IPMI design flaw.  
There is a flag (that will thus cause an interrupt) that tells you if 
the event queue is full, but it doesn't tell you if there is an event in 
the queue, only if its full.  So you have to poll for events.

-corey
