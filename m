Return-Path: <linux-kernel-owner+w=401wt.eu-S966031AbXDJArM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966031AbXDJArM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966032AbXDJArM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:47:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:38946 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966031AbXDJArK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:47:10 -0400
Date: Mon, 9 Apr 2007 17:47:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: wally@theblackmoor.net
Cc: linux-kernel@vger.kernel.org, "Jung-Ik (John) Lee" <jilee@google.com>,
       linux-acpi@vger.kernel.org
Subject: Re: PROBLEM:  ACPI Thermal Zone for CPU0 does not update after 
 hibernation
Message-Id: <20070409174700.2e0a14d8.akpm@linux-foundation.org>
In-Reply-To: <11584.192.146.101.26.1175890435.squirrel@panacea.theblackmoor.net>
References: <11584.192.146.101.26.1175890435.squirrel@panacea.theblackmoor.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 16:13:55 -0400 (EDT)
"Walter Francis" <wally@theblackmoor.net> wrote:

> After hibernating, the CPU0 thermal zone never updates.  It will stay at 59C
> forever for example.
> 
> I've tried making the thermal driver a module and unloading it before
> hibernating and it didn't help, also went back as far as 2.6.19 and saw the
> same behavior there.  Currently using 2.6.21-pre6.  If I reboot or suspend to
> *RAM*, the problem fixes itself.  And CPU1's thermal zone is fine.  But CPU0
> if it's (example) 59C, it stays 59C forever.  I'm seeing it in gkrellm, but
> it's coming from /proc/acpi/thermal_zone/*/temperature and verified to match
> there.

Yeah, John spotted a bug in there the other day.

Does this fix it?

--- a/drivers/acpi/thermal.c~acpi-thermal-fix-mod_timer-interval
+++ a/drivers/acpi/thermal.c
@@ -758,7 +758,8 @@ static void acpi_thermal_check(void *dat
 			del_timer(&(tz->timer));
 	} else {
 		if (timer_pending(&(tz->timer)))
-			mod_timer(&(tz->timer), (HZ * sleep_time) / 1000);
+			mod_timer(&(tz->timer),
+					jiffies + (HZ * sleep_time) / 1000);
 		else {
 			tz->timer.data = (unsigned long)tz;
 			tz->timer.function = acpi_thermal_run;
_

