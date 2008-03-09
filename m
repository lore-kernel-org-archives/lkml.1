Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbYCIINh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbYCIINh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 04:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYCIINY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 04:13:24 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:38051 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYCIINW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 04:13:22 -0400
Message-ID: <47D39C1F.6030900@free.fr>
Date: Sun, 09 Mar 2008 09:13:19 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Balaji Rao <balajirrao@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 7: slab corruptions
References: <20080307141856.b27d1725.sfr@canb.auug.org.au> <47D26E42.9020704@free.fr> <200803090029.49180.balajirrao@gmail.com> <20080309030559.GA24355@suse.de>
In-Reply-To: <20080309030559.GA24355@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09.03.2008 04:05, Greg KH a écrit :
> On Sun, Mar 09, 2008 at 12:29:48AM +0530, Balaji Rao wrote:
>> On Saturday 08 March 2008 04:15:22 pm Laurent Riffard wrote:
>>> Le 07.03.2008 04:18, Stephen Rothwell a ??crit :
>>>> Hi all,
>>>>
>>>> I have created today's linux-next tree at
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
>>> I've got a lot of "Slab corruption" with next-20060307 (actually a
>>> continuous flow of warnings) whereas next-20060306 is fine.
>>>
[snip]
>>>
>>> I did a bisection:
>>>
>>> 5a428808720b31026890d3ff71fbd891d9a94fd6 is first bad commit
>>> commit 5a428808720b31026890d3ff71fbd891d9a94fd6
>>> Author: Balaji Rao <balajirrao@gmail.com>
>>> Date:   Thu Mar 6 22:23:18 2008 +0530
>>>
>>>     kobjects: mark cleaned up kobjects as unitialized
>>>
>>>     When I remove only the kvm-intel module without removing the kvm module
>>>     itself, I get an error saying that a kobject is trying to be
>>>     reinitialized. Its because of the fact that kvm reuses a kobject in
>>>     kvm_init when calling sysdev_register.
>>>
>>>     This patch fixes kobject_cleanup by marking the kobject as
>>> uninitialized when we cleanup to allow kobjects to be reused.
>>>
>>>     Signed-off-by: Balaji Rao <balajirrao@gmail.com>
>>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>>>
>>> :040000 040000 c15d08d966391dec783d137558fad66d9c2da57b
>>> : eddea2ec69c014370cf98cc2fc7e24a8dc301e70 M     lib
>>>
>>> .config attached
>>> ~~
>>> laurent
>> Hi greg,
>>
>> Apparently, its the wrong place to mark the kobject as uninitialized as the 
>> kobject could be freed by then. I've now moved it to the top of 
>> kobject_cleanup(). This fixes the problem for me.
>>
>> laurent, can you please revert the above commit , and apply this patch ? Does 
>> it help ?
>>
>> Signed-off-by: Balaji Rao <balajirrao@gmail.com>

Yes, it does help, all the "Slab corruptions" warnings are gone.
Thanks.

Tested-by: Laurent Riffard <laurent.riffard@free.fr>

>>
>> diff --git a/lib/kobject.c b/lib/kobject.c
>> index d784dae..a1f87bd 100644
>> --- a/lib/kobject.c
>> +++ b/lib/kobject.c
>> @@ -548,6 +548,9 @@ static void kobject_cleanup(struct kobject *kobj)
>>         pr_debug("kobject: '%s' (%p): %s\n",
>>                  kobject_name(kobj), kobj, __FUNCTION__);
>>  
>> +       /* Set the state to uninitialized */
>> +       kobj->state_initialized = 0;
>> +
>>         if (t && !t->release)
>>                 pr_debug("kobject: '%s' (%p): does not have a release() "
>>                          "function, it is broken and must be fixed.\n",
>>
>>
> 
> Doh, this is correct, sorry about that, I'll fix this up properly...
> 
> thanks,
> 
> greg k-h
