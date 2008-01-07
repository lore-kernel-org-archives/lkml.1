Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYAGHp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYAGHp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 02:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYAGHpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 02:45:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:19058 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbYAGHpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 02:45:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,252,1196668800"; 
   d="scan'208";a="277294097"
Subject: [PATCH] ACPI: fix processor throttling set error
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1199434602.19185.1.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
	 <1199434602.19185.1.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Mon, 07 Jan 2008 14:56:01 +0800
Message-Id: <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI: fix processor throttling set error
From: Yi Yang <yi.y.yang@intel.com>

When echo some invalid values to /proc/acpi/processor/*/throttling,
there isn't any error info returned, on the contray, it sets
throttling value to some T* successfully, obviously, this is incorrect,
a correct way should be to let it fail and return error info.

This patch fixed the aforementioned issue, it also enables
/proc/acpi/processor/*/throttling to accept such values as 't0' and 'T0',
it also strictly limits /proc/acpi/processor/*/throttling only to accept
 "*", "t*" and "T*", "*" is the throttling state value the processor can
support, current, it is 0 - 7.

Before applying this patch, the test result is below:

[root@localhost acpi]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T1
state available: T0 to T7
states:
    T0:                  100%
   *T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost acpi]# echo "1xxxxxx" > /proc/acpi/processor/CPU0/throttling
[root@localhost acpi]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T1
state available: T0 to T7
states:
    T0:                  100%
   *T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost acpi]# echo "0" > /proc/acpi/processor/CPU0/throttling
[root@localhost acpi]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost acpi]# cd /
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost /]# echo "T0" > /proc/acpi/processor/CPU0/throttling
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost /]# echo "T7" > /proc/acpi/processor/CPU0/throttling
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost /]# echo "T100" > /proc/acpi/processor/CPU0/throttling
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost /]# echo "xxx" > /proc/acpi/processor/CPU0/throttling
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost /]# echo "2xxxx" > /proc/acpi/processor/CPU0/throttling
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T2
state available: T0 to T7
states:
    T0:                  100%
    T1:                  87%
   *T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost /]# echo "" > /proc/acpi/processor/CPU0/throttling
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost /]# echo "7777" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost /]# echo "7xxx" > /proc/acpi/processor/CPU0/throttling
[root@localhost /]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T7
state available: T0 to T7
states:
    T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
   *T7:                  12%
[root@localhost /]#


After applying this patch, the test result is below:

[root@localhost linux-2.6.24-rc6]# echo > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo "" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo "0" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# echo "t0" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# echo "T0" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T0
state available: T0 to T7
states:
   *T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
    T7:                  12%
[root@localhost linux-2.6.24-rc6]# echo "T7" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T7
state available: T0 to T7
states:
    T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
   *T7:                  12%
[root@localhost linux-2.6.24-rc6]# echo "T8" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# vi drivers/acpi/processor_throttling.c
[root@localhost linux-2.6.24-rc6]# echo "T8" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo "t7" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# echo "t70" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo "70" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo "7000" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo "70" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo "xxx" > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo -n > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# echo -n "" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# echo $?
0
[root@localhost linux-2.6.24-rc6]# echo -n "" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T7
state available: T0 to T7
states:
    T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
   *T7:                  12%
[root@localhost linux-2.6.24-rc6]# echo -n "" > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# cat /proc/acpi/processor/CPU0/throttling
state count:             8
active state:            T7
state available: T0 to T7
states:
    T0:                  100%
    T1:                  87%
    T2:                  75%
    T3:                  62%
    T4:                  50%
    T5:                  37%
    T6:                  25%
   *T7:                  12%
[root@localhost linux-2.6.24-rc6]# echo t0 > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# echo T0 > /proc/acpi/processor/CPU0/throttling
[root@localhost linux-2.6.24-rc6]# echo Tt0 > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]# echo T > /proc/acpi/processor/CPU0/throttling
-bash: echo: write error: Invalid argument
[root@localhost linux-2.6.24-rc6]#

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 processor_throttling.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 6742d7b..10035a6 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -898,7 +898,10 @@ static ssize_t acpi_processor_write_throttling(struct file *file,
 	int result = 0;
 	struct seq_file *m = file->private_data;
 	struct acpi_processor *pr = m->private;
-	char state_string[12] = { '\0' };
+	char state_string[5] = "";
+	char *charp = NULL;
+	size_t state_val = 0;
+	char tmpbuf[5] = "";
 
 	if (!pr || (count > sizeof(state_string) - 1))
 		return -EINVAL;
@@ -907,10 +910,23 @@ static ssize_t acpi_processor_write_throttling(struct file *file,
 		return -EFAULT;
 
 	state_string[count] = '\0';
+	if ((count > 0) && (state_string[count-1] == '\n'))
+		state_string[count-1] = '\0';
 
-	result = acpi_processor_set_throttling(pr,
-					       simple_strtoul(state_string,
-							      NULL, 0));
+	charp = state_string;
+	if ((state_string[0] == 't') || (state_string[0] == 'T'))
+		charp++;
+
+	state_val = simple_strtoul(charp, NULL, 0);
+	if (state_val >= pr->throttling.state_count)
+		return -EINVAL;
+
+	snprintf(tmpbuf, 5, "%d", state_val);
+
+	if (strcmp(tmpbuf, charp) != 0)
+		return -EINVAL;
+
+	result = acpi_processor_set_throttling(pr, state_val);
 	if (result)
 		return result;
 


