Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYAHG5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYAHG5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 01:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYAHG50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 01:57:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:42410 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbYAHG5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 01:57:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,256,1196668800"; 
   d="scan'208";a="318348289"
Subject: [PATCH] ACPI: fix processor limit set error
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
	 <1199434602.19185.1.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Tue, 08 Jan 2008 11:21:26 +0800
Message-Id: <1199762486.3551.22.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI: fix processor limit set error
From: Yi Yang <yi.y.yang@intel.com>

when echo some invalid values to /proc/acpi/processor/CPU*/limit,
it doesn't return any error info, on the contrary, it successes
and sets some other values, for example:

[root@localhost /]# echo "0:0A" >/proc/acpi/processor/CPU0/limit
[root@localhost /]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T0
user limit:              P0:T0
thermal limit:           P0:T0
[root@localhost /]# echo "0:0F" >/proc/acpi/processor/CPU0/limit
[root@localhost /]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T0
user limit:              P0:T0
thermal limit:           P0:T0
[root@localhost /]# echo "0:0 0:1 0:2" >/proc/acpi/processor/CPU0/limit
[root@localhost /]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T0
user limit:              P0:T0
thermal limit:           P0:T0
[root@localhost /]#

A correct way is that it should fail and return error info.

This patch fixed this issue, it accepts not only such inputs as "*:*",
but also accepts such inputs as "p*:t*" or "P*:T*" or "p*:*" or "*:t*",
the former "*" in inputs means the allowed processor performance state,
currently it is only a stub and not set to the processor limit data
structure, the latter "*" means the allowed processor throttling state
which rages from 0 to 7 generally. This patch strictly limits inputs to
meet the above conditions, any input which can't meet the above conditions
is considered as invalid input.

Before applying this patch, the test result is below:

[root@localhost /]# echo "0:0A" >/proc/acpi/processor/CPU0/limit
[root@localhost /]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T0
user limit:              P0:T0
thermal limit:           P0:T0
[root@localhost /]# echo "0:0F" >/proc/acpi/processor/CPU0/limit
[root@localhost /]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T0
user limit:              P0:T0
thermal limit:           P0:T0
[root@localhost /]# echo "10:2F" >/proc/acpi/processor/CPU0/limit
[root@localhost /]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T2
user limit:              P0:T2
thermal limit:           P0:T0
[root@localhost /]# echo "0:0 0:1 0:2" >/proc/acpi/processor/CPU0/limit
[root@localhost /]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T0
user limit:              P0:T0
thermal limit:           P0:T0
[root@localhost /]#

After applying this patch, the test result is below:

[root@localhost ~]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T0
user limit:              P0:T0
thermal limit:           P0:T0
[root@localhost ~]# echo "0:0A" > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "0:0F" > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "P0:T1" > /proc/acpi/processor/CPU0/limit
[root@localhost ~]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T1
user limit:              P0:T1
thermal limit:           P0:T0
[root@localhost ~]# echo "p0:t1" > /proc/acpi/processor/CPU0/limit
[root@localhost ~]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T1
user limit:              P0:T1
thermal limit:           P0:T0
[root@localhost ~]# echo "p0:x1" > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "q0:x1" > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "p0:1" > /proc/acpi/processor/CPU0/limit
[root@localhost ~]# echo "q0:x1" > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T1
user limit:              P0:T1
thermal limit:           P0:T0
[root@localhost ~]# echo "0:t1" > /proc/acpi/processor/CPU0/limit
[root@localhost ~]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T1
user limit:              P0:T1
thermal limit:           P0:T0
[root@localhost ~]# echo "0:t1F" > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "" > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "0:0 0:0 0:2 " > /proc/acpi/processor/CPU0/limit
-bash: echo: write error: Invalid argument
[root@localhost ~]# echo "P0:T1" > /proc/acpi/processor/CPU0/limit
[root@localhost ~]# cat /proc/acpi/processor/CPU0/limit
active limit:            P0:T1
user limit:              P0:T1
thermal limit:           P0:T0
[root@localhost ~]#


Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 processor_thermal.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 06e6f3f..262d56e 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -349,9 +349,11 @@ static ssize_t acpi_processor_write_limit(struct file * file,
 	int result = 0;
 	struct seq_file *m = file->private_data;
 	struct acpi_processor *pr = m->private;
-	char limit_string[25] = { '\0' };
+	char limit_string[10] = "";
 	int px = 0;
 	int tx = 0;
+	char *tmpp = NULL;
+	char tmpstring[10] = "";
 
 
 	if (!pr || (count > sizeof(limit_string) - 1)) {
@@ -363,21 +365,39 @@ static ssize_t acpi_processor_write_limit(struct file * file,
 	}
 
 	limit_string[count] = '\0';
+	if ((count > 0) && (limit_string[count-1] == '\n'))
+		limit_string[count-1] = '\0';
 
-	if (sscanf(limit_string, "%d:%d", &px, &tx) != 2) {
-		printk(KERN_ERR PREFIX "Invalid data format\n");
+	tmpp = memchr(limit_string, ':', count);
+	if (tmpp == NULL)
+		return -EINVAL;
+
+	*tmpp = '\0';
+	tmpp = limit_string;
+	if ((limit_string[0] == 'p') || (limit_string[0] == 'P'))
+		tmpp++;
+	px = simple_strtoul(tmpp, NULL, 0);
+	snprintf(tmpstring, 10, "%d", px);
+	if (strcmp(tmpp, tmpstring) != 0)
+		return -EINVAL;
+
+	tmpp += strlen(tmpp) + 1;
+	if ((tmpp[0] == 't') || (tmpp[0] == 'T'))
+		tmpp++;
+	tx = simple_strtoul(tmpp, NULL, 0);
+	if (tx > (pr->throttling.state_count - 1))
+		return -EINVAL;
+	snprintf(tmpstring, 10, "%d", tx);
+	if (strcmp(tmpp, tmpstring) != 0)
 		return -EINVAL;
-	}
 
 	if (pr->flags.throttling) {
-		if ((tx < 0) || (tx > (pr->throttling.state_count - 1))) {
-			printk(KERN_ERR PREFIX "Invalid tx\n");
-			return -EINVAL;
-		}
 		pr->limit.user.tx = tx;
-	}
-
-	result = acpi_processor_apply_limit(pr);
+		result = acpi_processor_apply_limit(pr);
+		if (result != 0)
+			return result;
+	} else
+		return -ENODEV;
 
 	return count;
 }


