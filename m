Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYE0HSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYE0HSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 03:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbYE0HSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 03:18:01 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:54926 "EHLO burp.tkv.asdf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbYE0HSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 03:18:00 -0400
Date: Tue, 27 May 2008 10:17:53 +0300
From: Markku Savela <msa@moth.iki.fi>
Message-Id: <200805270717.m4R7HriQ016260@burp.tkv.asdf.org>
To: Greg KH <greg@kroah.com>
CC: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-reply-to: <20080527035241.GB20295@kroah.com> (message from Greg KH on Mon,
	26 May 2008 20:52:41 -0700)
Subject: Re: Bug/misfeature of "securityfs"
References: <87iqx1pd24.fsf@burp.tkv.asdf.org> <Xine.LNX.4.64.0805271019550.17391@us.intercode.com.au> <20080527035241.GB20295@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should not really reply from hip in the morning, ignore more
previous message. The "file exists" definitely comes from the module
init failing, because it finds the directory existing.

Here is some more detailed information and a test module
(unfortunately, just pasted in this message):

*shell1*
	*shell2*

         > cd /sys/kernel/security/
         > ls
         apparmor
 > sudo insmod foobar.ko
        > ls
        apparmor  foobar
 > sudo rmmod foobar.ko
        > ls
        apparmor

// so far fine, directory comes and goes...

 > sudo insmod foobar.ko
        > ls
        apparmor  foobar
        > cd foobar/
 > sudo rmmod foobar.ko
 > ls /sys/kernel/security/
apparmor  foobar
        > cd ..
 > ls /sys/kernel/security/
apparmor

// so far fine, directory goes when
// other shell exits it.

 > sudo insmod foobar.ko
        > cd foobar/
 > sudo rmmod foobar.ko
 > ls /sys/kernel/security/
apparmor  foobar
 > sudo insmod foobar.ko
insmod: error inserting 'foobar.ko': -1 File exists
        > cd ..
        > ls
        apparmor  foobar
// 'foobar' still exists, while module unloaded
// and shell also is out.

 > ls /sys/kernel/security/
apparmor  foobar
 > ls /sys/kernel/security/
apparmor  foobar
 > sudo insmod foobar.ko
insmod: error inserting 'foobar.ko': -1 File exists

// And, now only reboot seems to remove the directory"

-------------------------------------------------------------------
tail /var/log/syslog

May 27 09:49:13 maja kernel: [  192.771424] foobar: Module 'foobar' loaded
May 27 09:49:28 maja kernel: [  207.637838] foobar: Module 'foobar' unloaded
May 27 09:49:35 maja kernel: [  214.890241] foobar: Module 'foobar' loaded
May 27 09:49:46 maja kernel: [  225.719495] foobar: Module 'foobar' unloaded
May 27 09:50:19 maja kernel: [  258.782263] foobar: Module 'foobar' loaded
May 27 09:50:27 maja kernel: [  266.641655] foobar: Module 'foobar' unloaded
May 27 09:50:48 maja kernel: [  288.383145] foobar: Foobar FS create failed
May 27 09:51:11 maja kernel: [  311.323851] foobar: Foobar FS create failed

------------------------------------------------------------------
#include <linux/init.h>
#include <linux/module.h>
#include <linux/security.h>

#define FOOBAR_NAME "foobar"

#undef DBG
#undef DBGG
#undef INFO
#undef ERR

#ifdef FOOBAR_DEBUG
#	define DBG(args...) printk(KERN_DEBUG FOOBAR_NAME ": " args)
#else
#	define DBG(args...)
#endif
#define DBGG(args...)
#define INFO(args...) printk(KERN_INFO FOOBAR_NAME ": " args)
#define ERR(args...) printk(KERN_ERR FOOBAR_NAME ": " args)

static struct dentry* foobar_fs;

static void foobar_cleanup(void)
	{
	if (foobar_fs && !IS_ERR(foobar_fs))
		{
		securityfs_remove(foobar_fs);
		};
	}

static int __init foobar_init(void)
	{
	DBG("foobar_init\n");
	if (foobar_fs)
		{
		ERR("Foobar FS already exists\n");
		return -EEXIST;
		}

	foobar_fs = securityfs_create_dir(FOOBAR_NAME, NULL);
	if (IS_ERR(foobar_fs))
		{
		ERR("Foobar FS create failed\n");
		foobar_cleanup();
		return PTR_ERR(foobar_fs);
		}
	INFO("Module 'foobar' loaded\n");
	return 0;
	}

static void __exit foobar_exit(void)
	{
	DBG("foobar_exit\n");
	foobar_cleanup();
	INFO("Module 'foobar' unloaded\n");
	}

module_init(foobar_init);
module_exit(foobar_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Markku Savela");


