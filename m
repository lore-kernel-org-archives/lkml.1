Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967798Ab0B0ELM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 23:11:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967772Ab0B0ELL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 23:11:11 -0500
Date: Fri, 26 Feb 2010 20:11:00 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Markus Rechberger <mrechberger@gmail.com>
cc: werner@guyane.dyn-o-saur.com, Greg KH <greg@kroah.com>,
       Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 bugs (USBFS, Intel graphic)
In-Reply-To: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1002261953450.4513@localhost.localdomain>
References: <d9def9db1002261942k27b64dd4g670dd29969c93cbf@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 27 Feb 2010, Markus Rechberger wrote:
> 
> commit d4a4683ca054ed9917dfc9e3ff0f7ecf74ad90d6 upstream.
> 
> this patch breaks isochronous USBFS support, please revert that patch!
> 
> http://sundtek.de/images/tvtime-bildfehler.jpg
> 
> with the patch reverted:
> http://sundtek.de/images/tvtime-working.png

Hmm. That would seem to mean that either the app (tvtime) depended in some 
_really_ interesting way on some random data that was never even 
transferred from the device, or 'urb->actual_length' isn't actually 
reliable in some cases.

Does this patch (_instead_ of reverting things) change any behavior? Do 
you get that warning? It will zero-fill the remainder of the buffer.

(UNTESTED! It compiled for me, and looks ok, but whatever..)

		Linus
---
 drivers/usb/core/devio.c |   53 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index a678186..8afee02 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1305,6 +1305,47 @@ static int proc_unlinkurb(struct dev_state *ps, void __user *arg)
 	return 0;
 }
 
+/*
+ * Fixme! We don't have a good memclear_user(), so we do it with a
+ * stupid copy_to_user() loop from a zero buffer.
+ */
+static int memclear_user(void __user *dst, long len)
+{
+	while (len > 0) {
+		static const char zeroes[128];
+		unsigned long n = len;
+
+		if (n > sizeof(zeroes))
+			n = sizeof(zeroes);
+		if (copy_to_user(dst, zeroes, n))
+			return -EFAULT;
+		dst += n;
+		len -= n;
+	}
+	return 0;
+}
+
+static int copy_buffer_to_user(struct async *as, struct urb *urb)
+{
+	void __user *dst = as->userbuffer;
+	void *src;
+	unsigned long len, full;
+
+	if (!dst)
+		return 0;
+
+	len = urb->actual_length;
+	full = urb->transfer_buffer_length;
+	if (WARN_ONCE(len > full, "actual_length (%lu) > transfer_buffer_length (%lu)", len, full))
+		len = full;
+
+	src = urb->transfer_buffer;
+	if (copy_to_user(dst, src, len))
+		return -EFAULT;
+
+	return memclear_user(dst + len, full - len);
+}
+
 static int processcompl(struct async *as, void __user * __user *arg)
 {
 	struct urb *urb = as->urb;
@@ -1312,10 +1353,8 @@ static int processcompl(struct async *as, void __user * __user *arg)
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer && urb->actual_length)
-		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->actual_length))
-			goto err_out;
+	if (copy_buffer_to_user(as, urb))
+		goto err_out;
 	if (put_user(as->status, &userurb->status))
 		goto err_out;
 	if (put_user(urb->actual_length, &userurb->actual_length))
@@ -1480,10 +1519,8 @@ static int processcompl_compat(struct async *as, void __user * __user *arg)
 	void __user *addr = as->userurb;
 	unsigned int i;
 
-	if (as->userbuffer && urb->actual_length)
-		if (copy_to_user(as->userbuffer, urb->transfer_buffer,
-				 urb->actual_length))
-			return -EFAULT;
+	if (copy_buffer_to_user(as, urb))
+		return -EFAULT;
 	if (put_user(as->status, &userurb->status))
 		return -EFAULT;
 	if (put_user(urb->actual_length, &userurb->actual_length))
