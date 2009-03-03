Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZCCPV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZCCPV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbZCCPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:21:47 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:35995 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZCCPVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:21:46 -0500
Date: Tue, 03 Mar 2009 09:21:23 -0600
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 4/5] IPMI: Add console oops catcher
Message-id: <20090303152123.GD7777@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Console messages on oops or panic are very important to investigate problem.
Logging oops or panic messages to SEL is useful because SEL is a non
volatile memory.

Implement a console driver to log messages to SEL when oops_in_progress is
not zero. The first message just after oops, panic or every 10 seconds from
last timestamp are logged as OEM event with timestamp, others are logged as
OEM event without timestamp.

Enable config IPMI_OOPS_CONSOLE and add console=ttyIPMI to kernel command
line to log panic or oops messages to IPMI SEL.

The number of entries for this output is limited by msg_limit paramter,
and the default value is 100.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
v2 -> v3: Use timestamp in first recode and every 10 seconds.
v1 -> v2: Add msg_limit to limit output size.

 drivers/char/ipmi/Kconfig             |    7 +
 drivers/char/ipmi/Makefile            |    1 +
 drivers/char/ipmi/ipmi_oops_console.c |  256 +++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/ipmi/ipmi_oops_console.c

diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
index 0baa8fa..4bca2b3 100644
--- a/drivers/char/ipmi/Kconfig
+++ b/drivers/char/ipmi/Kconfig
@@ -61,4 +61,11 @@ config IPMI_POWEROFF
          This enables a function to power off the system with IPMI if
 	 the IPMI management controller is capable of this.
 
+config IPMI_OOPS_CONSOLE
+	tristate 'IPMI oops console'
+	help
+	  This enables the IPMI oops console. IPMI oops console logs oops or
+	  panic console messsages to SEL. The number of entries for this usage
+	  is limited by msg_limit, default is 100 entries.
+
 endif # IPMI_HANDLER
diff --git a/drivers/char/ipmi/Makefile b/drivers/char/ipmi/Makefile
index eb8a1a8..cbbac18 100644
--- a/drivers/char/ipmi/Makefile
+++ b/drivers/char/ipmi/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += ipmi_devintf.o
 obj-$(CONFIG_IPMI_SI) += ipmi_si.o
 obj-$(CONFIG_IPMI_WATCHDOG) += ipmi_watchdog.o
 obj-$(CONFIG_IPMI_POWEROFF) += ipmi_poweroff.o
+obj-$(CONFIG_IPMI_OOPS_CONSOLE) += ipmi_oops_console.o
diff --git a/drivers/char/ipmi/ipmi_oops_console.c b/drivers/char/ipmi/ipmi_oops_console.c
new file mode 100644
index 0000000..437955f
--- /dev/null
+++ b/drivers/char/ipmi/ipmi_oops_console.c
@@ -0,0 +1,256 @@
+/*
+ * ipmi_oops_console.c
+ *
+ * IPMI Oops Console
+ * Logging console message to SEL on oops
+ *
+ * Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
+ *
+ * Copyright (C) 2008 NEC Corporation
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License as published by the
+ *  Free Software Foundation; either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *
+ *  THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ *  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
+ *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
+ *  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
+ *  OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ *  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ *  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ *  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/ipmi.h>
+#include <linux/ipmi_smi.h>
+#include <linux/console.h>
+#include <linux/jiffies.h>
+#include <asm/atomic.h>
+
+#define PFX "IPMI oops_console: "
+
+static ipmi_user_t oops_user;
+static int oops_intf = -1;
+
+static atomic_t oops_counter;
+
+#define SEL_MSGSIZE_TIMESTAMP	(6U)
+#define SEL_MSGSIZE		(13U)
+#define DEF_LIMIT		(100)
+#define TIMESTAMP_INTERVAL	(10 * HZ)
+
+static char oops_msg[SEL_MSGSIZE_TIMESTAMP + SEL_MSGSIZE];
+static char *msg_ptr = oops_msg;
+static unsigned int msg_len;
+static unsigned long msg_jiffies;
+static int msg_count, msg_limit = DEF_LIMIT;
+
+module_param(msg_limit, int, 0644);
+MODULE_PARM_DESC(msg_limit, "Message limit. Default: 100 entries.");
+
+static void oops_smi_msg_done(struct ipmi_smi_msg *msg)
+{
+	atomic_dec(&oops_counter);
+}
+static struct ipmi_smi_msg oops_smi_msg = {
+	.done = oops_smi_msg_done
+};
+
+static void oops_recv_msg_done(struct ipmi_recv_msg *msg)
+{
+	atomic_dec(&oops_counter);
+}
+static struct ipmi_recv_msg oops_recv_msg = {
+	.done = oops_recv_msg_done
+};
+
+static void ipmi_oops_console_log_to_sel(int timestamp)
+{
+	struct ipmi_system_interface_addr si;
+	struct kernel_ipmi_msg msg;
+	unsigned int len;
+	unsigned char data[16];
+	unsigned char my_addr;
+
+	if (!oops_user || !msg_len || msg_count >= msg_limit)
+		return;
+
+	len = min((timestamp ? SEL_MSGSIZE_TIMESTAMP : SEL_MSGSIZE), msg_len);
+
+	si.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	si.channel = IPMI_BMC_CHANNEL;
+	si.lun = 0;
+
+	msg.netfn = IPMI_NETFN_STORAGE_REQUEST;
+	msg.cmd = IPMI_ADD_SEL_ENTRY_CMD;
+	msg.data = data;
+	msg.data_len = 16;
+
+	memset(data, 0, sizeof(data));
+	if (timestamp) {
+		len = min(SEL_MSGSIZE_TIMESTAMP, msg_len);
+		data[2] = 0xd1; /* OEM event with timestamp */
+		memcpy(data + 10, msg_ptr, len);
+		msg_jiffies = jiffies; /* save jiffies at timestamp */
+	} else {
+		len = min(SEL_MSGSIZE, msg_len);
+		data[2] = 0xf1; /* OEM event without timestamp */
+		memcpy(data + 3, msg_ptr, len);
+	}
+
+	preempt_disable();
+
+	if (ipmi_get_my_address(oops_user, 0, &my_addr))
+		goto out;
+
+	atomic_set(&oops_counter, 2);
+	if (ipmi_request_supply_msgs(oops_user, (struct ipmi_addr *)&si,
+				     0, &msg, NULL, &oops_smi_msg,
+				     &oops_recv_msg, 1) < 0)
+		goto out;
+	while (atomic_read(&oops_counter) > 0) {
+		ipmi_poll_interface(oops_user);
+		cpu_relax();
+	}
+
+	++msg_count;
+	msg_len -= len;
+	msg_ptr = msg_len ? &oops_msg[len] : oops_msg;
+out:
+	preempt_enable();
+}
+
+static void ipmi_oops_console_sync(void)
+{
+	if (!oops_user || !msg_len || msg_count >= msg_limit)
+		return;
+
+	if (jiffies > (msg_jiffies + TIMESTAMP_INTERVAL)) {
+		if (msg_ptr != oops_msg)
+			ipmi_oops_console_log_to_sel(0);
+		if (msg_len >= SEL_MSGSIZE_TIMESTAMP)
+			ipmi_oops_console_log_to_sel(1);
+		return;
+	}
+	if (msg_len >= SEL_MSGSIZE)
+		ipmi_oops_console_log_to_sel(0);
+}
+
+static void
+ipmi_oops_console_write(struct console *con, const char *s, unsigned int count)
+{
+	unsigned int size;
+
+	if (likely(!oops_in_progress)) {
+		ipmi_oops_console_log_to_sel(0);
+		return;
+	}
+
+	if (unlikely(!oops_user))
+		return;
+
+	while (msg_count < msg_limit && count > 0) {
+		size = min(SEL_MSGSIZE - msg_len, count);
+		memcpy(msg_ptr + msg_len, s, size);
+		msg_len += size;
+		s += size;
+		count -= size;
+		ipmi_oops_console_sync();
+	}
+}
+
+static struct console oops_console = {
+	.name	= "ttyIPMI",
+	.write	= ipmi_oops_console_write,
+	.unblank = ipmi_oops_console_sync,
+	.index	= -1,
+};
+
+static void ipmi_oops_recv(struct ipmi_recv_msg *msg, void *data)
+{
+	ipmi_free_recv_msg(msg);
+}
+
+static struct ipmi_user_hndl ipmi_handler = {
+	.ipmi_recv_hndl = ipmi_oops_recv,
+};
+
+static void ipmi_register_oops_console(int intf)
+{
+	int ret;
+
+	ret = ipmi_create_user(intf, &ipmi_handler, NULL, &oops_user);
+	if (ret < 0) {
+		printk(KERN_ERR PFX "unable to create user\n");
+		return;
+	}
+
+	oops_intf = intf;
+
+	register_console(&oops_console);
+
+	printk(KERN_INFO PFX "ready\n");
+}
+
+static void ipmi_unregister_oops_console(int intf)
+{
+	unregister_console(&oops_console);
+
+	ipmi_destroy_user(oops_user);
+	oops_user = NULL;
+	oops_intf = -1;
+}
+
+static void ipmi_new_smi(int if_num, struct device *dev)
+{
+	ipmi_register_oops_console(if_num);
+}
+
+static void ipmi_smi_gone(int if_num)
+{
+	ipmi_unregister_oops_console(if_num);
+}
+
+static struct ipmi_smi_watcher smi_watcher = {
+	.owner		= THIS_MODULE,
+	.new_smi	= ipmi_new_smi,
+	.smi_gone	= ipmi_smi_gone,
+};
+
+static int __init ipmi_oops_console_init(void)
+{
+	int ret;
+
+	ret = ipmi_smi_watcher_register(&smi_watcher);
+	if (ret) {
+		printk(KERN_ERR PFX "unable to register smi watcher\n");
+		return ret;
+	}
+
+	printk(KERN_INFO PFX "driver initialized\n");
+
+	return ret;
+}
+module_init(ipmi_oops_console_init);
+
+static void __exit ipmi_oops_console_exit(void)
+{
+	if (oops_intf >= 0)
+		ipmi_unregister_oops_console(oops_intf);
+}
+module_exit(ipmi_oops_console_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>");
+MODULE_DESCRIPTION("oops console handler based upon the IPMI interface.");
