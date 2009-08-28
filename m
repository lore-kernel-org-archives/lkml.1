Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZH1T6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZH1T6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZH1T6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:58:16 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:60981 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbZH1T6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sxeWvQZ9aUnEUEn2+OBlNSj1prJcWB9VWok04AMNwovB+Tdk88/S6EK86sUpFvJ8hO
         R66qB1l6kimm+kBk+EBsctkbEHR/MiYtQYyiX7JOvdqKdeJW9o/NXvZD/XJ1ro7OcpgJ
         2XpU6v4oaTQWdUGUuvRhpqdcAhA8v1kPvg9eQ=
Date: Fri, 28 Aug 2009 23:58:14 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dac960: switch to seq_file
Message-ID: <20090828195814.GE15123@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/block/DAC960.c |  156 ++++++++++++++++++++++---------------------------
 1 file changed, 71 insertions(+), 85 deletions(-)

--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
@@ -6422,16 +6423,10 @@ static bool DAC960_V2_ExecuteUserCommand(DAC960_Controller_T *Controller,
   return true;
 }
 
-
-/*
-  DAC960_ProcReadStatus implements reading /proc/rd/status.
-*/
-
-static int DAC960_ProcReadStatus(char *Page, char **Start, off_t Offset,
-				 int Count, int *EOF, void *Data)
+static int dac960_proc_show(struct seq_file *m, void *v)
 {
   unsigned char *StatusMessage = "OK\n";
-  int ControllerNumber, BytesAvailable;
+  int ControllerNumber;
   for (ControllerNumber = 0;
        ControllerNumber < DAC960_ControllerCount;
        ControllerNumber++)
@@ -6444,52 +6439,49 @@ static int DAC960_ProcReadStatus(char *Page, char **Start, off_t Offset,
 	  break;
 	}
     }
-  BytesAvailable = strlen(StatusMessage) - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &StatusMessage[Offset], Count);
-  return Count;
+  seq_puts(m, StatusMessage);
+  return 0;
 }
 
+static int dac960_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_proc_show, NULL);
+}
 
-/*
-  DAC960_ProcReadInitialStatus implements reading /proc/rd/cN/initial_status.
-*/
+static const struct file_operations dac960_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-static int DAC960_ProcReadInitialStatus(char *Page, char **Start, off_t Offset,
-					int Count, int *EOF, void *Data)
+static int dac960_initial_status_proc_show(struct seq_file *m, void *v)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
-  int BytesAvailable = Controller->InitialStatusLength - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &Controller->CombinedStatusBuffer[Offset], Count);
-  return Count;
+	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
+	seq_printf(m, "%.*s", Controller->InitialStatusLength, Controller->CombinedStatusBuffer);
+	return 0;
 }
 
+static int dac960_initial_status_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_initial_status_proc_show, PDE(inode)->data);
+}
 
-/*
-  DAC960_ProcReadCurrentStatus implements reading /proc/rd/cN/current_status.
-*/
+static const struct file_operations dac960_initial_status_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_initial_status_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-static int DAC960_ProcReadCurrentStatus(char *Page, char **Start, off_t Offset,
-					int Count, int *EOF, void *Data)
+static int dac960_current_status_proc_show(struct seq_file *m, void *v)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
+  DAC960_Controller_T *Controller = (DAC960_Controller_T *) m->private;
   unsigned char *StatusMessage =
     "No Rebuild or Consistency Check in Progress\n";
   int ProgressMessageLength = strlen(StatusMessage);
-  int BytesAvailable;
   if (jiffies != Controller->LastCurrentStatusTime)
     {
       Controller->CurrentStatusLength = 0;
@@ -6513,49 +6505,41 @@ static int DAC960_ProcReadCurrentStatus(char *Page, char **Start, off_t Offset,
 	}
       Controller->LastCurrentStatusTime = jiffies;
     }
-  BytesAvailable = Controller->CurrentStatusLength - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &Controller->CurrentStatusBuffer[Offset], Count);
-  return Count;
+	seq_printf(m, "%.*s", Controller->CurrentStatusLength, Controller->CurrentStatusBuffer);
+	return 0;
 }
 
+static int dac960_current_status_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_current_status_proc_show, PDE(inode)->data);
+}
 
-/*
-  DAC960_ProcReadUserCommand implements reading /proc/rd/cN/user_command.
-*/
+static const struct file_operations dac960_current_status_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_current_status_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
-static int DAC960_ProcReadUserCommand(char *Page, char **Start, off_t Offset,
-				      int Count, int *EOF, void *Data)
+static int dac960_user_command_proc_show(struct seq_file *m, void *v)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
-  int BytesAvailable = Controller->UserStatusLength - Offset;
-  if (Count >= BytesAvailable)
-    {
-      Count = BytesAvailable;
-      *EOF = true;
-    }
-  if (Count <= 0) return 0;
-  *Start = Page;
-  memcpy(Page, &Controller->UserStatusBuffer[Offset], Count);
-  return Count;
-}
+	DAC960_Controller_T *Controller = (DAC960_Controller_T *)m->private;
 
+	seq_printf(m, "%.*s", Controller->UserStatusLength, Controller->UserStatusBuffer);
+	return 0;
+}
 
-/*
-  DAC960_ProcWriteUserCommand implements writing /proc/rd/cN/user_command.
-*/
+static int dac960_user_command_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dac960_user_command_proc_show, PDE(inode)->data);
+}
 
-static int DAC960_ProcWriteUserCommand(struct file *file,
+static ssize_t dac960_user_command_proc_write(struct file *file,
 				       const char __user *Buffer,
-				       unsigned long Count, void *Data)
+				       size_t Count, loff_t *pos)
 {
-  DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
+  DAC960_Controller_T *Controller = (DAC960_Controller_T *) PDE(file->f_path.dentry->d_inode)->data;
   unsigned char CommandBuffer[80];
   int Length;
   if (Count > sizeof(CommandBuffer)-1) return -EINVAL;
@@ -6572,6 +6556,14 @@ static int DAC960_ProcWriteUserCommand(struct file *file,
 	    ? Count : -EBUSY);
 }
 
+static const struct file_operations dac960_user_command_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dac960_user_command_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= dac960_user_command_proc_write,
+};
 
 /*
   DAC960_CreateProcEntries creates the /proc/rd/... entries for the
@@ -6586,23 +6578,17 @@ static void DAC960_CreateProcEntries(DAC960_Controller_T *Controller)
 
 	if (DAC960_ProcDirectoryEntry == NULL) {
   		DAC960_ProcDirectoryEntry = proc_mkdir("rd", NULL);
-  		StatusProcEntry = create_proc_read_entry("status", 0,
+  		StatusProcEntry = proc_create("status", 0,
 					   DAC960_ProcDirectoryEntry,
-					   DAC960_ProcReadStatus, NULL);
+					   &dac960_proc_fops);
 	}
 
       sprintf(Controller->ControllerName, "c%d", Controller->ControllerNumber);
       ControllerProcEntry = proc_mkdir(Controller->ControllerName,
 				       DAC960_ProcDirectoryEntry);
-      create_proc_read_entry("initial_status", 0, ControllerProcEntry,
-			     DAC960_ProcReadInitialStatus, Controller);
-      create_proc_read_entry("current_status", 0, ControllerProcEntry,
-			     DAC960_ProcReadCurrentStatus, Controller);
-      UserCommandProcEntry =
-	create_proc_read_entry("user_command", S_IWUSR | S_IRUSR,
-			       ControllerProcEntry, DAC960_ProcReadUserCommand,
-			       Controller);
-      UserCommandProcEntry->write_proc = DAC960_ProcWriteUserCommand;
+      proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
+      proc_create_data("current_status", 0, ControllerProcEntry, &dac960_current_status_proc_fops, Controller);
+      UserCommandProcEntry = proc_create_data("user_command", S_IWUSR | S_IRUSR, ControllerProcEntry, &dac960_user_command_proc_fops, Controller);
       Controller->ControllerProcEntry = ControllerProcEntry;
 }
 
