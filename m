Return-Path: <linux-kernel-owner+w=401wt.eu-S1030377AbXAYQ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377AbXAYQ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030378AbXAYQ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:58:48 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59349 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030377AbXAYQ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:58:47 -0500
Message-ID: <45B8E26E.5000104@bull.net>
Date: Thu, 25 Jan 2007 18:01:34 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/6] Tunable structure and registration routines
References: <20070116061516.899460000@bull.net>	<20070116063028.375290000@bull.net>	<20070124163218.ec54891d.randy.dunlap@oracle.com>	<45B8DA37.5050502@bull.net> <20070125083424.7c455d94.randy.dunlap@oracle.com>
In-Reply-To: <20070125083424.7c455d94.randy.dunlap@oracle.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 17:59:35,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 17:59:37,
	Serialize complete at 25/01/2007 17:59:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 25 Jan 2007 17:26:31 +0100 Nadia Derbey wrote:
>>>>+Any kernel subsystem that has registered a tunable should call
>>>>+auto_tune_func() as follows:
>>>>+
>>>>++-------------------------+--------------------------------------------+
>>>>+| Step                    | Routine to call                            |
>>>>++-------------------------+--------------------------------------------+
>>>>+| Declaration phase       | DEFINE_TUNABLE(name, values...);           |
>>>>++-------------------------+--------------------------------------------+
>>>>+| Initialization routine  | set_tunable_min_max(name, min, max);       |
>>>>+|                         | set_autotuning_routine(name, routine);     |
>>>>+|                         | register_tunable(&name);                   |
>>>>+| Note: the 1st 2 calls   |                                            |
>>>>+|       are optional      |                                            |
>>>>++-------------------------+--------------------------------------------+
>>>>+| Alloc                   | activate_auto_tuning(AKT_UP, &name);       |
>>>>++-------------------------+--------------------------------------------+
>>>>+| Free                    | activate_auto_tuning(AKT_DOWN, &name);     |
>>>
>>>
>>>So does Free always use AKT_DOWN?  why does it matter?
>>>Seems unneeded and inconsistent.
>>
>>Tuning down is recommended in order to come back to the default tunable 
>>value.
> 
> 
> Let me try to be clearer.  What is Alloc?  and why is AKT_UP
> associated with Alloc and AFK_DOWN associated with Free (whatever
> that means)?

Alloc stands for resource allocation: in a subsystem where resource 
allocation depends on a tunable value, we should tune up that value 
prior to the alllocation itself. Let's come back to the ipc subsystem 
example: ipc_addid() is the routine that adds an entry to an ipc array. 
The 1st thing it does (via grow_ary()) is to allocate some more space 
for the ipc array if needed, i.e. if the ipc tunable value has 
increased. That's why the tunable should be tuned up before calling 
ipc_addid().

AKT_DOWN is the reverse operation: we are freeing resources, so the 
tunble has no reason to remain with a big value.

> 
> 
> 
>>I agree with you: today it has quite no effect, except on the tunable 
>>value. If we take the ipc's example, grow_ary() just returns if the new 
>>tunable value happens to be lower than the previous one.
>>But we can imagine, in the future, that grow_ary could deallocate the 
>>unused memory.
>>+ in that particular case, lowering the tunable value makes the 1st loop 
>>in ipc_addid() shorter.
>>
>>
>>>How does one activate a tunable for downward adjustment?
>>
>>Actually a tunable is activated to be dynamically adjusted (whatever the 
>>direction).
>>But you are giving me an idea for a future enhancement: we can imagine a 
>>tunable that could be allowed to increase only (or decrease only). In 
>>that case, we should move the autotune sysfs attribute into an 'up' and 
>>a 'down' attribute?
> 
> 
> Couldn't the tunable owner just adjust the min value to a new
> (larger) min value, e.g.?

You're completely right: setting the min value to the default one should 
be enough!

> 
> 
> 
>>>>+extern void fork_late_init(void);
>>>
>>>
>>>Looks like the wrong header file for that extern.
>>>
>>>
>>
>>Actually, I wanted the changes to the existing kernel files to be as 
>>small as possible. That's why everything is concentrated, whenever 
>>possible, in the added files.
> 
> 
> I suppose that's OK for review, but it shouldn't be merged that way.
> 
> ---
> ~Randy
> 


Regards,
Nadia

