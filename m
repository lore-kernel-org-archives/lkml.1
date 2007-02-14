Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXBNJY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXBNJY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbXBNJY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:24:58 -0500
Received: from mx1.suse.de ([195.135.220.2]:54432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179AbXBNJY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:24:57 -0500
Message-ID: <45D2D55F.4060605@suse.de>
Date: Wed, 14 Feb 2007 10:24:47 +0100
From: Gerd Hoffmann <kraxel@suse.de>
Organization: =?ISO-8859-1?Q?SUSE_LINUX_Products_GmbH=2C_GF=3A_?=
 =?ISO-8859-1?Q?Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 02/21] Xen-paravirt: Handle a zero-sized VT console
References: <20070213221729.772002682@goop.org> <20070213221829.513618819@goop.org>
In-Reply-To: <20070213221829.513618819@goop.org>
Content-Type: multipart/mixed;
 boundary="------------040403020007080106070803"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040403020007080106070803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeremy Fitzhardinge wrote:
> If we're running under Xen, then there's no VT console.  This results
> in vc->vc_screenbuf_size == 0, which causes alloc_bootmem to panic.
> Don't bother allocating a vc_screenbuf if its going to be 0 sized.

NAK.

The *real* problem is that the real-mode boot code never ever runs, thus
SCREEN_INFO is not initialized (all zeros), and vgacon doesn't catch
that case.  Instead it thinks it runs on a EGA card with 0 lines and 0
columns.

So better fix vgacon to catch this and switch to the 80x25 dummy console
instead, patch attached.

cheers,

  Gerd


--------------040403020007080106070803
Content-Type: text/plain;
 name="vgacon"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vgacon"

---
 drivers/video/console/vgacon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: paravirt-2.6.20-hg749/drivers/video/console/vgacon.c
===================================================================
--- paravirt-2.6.20-hg749.orig/drivers/video/console/vgacon.c
+++ paravirt-2.6.20-hg749/drivers/video/console/vgacon.c
@@ -372,7 +372,8 @@ static const char *vgacon_startup(void)
 	}
 
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
+	if ((ORIG_VIDEO_MODE == 0x00) ||	/* SCREEN_INFO not initialized */
+	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
 	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
 	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
 	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */

--------------040403020007080106070803--
