Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYICRju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYICRju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbYICRjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:39:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:56647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbYICRjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:39:05 -0400
Date: Wed, 3 Sep 2008 10:25:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/42] AX.25: Fix sysctl registration if
	!CONFIG_AX25_DAMA_SLAVE
Message-ID: <20080903172559.GU7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-AX.25-Fix-sysctl-registration-if-CONFIG_AX25_DAMA_.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

[ Upstream commit ffb208479bd62ab26c29a242faeb1de1c6d5fcdc ]

Since 49ffcf8f99e8d33ec8afb450956804af518fd788 ("sysctl: update
sysctl_check_table") setting struct ctl_table.procname = NULL does no
longer work as it used to the way the AX.25 code is expecting it to
resulting in the AX.25 sysctl registration code to break if
CONFIG_AX25_DAMA_SLAVE was not set as in some distribution kernels.
Kernel releases from 2.6.24 are affected.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ax25/sysctl_net_ax25.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/net/ax25/sysctl_net_ax25.c
+++ b/net/ax25/sysctl_net_ax25.c
@@ -36,6 +36,7 @@ static struct ctl_path ax25_path[] = {
 	{ .procname = "ax25", .ctl_name = NET_AX25, },
 	{ }
 };
+
 static const ctl_table ax25_param_table[] = {
 	{
 		.ctl_name	= NET_AX25_IP_DEFAULT_MODE,
@@ -167,6 +168,7 @@ static const ctl_table ax25_param_table[
 		.extra1		= &min_proto,
 		.extra2		= &max_proto
 	},
+#ifdef CONFIG_AX25_DAMA_SLAVE
 	{
 		.ctl_name	= NET_AX25_DAMA_SLAVE_TIMEOUT,
 		.procname	= "dama_slave_timeout",
@@ -177,6 +179,8 @@ static const ctl_table ax25_param_table[
 		.extra1		= &min_ds_timeout,
 		.extra2		= &max_ds_timeout
 	},
+#endif
+
 	{ .ctl_name = 0 }	/* that's all, folks! */
 };
 
@@ -210,16 +214,6 @@ void ax25_register_sysctl(void)
 		ax25_table[n].procname     = ax25_dev->dev->name;
 		ax25_table[n].mode         = 0555;
 
-#ifndef CONFIG_AX25_DAMA_SLAVE
-		/*
-		 * We do not wish to have a representation of this parameter
-		 * in /proc/sys/ when configured *not* to include the
-		 * AX.25 DAMA slave code, do we?
-		 */
-
-		child[AX25_VALUES_DS_TIMEOUT].procname = NULL;
-#endif
-
 		child[AX25_MAX_VALUES].ctl_name = 0;	/* just in case... */
 
 		for (k = 0; k < AX25_MAX_VALUES; k++)

-- 
