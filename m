Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYDABOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYDABOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 21:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYDABOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 21:14:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:28979 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYDABOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 21:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jcjmWsoTJP2M19JhYb/HoPWdjxObuCDral58hxkl4WENgliAhrZ8vKLoxLZQDLVI5EBJ5rEK5eXfoKR+GxyB2gCYS8i+YfzhP4VYW3A4VjSY1cnELpIywyigOosp+avA3nhWAPJn723LZUihm78Y9z7EGxsCqT/llvq1+f/JyL0=
Message-ID: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com>
Date: Mon, 31 Mar 2008 21:14:35 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Linux Kernel Development" <linux-kernel@vger.kernel.org>
Subject: Clarifying platform_device_unregister
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to figure out a problem I'm experiencing with
platform_device_unregister. Here's what I'm seeing with a piece of
test code based on corgi_pm.c:

static int mydata;
static struct platform_device *mytest_device;
static int __devinit mytest_init(void)
{
        int ret;

        mytest_device = platform_device_alloc("no_such_driver", -1);

// no_such_driver intentionally doesn't exist. i want to test this
mytest module being insmod-ed/rmmod-ed without ever being bound to a
platform driver.

        if (!mytest_device)
                return -ENOMEM;


        mytest_device->dev.platform_data = &mydata;
        ret = platform_device_add(mytest_device);

        if (ret)
                platform_device_put(mytest_device);

        return ret;
}

static void mytest_exit(void)
{
        platform_device_unregister(mytest_device);
}


# insmod mytest.ko
# rmmod mytest

When I do that, I see a panic, appended below. I was wondering if this
is due to a mistake in my understanding of how the platform code is
intended to be used. The other related question I have is, when a
platform device uses a platform driver through p_d_alloc or
p_add_devices or _register, who is supposed to manage module
refcounting? Should the platform device code call request_module and
try_module_get to manage the counts for platform drivers that they
use? I assumed that the platform support code should do that, since it
knows when the platform drivers get bound to the platform devices.

Thanks,
jaya

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c3dcc000
[00000000] *pgd=a3e8c031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in: mytest(-)
CPU: 0    Not tainted  (2.6.25-rc6gum-00000-gd14ba55-dirty #23)
PC is at kfree+0x6c/0xc4
LR is at platform_device_release+0x1c/0x30
pc : [<c00722e0>]    lr : [<c0123ad0>]    psr: 40000093
sp : c3e3fe60  ip : c3e3fe80  fp : c3e3fe7c
r10: 00000000  r9 : c3e3e000  r8 : c001ac84
r7 : 00000880  r6 : bf000540  r5 : a0000013  r4 : c3e4bc00
r3 : 00000000  r2 : 0009f000  r1 : 00000001  r0 : c0247000
Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0000397f  Table: a3dcc000  DAC: 00000015
Process rmmod (pid: 346, stack limit = 0xc3e3e268)
Stack: (0xc3e3fe60 to 0xc3e40000)
fe60: c3c0f338 c3e4bc00 c0235e6c c3db98a0 c3e3fe94 c3e3fe80 c0123ad0 c0072280
fe80: c00b8e50 c3e4bc70 c3e3fea4 c3e3fe98 c011e8ac c0123ac0 c3e3fec4 c3e3fea8
fea0: c00ebae0 c011e858 c3e4bc70 c3e4bc74 c00ebaf0 c3e3ff48 c3e3fed4 c3e3fec8
fec0: c00ebb04 c00eba88 c3e3feec c3e3fed8 c00ec96c c00ebafc c3e4bc00 00000000
fee0: c3e3fefc c3e3fef0 c00eb994 c00ec90c c3e3ff0c c3e3ff00 c011ea50 c00eb980
ff00: c3e3ff1c c3e3ff10 c0123b00 c011ea40 c3e3ff34 c3e3ff20 c0123b84 c0123af0
ff20: c004ff08 bf0003e0 c3e3ff44 c3e3ff38 bf000018 c0123b70 c3e3ffa4 c3e3ff48
ff40: c00535a0 bf00000c 30326d61 64706530 c0077600 c00771c0 c3e3ff84 c3e3ff68
ff60: c0074188 c0077658 0000000a c3e3e000 c3d9c180 c3c27120 c3e3ffa4 c3e3ff88
ff80: 00075728 00000000 be9c0cb0 be9be498 be9be4b0 00000081 00000000 c3e3ffa8
ffa0: c001ab00 c0053464 be9c0cb0 be9be498 be9be498 00000880 d6d6f735 00000000
ffc0: be9c0cb0 be9be498 be9be4b0 00000081 00000880 00000000 00000000 be9c0d24
ffe0: 40018a4c be9be488 00008e6c 40018a58 20000010 be9be498 00000000 00000000
Backtrace:
[<c0072274>] (kfree+0x0/0xc4) from [<c0123ad0>]
(platform_device_release+0x1c/0x30)
 r6:c3db98a0 r5:c0235e6c r4:c3e4bc00
[<c0123ab4>] (platform_device_release+0x0/0x30) from [<c011e8ac>]
(device_release+0x60/0x80)
 r4:c3e4bc70
[<c011e84c>] (device_release+0x0/0x80) from [<c00ebae0>]
(kobject_cleanup+0x64/0x74)
[<c00eba7c>] (kobject_cleanup+0x0/0x74) from [<c00ebb04>]
(kobject_release+0x14/0x18)
 r6:c3e3ff48 r5:c00ebaf0 r4:c3e4bc74
[<c00ebaf0>] (kobject_release+0x0/0x18) from [<c00ec96c>] (kref_put+0x6c/0x80)
[<c00ec900>] (kref_put+0x0/0x80) from [<c00eb994>] (kobject_put+0x20/0x28)
 r5:00000000 r4:c3e4bc00
[<c00eb974>] (kobject_put+0x0/0x28) from [<c011ea50>] (put_device+0x1c/0x20)
[<c011ea34>] (put_device+0x0/0x20) from [<c0123b00>]
(platform_device_put+0x1c/0x20)
[<c0123ae4>] (platform_device_put+0x0/0x20) from [<c0123b84>]
(platform_device_unregister+0x20/0x24)
[<c0123b64>] (platform_device_unregister+0x0/0x24) from [<bf000018>]
(mytest_exit+0x18/0x20 [am200epd])
 r4:bf0003e0
[<bf000000>] (mytest_exit+0x0/0x20 [am200epd]) from [<c00535a0>]
(sys_delete_module+0x148/0x18c)
[<c0053458>] (sys_delete_module+0x0/0x18c) from [<c001ab00>]
(ret_fast_syscall+0x0/0x2c)
 r7:00000081 r6:be9be4b0 r5:be9be498 r4:be9c0cb0
Code: e3530909 0590000c e5903000 e2133080 (05833000)
---[ end trace eb1de0e70e5a62af ]---
Segmentation fault
