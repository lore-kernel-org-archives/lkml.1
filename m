Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYISSF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYISSF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYISSFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:05:16 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:37897 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYISSFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:05:14 -0400
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Fri, 19 Sep 2008 20:05:11 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Janne Grunau <j@jannau.net>,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809151420.32130.jwilson@redhat.com> <200809160008.43218.jwilson@redhat.com>
In-Reply-To: <200809160008.43218.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809192005.12068.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 46d95ba3376559e2858f4f05828cc033
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 06:08, Jarod Wilson wrote:
> Current git tree works for receiving IR signals via lirc_serial (tested by
> Janne) and via lirc_mceusb2 (tested by me). Something is still slightly
> haywire with lirc_i2c though. It registers fine, but IR signals simply
> aren't making it to lircd. Probably unrelated to the dynamic device num
> changes, looking into it.

Thank you for keeping me up to date, here are my test results with todays 
(36e60bd457588b2a2fd37e0c1d0652a9fe214d85) git:

- Compiles fine, except some warnings:

drivers/input/lirc/lirc_dev.h:60:
  warning: 'lirc_buffer_available' defined but not used
drivers/input/lirc/lirc_dev.h:72:
  warning: 'lirc_buffer_write' defined but not used
drivers/input/lirc/lirc_dev.h:56:
  warning: 'lirc_buffer_empty' defined but not used
drivers/input/lirc/lirc_dev.h:60:
  warning: 'lirc_buffer_available' defined but not used
drivers/input/lirc/lirc_dev.h:66:
  warning: 'lirc_buffer_read' defined but not used

- Module loads fine, with this messages:

lirc_dev: IR Remote Control driver registered, major 252 
lirc_serial: auto-detected active low receiver
lirc_dev: lirc_register_driver: sample_rate: 0

- But lircd crashes immediately every time irexec/irw tries to connect:

BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<cabc9006>] :lirc_dev:lirc_buffer_clear+0x6/0x17
*pde = 00000000 
Oops: 0002 [#1] 
Modules linked in: lirc_serial lirc_dev ves1820 arc4 ecb crypto_blkcipher 
cryptomgr crypto_algapi rt61pci rt2x00pci rt2x00lib led_class dvb_ttpci 
saa7146_vv saa7146 videobuf_dma_sg videobuf_core mac80211 videodev 
v4l1_compat ttpci_eeprom ehci_hcd uhci_hcd cfg80211 eeprom_93cx6

Pid: 2501, comm: lircd Not tainted (2.6.27-rc5 #7)
EIP: 0060:[<cabc9006>] EFLAGS: 00010046 CPU: 0
EIP is at lirc_buffer_clear+0x6/0x17 [lirc_dev]
EAX: 00000000 EBX: c7825cc0 ECX: cabc94f1 EDX: 00000246
ESI: fffffff0 EDI: c726537c EBP: c6bdf000 ESP: c6b73eac
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process lircd (pid: 2501, ti=c6b72000 task=c72ef7a0 task.ti=c6b72000)
Stack: cabc958f 00000000 c7825d3c c014e15c 00000000 c6bdf000 c726537c 00000000 
       c014e09b c014b052 c78c2900 c759fd80 c6b73f14 c6bdf000 c6b73f14 00000003 
       c014b156 c6bdf000 00000000 00000000 00000000 c01544ae 00000002 00000026 
Call Trace:
 [<cabc958f>] irctl_open+0x9e/0x131 [lirc_dev]
 [<c014e15c>] chrdev_open+0xc1/0xf6
 [<c014e09b>] chrdev_open+0x0/0xf6
 [<c014b052>] __dentry_open+0xf2/0x1da
 [<c014b156>] nameidata_to_filp+0x1c/0x2c
 [<c01544ae>] do_filp_open+0x28b/0x545
 [<c015bc37>] alloc_fd+0x46/0xad
 [<c014ae8d>] do_sys_open+0x42/0xb6
 [<c014af45>] sys_open+0x1e/0x23
 [<c010297d>] sysenter_do_call+0x12/0x25
 [<c02f0000>] ioctl_standard_iw_point+0x12d/0x200
 =======================
Code: <c7> 40 0c 00 00 00 00 c7 40 08 00 00 00 00 52 9d c3 53 89 c3 8b 40 
EIP: [<cabc9006>] lirc_buffer_clear+0x6/0x17 [lirc_dev] SS:ESP 0068:c6b73eac
---[ end trace 782e5196b9791a10 ]---


If wanted I could start a bisect on this.


Regards,
Stefan
