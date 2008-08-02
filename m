Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYHBRMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYHBRMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbYHBRM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:12:29 -0400
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:44971 "EHLO
	young-lust.wild-wind.fr.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbYHBRM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:12:27 -0400
From: Marc Zyngier <maz@misterjones.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG][PATCH][2.6.27-rc1] Fix IHEX firmware generation/loading
Organization: Metropolis -- Nowhere
X-Attribution: maz
Reply-to: maz@misterjones.org
Date: Sat, 02 Aug 2008 19:12:23 +0200
Message-ID: <wrpy73fl4so.fsf@hina.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.70.139
X-SA-Exim-Rcpt-To: dwmw2@infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on young-lust.wild-wind.fr.eu.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I upgraded my console server to 2.6.27-rc1, and found that io_edgeport
was Oops-ing badly. I captured this Oops, with io_edgeport.debug
enabled:

[   27.984039] firmware: requesting edgeport/down.fw
[   29.764896] drivers/usb/serial/io_edgeport.c: downloading firmware version (930) 1.16.4
[   29.764943] drivers/usb/serial/io_edgeport.c: sram_write - 4, 0, 255
[   29.792629] drivers/usb/serial/io_edgeport.c: sram_write - be04, 380, 14393
[   31.449750] drivers/usb/serial/io_edgeport.c: sram_write - 1273, 16a9, 8437
[   31.867944] BUG: unable to handle kernel paging request at c88d9000
[   31.869058] IP: [<c88e60d8>] :io_edgeport:edge_startup+0xc63/0x1597
[   31.869405] *pde = 0690b067 *pte = 00000000 
[   31.869405] Oops: 0000 [#1] 
[   31.869405] Modules linked in: snd_cs4236 snd_cs4236_lib snd_wavefront snd_opl3_lib snd_cs4231_lib snd_pcm snd_hwdep snd_mpu401_uart snd_timer snd_rawmidi snd_page_alloc snd_seq_device snd soundcore psmouse i2c_piix4 usbhid(+) hid serio_raw ff_memless io_edgeport(+) i2c_core usbserial rocket pcspkr evdev ext2 mbcache ide_disk ata_piix ata_generic libata scsi_mod dock uhci_hcd piix ide_pci_generic ide_core usbcore e100 mii
[   31.869405] 
[   31.869405] Pid: 914, comm: modprobe Not tainted (2.6.27-rc1 #1)
[   31.869405] EIP: 0060:[<c88e60d8>] EFLAGS: 00010212 CPU: 0
[   31.869405] EIP is at edge_startup+0xc63/0x1597 [io_edgeport]
[   31.869405] EAX: 00000040 EBX: 75220a75 ECX: 00000006 EDX: 00000040
[   31.869405] ESI: c88d8ffe EDI: c6cd6948 EBP: c69d5800 ESP: c7ac5c58
[   31.869405]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   31.869405] Process modprobe (pid: 914, ti=c7ac4000 task=c6919400 task.ti=c7ac4000)
[   31.869405] Stack: 012560c0 c6c48b40 08082e80 c68fa800 c03228fc c69d5c44 c7ad3de0 127316a9 
[   31.869405]        c88e8616 00001273 00001273 c68fa800 c88d8fd6 2d290046 c6cd6920 00000040 
[   31.869405]        c7ac5ccd c038ff93 00000052 0000000f 00000296 c7ac5ccd 00000006 00000296 
[   31.869405] Call Trace:
[   31.869405]  [<c8876040>] usb_serial_probe+0x935/0xc4a [usbserial]
[   31.869405]  [<c01bcddb>] ida_get_new_above+0xd8/0x1b0
[   31.869405]  [<c0177e08>] find_inode+0x1b/0x56
[   31.869405]  [<c019f5dc>] sysfs_ilookup_test+0x0/0xd
[   31.869405]  [<c0177cb8>] iput+0x21/0x49
[   31.869405]  [<c019fb1b>] sysfs_addrm_finish+0x46/0x16b
[   31.869405]  [<c019f872>] __sysfs_add_one+0x11/0x80
[   31.869405]  [<c8842f6e>] usb_match_one_id+0x1c/0x71 [usbcore]
[   31.869405]  [<c88433fc>] usb_autopm_do_device+0xaa/0xb1 [usbcore]
[   31.869405]  [<c88438bf>] usb_probe_interface+0xdf/0x112 [usbcore]
[   31.869405]  [<c020a26d>] driver_probe_device+0x9c/0x12d
[   31.869405]  [<c020a335>] __driver_attach+0x37/0x55
[   31.869405]  [<c0209d05>] bus_for_each_dev+0x31/0x57
[   31.869405]  [<c020a121>] driver_attach+0x11/0x13
[   31.869405]  [<c020a2fe>] __driver_attach+0x0/0x55
[   31.869405]  [<c020978e>] bus_add_driver+0x91/0x1a7
[   31.869405]  [<c020a499>] driver_register+0x7d/0xd6
[   31.869405]  [<c8843a6e>] usb_register_driver+0x56/0xad [usbcore]
[   31.869405]  [<c8829059>] edgeport_init+0x59/0xa2 [io_edgeport]
[   31.869405]  [<c0137be3>] sys_init_module+0x13f9/0x159e
[   31.869405]  [<c0103842>] syscall_call+0x7/0xb
[   31.869405]  =======================
[   31.869405] Code: 9c 24 86 00 00 00 76 0a 66 c7 84 24 86 00 00 00 40 00 0f b7 94 24 86 00 00 00 8b 7c 24 38 8b 74 24 30 89 d1 89 54 24 3c c1 e9 02 <f3> a5 89 d1 83 e1 03 74 02 f3 a4 8b 8c 24 80 00 00 00 8b 01 8b 
[   31.869405] EIP: [<c88e60d8>] edge_startup+0xc63/0x1597 [io_edgeport] SS:ESP 0068:c7ac5c58
[   31.869405] ---[ end trace ed926a14b0da94f9 ]---

Looks like the machine crashes while sending the firmware to the
device. From the driver POV, it looks awfully wrong!

Looking at the firmware file (firmware/edgeport/down.fw, produced from
firmware/edgeport/down.H16), something is definitly looking funny:

$ od -A x -x firmware/edgeport/down.fw | head
000000 0000 0000 0000 1001 0400 0000 ff00 0000
000010 0000 0002 0280 b044 ff00 0b00 0000 4402
000020 0072 0000 ff00 1300 0000 0002 0013 0000
000030 ff00 1b00 0000 0002 001b 0000 ff00 2300
000040 0000 0002 0023 0000 ff00 2b00 0000 0002
000050 002b 0000 ff00 3300 0000 0002 0033 0000
[...]

You may notice that the ->len field is always set to zero. This is
bad. I tracked it down to firmware/ihex2fw.c::output_records():

       p->len = htonl(p->len);

Given that ->len is an uint16_t, turning this htonl() to htons() helps
a lot:

$ od -A x -x firmware/edgeport/down.fw | head
000000 0000 0000 0400 1001 0400 0000 ff00 0000
000010 0600 0002 0280 b044 ff00 0b00 0300 4402
000020 0072 0000 ff00 1300 0300 0002 0013 0000
000030 ff00 1b00 0300 0002 001b 0000 ff00 2300
000040 0300 0002 0023 0000 ff00 2b00 0300 0002
000050 002b 0000 ff00 3300 0300 0002 0033 0000
[..]

See, our ->len field is back.

And while we're at it, let this function generate six null bytes
instead of five to mark the end of the firmware blob, since that's
what it should be (4 bytes for the address, and 2 for the len).

But now, instead of Oops-ing, the machine refuses to validate the file
(include/linux/ihex.c::ihex_validate_fw() returns -EINVAL). Of course,
since ->len was always zero, and thus indicating the end of the
firmware blob, this function never validated *anything*!

Lets have a look at this:

struct ihex_binrec {
        __be32 addr;
        __be16 len;
        uint8_t data[0];
} __attribute__((aligned(4)));

Hmmm... sizeof(struct ihex_binrec) = 8. Oh wait, we're doing our best
to actually *pack* this stuff... Let's try __attribute__((packed)) !
Now sizeof(struct ihex_binrec) = 6, which is much better, since that's
what ihex2fw is actually dumping.

Hooray, after much head scratching, my EdgePort is back to work, and I
can actually use it to debug my other stuff...

David, please apply.

	M.
---

Fix both the IHEX firmware generation (len field always null, and EOF
marker a byte too short) and loading (struct ihex_binrec needs to be
packed to reflect the on-disk structure).

Signed-of-by: Marc Zyngier <maz@misterjones.org>

diff --git a/firmware/ihex2fw.c b/firmware/ihex2fw.c
index 660b191..8f7fdaa 100644
--- a/firmware/ihex2fw.c
+++ b/firmware/ihex2fw.c
@@ -250,19 +250,19 @@ static void file_record(struct ihex_binrec *record)
 
 static int output_records(int outfd)
 {
-	unsigned char zeroes[5] = {0, 0, 0, 0, 0};
+	unsigned char zeroes[6] = {0, 0, 0, 0, 0, 0};
 	struct ihex_binrec *p = records;
 
 	while (p) {
 		uint16_t writelen = (p->len + 9) & ~3;
 
 		p->addr = htonl(p->addr);
-		p->len = htonl(p->len);
+		p->len = htons(p->len);
 		write(outfd, &p->addr, writelen);
 		p = p->next;
 	}
 	/* EOF record is zero length, since we don't bother to represent
 	   the type field in the binary version */
-	write(outfd, zeroes, 5);
+	write(outfd, zeroes, 6);
 	return 0;
 }
diff --git a/include/linux/ihex.h b/include/linux/ihex.h
index 2baace2..31d8629 100644
--- a/include/linux/ihex.h
+++ b/include/linux/ihex.h
@@ -18,7 +18,7 @@ struct ihex_binrec {
 	__be32 addr;
 	__be16 len;
 	uint8_t data[0];
-} __attribute__((aligned(4)));
+} __attribute__((packed));
 
 /* Find the next record, taking into account the 4-byte alignment */
 static inline const struct ihex_binrec *

-- 
And if you don't know where you're going, any road will take you there...
