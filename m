Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZIWXOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZIWXOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZIWXOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:14:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:33517 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZIWXOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:14:43 -0400
Message-ID: <4ABAAB89.1080407@windriver.com>
Date: Wed, 23 Sep 2009 18:13:13 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk:Allowmorethan
 one early console"
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu> <4ABA90C6.3000600@windriver.com> <20090923213929.GA20204@elte.hu> <4ABAA398.7080903@windriver.com> <alpine.LFD.2.01.0909231553480.3303@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909231553480.3303@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------050200090802020405060708"
X-OriginalArrivalTime: 23 Sep 2009 23:13:17.0586 (UTC) FILETIME=[6F2A4F20:01CA3CA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050200090802020405060708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> On Wed, 23 Sep 2009, Jason Wessel wrote:
>   
>> Perhaps you will consider adding this patch to your tree?   It fixes the
>> specific case you mentioned.  It will still allow the board to boot and
>> instead of crashing, print a warning on the second instance.
>>     
>
> Ugh. This looks totally bogus.
>
> Why don't you just add CON_REGISTERED to the console flags, and do
>
> 	/* Already registered? */
> 	if (early_console->flags & CON_REGISTERED)
> 		return;
> 	early_console->flags |= CON_REGISTERED;
>
> there instead? That whole "loop over existing consoles to check their 
> names" looks silly and broken, and you're already playing with the flags 
> in there (CON_BOOT).
>   

Seems reasonable to me.  We don't even have to add a new flag, because
we already have the index set to != -1 when the console registration
succeeds.

Here is the revised patch.

Jason.



--------------050200090802020405060708
Content-Type: text/x-diff;
 name="0001-early_printk-Protect-against-using-the-same-device-t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-early_printk-Protect-against-using-the-same-device-t.pa";
 filename*1="tch"

>From 66081d4a28cb17f58b09fe05a5a9c8441fc701ac Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 23 Sep 2009 18:11:31 -0500
Subject: [PATCH 1/1] early_printk: Protect against using the same device twice

If you use the kernel argument:

earlyprintk=serial,ttyS0,115200

This will cause a recursive crash.  Instead warn the end user that they
specified the device a second time.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/early_printk.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 2acfd3f..41fd965 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -178,6 +178,11 @@ asmlinkage void early_printk(const char *fmt, ...)
 
 static inline void early_console_register(struct console *con, int keep_early)
 {
+	if (early_console->index != -1) {
+		printk(KERN_CRIT "ERROR: earlyprintk= %s already used\n",
+		       con->name);
+		return;
+	}
 	early_console = con;
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
-- 
1.6.3.1.9.g95405b


--------------050200090802020405060708--
