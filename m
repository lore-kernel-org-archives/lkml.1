Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbZA2RuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbZA2RuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:50:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760521AbZA2Rts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:49:48 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34702 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760505AbZA2Rtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uKdGrWCpagb1Z/w+9dGO2Kkhx4UhKgGGoPLzRaFr7ifY2Ij/i/YOPkhlcbHjl0CQrP
         34DNjWD6I6AKiSWSq+9bQHfnu1rVRooa4Mhn/M80y7uepvH1rVFR/rdOSK0w97Pyen1O
         h5K91NUHGhB4QLaxhhH6BPRn9CQ7lb61m0tzw=
Date: Thu, 29 Jan 2009 20:55:30 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/17] proc tty: switch xtensa iss console to ->proc_fops
Message-ID: <20090129175530.GP21643@x200.localdomain>
References: <20090129174830.GA21643@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129174830.GA21643@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/xtensa/platforms/iss/console.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index efed889..5a2db68 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/major.h>
 #include <linux/param.h>
+#include <linux/seq_file.h>
 #include <linux/serial.h>
 #include <linux/serialP.h>
 
@@ -178,22 +179,24 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 	/* Stub, once again.. */
 }
 
-static int rs_read_proc(char *page, char **start, off_t off, int count,
-			int *eof, void *data)
+static int rs_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
-	off_t begin = 0;
-
-	len += sprintf(page, "serinfo:1.0 driver:%s\n", serial_version);
-	*eof = 1;
-
-	if (off >= len + begin)
-		return 0;
+	seq_printf(m, "serinfo:1.0 driver:%s\n", serial_version);
+	return 0;
+}
 
-	*start = page + (off - begin);
-	return ((count < begin + len - off) ? count : begin + len - off);
+static int rs_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, rs_proc_show, NULL);
 }
 
+static const struct file_operations rs_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rs_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 static struct tty_operations serial_ops = {
 	.open = rs_open,
@@ -205,7 +208,7 @@ static struct tty_operations serial_ops = {
 	.chars_in_buffer = rs_chars_in_buffer,
 	.hangup = rs_hangup,
 	.wait_until_sent = rs_wait_until_sent,
-	.read_proc = rs_read_proc
+	.proc_fops = &rs_proc_fops,
 };
 
 int __init rs_init(void)
-- 
1.5.6.5

