Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZJ0ObK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZJ0ObK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZJ0ObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:31:07 -0400
Received: from mail.nomovok.com ([83.150.122.238]:45007 "EHLO mail.nomovok.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbZJ0ObF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:31:05 -0400
Subject: [PATCH] hso: fix soft-lockup
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti.kaijanmaki@nomovok.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org,
       Jan Dumon <j.dumon@option.com>
In-Reply-To: <20091026194058.GA25263@kroah.com>
References: <1256200578.3057.113.camel@nomovok.homedomain>
	 <20091026171550.GA24910@kroah.com>
	 <1256585855.3591.52.camel@nomovok.homedomain>
	 <20091026194058.GA25263@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 16:26:56 +0200
Message-ID: <1256653616.3591.114.camel@nomovok.homedomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 12:40 -0700, Greg KH wrote:
> Yes, that should be a new patch, especially as it would not be needed
> to fix older kernels for the original bug.
> 
> So, care to send 2 patches?  The debug one isn't needed to be sent to
> the stable@kernel.org address.


Fix soft-lockup in hso.c which is triggered on SMP machine when
modem is removed while file descriptor(s) under /dev are still open:

  old version called kref_put() too early which resulted in destroying
  hso_serial and hso_device objects which were still used later on.

Signed-off-by: Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>
---
 drivers/net/usb/hso.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 746839b..43bc3fc 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1363,7 +1363,7 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 	/* reset the rts and dtr */
 	/* do the actual close */
 	serial->open_count--;
-	kref_put(&serial->parent->ref, hso_serial_ref_free);
+
 	if (serial->open_count <= 0) {
 		serial->open_count = 0;
 		spin_lock_irq(&serial->serial_lock);
@@ -1383,6 +1383,8 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 		usb_autopm_put_interface(serial->parent->interface);
 
 	mutex_unlock(&serial->parent->mutex);
+
+	kref_put(&serial->parent->ref, hso_serial_ref_free);
 }
 
 /* close the requested serial port */
-- 
1.6.3.3

