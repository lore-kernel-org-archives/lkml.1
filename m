Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbXI0Ule@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbXI0Ule (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbXI0UlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:41:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664AbXI0UlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:41:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=UMpBB1BAOmaP/JweM6v6GmsVlz8ebWbTCBrEzAtJ0DTfCy9igQbh8+b7lXsBiEfP9
	10Vb1d2FL3GJkLLlUUH7A==
Date: Thu, 27 Sep 2007 13:41:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch 2/2] pci: write file size to inode on proc bus file write
In-Reply-To: <alpine.DEB.0.9999.0709271322370.8767@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.0.9999.0709271323110.8767@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0709271322370.8767@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a /proc/bus/pci file is written to, the size of that PCI device's
configuration space must be written to the inode.  Otherwise, it is
possible for the file to specify a size of 0 on stat if a task is holding
the same file open.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/pci/proc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -129,7 +129,7 @@ proc_bus_pci_read(struct file *file, char __user *buf, size_t nbytes, loff_t *pp
 static ssize_t
 proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	const struct inode *ino = file->f_path.dentry->d_inode;
+	struct inode *ino = file->f_path.dentry->d_inode;
 	const struct proc_dir_entry *dp = PDE(ino);
 	struct pci_dev *dev = dp->data;
 	int pos = *ppos;
@@ -193,6 +193,7 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	}
 
 	*ppos = pos;
+	i_size_write(ino, dp->size);
 	return nbytes;
 }
 
