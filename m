Return-Path: <linux-kernel-owner+w=401wt.eu-S1767365AbXCIQ0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767365AbXCIQ0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767364AbXCIQ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:26:14 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:50555 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767361AbXCIQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:26:12 -0500
Message-ID: <45F18A8C.6020209@s5r6.in-berlin.de>
Date: Fri, 09 Mar 2007 17:25:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Artem Bityutskiy <dedekind@yandex.ru>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: the usage of DEBUG_DRIVER seems ambiguous
References: <Pine.LNX.4.64.0703071941200.14336@CPE00045a9c397f-CM001225dbafb6> <20070308111858.9352f51d.randy.dunlap@oracle.com> <45F169CA.3000106@yandex.ru> <Pine.LNX.4.64.0703090916410.3143@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0703090916410.3143@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Fri, 9 Mar 2007, Artem Bityutskiy wrote:
>> Randy Dunlap wrote:
>> > The ones in drivers/net/ are just local driver debug controls.
>> > They happen to have the same name as a (likely newer) kconfig symbol.
>> >
>> > Is there a real problem that needs to be fixed?
>>
>> Renaming them just for the sake of being less confusing makes sense.
...
> if someone wants to make a suggestion, i can submit a simple renaming
> patch.

If a driver or subsystem already uses a prefix to have an own namespace
for macros, functions, structs and so on, a local DEBUG_DRIVER could
become something like LOCALPREFIX_DEBUG. If there is a narrow usage of
the macro, e.g. to indicate a debug level, it could become something
speaking like LOCALPREFIX_DEBUG_LEVEL. --- However, after looking at the
actual occurrences of DEBUG_DRIVER, I see that this recommendation
doesn't really apply that well.

>From your initial post:
| $ $ grep -rw DEBUG_DRIVER *
| drivers/net/sunlance.c:#undef DEBUG_DRIVER

This is an old forgotten rest of earlier debug code. See here for evidence:
http://lxr.linux.no/source/drivers/net/sunlance.c?v=2.2.26#L791
791 #ifdef DEBUG_DRIVER
792         printk (KERN_DEBUG "Lance restart=%d\n", status);
793 #endif

This usage of DEBUG_DRIVER isn't there anymore. Therefore simply delete
the remaining occurrence:
-#undef DEBUG_DRIVER

| drivers/net/a2065.c:#ifdef DEBUG_DRIVER
| drivers/net/a2065.c:#ifdef DEBUG_DRIVER

Rename to A2065_DEBUG or LANCE_DEBUG. Two more alternatives:

-#ifdef DEBUG_DRIVER
+#if 0 /* debug */

or
-#ifdef DEBUG_DRIVER
-	years_old_debug_cruft_nobody_enables_anymore();
-#endif

Needless to say, the maintainer certainly wants to ACK/NAK this.

| drivers/net/7990.c:#ifdef DEBUG_DRIVER
| drivers/net/7990.c:#ifdef DEBUG_DRIVER

Exactly like with a2065.c.

| drivers/base/Kconfig:config DEBUG_DRIVER

According to where it is defined, CONFIG_DEBUG_DRIVER should only occur
in drivers/base/* (and some defconfigs outside of drivers/base/).

| ...

More hits from LXR:

drivers/isdn/hardware/eicon/dbgioctl.h

Where is this header file used anyway? Can the entire file be deleted?

drivers/isdn/gigaset/gigaset.h  (definition as enum item)
drivers/isdn/gigaset/common.c   (multiple uses)

If the overlap with CONFIG_DEBUG_DRIVER bothers you, rename it to
DEBUG_DRIVER_STRUCT or whatever.
-- 
Stefan Richter
-=====-=-=== --== --===
http://arcgraph.de/sr/
