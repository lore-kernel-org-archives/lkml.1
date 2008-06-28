Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYF1KJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYF1KJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 06:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYF1KJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 06:09:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYF1KJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:09:20 -0400
Subject: Re: linux-next: Tree for June 26
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh <jaswinder@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <200806280104.17527.rjw@sisk.pl>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
	 <200806270138.53895.rjw@sisk.pl>
	 <1214563913.10393.180.camel@pmac.infradead.org>
	 <200806280104.17527.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 28 Jun 2008 11:09:14 +0100
Message-Id: <1214647754.10393.255.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-28 at 01:04 +0200, Rafael J. Wysocki wrote:
> Unfortunately, it doesn't help.  The driver either oopses or just doesn't work
> (I don't know what exactly causes it to oops, although that only happens during
> boot).

Hm, do you get any more useful output with this...?

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 8c0631b..3bcf128 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -5670,6 +5670,11 @@ static int tg3_load_firmware_cpu(struct tg3 *tp, u32 cpu_base, u32 cpu_scratch_b
 	int err, lock_err, i;
 	void (*write_op)(struct tg3 *, u32, u32);
 
+	printk("%s, base %x scratch %x,%x info %x,%x,%p[%x,%x...]\n",
+	       __func__, cpu_base, cpu_scratch_base, cpu_scratch_size,
+	       info->fw_base, info->fw_len, info->fw_data, info->fw_data[0],
+	       info->fw_data[1]);
+
 	if (cpu_base == TX_CPU_BASE &&
 	    (tp->tg3_flags2 & TG3_FLG2_5705_PLUS)) {
 		printk(KERN_ERR PFX "tg3_load_firmware_cpu: Trying to load "
@@ -5697,12 +5702,18 @@ static int tg3_load_firmware_cpu(struct tg3 *tp, u32 cpu_base, u32 cpu_scratch_b
 		write_op(tp, cpu_scratch_base + i, 0);
 	tw32(cpu_base + CPU_STATE, 0xffffffff);
 	tw32(cpu_base + CPU_MODE, tr32(cpu_base+CPU_MODE)|CPU_MODE_HALT);
-	for (i = 0; i < (info->fw_len / sizeof(u32)); i++)
+	for (i = 0; i < (info->fw_len / sizeof(u32)); i++) {
+		if ((i < 5) || i > ((info->fw_len / 4) - 5))
+			printk("Write word at %x: %x\n", 
+			       cpu_scratch_base +
+			       (info->fw_base & 0xffff) +
+			       (i * sizeof(u32)),
+			       be32_to_cpu(info->fw_data[i]));
 		write_op(tp, (cpu_scratch_base +
 			      (info->fw_base & 0xffff) +
 			      (i * sizeof(u32))),
 			      be32_to_cpu(info->fw_data[i]));
-
+	}
 	err = 0;
 
 out:
@@ -5716,6 +5727,8 @@ static int tg3_load_5701_a0_firmware_fix(struct tg3 *tp)
 	const __be32 *fw_data;
 	int err, i;
 
+	printk("%s, fw %p\n", __func__, tp->fw);
+
 	fw_data = (void *)tp->fw->data;
 
 	/* Firmware blob starts with version numbers, followed by
@@ -5778,6 +5791,8 @@ static int tg3_load_tso_firmware(struct tg3 *tp)
 	if (tp->tg3_flags2 & TG3_FLG2_HW_TSO)
 		return 0;
 
+	printk("%s, fw %p\n", __func__, tp->fw);
+
 	fw_data = (void *)tp->fw->data;
 
 	/* Firmware blob starts with version numbers, followed by
@@ -12253,6 +12268,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 	if (fw_name) {
 		const __be32 *fw_data;
 
+		printk("tg3 request firmware %s\n", fw_name);
 		err = request_firmware(&tp->fw, fw_name, &tp->pdev->dev);
 		if (err) {
 			printk(KERN_ERR "tg3: Failed to load firmware \"%s\"\n",
@@ -12273,7 +12289,9 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 			err = -EINVAL;
 			goto err_out_fw;
 		}
-	}
+		printk("tg3 loaded fw %s, len %x\n", fw_name, tp->fw_len);
+	} else
+		printk("tg3 no firmware\n");
 
 	/* TSO is on by default on chips that support hardware TSO.
 	 * Firmware TSO on older chips gives lower performance, so it

> However, Ingo wrote that
> 
> " the firmware image, if i compare the before and after tg3FwText 
> hex dump is blatantly different. Is this some different format, or did 
> the "convert to request_firmware()" commit also embed an undocumented 
> version jump in the binary blob that is loaded to your card? "

Where did Ingo write that? Google doesn't show any instance of those
words other than your own quote, and I'm fairly sure he didn't Cc me
when he said it.

The firmware images are a straight binary dump of what was in the driver
in hex form, stored big-endian, and with a header at the beginning thus:
{
  unsigned char major, minor, fix, pad;
  __be32 load_address;
  __be32 length; // including BSS to be zeroed
  __be32 data[];
}

The TEXT/RODATA/DATA regions were all fairly much contiguous anyway, so
they just appear one after the other in the data[] blob. Let's run 'make
firmware_install' and look at usr/lib/firmware/tigon/tg3.bin... (with
'od -A x -t x4' on a big-endian box):

	000000 00000000 08000000 00000a80 00000000
	000010 10000003 00000000 0000000d 0000000d
	000020 3c1d0800 37bd3ffc 03a0f021 3c100800
	   ... text ...
	0009b0 00851024 1443ffe8 00851824 27bd0008
	0009c0 03e00008 00000000 00000000 35373031
	0009d0 726c7341 00000000 00000000 53774576
	   ... data ...
	000a10 6c457272 00000000 00000000 4d61696e
	000a20 43707542 00000000 00000000 00000000
	000a30 00000000 00000000 00000000 00000000
	*
	000a60 00000000 00000000 00000000

That does look like Tg3FwText[] starts at 0xC after the header (with
0x0, 0x10000003, 0x0, 0xd, 0xd, 0x3c1d0800...) as it should. It ends
with 0x00851824, 0x27bd0008, 0x03e00008, 0x0, 0x0 as it should, at
offset 0x9cc in the file (there's a superfluous 0 on the end of each
word array in the driver). Then you see tg3FwRodata[] starting
0x35373031, 0x726c7341, 0x0, 0x0, 0x53774576..., and tg3FwData[] is all
zeroes at the end.

I don't think you're using that firmware though; I think you're using
tg3_tso5.bin? That one looks fine to me too -- Tg3Tso5Fw[] starts with
0x0c004003, 0x0, 0x10f04, 0x0, 0x10000003 at offset 0xC in the file, as
it should, and ends at 0xe9C with 0x03e00008, 0xac4b001c, 0x0, 0x0. Then
the 0x50 bytes of Tg3Tso5FwRodata[] appear from 0xe9c-0xeec as they
should. And then there's a gap between the end of the rodata, and
Tg3TsoData[] at 0xf0c.

	000000 01020000 00010000 00000fd8 0c004003
	000010 00000000 00010f04 00000000 10000003
	   ... text ...
	000e80 ac460010 ac470014 ac4a0018 03e00008
	000e90 ac4b001c 00000000 00000000 4d61696e
	000ea0 43707542 00000000 4d61696e 43707541
	   ... rodata ...
	000ee0 6c457272 00000000 00000000 00000000
	000ef0 00000000 00000000 00000000 00000000
	000f00 00000000 00000000 00000000 00000000
	000f10 73746b6f 66666c64 5f76312e 322e3000
	000f20 00000000 00000000 00000000

I went over the binary files quite carefully, have just done so again,
and I don't see a problem with them. If Ingo sees one, then he's
cleverer than me. But quite naughty for not Ccing me when he pointed it
out.

-- 
dwmw2

