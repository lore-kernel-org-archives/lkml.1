Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZIWWl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZIWWl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZIWWlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:41:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:61418 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZIWWlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:41:23 -0400
Message-ID: <4ABAA398.7080903@windriver.com>
Date: Wed, 23 Sep 2009 17:39:20 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk:Allowmorethan
 one early console"
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu> <4ABA90C6.3000600@windriver.com> <20090923213929.GA20204@elte.hu>
In-Reply-To: <20090923213929.GA20204@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------020208090807060007050900"
X-OriginalArrivalTime: 23 Sep 2009 22:39:22.0996 (UTC) FILETIME=[B2748340:01CA3C9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020208090807060007050900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Jason Wessel <jason.wessel@windriver.com> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>
>>>   
>>>       
>>>> The commit point to which the attached config and bootlog belongs is:
>>>>
>>>>   2.6.31-07863-gb64ada6
>>>>
>>>> Reverting:
>>>>
>>>>   c953094: early_printk: Allow more than one early console
>>>>
>>>> solves it.
>>>>     
>>>>         
>>> btw., the boot options are:
>>>
>>> Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug
>>> initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel 
>>> selinux=0 nmi_watchdog=0 panic=1 3
>>>
>>>   
>>>       
>> AH HA!
>>
>> earlyprintk=serial,ttyS0,115200
>>
>> You are invoking the same device twice which is why you are having 
>> infinite recursion.  It was not obvious to me why the earlyprintk code 
>> would allow "serial" or "ttyS", but perhaps we need to protect for 
>> that?
>>
>> Your boot line should be:
>>
>> earlyprintk=serial,115200
>>
>> OR
>>
>> earlyprintk=ttyS0,115200
>>     
>
> ah, indeed!
>
>   
>> The line you had there before would have been the equivalent of doing:
>>
>> earlyprintk=ttyS0,ttyS0,115200
>>
>> Given this, do we still need to execute the revert your revert?  Or 
>> perhaps do we need to add some protection?
>>     
>
> I have such lines on other boxes too. I'd suggest to add protection if 
> it's not too ugly - the typoed line worked and was pretty natural to do, 
> and the failure mode is nasty enough.
>
> 	Ingo
>   

Perhaps you will consider adding this patch to your tree?   It fixes the
specific case you mentioned.  It will still allow the board to boot and
instead of crashing, print a warning on the second instance.

Thanks,
Jason.



--------------020208090807060007050900
Content-Type: text/x-diff;
 name="0001-early_printk-Protect-against-using-the-same-device-t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-early_printk-Protect-against-using-the-same-device-t.pa";
 filename*1="tch"

>From 2b34fcd7c99f442507fee3b79d8d5f18e873ecaf Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 23 Sep 2009 17:34:42 -0500
Subject: [PATCH 1/1] early_printk: Protect against using the same device twice

If you use the kernel argument:

earlyprintk=serial,ttyS0,115200

This will cause a recursive crash.  Instead warn the end user that they
specified the device a second time.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/early_printk.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 2acfd3f..712661a 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -178,11 +178,19 @@ asmlinkage void early_printk(const char *fmt, ...)
 
 static inline void early_console_register(struct console *con, int keep_early)
 {
+	struct console *bcon;
+
 	early_console = con;
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
 	else
 		early_console->flags |= CON_BOOT;
+	for (bcon = console_drivers; bcon != NULL; con = bcon->next)
+		if (strcmp(bcon->name, con->name) == 0) {
+			printk(KERN_CRIT "ERROR: earlyprintk= %s console"
+			       " already defined\n", con->name);
+			return;
+		}
 	register_console(early_console);
 }
 
-- 
1.6.3.1.9.g95405b


--------------020208090807060007050900--
