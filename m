Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbZKHMZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbZKHMZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbZKHMZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:25:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49554 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZKHMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:37 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 15/23] sysctl mips/lasat: Remove dead binary sysctl support
Date: Sun,  8 Nov 2009 04:22:02 -0800
Message-Id: <1257682930-31401-15-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Now that sys_sysctl is a generic wrapper around /proc/sys  .ctl_name
and .strategy members of sysctl tables are dead code.  Remove them.

The deleted strategy routines here surprise me.  ctl_name was
CTL_UNNUMBERED so they would not have been called at all.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/mips/lasat/sysctl.c |   99 +---------------------------------------------
 1 files changed, 1 insertions(+), 98 deletions(-)

diff --git a/arch/mips/lasat/sysctl.c b/arch/mips/lasat/sysctl.c
index b3deed8..1dbdd76 100644
--- a/arch/mips/lasat/sysctl.c
+++ b/arch/mips/lasat/sysctl.c
@@ -37,23 +37,6 @@
 #include "ds1603.h"
 #endif
 
-/* Strategy function to write EEPROM after changing string entry */
-int sysctl_lasatstring(ctl_table *table,
-		void *oldval, size_t *oldlenp,
-		void *newval, size_t newlen)
-{
-	int r;
-
-	r = sysctl_string(table, oldval, oldlenp, newval, newlen);
-	if (r < 0)
-		return r;
-
-	if (newval && newlen)
-		lasat_write_eeprom_info();
-
-	return 0;
-}
-
 
 /* And the same for proc */
 int proc_dolasatstring(ctl_table *table, int write,
@@ -113,46 +96,6 @@ int proc_dolasatrtc(ctl_table *table, int write,
 }
 #endif
 
-/* Sysctl for setting the IP addresses */
-int sysctl_lasat_intvec(ctl_table *table,
-		    void *oldval, size_t *oldlenp,
-		    void *newval, size_t newlen)
-{
-	int r;
-
-	r = sysctl_intvec(table, oldval, oldlenp, newval, newlen);
-	if (r < 0)
-		return r;
-
-	if (newval && newlen)
-		lasat_write_eeprom_info();
-
-	return 0;
-}
-
-#ifdef CONFIG_DS1603
-/* Same for RTC */
-int sysctl_lasat_rtc(ctl_table *table,
-		    void *oldval, size_t *oldlenp,
-		    void *newval, size_t newlen)
-{
-	struct timespec ts;
-	int r;
-
-	read_persistent_clock(&ts);
-	rtctmp = ts.tv_sec;
-	if (rtctmp < 0)
-		rtctmp = 0;
-	r = sysctl_intvec(table, oldval, oldlenp, newval, newlen);
-	if (r < 0)
-		return r;
-	if (newval && newlen)
-		rtc_mips_set_mmss(rtctmp);
-
-	return r;
-}
-#endif
-
 #ifdef CONFIG_INET
 int proc_lasat_ip(ctl_table *table, int write,
 		       void *buffer, size_t *lenp, loff_t *ppos)
@@ -214,23 +157,6 @@ int proc_lasat_ip(ctl_table *table, int write,
 }
 #endif
 
-static int sysctl_lasat_prid(ctl_table *table,
-				     void *oldval, size_t *oldlenp,
-				     void *newval, size_t newlen)
-{
-	int r;
-
-	r = sysctl_intvec(table, oldval, oldlenp, newval, newlen);
-	if (r < 0)
-		return r;
-	if (newval && newlen) {
-		lasat_board_info.li_eeprom_info.prid = *(int *)newval;
-		lasat_write_eeprom_info();
-		lasat_init_board_info();
-	}
-	return 0;
-}
-
 int proc_lasat_prid(ctl_table *table, int write,
 		       void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -252,115 +178,92 @@ extern int lasat_boot_to_service;
 
 static ctl_table lasat_table[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "cpu-hz",
 		.data		= &lasat_board_info.li_cpu_hz,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "bus-hz",
 		.data		= &lasat_board_info.li_bus_hz,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "bmid",
 		.data		= &lasat_board_info.li_bmid,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "prid",
 		.data		= &lasat_board_info.li_prid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_lasat_prid,
-		.strategy	= &sysctl_lasat_prid
-	},
+.	},
 #ifdef CONFIG_INET
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "ipaddr",
 		.data		= &lasat_board_info.li_eeprom_info.ipaddr,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_lasat_ip,
-		.strategy	= &sysctl_lasat_intvec
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "netmask",
 		.data		= &lasat_board_info.li_eeprom_info.netmask,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_lasat_ip,
-		.strategy	= &sysctl_lasat_intvec
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "passwd_hash",
 		.data		= &lasat_board_info.li_eeprom_info.passwd_hash,
 		.maxlen		=
 			sizeof(lasat_board_info.li_eeprom_info.passwd_hash),
 		.mode		= 0600,
 		.proc_handler	= &proc_dolasatstring,
-		.strategy	= &sysctl_lasatstring
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "boot-service",
 		.data		= &lasat_boot_to_service,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
 	},
 #ifdef CONFIG_DS1603
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "rtc",
 		.data		= &rtctmp,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dolasatrtc,
-		.strategy	= &sysctl_lasat_rtc
 	},
 #endif
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "namestr",
 		.data		= &lasat_board_info.li_namestr,
 		.maxlen		= sizeof(lasat_board_info.li_namestr),
 		.mode		= 0444,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "typestr",
 		.data		= &lasat_board_info.li_typestr,
 		.maxlen		= sizeof(lasat_board_info.li_typestr),
 		.mode		= 0444,
 		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string
 	},
 	{}
 };
 
 static ctl_table lasat_root_table[] = {
 	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "lasat",
 		.mode		=  0555,
 		.child		= lasat_table
-- 
1.6.5.2.143.g8cc62

