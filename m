Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbYA2Wzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbYA2Wzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYA2Wzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:55:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:32807 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbYA2Wzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:55:37 -0500
Message-ID: <479FAECF.8090308@windriver.com>
Date: Tue, 29 Jan 2008 16:55:11 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][KGDB] Re: [Kgdb-bugreport] KGDB: 8250_kgdb warnings
References: <479DAC35.60308@siemens.com>
In-Reply-To: <479DAC35.60308@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2008 22:54:57.0013 (UTC) FILETIME=[F814F250:01C862C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Hi Jason,
> 
> so far I ignored this because it worked, but I know my customer will
> complain later anyway: What is the deeper meaning of this warning which
> shows up once per registered UART port on my (x86) boxes?
> 
> void kgdb8250_add_port(int i, struct uart_port *serial_req)
> {
> #ifdef CONFIG_KGDB_SIMPLE_SERIAL
> 	if (should_copy_rs_table)
> 		printk(KERN_ERR "8250_kgdb: warning will over write serial"
> 			   " port definitions at kgdb init time\n");
> #endif
> ...
> 
> When I look at kgdb8250_add_platform_port, it starts with a call to
> kgdb8250_copy_rs_table, and I'm wondering now if that wouldn't be more
> appropriate here.
> 
> Jan
> 


This was the result of a race condition between the init code of the
platform vs the init code in kgdb.  The init code in the arch platform
could register serial ports prior to the kgdb module being configured
by the kernel while the kernel is processing all the __init functions.
It would have been easy to fix this with another call to
kgdb8250_copy_rs_table() but you cannot do that because a non-__init
function cannot call an __init function.


We might as well go ahead and fix the problem by adding in some checks
so as not to overwrite the dynamic registrations, because eventually
the SERIAL_PORT_DFNS will be gone.  Below is the patch with the fix to
add some saftey checks as well as to remove the warning.

--------Cut here-----------


Fix the initialization of the kgdb port structure such that
dynamically registered ports will not be later overwritten by the
SERIAL_PORT_DFNS table.  With this problem fixed, the printk about the
overwriting of the kgdb serial definitions at init time can be
removed.

Also add in additional runtime safety checks to make sure UART_NR was
statically allocated by the kernel at compile time to be large enough
for all the dynamic registered ports.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/serial/8250_kgdb.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -53,7 +53,7 @@ static int kgdb8250_buf_out_inx;
 
 /* Old-style serial definitions, if existant, and a counter. */
 #ifdef CONFIG_KGDB_SIMPLE_SERIAL
-static int should_copy_rs_table = 1;
+static int __initdata should_copy_rs_table = 1;
 static struct serial_state old_rs_table[] __initdata = {
 #ifdef SERIAL_PORT_DFNS
 	SERIAL_PORT_DFNS
@@ -260,7 +260,10 @@ static void __init kgdb8250_copy_rs_tabl
 	if (!should_copy_rs_table)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(old_rs_table); i++) {
+	for (i = 0; i < ARRAY_SIZE(old_rs_table) && i < UART_NR; i++) {
+		if (kgdb8250_ports[i].iobase || kgdb8250_ports[i].irq ||
+			kgdb8250_ports[i].membase)
+			continue;
 		kgdb8250_ports[i].iobase = old_rs_table[i].port;
 		kgdb8250_ports[i].irq = irq_canonicalize(old_rs_table[i].irq);
 		kgdb8250_ports[i].uartclk = old_rs_table[i].baud_base * 16;
@@ -281,7 +284,7 @@ static void __init kgdb8250_copy_rs_tabl
  */
 static void __init kgdb8250_late_init(void)
 {
-	/* Try and copy the old_rs_table. */
+	/* Setup the KGDB uart table if not already initialized */
 	kgdb8250_copy_rs_table();
 
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
@@ -303,7 +306,7 @@ static void __init kgdb8250_late_init(vo
 
 static __init int kgdb_init_io(void)
 {
-	/* Give us the basic table of uarts. */
+	/* Setup the KGDB uart table if not already initialized */
 	kgdb8250_copy_rs_table();
 
 	/* We're either a module and parse a config string, or we have a
@@ -401,11 +404,11 @@ struct kgdb_io kgdb_io_ops = {
  */
 void kgdb8250_add_port(int i, struct uart_port *serial_req)
 {
-#ifdef CONFIG_KGDB_SIMPLE_SERIAL
-	if (should_copy_rs_table)
-		printk(KERN_ERR "8250_kgdb: warning will over write serial"
-			   " port definitions at kgdb init time\n");
-#endif
+	if (i >= UART_NR) {
+		printk(KERN_ERR "KGDB dynamic uart registration failed"
+		   "NR_UARTS is too small");
+		return;
+	}
 
 	/* Copy the whole thing over. */
 	if (current_port != &kgdb8250_ports[i])
@@ -427,6 +430,12 @@ void __init kgdb8250_add_platform_port(i
 	/* Make sure we've got the built-in data before we override. */
 	kgdb8250_copy_rs_table();
 
+	if (i >= UART_NR) {
+		printk(KERN_ERR "KGDB dynamic uart registration failed"
+		   "NR_UARTS is too small");
+		return;
+	}
+
 	kgdb8250_ports[i].iobase = p->iobase;
 	kgdb8250_ports[i].membase = p->membase;
 	kgdb8250_ports[i].irq = p->irq;
