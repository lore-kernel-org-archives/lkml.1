Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYIRXIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYIRXIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbYIRXIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:08:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221AbYIRXIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:08:37 -0400
Date: Thu, 18 Sep 2008 16:08:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, "Parag Warudkar" <parag.lkml@gmail.com>
Subject: Re: mmotm 2008-09-18-14-56 uploaded (olpc_battery build errors)
Message-Id: <20080918160835.deaa3398.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0809181540480.28355@shark.he.net>
References: <200809182157.m8ILv0Vi021531@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0809181540480.28355@shark.he.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 15:42:18 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Thu, 18 Sep 2008, akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2008-09-18-14-56 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > It contains the following patches against 2.6.27-rc6:
> 
> olpc_battery build fails with
> 
> mmotm-2008-0918-1456/drivers/power/olpc_battery.c: At top level:
> mmotm-2008-0918-1456/drivers/power/olpc_battery.c:363: error: unknown field 'owner' specified in initializer
> mmotm-2008-0918-1456/drivers/power/olpc_battery.c:363: warning: excess elements in struct initializer
> mmotm-2008-0918-1456/drivers/power/olpc_battery.c:363: warning: (near initialization for 'olpc_bat_eeprom.attr')
> make[3]: *** [drivers/power/olpc_battery.o] Error 1
> 

OK, x86-sysfs-kill-owner-field-from-attribute.patch is being a pain. 
The problem is that it tries to kill all `owner' instances and then
remove the `owner' field.

But of course new code keeps on turning up doing the wrong thing and
the build breaks and I hae to keep fixing it.

I'm going to do this:

--- a/include/linux/sysfs.h~x86-sysfs-kill-owner-field-from-attribute-fix-3
+++ a/include/linux/sysfs.h
@@ -27,9 +27,7 @@ struct module;
  */
 struct attribute {
 	const char		*name;
-#ifndef CONFIG_X86
 	struct module		*owner;
-#endif
 	mode_t			mode;
 };
 

Parag, once that patch is merged into mainline can you please send a second
one which cleans up any newly-added occurrences and which also nukes that field.

