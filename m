Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZKBPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZKBPmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZKBPl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:41:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbZKBPl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:41:58 -0500
Message-ID: <4AEEFDA8.2060002@redhat.com>
Date: Mon, 02 Nov 2009 17:41:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, Glauber Costa <glommer@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       Ingo Molnar <mingo@redhat.com>, chris.mason@oracle.com
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <861f0a3e-8d6f-473e-a67d-80e46343fedd@default>
In-Reply-To: <861f0a3e-8d6f-473e-a67d-80e46343fedd@default>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 05:28 PM, Dan Magenheimer wrote:
>> From: Avi Kivity [mailto:avi@redhat.com]
>>
>> On 10/29/2009 06:15 PM, Dan Magenheimer wrote:
>>      
>>> On a related note, though some topic drift, many of
>>> the problems that occur in virtualization due to migration
>>> could be better addressed if Linux had an architected
>>> interface to allow it to be signaled if a migration
>>> occurred, and if Linux could signal applications of
>>> the same.  I don't have any cycles (pun intended) to
>>> think about this right now, but if anyone else starts
>>> looking at it, I'd love to be cc'ed.
>>>        
>> IMO that's not a good direction.  The hypervisor should not depend on
>> the guest for migration (the guest may be broken, or
>> malicious, or being
>> debugged, or slow).  So the notification must be asynchronous, which
>> means that it will only be delivered to applications after
>> migration has
>> completed.
>>      
> I definitely agree that the hypervisor can't wait for a guest
> to respond.
>
> You've likely thought through this a lot more than I have,
> but I was thinking that if the kernel received the notification
> as some form of interrupt, it could determine immediately
> if any running threads had registered for "SIG_MIGRATE"
> and deliver the signal synchronously.
>    

Interrupts cannot be delivered immediately.  Exceptions can, but not all 
guest code is prepared to handle them.  Once you start to handle the 
exception, migration is complete and you are late.


>> Instead of a "migration has occured, run for the hills" signal we're
>> better of finding out why applications want to know about
>> this event and
>> addressing specific needs.
>>      
> Perhaps.  It certainly isn't warranted for this one
> special case of timestamp handling.  But I'll bet 5-10 years
> from now, after we've handled a few special cases, we'll
> wish that we would have handled it more generically.
>    

Or we'll find that backwards compatibility for the generic signal is 
killing some optimization.

-- 
error compiling committee.c: too many arguments to function

