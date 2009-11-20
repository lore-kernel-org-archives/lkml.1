Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbZKTQlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbZKTQlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZKTQk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:40:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbZKTQk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:57 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>,
       Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH 06/15] eeprom_read()/eeprom_write() should update ppos instead of file->f_pos
Date: Fri, 20 Nov 2009 17:40:36 +0100
Message-Id: <1258735245-25826-7-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeprom_read()/eeprom_write() modify file->f_pos directly instead of the
ppos given. The VFS later updates the file->f_pos and overwrites it with
the unchanged value of ppos. Since nothing touches the struct file in
eeprom_read()/eeprom_write() now, the on stack allocated struct file in
eeprom_read_buf()/eeprom_write_buf() can be removed as well.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 arch/cris/arch-v10/drivers/eeprom.c |   34 +++++++++++++---------------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/eeprom.c b/arch/cris/arch-v10/drivers/eeprom.c
index 1f2ae90..68d9e88 100644
--- a/arch/cris/arch-v10/drivers/eeprom.c
+++ b/arch/cris/arch-v10/drivers/eeprom.c
@@ -439,20 +439,18 @@ static loff_t eeprom_lseek(struct file * file, loff_t offset, int orig)
 
 static int eeprom_read_buf(loff_t addr, char * buf, int count)
 {
-  struct file f;
-
-  f.f_pos = addr;
-  return eeprom_read(&f, buf, count, &addr);
+  return eeprom_read(NULL, buf, count, &addr);
 }
 
 
 
 /* Reads data from eeprom. */
 
-static ssize_t eeprom_read(struct file * file, char * buf, size_t count, loff_t *off)
+static ssize_t eeprom_read(struct file * file, char * buf, size_t count,
+			   loff_t *ppos)
 {
   int read=0;
-  unsigned long p = file->f_pos;
+  loff_t p = *ppos;
 
   unsigned char page;
 
@@ -498,11 +496,9 @@ static ssize_t eeprom_read(struct file * file, char * buf, size_t count, loff_t
 
   /* go on with the actual read */
   read = read_from_eeprom( buf, count);
-  
+
   if(read > 0)
-  {
-    file->f_pos += read;
-  }
+    *ppos += read;
 
   eeprom.busy--;
   wake_up_interruptible(&eeprom.wait_q);
@@ -513,18 +509,14 @@ static ssize_t eeprom_read(struct file * file, char * buf, size_t count, loff_t
 
 static int eeprom_write_buf(loff_t addr, const char * buf, int count)
 {
-  struct file f;
-
-  f.f_pos = addr;
-  
-  return eeprom_write(&f, buf, count, &addr);
+  return eeprom_write(NULL, buf, count, &addr);
 }
 
 
 /* Writes data to eeprom. */
 
 static ssize_t eeprom_write(struct file * file, const char * buf, size_t count,
-                            loff_t *off)
+			    loff_t *ppos)
 {
   int i, written, restart=1;
   unsigned long p;
@@ -543,9 +535,9 @@ static ssize_t eeprom_write(struct file * file, const char * buf, size_t count,
   {
     restart = 0;
     written = 0;
-    p = file->f_pos;
-   
-    
+    p = *ppos;
+
+
     while( (written < count) && (p < eeprom.size))
     {
       /* address the eeprom */
@@ -671,10 +663,10 @@ static ssize_t eeprom_write(struct file * file, const char * buf, size_t count,
 
   eeprom.busy--;
   wake_up_interruptible(&eeprom.wait_q);
-  if (written == 0 && file->f_pos >= eeprom.size){
+  if (written == 0 && *ppos >= eeprom.size){
     return -ENOSPC;
   }
-  file->f_pos += written;
+  *ppos += written;
   return written;
 }
 
-- 
1.6.4.2

