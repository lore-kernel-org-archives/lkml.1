Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbZHYXru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbZHYXru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbZHYXrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:47:49 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:20974 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932408AbZHYXrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:47:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] console_print: change the function api to make it have printk style interface
Date: Tue, 25 Aug 2009 16:47:49 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA9241@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] console_print: change the function api to make it have printk style interface
Thread-Index: Acol2vMDLJLKXOZeRaex6v/A5hDHCQAANitw
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks:

I bumped into this function in printk.c a while back. As I started using
it, I wondered if we could enhance it with printk style interface that
could make it somewhat more useful. 

One straightforward thing to do here would perhaps be to define this as
a macro. Something like this:

#define console_print(fmt,msg...) printk(KERN_EMERG fmt,##msg)

However, there might be some important reason why this was not done. I
do not know. 
Anyway, keeping the existing code of using a proper C function and
exporting the symbol, here's a patch that enhances the function to use
prink style interface. To the best of my knowledge, I do not think it
will break existing code that uses this function. I did a grep through
the kernel code and didn't look like this call was used in lot of other
places. I have also built the kernel locally with this change and looks
like at least for mips, it does not break our build.

CCing Linus for his opinion.

Cheers,

Ani


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
---
 drivers/char/serial167.c |    2 +-
 include/linux/tty.h      |    2 +-
 kernel/printk.c          |   14 ++++++++++++--
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 51e7a46..029aa0d 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -171,7 +171,7 @@ static int startup(struct cyclades_port *);
 static void cy_throttle(struct tty_struct *);
 static void cy_unthrottle(struct tty_struct *);
 static void config_setup(struct cyclades_port *);
-extern void console_print(const char *);
+extern int console_print(const char *, ...);
 #ifdef CYCLOM_SHOW_STATUS
 static void show_status(int);
 #endif
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e8c6c91..eb3e4fe 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -519,7 +519,7 @@ extern int pcxe_open(struct tty_struct *tty, struct
file *filp);
 
 /* printk.c */
 
-extern void console_print(const char *);
+extern int console_print(const char *, ...);
 
 /* vt.c */
 
diff --git a/kernel/printk.c b/kernel/printk.c
index b4d97b5..729b0ff 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1060,9 +1060,19 @@ void __sched console_conditional_schedule(void)
 }
 EXPORT_SYMBOL(console_conditional_schedule);
 
-void console_print(const char *s)
+int console_print(const char *fmt, ...)
 {
-	printk(KERN_EMERG "%s", s);
+	va_list args;
+	int r;
+	char _fmt[1024] = KERN_EMERG;
+
+	strncat(_fmt, fmt,sizeof(_fmt)- sizeof(KERN_EMERG));
+
+	va_start(args, fmt);
+	r = vprintk(_fmt, args);
+	va_end(args);
+
+	return r;
 }
 EXPORT_SYMBOL(console_print);
 
-- 
1.6.4

