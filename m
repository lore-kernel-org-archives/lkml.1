Return-Path: <linux-kernel-owner+w=401wt.eu-S965737AbXCGXPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbXCGXPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965738AbXCGXPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:15:53 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57582 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965737AbXCGXPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:15:51 -0500
Date: Wed, 7 Mar 2007 15:12:49 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Marcel Holtmann <marcel@holtmann.org>,
       Don Howard <dhoward@redhat.com>, Harald Welte <laforge@gnumonks.org>
Subject: [patch 103/101] Fix buffer overflow in Omnikey CardMan 4040 driver (CVE-2007-0005)
Message-ID: <20070307231249.GQ10574@sequoia.sous-sol.org>
References: <20070307171035.150802805@mini.kroah.org> <20070307173420.GA24957@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307173420.GA24957@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

Based on a patch from Don Howard <dhoward@redhat.com>

When calling write() with a buffer larger than 512 bytes, the
driver's write buffer overflows, allowing to overwrite the EIP and
execute arbitrary code with kernel privileges.

In read(), there exists a similar problem, but coming from the device.
A malicous or buggy device sending more than 512 bytes can overflow
of the driver's read buffer, with the same effects as above.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/pcmcia/cm4040_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20.1.orig/drivers/char/pcmcia/cm4040_cs.c
+++ linux-2.6.20.1/drivers/char/pcmcia/cm4040_cs.c
@@ -273,6 +273,7 @@ static ssize_t cm4040_read(struct file *
 	DEBUGP(6, dev, "BytesToRead=%lu\n", bytes_to_read);
 
 	min_bytes_to_read = min(count, bytes_to_read + 5);
+	min_bytes_to_read = min_t(size_t, min_bytes_to_read, READ_WRITE_BUFFER_SIZE);
 
 	DEBUGP(6, dev, "Min=%lu\n", min_bytes_to_read);
 
@@ -340,7 +341,7 @@ static ssize_t cm4040_write(struct file 
 		return 0;
 	}
 
-	if (count < 5) {
+	if ((count < 5) || (count > READ_WRITE_BUFFER_SIZE)) {
 		DEBUGP(2, dev, "<- cm4040_write buffersize=%Zd < 5\n", count);
 		return -EIO;
 	}
