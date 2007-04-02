Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXDBPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXDBPvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbXDBPvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:51:11 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:4500 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932881AbXDBPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:51:08 -0400
Date: Mon, 2 Apr 2007 17:48:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: Could the k8temp driver be interfering with ACPI?
Message-Id: <20070402174859.80b74b05.khali@linux-fr.org>
In-Reply-To: <20070401153951.GE5095@ucw.cz>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
	<20070302114747.GB1212@srcf.ucam.org>
	<20070302135810.GF2156@elf.ucw.cz>
	<20070302220052.f93f3976.khali@linux-fr.org>
	<20070401153951.GE5095@ucw.cz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, Len,

On Sun, 1 Apr 2007 15:39:52 +0000, Pavel Machek wrote:
> > > Actually for the acpi stuff... we might wrap ACPI interpretter with a
> > > semaphore that needs to be taken before starting any AML code. Then
> > > just make sure sensors take same semaphore?
> > 
> > I like the idea, it should work as long as we are guaranteed that all
> > the hwmon device accesses happen in the AML code? I'm not familiar with
> > ACPI, so you tell me.
> > 
> > In practice it's rather the SMBus drivers which will need to take the
> > lock, as this is what the AML code will access (for SMBus-based
> > hardware monitoring drivers.) For non-SMBus based hardware monitoring
> > drivers, indeed the driver itself should take it. We will have to pay
> > attention to deadlocks on systems with multiple hardware monitoring
> > chips and/or SMBus channels.
> > 
> > Can you please provide a patch implementing your proposal in acpi? Then
> > I could implement the i2c/hwmon part on some selected drivers and start
> > testing real world scenarii.
> 
> I'm sorry, but I do not have time for a patch.... and I'm not really
> acpi expert, anyway. Ask Len?

Meanwhile Alexey Starikovskiy pointed me to the
acpi_ex_enter/exit_interpreter functions, which take an ACPI mutex
(ACPI_MTX_INTERPRETER). As the mutex already exists, it sounds more
efficient to just reuse it rather than introducing a new one. I made an
experiment with the f71805f driver on a machine where ACPI is accessing
the F71805F chip, and it appears to work fine; patch at the end of this
post is someone wants to take a look and/or comment.

Looking at the comment before acpi_ex_exit_interpreter raises two
questions though:

>  * Cases where the interpreter is unlocked:
>  *      1) Completion of the execution of a control method
>  *      2) Method blocked on a Sleep() AML opcode
>  *      3) Method blocked on an Acquire() AML opcode
>  *      4) Method blocked on a Wait() AML opcode
>  *      5) Method blocked to acquire the global lock
>  *      6) Method blocked to execute a serialized control method that is
>  *          already executing
>  *      7) About to invoke a user-installed opregion handler

1* This suggests that the mutex could be released by the AML
interpreter in the middle of an SMBus transaction. If so, and if it
happens in practice, this means that we unfortunately cannot use this
mutex to reliably protect the SMBus drivers from concurrent accesses.
This even suggests that it's simply not possible to have a mutex we
take at the beginning when entering the AML interpreter and we release
when leaving the AML interpreter, as it looks like ACPI itself allows
interlaced execution of AML functions. Len, is this true?

What is the purpose of the ACPI_MTX_INTERPRETER mutex in the first
place, given that it seems it will be released on numerous occasions?
Is it to prevent concurrent AML execution while still allowing
interlaced execution?

2* What are "user-installed opregion handlers"? Are they something that
could help solve the ACPI vs. other drivers problem?

Thanks.

---
 drivers/acpi/utilities/utmutex.c |    2 ++
 drivers/hwmon/f71805f.c          |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

--- linux-2.6.21-rc5.orig/drivers/acpi/utilities/utmutex.c	2007-02-21 08:34:20.000000000 +0100
+++ linux-2.6.21-rc5/drivers/acpi/utilities/utmutex.c	2007-04-02 15:48:41.000000000 +0200
@@ -265,6 +265,7 @@ acpi_status acpi_ut_acquire_mutex(acpi_m
 
 	return (status);
 }
+EXPORT_SYMBOL_GPL(acpi_ut_acquire_mutex);
 
 /*******************************************************************************
  *
@@ -339,3 +340,4 @@ acpi_status acpi_ut_release_mutex(acpi_m
 	acpi_os_release_mutex(acpi_gbl_mutex_info[mutex_id].mutex);
 	return (AE_OK);
 }
+EXPORT_SYMBOL_GPL(acpi_ut_release_mutex);
--- linux-2.6.21-rc5.orig/drivers/hwmon/f71805f.c	2007-04-02 15:20:46.000000000 +0200
+++ linux-2.6.21-rc5/drivers/hwmon/f71805f.c	2007-04-02 17:15:46.000000000 +0200
@@ -37,6 +37,10 @@
 #include <linux/sysfs.h>
 #include <asm/io.h>
 
+#ifdef CONFIG_ACPI
+#include <acpi/acpi.h>
+#endif
+
 static struct platform_device *pdev;
 
 #define DRVNAME "f71805f"
@@ -273,15 +277,29 @@ static inline u8 temp_to_reg(long val)
 /* Must be called with data->update_lock held, except during initialization */
 static u8 f71805f_read8(struct f71805f_data *data, u8 reg)
 {
+	u8  val;
+#ifdef CONFIG_ACPI
+	acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
+#endif
 	outb(reg, data->addr + ADDR_REG_OFFSET);
-	return inb(data->addr + DATA_REG_OFFSET);
+	val = inb(data->addr + DATA_REG_OFFSET);
+#ifdef CONFIG_ACPI
+	acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
+#endif
+	return val;
 }
 
 /* Must be called with data->update_lock held, except during initialization */
 static void f71805f_write8(struct f71805f_data *data, u8 reg, u8 val)
 {
+#ifdef CONFIG_ACPI
+	acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
+#endif
 	outb(reg, data->addr + ADDR_REG_OFFSET);
 	outb(val, data->addr + DATA_REG_OFFSET);
+#ifdef CONFIG_ACPI
+	acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
+#endif
 }
 
 /* It is important to read the MSB first, because doing so latches the
@@ -291,10 +309,16 @@ static u16 f71805f_read16(struct f71805f
 {
 	u16 val;
 
+#ifdef CONFIG_ACPI
+	acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
+#endif
 	outb(reg, data->addr + ADDR_REG_OFFSET);
 	val = inb(data->addr + DATA_REG_OFFSET) << 8;
 	outb(++reg, data->addr + ADDR_REG_OFFSET);
 	val |= inb(data->addr + DATA_REG_OFFSET);
+#ifdef CONFIG_ACPI
+	acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
+#endif
 
 	return val;
 }
@@ -302,10 +326,16 @@ static u16 f71805f_read16(struct f71805f
 /* Must be called with data->update_lock held, except during initialization */
 static void f71805f_write16(struct f71805f_data *data, u8 reg, u16 val)
 {
+#ifdef CONFIG_ACPI
+	acpi_ut_acquire_mutex(ACPI_MTX_INTERPRETER);
+#endif
 	outb(reg, data->addr + ADDR_REG_OFFSET);
 	outb(val >> 8, data->addr + DATA_REG_OFFSET);
 	outb(++reg, data->addr + ADDR_REG_OFFSET);
 	outb(val & 0xff, data->addr + DATA_REG_OFFSET);
+#ifdef CONFIG_ACPI
+	acpi_ut_release_mutex(ACPI_MTX_INTERPRETER);
+#endif
 }
 
 static struct f71805f_data *f71805f_update_device(struct device *dev)


-- 
Jean Delvare
