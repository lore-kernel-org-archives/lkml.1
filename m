Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbZLGA3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbZLGA3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934434AbZLGA3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:29:44 -0500
Received: from kroah.org ([198.145.64.141]:34379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432AbZLGANC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:47 2009
Message-Id: <20091207000647.524185088@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henry Gebhardt <gebhardt@astro.uni-tuebingen.de>,
       Oliver Neukum <oliver@neukum.org>
Subject: [044/119] USB: cdc_acm: Fix race condition when opening tty
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=usb-cdc_acm-fix-race-condition-when-opening-tty.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Henry Gebhardt <gebhardt@astro.uni-tuebingen.de>

commit 18a77b5d237a67d2c621a46f5271a3b51da1b380 upstream.

If acm_rx_tasklet() gets called before tty_port_block_til_ready()
returns, then bulk IN urbs may not be sent. This fixes it.

Signed-off-by: Henry Gebhardt <gebhardt@astro.uni-tuebingen.de>
Acked-by: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -609,9 +609,9 @@ static int acm_tty_open(struct tty_struc
 
 	acm->throttle = 0;
 
-	tasklet_schedule(&acm->urb_task);
 	set_bit(ASYNCB_INITIALIZED, &acm->port.flags);
 	rv = tty_port_block_til_ready(&acm->port, tty, filp);
+	tasklet_schedule(&acm->urb_task);
 done:
 	mutex_unlock(&acm->mutex);
 err_out:


