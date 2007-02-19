Return-Path: <linux-kernel-owner+w=401wt.eu-S1750867AbXBSKaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750867AbXBSKaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXBSKaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:30:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49512 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbXBSKaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:30:12 -0500
Date: Mon, 19 Feb 2007 02:29:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Message-Id: <20070219022955.f734006a.akpm@linux-foundation.org>
In-Reply-To: <200702191101.09192.eike-kernel@sf-tec.de>
References: <200702161437.34063.eike-kernel@sf-tec.de>
	<20070216160920.27c1167a.akpm@linux-foundation.org>
	<200702191101.09192.eike-kernel@sf-tec.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007 11:01:02 +0100 Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> Andrew Morton wrote:
> > On Fri, 16 Feb 2007 14:37:28 +0100
> > Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> 
> > > I can't bring up my machine with root LVM anymore using x86_64. The same
> > > machine from same kernel tree boots fine as x86. The error message is
> > > quoted in subject. The tree is at
> > > 86a71dbd3e81e8870d0f0e56b87875f57e58222b (for those not using git:
> > > somewhere after 2.6.20).
> >
> > Does this fix it?  I don't see why it would, but this was recently added.
> 
> Yes. But now usb complains "unable to get a dynamic major for usb endpoints". 
> Nevertheless the USB mouse works.
> 

That's just nutty.

Can you add this, see what it says just prior to that "unable to get a
dynamic major for usb endpoints"?


--- a/fs/char_dev.c~a
+++ a/fs/char_dev.c
@@ -108,15 +108,21 @@ __register_chrdev_region(unsigned int ma
 	/* temporary */
 	if (major == 0) {
 		for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
+			printk("%s: i = %d: ", __FUNCTION__, i);
 			/*
 			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
 			 * majors
 			 */
 			if ((60 <= i && i <= 63) || (120 <= i && i <= 127) ||
-					(240 <= i && i <= 254))
+					(240 <= i && i <= 254)) {
+				printk("skipped\n");
 				continue;
-			if (chrdevs[i] == NULL)
+			}
+			if (chrdevs[i] == NULL) {
+				printk("free\n");
 				break;
+			}
+			printk("used\n");
 		}
 
 		if (i == 0) {
_

