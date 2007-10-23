Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbXJWB3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbXJWB3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXJWB3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:29:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbXJWB3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:29:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@suse.de
Subject: USB HCD: avoid duplicate local_irq_disable()
Date: Tue, 23 Oct 2007 03:28:31 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <alpine.LFD.0.9999.0710222344580.3167@localhost.localdomain> <200710230306.51606.arnd@arndb.de>
In-Reply-To: <200710230306.51606.arnd@arndb.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, matthew@wil.cx,
       ralf@linux-mips.org, adobriyan@gmail.com, viro@ftp.linux.org.uk,
       viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-usb-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230328.33915.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19wHsu5RpP3uThcvHTu+wgWopSyrn1ZXSt9H7D
 u5EtVOZotfwJSVCOBmLu1arWAzJOP+eJT17eQeUYPwClk/UEyC
 z2FHsF0Gb8/QT5glTd1iA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

usb_hcd_flush_endpoint() has a retry loop that starts with a spin_lock_irq(),
but only gives up the spinlock, not the irq_disable before jumping to the
rescan label.

Split the spin_lock_irq into the retryable part and the local_irq_disable()
that is only done once as a micro-optimization and slight cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

On Tuesday 23 October 2007, I wrote:
> I tried the trivial annotation below and (with lockdep enabled) got a few
> warnings at boot time, but only one that I could still find in the log
> buffer:

One more such example that was not found by lockdep. I guess this counts
as a false positive, as it is clearly harmless, but working around
it is a small optimization for the case where local_irq_disable()
is a hypervisor call.

Should we try to fix this class of (non-)problem in other places?
Will this patch cause a different warning with lockdep since now we
are pairing spin_lock() with spin_unlock_irq()?

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1312,8 +1312,9 @@ void usb_hcd_flush_endpoint(struct usb_device *udev,
 	hcd = bus_to_hcd(udev->bus);
 
 	/* No more submits can occur */
+	local_irq_disable();
 rescan:
-	spin_lock_irq(&hcd_urb_list_lock);
+	spin_lock(&hcd_urb_list_lock);
 	list_for_each_entry (urb, &ep->urb_list, urb_list) {
 		int	is_in;
 
