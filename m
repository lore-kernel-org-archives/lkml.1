Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbZAMIZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbZAMIZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 03:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbZAMIZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 03:25:39 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51961 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbZAMIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 03:25:37 -0500
Date: Tue, 13 Jan 2009 09:27:45 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: do not allow two nbd-clients at same time
Message-ID: <20090113082745.GA2098@elf.ucw.cz>
References: <20081208213542.GA10134@elf.ucw.cz> <20081208225758.GA2872@elf.ucw.cz> <20090112110322.GA2001@elf.ucw.cz> <496B4BBE.5040701@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B4BBE.5040701@steeleye.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-12 08:55:10, Paul Clements wrote:
> Pavel Machek wrote:
>> Two nbd-clients at same time are bad idea, and cause WARN_ON from nbd
>> in 2.6.28-rc7 from sysfs_add_one. This simply prevents that from
>> happening.
>
> Thanks for this. But I think we also need the following:
>
> --- drivers/block/nbd.c        2008-12-24 18:26:37.000000000 -0500
> +++ drivers/block/nbd.c 2009-01-12 08:50:17.000000000 -0500
> @@ -406,6 +406,7 @@ static int nbd_do_it(struct nbd_device *
>         ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj,  
> &pid_attr.attr);
>         if (ret) {
>                 printk(KERN_ERR "nbd: sysfs_create_file failed!");
> +               lo->pid = 0;
>                 return ret;
>         }
>
>

Yep, thanks.

> To zero out pid in the error case. Otherwise, it looks good.

Ok, new patch below.
								Pavel

--- 
Two nbd-clients at same time are bad idea, and cause WARN_ON from nbd
in 2.6.28-rc7 from sysfs_add_one. This simply prevents that from
happening.

To reproduce:

 cat /dev/zero | head -c 10000000 > /tmp/delme.fstest.fs
 nbd-server 9100 -l /anyone.can.connect > /tmp/delme.fstest.fs &
 sleep 1
 nbd-client localhost 9100 /dev/nd0 &
 nbd-client localhost 9100 /dev/nd0 &

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Paul Clements <paul.clements@steeleye.com>

---
commit 831d1b7c7c5b16b1115d7e08ddf9038704653a03
tree 1ae30466acfb40b88cb7c20613f327c3871274ee
parent 66d8f12491f52e259e42148af099a3fc83425a7b
author Pavel <pavel@amd.ucw.cz> Tue, 13 Jan 2009 09:26:22 +0100
committer Pavel <pavel@amd.ucw.cz> Tue, 13 Jan 2009 09:26:22 +0100

 drivers/block/nbd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 670e89d..caf6458 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -406,6 +406,7 @@ static int nbd_do_it(struct nbd_device *
 	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		lo->pid = 0;
 		return ret;
 	}
 
@@ -413,6 +414,7 @@ static int nbd_do_it(struct nbd_device *
 		nbd_end_request(req);
 
 	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	lo->pid = 0;
 	return 0;
 }
 
@@ -646,6 +648,8 @@ static int nbd_ioctl(struct block_device
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
 	case NBD_DO_IT:
+		if (lo->pid)
+			return -EBUSY;
 		if (!lo->file)
 			return -EINVAL;
 		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
