Return-Path: <linux-kernel-owner+w=401wt.eu-S1767708AbXEDHfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767708AbXEDHfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767598AbXEDHfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:35:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:61482 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767708AbXEDHfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=grbAfJz/NBfG10v29Ms3lX0goK0odOiGoY5BpZidCtk1a5b5o1o+n22cHbwclXw8dTbTTecoD0nE5kVqncM9D9gJTMU/DS3G7crHGsFlqiSLdHFWjtl+SOYnPBy7D/UDuCjVnATr1MUWOiGQFlHT+n5UZmAZhOR1H80L9k8xW3E=
Date: Fri, 4 May 2007 15:39:53 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: steve@chygwyn.com, pavel@ucw.cz, Paul.Clements@steeleye.com,
       linux-kernel@vger.kernel.org, Wang Ya-gang <lazy_linux@126.com>,
       Chen Li-jun <cljun@xiyou.edu.cn>
Subject: Re: [-mm Patch]nbd: check the return value of sysfs_create_file
Message-ID: <20070504073953.GA4743@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	steve@chygwyn.com, pavel@ucw.cz, Paul.Clements@steeleye.com,
	linux-kernel@vger.kernel.org, Wang Ya-gang <lazy_linux@126.com>,
	Chen Li-jun <cljun@xiyou.edu.cn>
References: <20070428053023.GA2578@localhost.localdomain> <20070503231450.93b4d417.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503231450.93b4d417.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 11:14:50PM -0700, Andrew Morton wrote:
>On Sat, 28 Apr 2007 13:30:23 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:
>
>> Since 'sysfs_create_file' is declared with attribute warn_unused_result, we must always check its return value carefully.
>> 
>
>Well that's not really the reason for your patch.
>
>warn_unused_result is there to tell us that there are deeper problems in
>the code which need addressing: the failure to check the
>sysfs_create_file() return value means that bugs in the kernel can remain
>undetected, or can be harder to find.


Oh, thanks very much for your pointing.

>
>> 
>> ---
>> 
>> --- linux-2.6.21-rc7-mm2/drivers/block/nbd.c.orig	2007-04-27 17:27:47.000000000 +0800
>> +++ linux-2.6.21-rc7-mm2/drivers/block/nbd.c	2007-04-27 17:47:32.000000000 +0800
>> @@ -373,7 +373,10 @@ static void nbd_do_it(struct nbd_device 
>>  	BUG_ON(lo->magic != LO_MAGIC);
>>  
>>  	lo->pid = current->pid;
>> -	sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
>> +	if (sysfs_create_file(&lo->disk->kobj, &pid_attr.attr)) {
>> +		printk(KERN_ERR "nbd: sysfs_create_file failed!");
>> +		return;
>> +	}
>>  
>>  	while ((req = nbd_read_stat(lo)) != NULL)
>>  		nbd_end_request(req);
>
>It would better saner to propagate this error back through callers:
>
>--- a/drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file-fix
>+++ a/drivers/block/nbd.c
>@@ -366,23 +366,25 @@ static struct disk_attribute pid_attr = 
> 	.show = pid_show,
> };
> 
>-static void nbd_do_it(struct nbd_device *lo)
>+static int nbd_do_it(struct nbd_device *lo)
> {
> 	struct request *req;
>+	int ret;
> 
> 	BUG_ON(lo->magic != LO_MAGIC);
> 
> 	lo->pid = current->pid;
>-	if (sysfs_create_file(&lo->disk->kobj, &pid_attr.attr)) {
>+	ret = sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
>+	if (ret) {
> 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
>-		return;
>+		return ret;
> 	}
> 
> 	while ((req = nbd_read_stat(lo)) != NULL)
> 		nbd_end_request(req);
> 
> 	sysfs_remove_file(&lo->disk->kobj, &pid_attr.attr);
>-	return;
>+	return 0;
> }
> 
> static void nbd_clear_que(struct nbd_device *lo)
>@@ -572,7 +574,9 @@ static int nbd_ioctl(struct inode *inode
> 	case NBD_DO_IT:
> 		if (!lo->file)
> 			return -EINVAL;
>-		nbd_do_it(lo);
>+		error = nbd_do_it(lo);
>+		if (error)
>+			return error;
> 		/* on return tidy up in case we have a signal */
> 		/* Forcibly shutdown the socket causing all listeners
> 		 * to error
>_


Well, better code. ;) I didn't consider changing the type of nbd_do_it().
Thanks again!

