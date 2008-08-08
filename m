Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYHHNkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYHHNkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 09:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYHHNkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 09:40:37 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:51338 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYHHNkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 09:40:36 -0400
Message-ID: <35181.166.70.238.45.1218201542.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <20080808122052.GA9038@one.firstfloor.org>
References: <20080807200659.GJ24801@one.firstfloor.org>
    <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com>
    <20080808022916.GM24801@one.firstfloor.org>
    <20080808120813.GA17364@sgi.com>
    <20080808122052.GA9038@one.firstfloor.org>
Date: Fri, 8 Aug 2008 07:19:02 -0600 (MDT)
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Cliff Wickman" <cpw@sgi.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Vivek Goyal" <vgoyal@redhat.com>, "Keith Owens" <kaos@ocs.com.au>,
       "Jay Lan" <jlan@sgi.com>, "Christoph Lameter" <cl@linux-foundation.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Josh Boyer" <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>,
       "Bernhard Walle" <bwalle@suse.de>
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In a partitioned system [I work for SGI, so I'm talking about an Altix],
>> there is memory sharing among multiple single-system images. And if
>> one of those partitions were to panic the other partitions need to
>> be informed that they cannot address the panic'd partition's memory.
>> (Once that partition is rebooted any such access will cause an MCA
>> in the accessor.)
>
> There are already existing shutdown hooks. Aren't they good enough
> for that?
>
> I would feel uneasy about having arbitary drivers hook into panic().
> While I'm sure your code is great there is unfortunately a lot
> of crappy driver code around.
>
> -Andi
>

I hooked panic last night and inserted a notify_die hook -- there is even
a state defined for it already -- DIE_PANIC.  The rest of the code should
be ok.  My only question was where to harvest the regs variable since
panic is not a real exception.

Here's a first stab.  You also must add #include <linux/kdebug.h> to the
top of panic as well.

diff -Naur linux-2.6.27/kernel/panic.c linux-2.6.27-mdb/kernel/panic.c
--- linux-2.6.27/kernel/panic.c	2008-08-07 15:32:29.000000000 -0600
+++ linux-2.6.27-mdb/kernel/panic.c	2008-08-07 15:29:09.000000000 -0600
@@ -82,6 +82,12 @@
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 	bust_spinlocks(0);

+        // call the notify_die handler for any resident debuggers which
+        // may be active and pass the message string.   On a software
+        // fault return at least some sort of regs  for a remote debugger
+        // to look at.
+	notify_die(DIE_PANIC, buf, get_irq_regs(), 0, 0, 0);
+
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.


Jeff


