Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbXD2LSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbXD2LSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbXD2LSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:18:03 -0400
Received: from styx.suse.cz ([82.119.242.94]:53822 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756371AbXD2LSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 07:18:00 -0400
Date: Sun, 29 Apr 2007 13:18:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Vincent ETIENNE <ve@vetienne.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Paul Walmsley <paul@booyaka.com>
Subject: Re: [linux-usb-devel] USB HID bug (was [PROBLEM] Bonding driver in
 linux-2.6.21-rc6-mm1)
In-Reply-To: <200704282243.54950.ve@vetienne.net>
Message-ID: <Pine.LNX.4.64.0704291315080.7370@jikos.suse.cz>
References: <Pine.LNX.4.44L0.0704281547260.14565-100000@netrider.rowland.org>
 <200704282243.54950.ve@vetienne.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Vincent ETIENNE wrote:

> > No, it isn't a problem in the USB core.  The device itself is messed up;
> > it really does report idVendor and idProduct both equal to 0.
> So is it just a scary trace but without consequence that i could ignored 
> ? May i ask you what is the device which is messed up ? ( Maybe should i 
> change it ? )

Hi Vincent,

yes, the device is messed up, but it shouldn't have any consequences for 
you - the HID driver is able to correctly handle that, so as soon as we 
don't need to add any extra quirks for such device, everything should be 
fine. I have removed the WARN_ON from the code in my tree. I think we 
still don't want users to add quirks for such broken devices (as it would 
collide with hid_blakclist[] terminator), so I have left the initial 
condition in usbhid_modify_dquirk() untouched.


From: Jiri Kosina <jkosina@suse.cz>

USB HID: don't warn on idVendor == 0

It turns out that there are broken devices out there that incorrectly
report VID/PID as 0x000, see http://lkml.org/lkml/2007/4/27/496

Therefore we should not confuse users by dumping warnings and stacktraces
in such situation. It is not possible to add quirks for such horribly
broken devices, but currently that's not needed.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 27188bd..17a8755 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -477,8 +477,6 @@ static struct hid_blacklist *usbhid_exis
 	struct quirks_list_struct *q;
 	struct hid_blacklist *bl_entry = NULL;
 
-	WARN_ON(idVendor == 0);
-
 	list_for_each_entry(q, &dquirks_list, node) {
 		if (q->hid_bl_item.idVendor == idVendor &&
 				q->hid_bl_item.idProduct == idProduct) {
