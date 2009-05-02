Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZEBUTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZEBUTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbZEBUTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:19:43 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34990 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbZEBUTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q5TdtqO+IGwgsmg9/Et2TPUcum4GAC9EdUeNv2G5T2e7K2tIA9LVfblY7xQhfs1pso
         IX9BwvKRt6bVvgS+vpfAVuwBy/3dHZ8aXWvof6oFR43Y+ZopnD6QqkA6ABjjI1Mjb98v
         hjXogg6S9AEBzmVg2REj/01ZxXOOMvnMd2rUs=
MIME-Version: 1.0
In-Reply-To: <1241293366.4412.14.camel@localhost.localdomain>
References: <49FC2455020000BF000290DA@mailgw2.hevs.ch>
	 <a8e1da0905020708j54cda260tac256469498f6ce3@mail.gmail.com>
	 <1241293366.4412.14.camel@localhost.localdomain>
Date: Sat, 2 May 2009 13:19:40 -0700
Message-ID: <dd18b0c30905021319u79bc94d0ned9c6333e0408818@mail.gmail.com>
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
From: Justin Mattock <justinmattock@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, Marc Pignat <Marc.Pignat@hevs.ch>,
       jkosina@suse.cz, ext-roger.quadros@nokia.com,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 2, 2009 at 12:42 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
>> >>> > Subject: bluetooth: Fix serialization when adding/deleting connections in hci_sysfs
>> >>> >
>> >>> > add_conn and del_conn should be serialized, but flush_workqueue can't be used
>> >>> > by the worker thread on it's own queue, so use flush_work to serialize add_conn
>> >>> > and del_conn against each other.
>> >>> >
>> >>> > Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>
>> >>>
>> >>> Acked-by: Jiri Kosina <jkosina@suse.cz>
>> >>>
>> >>> FWIW.
>> >>
>> >>nak from my side since I think it is the wrong fix. We really wanna wait
>> >>for all works to finish here. This includes work from other connection
>> >>attempts or terminations.
>> >
>> > IMHO, there is no need to wait for work currently running, since this is a
>> > singlethread workqueue.
>>
>> Yes, sounds right.
>>
>> >
>> > But it is perhaps simpler to use a lock (mutex or watherver locking primitive).
>>
>> I'm here a little bit late. Marcel, I'm quite busy recently, I just
>> see the commit and then this thread.
>>
>> Let me explain why I add two workqueue originally,  because workqueue
>> will be defered, so   we must guarantee "connection deletion" finished
>> before "connection adding with same bt addr",  or the "connection
>> adding" will fail.
>>
>> On the other hand flush "adding" workqueue in "connection deletion"
>> function is not necessary.
>>
>> To fix this bug, I think we can just use the two work struct for
>> add/del, at the same time keeping the original two workqueue.
>>
>> Please see following patch for this, (building-test only, I have no
>> bluetooth device at hand, I can test this the day after tommorrow)
>
> so I spent the whole day figuring out what is going on here and we keep
> making the wrong assumptions over and over again.
>
> First of all, we only add the sysfs device when we have a successful
> connection. And we identify it with the handle. This means that we can
> NOT have any name clashes anymore since the controller has to make sure
> a handle is only assigned once. Previously we did this on the BD_ADDR
> value and that lead to it. That is no longer the case.
>
> Second of all the two work queues introduces way too much complexity for
> a really simple task of adding and removing a sysfs device entry.
>
> The real problem we have right now are that we are not initializing the
> sysfs device when creating the hci_conn. This is just wrong and can lead
> to all kinds of weird invalid data access. And as a result the adding of
> the sysfs device should only set the name and add it.
>
> We also check device_registered before making sure that device_add has
> been run. And instead of adding more locking or crazy work queue
> dependencies, we should use the single thread work queue to ensure the
> correct order of things.
>
> The attached patch introduces a hci_conn_init_sysfs step to make sure we
> setup the sysfs device correctly. I left the flush_work calls, but I
> think they are not needed since a del_conn before add_conn is no longer
> possible now.
>
> Regards
>
> Marcel
>
>

well it seems your not the only one
with a broken bluetooth(latest git pull
this morning)
this is what dmesg shows:

[   64.484350] ------------[ cut here ]------------
[   64.484357] WARNING: at kernel/workqueue.c:371
flush_cpu_workqueue+0x26/0x6b()
[   64.484363] Hardware name: MacBookPro2,2
[   64.484366] Modules linked in: radeon drm agpgart bnep
snd_hda_codec_idt firewire_ohci firewire_core snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm ohci1394 snd_timer ath9k ieee1394 sky2
ehci_hcd snd_page_alloc i2c_i801 battery joydev evdev ac video
uhci_hcd thermal button hci_uart sco rfcomm btusb hidp l2cap bluetooth
ipmi_watchdog ipmi_msghandler uvcvideo isight_firmware uinput
arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables
coretemp acpi_cpufreq processor appletouch applesmc
[   64.484473] Pid: 762, comm: bluetooth Not tainted 2.6.30-rc4 #7
[   64.484477] Call Trace:
[   64.484488]  [<c0126c01>] warn_slowpath+0x71/0x87
[   64.484496]  [<c011c746>] ? dequeue_entity+0x20/0x206
[   64.484503]  [<c011c746>] ? dequeue_entity+0x20/0x206
[   64.484511]  [<c011cfc6>] ? dequeue_task_fair+0x57/0x5c
[   64.484520]  [<c011950c>] ? dequeue_task+0x12b/0x13e
[   64.484530]  [<c0238f39>] ? _raw_spin_unlock+0x75/0x7a
[   64.484539]  [<c03e45bd>] ? _spin_unlock_irq+0x8/0x10
[   64.484547]  [<c0123433>] ? finish_task_switch+0x4d/0xa2
[   64.484555]  [<c03e29e0>] ? __schedule+0x80d/0x87d
[   64.484563]  [<c0133e85>] flush_cpu_workqueue+0x26/0x6b
[   64.484572]  [<c0238f39>] ? _raw_spin_unlock+0x75/0x7a
[   64.484579]  [<c013405c>] flush_workqueue+0x2b/0x49
[   64.484602]  [<f877e91c>] add_conn+0x10/0x34 [bluetooth]
[   64.484609]  [<c0133c6a>] worker_thread+0x13b/0x1b9
[   64.484628]  [<f877e90c>] ? add_conn+0x0/0x34 [bluetooth]
[   64.484637]  [<c0136d99>] ? autoremove_wake_function+0x0/0x2f
[   64.484644]  [<c0133b2f>] ? worker_thread+0x0/0x1b9
[   64.484652]  [<c0136ac0>] kthread+0x46/0x6a
[   64.484659]  [<c0136a7a>] ? kthread+0x0/0x6a
[   64.484667]  [<c01033a7>] kernel_thread_helper+0x7/0x10
[   64.484673] ---[ end trace bd97c7b15860436c ]---
[   64.643667] BUG: unable to handle kernel NULL pointer dereference at 00000020
[   64.643678] IP: [<c01be904>] sysfs_addrm_start+0x21/0x8f
[   64.643692] *pde = 00000000
[   64.643698] Oops: 0000 [#1] SMP
[   64.643705] last sysfs file: /sys/devices/platform/applesmc.768/light
[   64.643711] Modules linked in: radeon drm agpgart bnep
snd_hda_codec_idt firewire_ohci firewire_core snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm ohci1394 snd_timer ath9k ieee1394 sky2
ehci_hcd snd_page_alloc i2c_i801 battery joydev evdev ac video
uhci_hcd thermal button hci_uart sco rfcomm btusb hidp l2cap bluetooth
ipmi_watchdog ipmi_msghandler uvcvideo isight_firmware uinput
arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables
coretemp acpi_cpufreq processor appletouch applesmc
[   64.643810]
[   64.643817] Pid: 1584, comm: bluetoothd Tainted: G        W
(2.6.30-rc4 #7) MacBookPro2,2
[   64.643823] EIP: 0060:[<c01be904>] EFLAGS: 00010286 CPU: 0
[   64.643829] EIP is at sysfs_addrm_start+0x21/0x8f
[   64.643834] EAX: f5796000 EBX: 00000000 ECX: 00000000 EDX: c054acc0
[   64.643840] ESI: f5797c60 EDI: f5797c70 EBP: f5797c54 ESP: f5797c48
[   64.643845]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   64.643851] Process bluetoothd (pid: 1584, ti=f5796000
task=f56c9860 task.ti=f5796000)
[   64.643856] Stack:
[   64.643860]  f4936058 f5797c60 00000000 f5797c7c c01bedaf fffffff4
00000000 00000000
[   64.643874]  00000000 00000000 f4ef4d1c f48129b4 f48129b4 f5797c90
c01bee18 f5797c88
[   64.643889]  f5797c90 f4ef4d1c f5797cac c0230e4a ffffffff fffffffe
f4ef4d1c f48129b4
[   64.643906] Call Trace:
[   64.643910]  [<c01bedaf>] ? create_dir+0x3a/0x76
[   64.643918]  [<c01bee18>] ? sysfs_create_dir+0x2d/0x3d
[   64.643926]  [<c0230e4a>] ? kobject_add_internal+0xb0/0x15f
[   64.643936]  [<c0230faa>] ? kobject_add_varg+0x31/0x3d
[   64.643945]  [<c0231020>] ? kobject_add+0x43/0x49
[   64.643952]  [<c02b2f0d>] ? device_add+0xd5/0x451
[   64.643962]  [<c0236f9c>] ? kvasprintf+0x38/0x43
[   64.643971]  [<c0230f73>] ? kobject_set_name_vargs+0x46/0x4c
[   64.643979]  [<c0322b1f>] ? hid_add_device+0x12b/0x147
[   64.643991]  [<f87a4091>] ? hidp_add_connection+0x2c0/0x539 [hidp]
[   64.644006]  [<f87a451d>] ? hidp_sock_ioctl+0xe2/0x1e6 [hidp]
[   64.644020]  [<c018141a>] ? check_object+0x136/0x190
[   64.644029]  [<c0208fb2>] ? avc_has_perm+0x3c/0x46
[   64.644038]  [<c020a123>] ? inode_has_perm+0x5b/0x65
[   64.644048]  [<c03413ee>] ? sock_ioctl+0x1b9/0x1dd
[   64.644057]  [<c0341235>] ? sock_ioctl+0x0/0x1dd
[   64.644064]  [<c0190ff7>] ? vfs_ioctl+0x18/0x71
[   64.644073]  [<c01914b1>] ? do_vfs_ioctl+0x461/0x49f
[   64.644082]  [<c020a1a9>] ? file_has_perm+0x7c/0x85
[   64.644091]  [<c0191530>] ? sys_ioctl+0x41/0x61
[   64.644099]  [<c020620e>] ? security_file_ioctl+0x10/0x13
[   64.644107]  [<c0191530>] ? sys_ioctl+0x41/0x61
[   64.644115]  [<c0102914>] ? sysenter_do_call+0x12/0x28
[   64.644125] Code: 45 f0 8d 65 f4 5b 5e 5f c9 c3 55 b9 04 00 00 00
89 e5 57 89 c7 56 89 c6 53 31 c0 89 d3 f3 ab b8 ac ac 54 c0 89 16 e8
a7 49 22 00 <8b> 53 20 b9 88 e4 1b c0 53 a1 80 0f 68 c0 e8 59 70 fd ff
89 c3
[   64.644213] EIP: [<c01be904>] sysfs_addrm_start+0x21/0x8f SS:ESP
0068:f5797c48
[   64.644223] CR2: 0000000000000020
[   64.644229] ---[ end trace bd97c7b15860436d ]---


-- 
Justin P. Mattock
