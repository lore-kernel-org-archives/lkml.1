Return-Path: <linux-kernel-owner+w=401wt.eu-S1764851AbYEMU2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764851AbYEMU2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764170AbYEMUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:25:58 -0400
Received: from mail137.messagelabs.com ([216.82.249.19]:15443 "EHLO
	mail137.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764158AbYEMUZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:25:55 -0400
X-VirusChecked: Checked
X-Env-Sender: James.Cammarata@savvis.net
X-Msg-Ref: server-13.tower-137.messagelabs.com!1210710322!41449354!4
X-StarScan-Version: 5.5.12.14.2; banners=savvis.net,-,-
X-Originating-IP: [216.91.182.151]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] net: add ability to clear per-interface network statistics via procfs
Date: Tue, 13 May 2008 15:25:27 -0500
Message-ID: <08C08CA018ADA046A6350BB9CC749CB5027201B7@sl6exchbe2.savvis.ad.savvis.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net: add ability to clear per-interface network statistics via procfs
Thread-Index: Aci1N3s4i42R6BoBS/+NMb9HlrUM+g==
From: "Cammarata, James" <James.Cammarata@savvis.net>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 May 2008 20:25:28.0792 (UTC) FILETIME=[7BFAC580:01C8B537]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Cammarata <jimi@sngx.net>

Added the ability to write to /proc/net/dev in order to clear the
interface counters for a given interface.  The ability to zero out
counters (especially the error counters) is extremely useful when
troubleshooting interface issues.

Syntax:
  echo 'net clear-stats ifdev' > /proc/net/dev
Where "ifdev" is the device name you wish to clear.

This code is based mainly on the code found in drivers/scsi/scsi_proc.c

Signed-off-by: James Cammarata <jimi@sngx.net>
---

--- net/core/dev.original       2008-05-13 12:48:46.000000000 -0400
+++ net/core/dev.c      2008-05-13 13:17:15.000000000 -0400
@@ -2453,6 +2453,87 @@ static struct netif_rx_stats *softnet_ge
        return rc;
 }

+/**
+ * proc_net_dev_write - handle writes to /proc/net/dev
+ * @file: not used
+ * @buf: buffer to write
+ * @length: length of buf, at most PAGE_SIZE
+ * @ppos: not used
+ *
+ * Description: this provides a mechanism to clear statistics on a
+ * per-interface basis
+ * "echo 'net clear-stats ifdev' >/proc/net/dev"
+ * with  "ifdev" replaced by the device name you wish to clear.
+ *
+ */
+static ssize_t proc_net_dev_write(struct file *file, const char __user
*buf,
+                                  size_t length, loff_t *ppos)
+{
+        char *buffer, *p;
+        char devname[IFNAMSIZ];
+        struct net *net;
+        struct net_device *dev;
+        int err;
+
+        if (!buf || length > PAGE_SIZE)
+                return -EINVAL;
+
+        buffer = (char *)__get_free_page(GFP_KERNEL);
+        if (!buffer)
+                return -ENOMEM;
+
+        err = -EFAULT;
+        if (copy_from_user(buffer, buf, length))
+                goto out;
+
+        err = -EINVAL;
+        if (length < PAGE_SIZE)
+                buffer[length] = '\0';
+        else if (buffer[PAGE_SIZE-1])
+                goto out;
+
+        err = -ENXIO;
+        net = get_proc_net(file->f_dentry->d_inode);
+        if (!net)
+                goto out;
+
+        /*
+         * Usage: echo "net clear-stats ifdev" >/proc/net/dev
+         * with  "ifdev" replaced by the device name you wish to clear.
+         */
+        if (!strncmp("net clear-stats",buffer,15)) {
+                p = buffer + 16;
+                sscanf(p,"%s",devname);
+                printk(KERN_INFO "net clearing stats - device is:
%s\n", devname);
+                dev = dev_get_by_name(net,devname);
+                if (!dev) {
+                   printk(KERN_INFO "no interface named '%s'\n",
devname);
+                } else {
+                        if (dev->get_stats) {
+                                struct net_device_stats *stats =
dev->get_stats(dev);
+                                memset(stats,0,sizeof(struct
net_device_stats));
+                                printk(KERN_INFO "stats cleared for
interface %s\n", devname);
+                        } else {
+                                printk(KERN_INFO "%s has no stats to
clear\n", devname);
+                        }
+                        dev_put(dev);
+                }
+        }
+
+        /*
+         * convert success returns so that we return the
+         * number of bytes consumed.
+         */
+        if (!err)
+                err = length;
+
+ out:
+        free_page((unsigned long)buffer);
+        return err;
+}
+
 static void *softnet_seq_start(struct seq_file *seq, loff_t *pos)
 {
        return softnet_get_online(pos);
@@ -2496,6 +2577,7 @@ static const struct file_operations dev_
        .owner   = THIS_MODULE,
        .open    = dev_seq_open,
        .read    = seq_read,
+        .write   = proc_net_dev_write,
        .llseek  = seq_lseek,
        .release = seq_release_net,
 };

______________________________________________________________________
This message contains information which may be confidential and/or privileged. Unless you are the intended recipient (or authorized to receive for the intended recipient), you may not read, use, copy or disclose to anyone the message or any information contained in the message. If you have received the message in error, please advise the sender by reply e-mail and delete the message and any attachment(s) thereto without retaining any copies.
______________________________________________________________________
