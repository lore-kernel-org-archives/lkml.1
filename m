Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYLKTYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYLKTYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbYLKTSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:24 -0500
Received: from kroah.org ([198.145.64.141]:55937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757086AbYLKTSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:12 -0500
Date: Thu, 11 Dec 2008 11:14:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Wolfgang Ocker <weo@reccoware.de>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 18/83] spi: avoid spidev crash when device is removed
Message-ID: <20081211191409.GR5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="spi-avoid-spidev-crash-when-device-is-removed.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfgang Ocker <weo@reccoware.de>

commit aaacf4bb51b243875b203e6ff73b5047636b4efa upstream.

I saw a kernel oops in spidev_remove() when a spidev device was registered
and I unloaded the SPI master driver:

Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc01c0c50
Oops: Kernel access of bad area, sig: 11 [#1]
CDSPR
Modules linked in: spi_ppc4xx(-)
NIP: c01c0c50 LR: c01bf9e4 CTR: c01c0c34
REGS: cec89c30 TRAP: 0300   Not tainted  (2.6.27.3izt)
MSR: 00021000 <ME>  CR: 24000228  XER: 20000007
DEAR: 00000004, ESR: 00800000
TASK = cf889040[2070] 'rmmod' THREAD: cec88000
GPR00: 00000000 cec89ce0 cf889040 cec8e000 00000004 cec8e000 ffffffff 00000000
GPR08: 0000001c c0336380 00000000 c01c0c34 00000001 1001a338 100e0000 100df49c
GPR16: 100b54c0 100df49c 100ddd20 100f05a8 100b5340 100efd68 00000000 00000000
GPR24: 100ec008 100f0428 c0327788 c0327794 cec8e0ac cec8e000 c0336380 00000000
NIP [c01c0c50] spidev_remove+0x1c/0xe4
LR [c01bf9e4] spi_drv_remove+0x2c/0x3c
Call Trace:
[cec89d00] [c01bf9e4] spi_drv_remove+0x2c/0x3c
[cec89d10] [c01859a0] __device_release_driver+0x78/0xb4
[cec89d20] [c0185ab0] device_release_driver+0x28/0x44
[cec89d40] [c0184be8] bus_remove_device+0xac/0xd8
[cec89d60] [c0183094] device_del+0x100/0x194
[cec89d80] [c0183140] device_unregister+0x18/0x30
[cec89da0] [c01bf30c] __unregister+0x20/0x34
[cec89db0] [c0182778] device_for_each_child+0x38/0x74
[cec89de0] [c01bf2d0] spi_unregister_master+0x28/0x44
[cec89e00] [c01bfeac] spi_bitbang_stop+0x1c/0x58
[cec89e20] [d908a5e0] spi_ppc4xx_of_remove+0x24/0x7c [spi_ppc4xx]
[...]

IMHO a call to spi_set_drvdata() is missing in spidev_probe(). The patch
below helped.

Signed-off-by: Wolfgang Ocker <weo@reccoware.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/spi/spidev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -598,7 +598,9 @@ static int spidev_probe(struct spi_devic
 	}
 	mutex_unlock(&device_list_lock);
 
-	if (status != 0)
+	if (status == 0)
+		spi_set_drvdata(spi, spidev);
+	else
 		kfree(spidev);
 
 	return status;

