Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZAJGrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZAJGrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZAJGr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:47:27 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:50724 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZAJGr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:47:26 -0500
Message-ID: <4968447A.9000401@freemail.hu>
Date: Sat, 10 Jan 2009 07:47:22 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: validate parameters of exported functions
References: <49684215.40307@freemail.hu>
In-Reply-To: <49684215.40307@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32721; Body=2 Fuz1=2
	Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Check the parameters of the exported functions in genhd.c agains NULL.
> The checks are done with BUG_ON() so they will only act if CONFIG_BUG=y.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>

The following simple module can trigger the BUG_ON(!disk->queue) condition
in unlink_gendisk() when the module is unloaded. The problem seems to be
that after alloc_disk() call the disk->queue is NULL. The inside the
del_disk() call this condition is not checked and the BUG_ON() will be
triggered:

#include <linux/module.h>
#include <linux/genhd.h>

MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
MODULE_DESCRIPTION("Test alloc_disk");
MODULE_LICENSE("GPL");

static struct gendisk *gd_ptr;

static int test_init_module(void)
{
	printk(KERN_DEBUG "starting module\n");

	gd_ptr = alloc_disk(1);
	if (!gd_ptr) {
		return -ENOMEM;
	}
	printk(KERN_DEBUG "gd_ptr after alloc=%p\n", gd_ptr);

	return 0;
}


static void test_exit_module(void)
{
	printk(KERN_DEBUG "unloading module\n");

	del_gendisk(gd_ptr);
}

module_init(test_init_module);
module_exit(test_exit_module);


[  137.688075] starting module
[  137.688101] gd_ptr after alloc=f4e36d48
[  148.978208] unloading module
[  148.978289] ------------[ cut here ]------------
[  148.978298] kernel BUG at block/genhd.c:544!
[  148.978305] invalid opcode: 0000 [#1] PREEMPT
[  148.978315] last sysfs file: /sys/class/power_supply/BAT0/charge_full
[  148.978322] Modules linked in: test_alloc_disk(-) ppdev lp cpufreq_ondemand cpufreq_conservative ipv6 xt_tcpudp iptable_filter ip_tables x_tables
leds_clevo_mail led_class via via_agp drm agpgart eeprom snd_pcm_oss snd_mixer_oss cpufreq_userspace cpufreq_powersave powernow_k8 fan snd_via82xx_modem
snd_via82xx mousedev snd_ac97_codec snd_mpu401_uart snd_seq_midi snd_seq_midi_event ac97_bus snd_rawmidi snd_pcm snd_seq pcmcia firmware_class snd_timer
snd_seq_device snd ide_cd_mod i2c_viapro snd_page_alloc psmouse serio_raw pcspkr soundcore k8temp hwmon cdrom i2c_core ehci_hcd uhci_hcd 8139too mii bitrev
crc32 usbcore yenta_socket rsrc_nonstatic pcmcia_core video backlight output 8250_pnp 8250 serial_core parport_pc parport battery ac thermal button processor evdev
[  148.978472]
[  148.978480] Pid: 4564, comm: rmmod Not tainted (2.6.28 #5) K8N800
[  148.978488] EIP: 0060:[<c0234868>] EFLAGS: 00210246 CPU: 0
[  148.978502] EIP is at unlink_gendisk+0x58/0x60
[  148.978509] EAX: 00000000 EBX: f4e36d48 ECX: f4f146e0 EDX: 00000000
[  148.978516] ESI: f4e36d48 EDI: f4e36f90 EBP: f60ddf1c ESP: f60ddf18
[  148.978524]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  148.978531] Process rmmod (pid: 4564, ti=f60dc000 task=f4f146e0 task.ti=f60dc000)
[  148.978537] Stack:
[  148.978541]  00000000 f60ddf40 c01cd344 f4e36d48 00000000 00000000 00000003 00000000
[  148.978559]  f815a400 00000000 f60ddf4c f815a01c f815a088 f60ddfb0 c014f1e8 f815a40c
[  148.978578]  74736574 6c6c615f 645f636f 006b7369 ffffffff b80be000 b80be000 00000000
[  148.978599] Call Trace:
[  148.978604]  [<c01cd344>] ? del_gendisk+0x84/0xd0
[  148.978617]  [<f815a01c>] ? test_exit_module+0x1c/0x20 [test_alloc_disk]
[  148.978632]  [<c014f1e8>] ? sys_delete_module+0x158/0x220
[  148.978646]  [<c0103407>] ? sysenter_exit+0xf/0x16
[  148.978658]  [<c01033d9>] ? sysenter_do_call+0x12/0x31
[  148.978667] Code: 00 00 e8 1c da f3 ff 89 d8 e8 c5 c1 ff ff 8b 4b 08 8b 93 28 02 00 00 a1 dc 35 84 c0 e8 62 03 07 00 5b 5d c3 0f 0b eb fe 8d 76 00 <0f> 0b eb
fe 8d 74 26 00 55 89 e5 53 89 d3 83 ec 10 8b 55 10 89
[  148.978773] EIP: [<c0234868>] unlink_gendisk+0x58/0x60 SS:ESP 0068:f60ddf18
[  148.978788] ---[ end trace 4e6bc6983f47e922 ]---

Regards,

	Márton Németh
