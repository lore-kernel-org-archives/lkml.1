Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYCHP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYCHP7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 10:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYCHP7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 10:59:07 -0500
Received: from aun.it.uu.se ([130.238.12.36]:51584 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYCHP7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 10:59:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18386.46903.998159.519599@harpo.it.uu.se>
Date: Sat, 8 Mar 2008 16:56:39 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org
Subject: 2.6.25 sysdev API problem
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernels up to and including 2.6.24, it was possible to
register-then-unregister a sysdev_class/sys_device pair
multiple times. Starting with the 2.6.24-git1 kernel, doing
so causes a warning

kobject (f88e96c8): tried to init an initialized object, something is seriously wrong

the second time the class/device pair is registered, followed
soon thereafter by random BUG()s and a kernel panic.

I'm seeing this problem with an out-of-tree but open-source driver
(the "perfctr" performance-monitoring counters driver), but similar
sysdev usage patterns can also be found in oprofile and kvm (though
I don't use them so I don't know if they have this problem or not).

Below is a simple driver module that illustrates the problem.
Inserting it into a 2.6.25-rc4 kernel first causes

foo_sysfs_init                                                             
foo_sysfs_exit                                                             
foo_sysfs_init                                                             
kobject (f88e96c8): tried to init an initialized object, something is seriously wrong
Pid: 2078, comm: insmod Not tainted 2.6.25-rc4 #1                          
 [<c01c3926>] kobject_init+0x76/0x80                                       
 [<c01c3db3>] kobject_init_and_add+0x13/0x40                               
 [<c02143cf>] sysdev_register+0x5f/0xd0                                    
 [<f88e904f>] foo_open_use_close+0x2f/0x80 [foo]                           
 [<f88eb00a>] foo_init+0xa/0xd [foo]                                       
 [<c013ca3c>] sys_init_module+0x11c/0x1ad0                                 
 [<c0151210>] handle_mm_fault+0x100/0x5f0                                  
 [<c02142b0>] sysdev_unregister+0x0/0x60                                   
 [<c0160f9e>] filp_close+0x3e/0x70                                         
 [<c0102f2a>] sysenter_past_esp+0x5f/0x85                                  
 =======================                                                   
foo_sysfs_exit

followed soon thereafter by 

------------[ cut here ]------------
Kernel BUG at c015f795 [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP 
Modules linked in: foo sunrpc af_packet snd_hda_intel snd_seq_oss snd_seq_midi_evee

Pid: 2112, comm: tcsh Not tainted (2.6.25-rc4 #1)
EIP: 0060:[<c015f795>] EFLAGS: 00010082 CPU: 1
EIP is at cache_alloc_refill+0x1c5/0x520
EAX: 00000001 EBX: 0000000c ECX: f78046c0 EDX: f7812bc0
ESI: ffffffff EDI: f686d3a0 EBP: f78236c0 ESP: f6a29f34
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process tcsh (pid: 2112, ti=f6a28000 task=f7b41aa0 task.ti=f6a28000)
Stack: 000000d0 000000d0 f7812bc8 f7812bd0 00000000 000000d0 f78046c0 f7817e00 
       f7812bc0 f71848c0 bfa03b78 00000001 f7169234 f735395c fffffff4 f78046c0 
       00000282 000000d0 c015f5c2 fffffff4 09815808 b7fc3ff4 f6a28000 c016ab08 
Call Trace:
 [<c015f5c2>] kmem_cache_alloc+0x82/0x90
 [<c016ab08>] getname+0x28/0xc0
 [<c010137e>] sys_execve+0xe/0x60
 [<c0102f2a>] sysenter_past_esp+0x5f/0x85
 [<c02a0000>] fn_hash_dump+0xd0/0x240
 =======================
Code: 00 83 c4 38 5b 5e 5f 5d c3 8b 7a 10 c7 42 34 01 00 00 00 39 7c 24 0c 74 b8 8 
EIP: [<c015f795>] cache_alloc_refill+0x1c5/0x520 SS:ESP 0068:f6a29f34
---[ end trace aeb1b82666c8fe26 ]---

The BUG() that finally kills the kernel often occurs in cache_alloc_refill(),
but it can also occur in other places.

/Mikael

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/sysdev.h>
#include <linux/version.h>

MODULE_LICENSE("GPL");

static int foo_suspend(struct sys_device *dev, pm_message_t state) { return 0; }

static int foo_resume(struct sys_device *dev) { return 0; }

static struct sysdev_class foo_sysdev_class = {
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,24)
	.name		= "foo",
#else
	set_kset_name("foo"),
#endif
	.resume		= foo_resume,
	.suspend	= foo_suspend,
};

static struct sys_device foo_sys_device = {
	.id	= 0,
	.cls	= &foo_sysdev_class,
};

static int foo_sysfs_init(void)
{
	int err;

	printk("%s\n", __FUNCTION__);
	err = sysdev_class_register(&foo_sysdev_class);
	if (!err)
		err = sysdev_register(&foo_sys_device);
	if (err)
		printk("%s failed, err %d\n", __FUNCTION__, err);
	return err;
}

static void foo_sysfs_exit(void)
{
	printk("%s\n", __FUNCTION__);
	sysdev_unregister(&foo_sys_device);
	sysdev_class_unregister(&foo_sysdev_class);
}

static void foo_open_use_close(void)
{
	if (foo_sysfs_init() == 0)
		foo_sysfs_exit();
}

int __init foo_init(void)
{
	foo_open_use_close();
	foo_open_use_close();
	return 0;
}

void __exit foo_exit(void) { }

module_init(foo_init)
module_exit(foo_exit)
