Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZAHG1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZAHG1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZAHG1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:27:42 -0500
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:60710 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZAHG1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:27:41 -0500
Message-ID: <49659CD8.8080207@freemail.hu>
Date: Thu, 08 Jan 2009 07:27:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pair of alloc_disk()? + OOPS
References: <496444F9.2020202@freemail.hu> <49659595.8020805@freemail.hu>
In-Reply-To: <49659595.8020805@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32720; Body=1 Fuz1=1
	Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> Németh Márton wrote:
>> Hi,
>>
>> I cannot find free_disk() or similar function which takes "struct gendisk"
>> as a parameter and can do the reverse thing what alloc_disk() do.
>>
>> Could you please give me a hint what would be the correct function call
>> in the following example in test_exit_module() so the module do not leak?
>>
>>
>> #include <linux/module.h>
>> #include <linux/genhd.h>
>>
>> MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
>> MODULE_DESCRIPTION("Test alloc_disk");
>> MODULE_LICENSE("GPL");
>>
>> static struct gendisk *gd_ptr;
>>
>> static int test_init_module(void)
>> {
>>         printk(KERN_DEBUG "starting module\n");
>>
>>         gd_ptr = alloc_disk(1);
>>         if (!gd_ptr) {
>>                 return -ENOMEM;
>>         }
>>
>>         printk(KERN_DEBUG "gd_ptr after alloc=%p\n", gd_ptr);
>>
>>         return 0;
>> }
>>
>>
>> static void test_exit_module(void)
>> {
>>         printk(KERN_DEBUG "unloading module\n");
>>
>>         /* FIXME: no free_disk(gd_ptr) is available */
>> }
>>
>> module_init(test_init_module);
>> module_exit(test_exit_module);
> 
> I found a solution in "Linux Device Drivers, Third Edition", in chapter 16
> "Block drivers" (page 468) where del_gendisk() is mentioned, so the
> test_exit_module() should look like:
> 
> static void test_exit_module(void)
> {
>         printk(KERN_DEBUG "unloading module\n");
> 
>         del_gendisk(gd_ptr);
> 
> }
> 
> However, when I unload this module (also attached), I get the following
> oops message in dmesg with kernel 2.6.28:
> 
> [ 2164.859107] starting module
> [ 2164.859132] gd_ptr after alloc=f60f2a30
> [ 2246.611974] unloading module
> [ 2246.612648] BUG: unable to handle kernel NULL pointer dereference at 00000164
> [ 2246.612666] IP: [<c0172266>] bdi_unregister+0x6/0x30
> [ 2246.612684] *pde = 00000000
> [ 2246.612694] Oops: 0000 [#1] PREEMPT
> [ 2246.612703] last sysfs file: /sys/class/power_supply/BAT0/charge_full
> [ 2246.612711] Modules linked in: test_alloc_disk(-) nls_iso8859_2 nls_cp437 vfat fat nls_base sd_mod usb_storage scsi_mod ppdev lp cpufreq_ondemand
> cpufreq_conservative ipv6 xt_tcpudp iptable_filter ip_tables x_tables leds_clevo_mail led_class via via_agp drm agpgart eeprom snd_pcm_oss snd_mixer_oss
> cpufreq_userspace cpufreq_powersave powernow_k8 fan snd_via82xx snd_via82xx_modem snd_mpu401_uart snd_seq_midi snd_seq_midi_event pcmcia firmware_class
> snd_ac97_codec ac97_bus mousedev snd_rawmidi snd_pcm snd_seq snd_timer snd_seq_device ide_cd_mod snd i2c_viapro yenta_socket rsrc_nonstatic 8139too psmouse
> serio_raw k8temp hwmon pcspkr cdrom snd_page_alloc soundcore 8250_pnp i2c_core ehci_hcd uhci_hcd pcmcia_core usbcore mii bitrev crc32 video backlight output
> 8250 serial_core parport_pc parport battery ac thermal button processor evdev
> [ 2246.612866]
> [ 2246.612874] Pid: 5121, comm: rmmod Not tainted (2.6.28 #3) K8N800
> [ 2246.612881] EIP: 0060:[<c0172266>] EFLAGS: 00210206 CPU: 0
> [ 2246.612889] EIP is at bdi_unregister+0x6/0x30
> [ 2246.612895] EAX: 000000fc EBX: 000000fc ECX: f60f2b48 EDX: c03cb301
> [ 2246.612901] ESI: f60f2a30 EDI: f60f2c78 EBP: d348df10 ESP: d348df0c
> [ 2246.612908]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [ 2246.612915] Process rmmod (pid: 5121, ti=d348c000 task=d372c860 task.ti=d348c000)
> [ 2246.612920] Stack:
> [ 2246.612924]  f60f2a30 d348df1c c02347f6 00000000 d348df40 c01cd344 f60f2a30 00000000
> [ 2246.612941]  00000000 00000003 00000000 f821d400 00000000 d348df4c f821d01c f821d088
> [ 2246.612959]  d348dfb0 c014f1e8 f821d40c 74736574 6c6c615f 645f636f 006b7369 ffffffff
> [ 2246.612979] Call Trace:
> [ 2246.612983]  [<c02347f6>] ? unlink_gendisk+0x26/0x50
> [ 2246.612995]  [<c01cd344>] ? del_gendisk+0x84/0xd0
> [ 2246.613009]  [<f821d01c>] ? test_exit_module+0x1c/0x20 [test_alloc_disk]
> [ 2246.613025]  [<c014f1e8>] ? sys_delete_module+0x158/0x220
> [ 2246.613028]  [<c0103407>] ? sysenter_exit+0xf/0x16
> [ 2246.613028]  [<c01033d9>] ? sysenter_do_call+0x12/0x31
> [ 2246.613028] Code: 00 00 c7 40 24 00 00 00 00 c7 40 28 00 00 00 00 c7 40 58 00 00 00 00 83 c0 2c e8 c6 9b 0c 00 5d c3 8d 74 26 00 55 89 e5 53 89 c3 <8b> 40 68
> 85 c0 74 1f 8b 43 70 e8 3b 8d 0a 00 8b 43 6c e8 33 8d
> [ 2246.613028] EIP: [<c0172266>] bdi_unregister+0x6/0x30 SS:ESP 0068:d348df0c
> [ 2246.613224] ---[ end trace 8f06b3a64120ba58 ]---
> 
> Do anybody know what is wrong with the attached simple example module?

I forget to send the links to the book:
http://lwn.net/Kernel/LDD3/
http://lwn.net/images/pdf/LDD3/ch16.pdf

Regards,

	Márton Németh
