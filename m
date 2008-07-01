Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYGARJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYGARJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYGARJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:09:42 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:42672 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbYGARJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:09:40 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for June 30 (USB: cdc-acm)
Date: Tue, 1 Jul 2008 19:10:08 +0200
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <20080630114332.b797e5e4.randy.dunlap@oracle.com> <20080630190125.GA3553@kroah.com>
In-Reply-To: <20080630190125.GA3553@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011910.09251.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 30 Juni 2008 21:01:25 schrieb Greg KH:
> On Mon, Jun 30, 2008 at 11:43:32AM -0700, Randy Dunlap wrote:
> > cdc-acm fails to build when CONFIG_PM=n:
> > 
> > linux-next-20080630/drivers/usb/class/cdc-acm.c: In function 'acm_suspend':
> > linux-next-20080630/drivers/usb/class/cdc-acm.c:1263: error: 'struct usb_device' has no member named 'auto_pm'
> > make[4]: *** [drivers/usb/class/cdc-acm.o] Error 1
> 
> Yeah, known issue due to the pm and usb trees conflicting here.  It will
> be fixed up at the merge time with Linus.

Here's the fix. cdc-wdm has the same problem. The fix is the same.

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oneukum@suse.de>

---

--- linux-2.6.26-greg/drivers/usb/class/cdc-acm.alt.c	2008-07-01 11:22:06.000000000 +0200
+++ linux-2.6.26-greg/drivers/usb/class/cdc-acm.c	2008-07-01 11:24:24.000000000 +0200
@@ -1258,6 +1258,7 @@ static void acm_disconnect(struct usb_in
 		tty_hangup(acm->tty);
 }
 
+#ifdef CONFIG_PM
 static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct acm *acm = usb_get_intfdata(intf);
@@ -1323,6 +1324,8 @@ err_out:
 	mutex_unlock(&acm->mutex);
 	return rv;
 }
+
+#endif /* CONFIG_PM */
 /*
  * USB driver structure.
  */
@@ -1378,10 +1381,14 @@ static struct usb_driver acm_driver = {
 	.name =		"cdc_acm",
 	.probe =	acm_probe,
 	.disconnect =	acm_disconnect,
+#ifdef CONFIG_PM
 	.suspend =	acm_suspend,
 	.resume =	acm_resume,
+#endif
 	.id_table =	acm_ids,
+#ifdef CONFIG_PM
 	.supports_autosuspend = 1,
+#endif
 };
 
 /*
--- linux-2.6.26-greg/drivers/usb/class/cdc-wdm.alt.c	2008-07-01 11:36:03.000000000 +0200
+++ linux-2.6.26-greg/drivers/usb/class/cdc-wdm.c	2008-07-01 11:36:35.000000000 +0200
@@ -750,12 +750,16 @@ static int wdm_suspend(struct usb_interf
 	dev_dbg(&desc->intf->dev, "wdm%d_suspend\n", intf->minor);
 
 	mutex_lock(&desc->plock);
+#ifdef CONFIG_PM
 	if (interface_to_usbdev(desc->intf)->auto_pm && test_bit(WDM_IN_USE, &desc->flags)) {
 		rv = -EBUSY;
 	} else {
+#endif
 		cancel_work_sync(&desc->rxwork);
 		kill_urbs(desc);
+#ifdef CONFIG_PM
 	}
+#endif
 	mutex_unlock(&desc->plock);
 
 	return rv;
