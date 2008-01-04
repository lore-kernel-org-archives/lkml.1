Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYADIZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYADIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYADIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:25:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:50036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbYADIZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:25:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,244,1196668800"; 
   d="scan'208";a="357409001"
Subject: [PATCH linux-acpi] fix acpi fan state set error
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1198744900.3640.4.camel@yangyi-dev.bj.intel.com>
	 <1198916553.3806.2.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Fri, 04 Jan 2008 16:16:42 +0800
Message-Id: <1199434602.19185.1.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ACPI: fix acpi fan state set error
From: Yi Yang <yi.y.yang@intel.com>

Under /proc/acpi, there is a fan control interface, a user can
set 0 or 3 to /proc/acpi/fan/*/state, 0 denotes D0 state, 3
denotes D3 state, but in current implementation, a user can
set a fan to D1 state by any char excluding '1', '2' and '3'.

For example:

[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost acpi]# echo "" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  on
[root@localhost acpi]# echo "3" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost acpi]# echo "xxxxx" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  on

Obviously, such inputs as "" and "xxxxx" are invalid for fan state.

This patch fixes this issue, it strictly limits fan state only to
accept 0, 1, 2 and 3, any other inputs are invalid.

Before applying this patch, the test result is:

[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost acpi]# echo "" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  on
[root@localhost acpi]# echo "3" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost acpi]# echo "xxxxx" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  on
[root@localhost acpi]# echo "3" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost acpi]# echo "3x" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost acpi]# echo "-1x" > /proc/acpi/fan/C31B/state
[root@localhost acpi]# cat /proc/acpi/fan/C31B/state
status:                  on
[root@localhost acpi]#


After applying this patch, the test result is:

[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost ~]# echo "" > /proc/acpi/fan/C31B/state
-bash: echo: write error: Invalid argument
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost ~]# echo "3" > /proc/acpi/fan/C31B/state
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost ~]# echo "xxxxx" > /proc/acpi/fan/C31B/state
-bash: echo: write error: Invalid argument
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost ~]# echo "-1x" > /proc/acpi/fan/C31B/state
-bash: echo: write error: Invalid argument
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost ~]# echo "0" > //proc/acpi/fan/C31B/state
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  on
[root@localhost ~]# echo "4" > //proc/acpi/fan/C31B/state
-bash: echo: write error: Invalid argument
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  on
[root@localhost ~]# echo "3" > //proc/acpi/fan/C31B/state
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  off
[root@localhost ~]# echo "0" > //proc/acpi/fan/C31B/state
[root@localhost ~]# cat /proc/acpi/fan/C31B/state
status:                  on
[root@localhost ~]# echo "3x" > //proc/acpi/fan/C31B/state
-bash: echo: write error: Invalid argument
[root@localhost ~]#


Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 fan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index a5a5532..53f7c72 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -98,7 +98,7 @@ acpi_fan_write_state(struct file *file, const char __user * buffer,
 	int result = 0;
 	struct seq_file *m = file->private_data;
 	struct acpi_device *device = m->private;
-	char state_string[12] = { '\0' };
+	char state_string[3] = { '\0' };
 
 	if (count > sizeof(state_string) - 1)
 		return -EINVAL;
@@ -107,6 +107,12 @@ acpi_fan_write_state(struct file *file, const char __user * buffer,
 		return -EFAULT;
 
 	state_string[count] = '\0';
+	if ((state_string[0] < '0') || (state_string[0] > '3'))
+		return -EINVAL;
+	if (state_string[1] == '\n')
+		state_string[1] = '\0';
+	if (state_string[1] != '\0')
+		return -EINVAL;
 
 	result = acpi_bus_set_power(device->handle,
 				    simple_strtoul(state_string, NULL, 0));


