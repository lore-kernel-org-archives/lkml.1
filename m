Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZIXOKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZIXOKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZIXOKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:10:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:40095 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZIXOKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:10:40 -0400
Message-ID: <4ABB7D5E.6000301@windriver.com>
Date: Thu, 24 Sep 2009 09:08:30 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk: Allowmorethan
 one early console"
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu> <4ABA90C6.3000600@windriver.com> <20090924122249.GA8425@cmpxchg.org>
In-Reply-To: <20090924122249.GA8425@cmpxchg.org>
Content-Type: multipart/mixed;
 boundary="------------060909040007080306010308"
X-OriginalArrivalTime: 24 Sep 2009 14:08:31.0934 (UTC) FILETIME=[7F695DE0:01CA3D20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060909040007080306010308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Johannes Weiner wrote:
> On Wed, Sep 23, 2009 at 04:19:02PM -0500, Jason Wessel wrote:
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
>> infinite recursion.  It was not obvious to me why the earlyprintk
>> code would allow "serial" or "ttyS", but perhaps we need to protect
>> for that?
>>     
>
> That is how it's documented, quoting kernel-parameters.txt:
>
> 	earlyprintk=vga
> 	earlyprintk=serial[,ttySn[,baudrate]]
> 	earlyprintk=dbgp
>
> so ttySn is actually an option to the 'serial' mode.  This has been
> working before because we parsed only one mode but now we parse
>
> 	serial,ttyS0,115200
>
> correctly and then advance character-wise, looking for another
> console:
>
> 	erial,ttyS0,...
> 	rial,ttyS0...
> 	...
>
> until we hit 'ttyS0,115200' which again we parse as a stand-alone
> console definition, yielding twice the same one.
>
>   
>> Your boot line should be:
>>
>> earlyprintk=serial,115200
>>     
>
> Sure this works?  I haven't tried it, but the code looks like it would
> misinterpret the baudrate as the port number, fail and advance to the
> end of the string, and not set the baudrate at all.  You can specify
> ttyS0 standalone, but not serial alone.
>
>   

Perhaps not.  I see the documentation needs an update though because it
did not match the code, for the case of just using ttyS0 or ttyS1 directly.

> It would probably make sense to skip what is successfully parsed
> completely, perhaps like the (untested) diff below?  The other init
> functions would need to be converted too, so that we know how much
> they peeked into the buffer.
>
>   

We can simply check the extra arg case after the parsing and advance,
instead of modifying all the functions.  Then it is all backward compatible.

The fully tested patch follows.

Ingo if you agree, can you pull in this patch?  Or comment and I'll make
some further adjustments.

Thanks,
Jason.

--------------060909040007080306010308
Content-Type: text/x-diff;
 name="0001-x86-earlyprintk-Fix-regression-to-handle-serial-ttyS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-earlyprintk-Fix-regression-to-handle-serial-ttyS.pa";
 filename*1="tch"

>From 047b893e33041dbaf17b2a7eb03ea20486344d6f Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Thu, 24 Sep 2009 09:00:01 -0500
Subject: [PATCH 1/1] x86,earlyprintk: Fix regression to handle serial,ttySn as 1 arg

Commit c9530948bc626c8b638015c0b32abb9615659ec6 introduced a
regression in the parsing of the earlyprintk= kernel arguments.

If you specify "earlyprintk=serial,ttyS0,115200" as a kernel argument,
the "serial,ttyS" should be parsed as a single argument and not as
"serial" and then "ttyS".

Also update the documentation to reflect you can specify the ttyS
directly without the "serial" argument.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/kernel-parameters.txt |    1 +
 arch/x86/kernel/early_printk.c      |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6fa7292..9107b38 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -671,6 +671,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
 
 			Append ",keep" to not disable it when the real console
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 2acfd3f..b7bfdd5 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -201,8 +201,11 @@ static int __init setup_early_printk(char *buf)
 
 	while (*buf != '\0') {
 		if (!strncmp(buf, "serial", 6)) {
-			early_serial_init(buf + 6);
+			buf += 6;
+			early_serial_init(buf);
 			early_console_register(&early_serial_console, keep);
+			if (!strncmp(buf, ",ttyS", 5))
+			    buf += 5;
 		}
 		if (!strncmp(buf, "ttyS", 4)) {
 			early_serial_init(buf + 4);
-- 
1.6.3.1.9.g95405b


--------------060909040007080306010308--
