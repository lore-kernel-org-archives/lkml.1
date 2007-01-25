Return-Path: <linux-kernel-owner+w=401wt.eu-S1030299AbXAYQXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299AbXAYQXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXAYQXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:23:45 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54652 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030299AbXAYQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:23:43 -0500
Message-ID: <45B8DA37.5050502@bull.net>
Date: Thu, 25 Jan 2007 17:26:31 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/6] Tunable structure and registration routines
References: <20070116061516.899460000@bull.net>	<20070116063028.375290000@bull.net> <20070124163218.ec54891d.randy.dunlap@oracle.com>
In-Reply-To: <20070124163218.ec54891d.randy.dunlap@oracle.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 17:24:32,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 17:24:33,
	Serialize complete at 25/01/2007 17:24:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

Thanks for reviewing the code!
My comments embedded.
I'll re-send the patches as soon as possible.

Regards,
Nadia

Randy Dunlap wrote:
> On Tue, 16 Jan 2007 07:15:17 +0100 Nadia.Derbey@bull.net wrote:
> 
> 
>>[PATCH 01/06]
>>
<snip>
> 
> 
>>+Any kernel subsystem that has registered a tunable should call
>>+auto_tune_func() as follows:
>>+
>>++-------------------------+--------------------------------------------+
>>+| Step                    | Routine to call                            |
>>++-------------------------+--------------------------------------------+
>>+| Declaration phase       | DEFINE_TUNABLE(name, values...);           |
>>++-------------------------+--------------------------------------------+
>>+| Initialization routine  | set_tunable_min_max(name, min, max);       |
>>+|                         | set_autotuning_routine(name, routine);     |
>>+|                         | register_tunable(&name);                   |
>>+| Note: the 1st 2 calls   |                                            |
>>+|       are optional      |                                            |
>>++-------------------------+--------------------------------------------+
>>+| Alloc                   | activate_auto_tuning(AKT_UP, &name);       |
>>++-------------------------+--------------------------------------------+
>>+| Free                    | activate_auto_tuning(AKT_DOWN, &name);     |
> 
> 
> So does Free always use AKT_DOWN?  why does it matter?
> Seems unneeded and inconsistent.

Tuning down is recommended in order to come back to the default tunable 
value.
I agree with you: today it has quite no effect, except on the tunable 
value. If we take the ipc's example, grow_ary() just returns if the new 
tunable value happens to be lower than the previous one.
But we can imagine, in the future, that grow_ary could deallocate the 
unused memory.
+ in that particular case, lowering the tunable value makes the 1st loop 
in ipc_addid() shorter.

> How does one activate a tunable for downward adjustment?

Actually a tunable is activated to be dynamically adjusted (whatever the 
direction).
But you are giving me an idea for a future enhancement: we can imagine a 
tunable that could be allowed to increase only (or decrease only). In 
that case, we should move the autotune sysfs attribute into an 'up' and 
a 'down' attribute?

<snip>

>>+
>>+2) User part:
>>+
>>+As seen above, the only way to activate automatic tuning is from user side:
>>+- the directory /sys/tunables is created during the init phase.
>>+- each time a tunable is registered by a kernel subsystem, a directory is
>>+created for it under /sys/tunables.
>>+- This directory contains 1 file for each tunable kobject attribute:
> 
> 
> Please try to limit text documentation to 80 columns or less.

That's exactly what I did?



<snip>

>>Index: linux-2.6.20-rc4/fs/Kconfig
>>===================================================================
>>--- linux-2.6.20-rc4.orig/fs/Kconfig	2007-01-15 13:08:14.000000000 +0100
>>+++ linux-2.6.20-rc4/fs/Kconfig	2007-01-15 14:20:20.000000000 +0100
>>@@ -925,6 +925,8 @@ config PROC_KCORE
>> 	bool "/proc/kcore support" if !ARM
>> 	depends on PROC_FS && MMU
>> 
>>+source "kernel/autotune/Kconfig"
> 
> 
> Why is that is the File systems menu?  Seems odd to me
> for it to be there.  If it's just because it depends on
> PROC_FS and SYSFS, then it should just go completely after
> the File systems menu.
> 

Since the tunables that are handled in AKT, I wanted the feature to be 
close to CONFIG_PROC_FS.
Now, I do not agree with your proposal: putting it after the FS menu 
means that it would appear in the main menu, right? I'll try to find a 
better place for it.



>>Index: linux-2.6.20-rc4/include/linux/akt.h
>>===================================================================
>>--- /dev/null	1970-01-01 00:00:00.000000000 +0000
>>+++ linux-2.6.20-rc4/include/linux/akt.h	2007-01-15 14:26:24.000000000 +0100
>>@@ -0,0 +1,186 @@
>>+


<snip>

>>+	char flags;	/* Only 2 bits are meaningful: */
> 
> 
> Make flags unsigned char so that no sign bit is needed.
> 
> 
>>+			/* bit 0: set to 1 if the associated tunable can */
>>+			/*        be automatically adjusted */
>>+			/* bits 1: set to 1 if the tunable has been */
>>+			/*         registered */
>>+			/* bits 2-7: useless */
> 
> 
>                                      unused ??

yep

<snip>

> 
> 
>>+
>>+extern void fork_late_init(void);
> 
> 
> Looks like the wrong header file for that extern.
> 
> 

Actually, I wanted the changes to the existing kernel files to be as 
small as possible. That's why everything is concentrated, whenever 
possible, in the added files.

Regards,
Nadia




