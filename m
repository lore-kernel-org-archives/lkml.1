Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbYAEWeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbYAEWeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 17:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYAEWdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 17:33:52 -0500
Received: from dns.vs-node3.de ([87.106.12.105]:60798 "EHLO
	aragorn.vidconference.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYAEWdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 17:33:51 -0500
Date: Sat, 5 Jan 2008 23:33:39 +0100
To: linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org
Subject: Regression: VIDIOCGMBUF ioctl hangs on bttv driver (2.6.24-rc6)
Message-ID: <20080105223338.GA18690@vidsoft.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Gregor Jasny <jasny@vidsoft.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

During some tests I've noticed that the VIDIOCGMBUF ioctl hangs on my
bttv video device. It simply does not return and the process is stuck in
the D+ state. With Kernel 2.6.22.9 the (attached) testcase works like a
charm. The V4L2 interface is working with 2.6.24, too (at least displays
xawtv the usual pixel snow).

Hard and Software:
64 bit Linux 2.6.24-rc6 (todays pull) on a Intel Core 2 Duo

WinTV PCI:
05:02.0 0400: 109e:036e (rev 02)
05:02.1 0480: 109e:0878 (rev 02)

dmesg:
Rincewind:~# dmesg |grep bttv
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 2) at 0000:05:02.0, irq: 23, latency: 64, mmio: 0xdfefe000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
bttv0: Hauppauge eeprom indicates model#61324
bttv0: tuner type=14
bttv0: i2c: checking for MSP34xx @ 0x80... found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok

from /proc/interrupts:
 23:      55900          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb5, bttv0

If I could help with more logs, a bisection, some debug printks, please contact me.

Thanks!

Gregor

--vtzGhvizbBRQ85DL
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="bttvregression.c"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <errno.h>

#include <sys/ioctl.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

#include <linux/ioctl.h>
#include <linux/videodev.h>

int main( int argc, char *argv[])
{
	const char device[] = "/dev/video0";
	int r;

	int fd = open (device, O_RDWR);
	assert(fd);

	struct video_mbuf mbuf = { 0 };
	r = ioctl (fd, VIDIOCGMBUF, &mbuf);
	assert (r == 0);

	printf ("Frames: %i\n", mbuf.frames);	

	close (fd);

	return 0;
}

--vtzGhvizbBRQ85DL--
