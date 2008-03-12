Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYCLPmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYCLPmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYCLPmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:42:38 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38444 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYCLPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:42:37 -0400
Message-ID: <47D7FAA0.1090802@linux.vnet.ibm.com>
Date: Wed, 12 Mar 2008 16:45:36 +0100
From: Frank Munzert <frankm@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
Subject: BUG: lock held when returning to user space
Content-Type: multipart/mixed;
 boundary="------------050907070707060506010700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050907070707060506010700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Ingo,

we provided a device driver vmur dealing with z/VM virtual unit record 
devices (reader, punch, printer). A corresponding user space tool 
provides functions similar to the CMS commands RECEIVE, PUNCH, PRINT.  
Unit record devices are not meant for concurrent read or write by 
multiple users, that's why we need to serialize access. The driver's 
open method uses  mutex_trylock or  mutex_lock_interruptible  to  ensure 
exclusive access to the device, while its  release method  uses 
mutex_unlock.

As a consequence, lockdep complains about locks being held when 
returning to user space. We used a very simple char device driver 
(appended below) to produce this message: 
================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
testapp/2683 is leaving the kernel with locks still held!
1 lock held by testapp/2683:
 #0:  (&test_mutex){--..}, at: [<000003e00003316c>] test_open+0x30/0x64 
[test]

For the vmur device driver it is crucial to have only one process access 
a given unit record device node at a given time. So having open hold the 
mutex and return to user space is exactly what we want. Is  there any 
annotation  to tell lockdep to suppress or bypass this kind of warning?

Thanks in advance,

Frank


--------------050907070707060506010700
Content-Type: text/plain;
 name="test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test.c"

#include  <linux/module.h>
#include  <linux/init.h>
#include  <linux/fs.h>
#include  <linux/types.h>
#include  <linux/cdev.h>

#define  DEVICE_NAME  "test"
#define  MODULE_NAME  "test"

static dev_t Devno;
static struct cdev test_cdev;
static struct mutex test_mutex;

static ssize_t test_read(struct file *filp, char *buff, size_t len,
			 loff_t *whence)
{
	return 1;
}

static ssize_t test_write(struct file *filp, const char *buff,
			  size_t len, loff_t *whence)
{
	return 1;
}

static int test_open(struct inode *ino, struct file *filp)
{
	if (mutex_lock_interruptible(&test_mutex))
		return -ERESTARTSYS;
	printk("%s: test device is open.\n", MODULE_NAME);
	return 0;
}

static int test_close(struct inode *ino, struct file *filp)
{
	printk("%s: test device is closed.\n", MODULE_NAME);
	mutex_unlock(&test_mutex);
	return 0;
}

static struct file_operations Fops  =  { .owner   = THIS_MODULE,
				         .read    = test_read,
				         .write   = test_write,
				         .open    = test_open,
				         .release = test_close    };

static int __init test_init(void)
{
	int rc;
	rc = alloc_chrdev_region(&Devno, 0, 1, DEVICE_NAME);
	if (rc < 0)
	{
		printk("%s: Registration failed...\n",MODULE_NAME);
		return rc;
	}
	printk("%s: Registration %s at major number %d\n", MODULE_NAME,
				DEVICE_NAME, MAJOR(Devno));
	cdev_init(&test_cdev, &Fops);
	test_cdev.owner = THIS_MODULE;
	rc = cdev_add(&test_cdev, Devno, 1);
	if (rc < 0) {
		printk("%s: Device object not added!\n", MODULE_NAME);
		unregister_chrdev_region(Devno, 1);
		return rc;
	}
	printk("%s: Device added.\n", MODULE_NAME);
	mutex_init(&test_mutex);
	return 0;
}

static void __exit test_exit(void)
{
	cdev_del(&test_cdev);
	unregister_chrdev_region(Devno, 1);
	printk("%s: Module removed.\n", MODULE_NAME);
}

module_init(test_init);
module_exit(test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Frank");
MODULE_DESCRIPTION("Simple char driver.");

--------------050907070707060506010700--

