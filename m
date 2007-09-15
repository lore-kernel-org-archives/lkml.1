Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXIOSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXIOSIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXIOSIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:08:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:58123 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXIOSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ge6qe/I6UnVHFioSnq9KJFxSPTrcjq/DqEnR1XsAl5RaXaUJX0lc5vgGAtyREDzt/WItEK9RGC3WxijfF+9oNIxy+we5KjeZKeLLC638Hh6IfmOkf8euKpPNs10+SecsfMZ4U+vbgiTyvFZYGcCxlhil2p0nRd3EwKZKk8FZ2mU=
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>
	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 21:08:01 +0300
Message-Id: <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all, Satyam,

This is my second stab at solving the "stack over flow due to
dump_strace when close to stack-overflow is detected by do_IRQ" problem.
(Hopefully) this patch is creates less noise then the previous one.

[snip]
> I'll try and create an option 2 (static allocation, minimal locking)
> patch and post ASAP.
> Hopefully it'll fare better. (While keeping the current interface intact
> and reducing the damage/noise)
> 
> - Gilboa

- Gilboa

--- linux-2.6/kernel/kallsyms.orig	2007-09-15 11:46:54.000000000 +0300
+++ linux-2.6/kernel/kallsyms.c	2007-09-15 21:06:55.000000000 +0300
@@ -306,13 +306,14 @@ int lookup_symbol_attrs(unsigned long ad
 	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
 }
 
-/* Look up a kernel symbol and return it in a text buffer. */
-int sprint_symbol(char *buffer, unsigned long address)
+/* Internal version:
+   Look up a kernel symbol and module name and return them to the
+     caller's buffer/namebuf buffers. */
+int __sprint_symbol(char *buffer, char *namebuf, unsigned long address)
 {
-	char *modname;
-	const char *name;
 	unsigned long offset, size;
-	char namebuf[KSYM_NAME_LEN];
+	const char *name;
+	char *modname;
 
 	name = kallsyms_lookup(address, &size, &offset, &modname, namebuf);
 	if (!name)
@@ -325,14 +326,35 @@ int sprint_symbol(char *buffer, unsigned
 		return sprintf(buffer, "%s+%#lx/%#lx", name, offset, size);
 }
 
+/* Exported version:
+   Look up a kernel symbol and return it in a text buffer. */
+int sprint_symbol(char *buffer, unsigned long address)
+{
+	char namebuf[KSYM_NAME_LEN];
+
+	return __sprint_symbol(buffer, namebuf, address);
+}
+
+static DEFINE_SPINLOCK(symbol_lock);
+
 /* Look up a kernel symbol and print it to the kernel messages. */
 void __print_symbol(const char *fmt, unsigned long address)
 {
-	char buffer[KSYM_SYMBOL_LEN];
+	/* Use static buffers instead of char array to reduce
+	     stack footprint in i386/4KSTACKS.
+	     Buffers must be protected against re-entry. */
+	static char namebuf[KSYM_NAME_LEN];
+	static char buffer[KSYM_SYMBOL_LEN];
+	unsigned long flags;
+
 
-	sprint_symbol(buffer, address);
+	spin_lock_irqsave(&symbol_lock, flags);
+
+	__sprint_symbol(buffer, namebuf, address);
 
 	printk(fmt, buffer);
+
+	spin_unlock_irqrestore(&symbol_lock, flags);
 }
 
 /* To avoid using get_symbol_offset for every symbol, we carry prefix
along. */


