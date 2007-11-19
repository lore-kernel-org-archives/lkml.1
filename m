Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbXKSDcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbXKSDcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 22:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXKSDcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 22:32:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:37855 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbXKSDcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 22:32:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=BuOAA/Y1yNx20RvZBb/0aMFpC2OoC+ym2UnmZjSz6zaWRSo3k5TjivNE64AGEFsEKQ/goRhqPBPEzNzP7uNy086Adcu+rkQcD5Aez0++lPv3kOG/HAlCSoGeoIzn2ZHf0wD6ht/IhiTS4S1i01/bCwea4cYTLfkgIqR+iMmS7JE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] printk.c: use ints instead of longs for logbuf index
Date: Sun, 18 Nov 2007 19:32:12 -0800
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8OQQH/OiVkOsXyo"
Message-Id: <200711181932.12588.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_8OQQH/OiVkOsXyo
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Andrew,

This patch stops using unsigned _longs_ for printk
buffer indexes. Log buffer is way smaller than 2 gigabytes
and unsigned ints will work too . Indeed, they do work nicely
on all 32-bit platforms where longs and ints are the same.

With this patch, we have following size savings on amd64:

   text    data     bss     dec     hex filename
   5997     313   17736   24046    5dee 2.6.23.1.t64/kernel/printk.o
   5858     313   17700   23871    5d3f 2.6.23.1.printk.t64/kernel/printk.o

Please take this patch into -mm.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_8OQQH/OiVkOsXyo
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.23.1.printk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23.1.printk.diff"

diff -urpN linux-2.6.23.1/kernel/printk.c linux-2.6.23.1.printk/kernel/printk.c
--- linux-2.6.23.1/kernel/printk.c	2007-10-12 09:43:44.000000000 -0700
+++ linux-2.6.23.1.printk/kernel/printk.c	2007-11-18 19:11:28.000000000 -0800
@@ -84,16 +84,16 @@ static int console_locked, console_suspe
  */
 static DEFINE_SPINLOCK(logbuf_lock);
 
-#define LOG_BUF_MASK	(log_buf_len-1)
+#define LOG_BUF_MASK (log_buf_len-1)
 #define LOG_BUF(idx) (log_buf[(idx) & LOG_BUF_MASK])
 
 /*
  * The indices into log_buf are not constrained to log_buf_len - they
  * must be masked before subscripting
  */
-static unsigned long log_start;	/* Index into log_buf: next char to be read by syslog() */
-static unsigned long con_start;	/* Index into log_buf: next char to be sent to consoles */
-static unsigned long log_end;	/* Index into log_buf: most-recently-written-char + 1 */
+static unsigned log_start;	/* Index into log_buf: next char to be read by syslog() */
+static unsigned con_start;	/* Index into log_buf: next char to be sent to consoles */
+static unsigned log_end;	/* Index into log_buf: most-recently-written-char + 1 */
 
 /*
  *	Array of consoles built from command line options (console=)
@@ -119,17 +119,17 @@ static int console_may_schedule;
 static char __log_buf[__LOG_BUF_LEN];
 static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
-static unsigned long logged_chars; /* Number of chars produced since last read+clear operation */
+static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
 static int __init log_buf_len_setup(char *str)
 {
-	unsigned long size = memparse(str, &str);
+	unsigned size = memparse(str, &str);
 	unsigned long flags;
 
 	if (size)
 		size = roundup_pow_of_two(size);
 	if (size > log_buf_len) {
-		unsigned long start, dest_idx, offset;
+		unsigned start, dest_idx, offset;
 		char *new_log_buf;
 
 		new_log_buf = alloc_bootmem(size);
@@ -179,7 +179,7 @@ __setup("log_buf_len=", log_buf_len_setu
  */
 int do_syslog(int type, char __user *buf, int len)
 {
-	unsigned long i, j, limit, count;
+	unsigned i, j, limit, count;
 	int do_clear = 0;
 	char c;
 	int error = 0;
@@ -320,7 +320,7 @@ asmlinkage long sys_syslog(int type, cha
 /*
  * Call the console drivers on a range of log_buf
  */
-static void __call_console_drivers(unsigned long start, unsigned long end)
+static void __call_console_drivers(unsigned start, unsigned end)
 {
 	struct console *con;
 
@@ -347,8 +347,8 @@ __setup("ignore_loglevel", ignore_loglev
 /*
  * Write out chars from start to end - 1 inclusive
  */
-static void _call_console_drivers(unsigned long start,
-				unsigned long end, int msg_log_level)
+static void _call_console_drivers(unsigned start,
+				unsigned end, int msg_log_level)
 {
 	if ((msg_log_level < console_loglevel || ignore_loglevel) &&
 			console_drivers && start != end) {
@@ -368,12 +368,12 @@ static void _call_console_drivers(unsign
  * log_buf[start] to log_buf[end - 1].
  * The console_sem must be held.
  */
-static void call_console_drivers(unsigned long start, unsigned long end)
+static void call_console_drivers(unsigned start, unsigned end)
 {
-	unsigned long cur_index, start_print;
+	unsigned cur_index, start_print;
 	static int msg_level = -1;
 
-	BUG_ON(((long)(start - end)) > 0);
+	BUG_ON(((int)(start - end)) > 0);
 
 	cur_index = start;
 	start_print = start;
@@ -649,7 +649,7 @@ asmlinkage long sys_syslog(int type, cha
 	return -ENOSYS;
 }
 
-static void call_console_drivers(unsigned long start, unsigned long end)
+static void call_console_drivers(unsigned start, unsigned end)
 {
 }
 
@@ -830,8 +830,8 @@ void wake_up_klogd(void)
 void release_console_sem(void)
 {
 	unsigned long flags;
-	unsigned long _con_start, _log_end;
-	unsigned long wake_klogd = 0;
+	unsigned _con_start, _log_end;
+	unsigned wake_klogd = 0;
 
 	if (console_suspended) {
 		up(&secondary_console_sem);
@@ -1122,7 +1122,7 @@ void tty_write_message(struct tty_struct
 int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst)
 {
 	static DEFINE_SPINLOCK(ratelimit_lock);
-	static unsigned long toks = 10 * 5 * HZ;
+	static unsigned toks = 10 * 5 * HZ;
 	static unsigned long last_msg;
 	static int missed;
 	unsigned long flags;

--Boundary-00=_8OQQH/OiVkOsXyo--
