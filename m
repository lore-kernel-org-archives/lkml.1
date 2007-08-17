Return-Path: <linux-kernel-owner+w=401wt.eu-S1765958AbXHQVIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765958AbXHQVIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 17:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXHQVIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 17:08:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18844 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbXHQVIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 17:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DqItJBeok03ic+eaPmhfgCYC1oMp5bcSkoagCTiHssVOcZzQ4sv0cNDNBnL7lvqE7ZVxjXQXDF5j1tUwi29bHrpprJXJ5NEx0XL0oXtHgYjUivWj4Z9CTTsY0UlbxlZNUbzUNY2h3WnJBGrPSWADn/WcJ5X30/jk6/7uvfjXFrk=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Marcio Saito <marcio@cyclades.com>
Subject: [PATCH] Cyclades: Avoid label defined but not used warning
Date: Fri, 17 Aug 2007 23:05:23 +0200
User-Agent: KMail/1.9.7
Cc: Randolph Bentson <bentson@grieg.seaslug.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708172305.23730.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't like compiler warnings, especially not when they are easy to 
avoid.

Building cyclades driver without CONFIG_PCI currently results in this :

   CC      drivers/char/cyclades.o
 drivers/char/cyclades.c: In function 'cy_init':
 drivers/char/cyclades.c:5488: warning: label 'err_unr' defined but not used

That's easily avoided, with no ill effects by simply moving what's 
under the 'err_unr' label (used from only a single location) inside 
the existing #ifdef - so that's what this patch does.

Compile tested on i386 only. I don't have the hardware to do any 
other testing.

Please consider applying.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/char/cyclades.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 9e0adfe..858bdab 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -5480,13 +5480,13 @@ static int __init cy_init(void)
 #ifdef CONFIG_PCI
 	/* look for pci boards */
 	retval = pci_register_driver(&cy_pci_driver);
-	if (retval && !nboards)
-		goto err_unr;
+	if (retval && !nboards) {
+		tty_unregister_driver(cy_serial_driver);
+		goto err_frtty;
+	}
 #endif
 
 	return 0;
-err_unr:
-	tty_unregister_driver(cy_serial_driver);
 err_frtty:
 	put_tty_driver(cy_serial_driver);
 err:


