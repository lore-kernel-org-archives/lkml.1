Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbYEFTDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbYEFTDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbYEFTDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:03:05 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40795 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYEFTDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:03:01 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: acpi_cpu_freq_init warning...
References: <86802c440805051951u153ebc21p15f0d73904496217@mail.gmail.com>
	<87k5i8hrmk.fsf@duaron.myhome.or.jp>
	<alpine.LFD.1.10.0805060741290.32269@woody.linux-foundation.org>
Date: Wed, 07 May 2008 04:02:53 +0900
In-Reply-To: <alpine.LFD.1.10.0805060741290.32269@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 6 May 2008 07:47:18 -0700 (PDT)")
Message-ID: <87skwvcl2a.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 6 May 2008, OGAWA Hirofumi wrote:
>> -	if ((drv->entry.next != drv->entry.prev) ||
>> +	if ((drv->entry.next != drv->entry.prev) &&
>>  	    (drv->entry.next != NULL)) {
>
> Umm. That code still makes no sense.
>
> The "drv->entry.next == drv->entry.prev" condition will trigger under 
> *three* different circumstances:
>
>  - next/prev == NULL (uninitialized). Checked for by the explicit check 
>    against NULL.
>
>  - list empty (both next/prev point back to itself), which I assume the 
>    check was *meant* for.
>
>  - list has only *one* entry, when next/prev both point to the list head.
>
> and I'm pretty damn sure that whoever wrote that code didn't mean that 
> last one, but who knows..
>
> The fact is, looking at next/prev this way is a sure way to have bugs.
>
> What is that PoS *trying* to test for? I assume it is meant to test for
>
> 	/* Is the list initialized and non-empty? */
> 	if (drv->entry.next && !list_empty(&drv->entry)) {
> 		...
>
> and dammit, just doing it that way is shorter and simpler.

Whoops, sorry. You are right.

diff -puN drivers/base/sys.c~fix-sys-bogus-warning drivers/base/sys.c
--- linux-2.6/drivers/base/sys.c~fix-sys-bogus-warning	2008-05-07 03:51:00.000000000 +0900
+++ linux-2.6-hirofumi/drivers/base/sys.c	2008-05-07 04:01:14.000000000 +0900
@@ -175,8 +175,7 @@ int sysdev_driver_register(struct sysdev
 	}
 
 	/* Check whether this driver has already been added to a class. */
-	if ((drv->entry.next != drv->entry.prev) ||
-	    (drv->entry.next != NULL)) {
+	if (drv->entry.next && !list_empty(&drv->entry)) {
 		printk(KERN_WARNING "sysdev: class %s: driver (%p) has already"
 			" been registered to a class, something is wrong, but "
 			"will forge on!\n", cls->name, drv);
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
