Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZDUAbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZDUAbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZDUAaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:30:55 -0400
Received: from smtpout10.uol.com.br ([200.221.4.201]:45058 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbZDUAay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:30:54 -0400
DomainKey-Signature: a=rsa-sha1; s=ubzo; d=uol.com.br; c=nofws; q=dns;
	h=dkim-signature:message-id:date:from:user-agent:
	mime-version:to:cc:subject:references:in-reply-to:content-type;
	b=IDNT1Ci1gXxjVnXQyTwHvVV/nWa3Kt49c1Al4YuOQZRdTGAkckUckbqOUVFYUD8Md
	FW+gpU0To4K0SLAfd159Q==
Message-ID: <49ED12FB.9020207@uol.com.br>
Date: Mon, 20 Apr 2009 21:27:39 -0300
From: Adriano dos Santos Fernandes <adrianosf@uol.com.br>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: memory_open cleanup - lookup minor device number
 from devlist
References: <49EBF483.8000908@uol.com.br> <20090420170155.9ff82860.akpm@linux-foundation.org>
In-Reply-To: <20090420170155.9ff82860.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------060405040801050505060707"
X-SIG5: 05391a1ef47d4af4801b8ad820b6a9e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060405040801050505060707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Mon, 20 Apr 2009 01:05:23 -0300
> Adriano dos Santos Fernandes <adrianosf@uol.com.br> wrote:
>
>   
>> memory_open ignores devlist and does a switch for each item, duplicating 
>> code
>> and conditional definitions.
>>
>> Clean it adding backing_dev_info to devlist and use it to lookup for the 
>> minor
>> device.
>>     
>
> The patch looks reasonable, however your email client replaced all tabs
> with spaces and I didn't really feel like fixing it all up.
>   
I'm not having success to let Thunderbird make it right. I put the exact 
same patch attached now.

> I wonder what the lock_kernel() calls in memory_open() are doing.
Hmm, not something I can say while submitting my first patch. ;-)


Adriano


--------------060405040801050505060707
Content-Type: text/x-patch;
 name="memory_open.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="memory_open.patch"

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8f05c38..9e350f2 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -861,59 +861,58 @@ static const struct file_operations kmsg_fops = {
 	.write =	kmsg_write,
 };
 
-static int memory_open(struct inode * inode, struct file * filp)
-{
-	int ret = 0;
-
-	lock_kernel();
-	switch (iminor(inode)) {
-		case 1:
-			filp->f_op = &mem_fops;
-			filp->f_mapping->backing_dev_info =
-				&directly_mappable_cdev_bdi;
-			break;
+static const struct {
+	unsigned int		minor;
+	char			*name;
+	umode_t			mode;
+	const struct file_operations	*fops;
+	struct backing_dev_info	*dev_info;
+} devlist[] = { /* list of minor devices */
+	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops,
+		&directly_mappable_cdev_bdi},
 #ifdef CONFIG_DEVKMEM
-		case 2:
-			filp->f_op = &kmem_fops;
-			filp->f_mapping->backing_dev_info =
-				&directly_mappable_cdev_bdi;
-			break;
+	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops,
+		&directly_mappable_cdev_bdi},
 #endif
-		case 3:
-			filp->f_op = &null_fops;
-			break;
+	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops, NULL},
 #ifdef CONFIG_DEVPORT
-		case 4:
-			filp->f_op = &port_fops;
-			break;
+	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops, NULL},
 #endif
-		case 5:
-			filp->f_mapping->backing_dev_info = &zero_bdi;
-			filp->f_op = &zero_fops;
-			break;
-		case 7:
-			filp->f_op = &full_fops;
-			break;
-		case 8:
-			filp->f_op = &random_fops;
-			break;
-		case 9:
-			filp->f_op = &urandom_fops;
-			break;
-		case 11:
-			filp->f_op = &kmsg_fops;
-			break;
+	{5, "zero",    S_IRUGO | S_IWUGO,           &zero_fops, &zero_bdi},
+	{7, "full",    S_IRUGO | S_IWUGO,           &full_fops, NULL},
+	{8, "random",  S_IRUGO | S_IWUSR,           &random_fops, NULL},
+	{9, "urandom", S_IRUGO | S_IWUSR,           &urandom_fops, NULL},
+	{11,"kmsg",    S_IRUGO | S_IWUSR,           &kmsg_fops, NULL},
 #ifdef CONFIG_CRASH_DUMP
-		case 12:
-			filp->f_op = &oldmem_fops;
-			break;
+	{12,"oldmem",    S_IRUSR | S_IWUSR | S_IRGRP, &oldmem_fops, NULL},
 #endif
-		default:
-			unlock_kernel();
-			return -ENXIO;
+};
+
+static int memory_open(struct inode * inode, struct file * filp)
+{
+	int ret = 0;
+	int i;
+
+	lock_kernel();
+
+	for (i = 0; i < ARRAY_SIZE(devlist); i++) {
+		if (devlist[i].minor == iminor(inode)) {
+			filp->f_op = devlist[i].fops;
+			if (devlist[i].dev_info) {
+				filp->f_mapping->backing_dev_info =
+					devlist[i].dev_info;
+			}
+
+			break;
+		}
 	}
-	if (filp->f_op && filp->f_op->open)
-		ret = filp->f_op->open(inode,filp);
+
+	if (i == ARRAY_SIZE(devlist))
+		ret = -ENXIO;
+	else
+		if (filp->f_op && filp->f_op->open)
+			ret = filp->f_op->open(inode,filp);
+
 	unlock_kernel();
 	return ret;
 }
@@ -922,30 +921,6 @@ static const struct file_operations memory_fops = {
 	.open		= memory_open,	/* just a selector for the real open */
 };
 
-static const struct {
-	unsigned int		minor;
-	char			*name;
-	umode_t			mode;
-	const struct file_operations	*fops;
-} devlist[] = { /* list of minor devices */
-	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops},
-#ifdef CONFIG_DEVKMEM
-	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops},
-#endif
-	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops},
-#ifdef CONFIG_DEVPORT
-	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops},
-#endif
-	{5, "zero",    S_IRUGO | S_IWUGO,           &zero_fops},
-	{7, "full",    S_IRUGO | S_IWUGO,           &full_fops},
-	{8, "random",  S_IRUGO | S_IWUSR,           &random_fops},
-	{9, "urandom", S_IRUGO | S_IWUSR,           &urandom_fops},
-	{11,"kmsg",    S_IRUGO | S_IWUSR,           &kmsg_fops},
-#ifdef CONFIG_CRASH_DUMP
-	{12,"oldmem",    S_IRUSR | S_IWUSR | S_IRGRP, &oldmem_fops},
-#endif
-};
-
 static struct class *mem_class;
 
 static int __init chr_dev_init(void)

--------------060405040801050505060707--
