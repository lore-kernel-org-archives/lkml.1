Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYCZSc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYCZSc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbYCZScv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:32:51 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:56524 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757400AbYCZScu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:32:50 -0400
Message-ID: <47EA96A4.803@gawab.com>
Date: Wed, 26 Mar 2008 11:32:04 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803191648.59400.jbarnes@virtuousgeek.org> <47E86C60.5040706@gawab.com> <200803251308.43830.jbarnes@virtuousgeek.org>
In-Reply-To: <200803251308.43830.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> So somehow both pipes are getting disabled, and your LCD is getting turned
> off and things never get re-enabled.  The X driver should have turned things
> back on though, after detecting what's available.  Do you have your X logs
> from the working & broken cases?  Also, did you try reproducing the blank
> screen problem w/o gdm enabled as Bryce suggested?  That could help narrow
> down if it's just an intelfb problem vs. a new intelfb/X driver interaction
> bug.
>
> I still don't know why this behavior would have changed between 2.6.24 and
> 2.6.25-rc though... maybe the fb guys have some clue about other fb changes
> that may have affected things.

Ok, I have the X logs:
http://jdserver.homelinux.org/linux/Xorg.0.log-blank
http://jdserver.homelinux.org/linux/Xorg.0.log-good

Below is just a portion of the diff of those files.

--- Xorg.0.log-blank    2008-03-26 11:14:12.000000000 -0700
+++ Xorg.0.log-good    2008-03-26 11:14:35.000000000 -0700
@@ -20,7 +20,7 @@
 Markers: (--) probed, (**) from config file, (==) default setting,
     (++) from command line, (!!) notice, (II) informational,
     (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
-(==) Log file: "/var/log/Xorg.0.log", Time: Wed Mar 26 09:59:56 2008
+(==) Log file: "/var/log/Xorg.0.log", Time: Wed Mar 26 10:02:12 2008
 (==) Using config file: "/etc/X11/xorg.conf"
 (==) ServerLayout "Default Layout"
 (**) |-->Screen "Default Screen" (0)
@@ -470,9 +470,9 @@
 (WW) intel(0): Register 0x61200 (PP_STATUS) changed from 0xc0000008 to 
0xd0000009
 (WW) intel(0): PP_STATUS before: on, ready, sequencing idle
 (WW) intel(0): PP_STATUS after: on, ready, sequencing on
-(WW) intel(0): Register 0x71024 (PIPEBSTAT) changed from 0x00000202 to 
0x00000242
-(WW) intel(0): PIPEBSTAT before: status: VSYNC_INT_STATUS VBLANK_INT_STATUS
-(WW) intel(0): PIPEBSTAT after: status: VSYNC_INT_STATUS 
LBLC_EVENT_STATUS VBLANK_INT_STATUS
+(WW) intel(0): Register 0x71024 (PIPEBSTAT) changed from 0x80000202 to 
0x80000242
+(WW) intel(0): PIPEBSTAT before: status: FIFO_UNDERRUN VSYNC_INT_STATUS 
VBLANK_INT_STATUS
+(WW) intel(0): PIPEBSTAT after: status: FIFO_UNDERRUN VSYNC_INT_STATUS 
LBLC_EVENT_STATUS VBLANK_INT_STATUS
 (WW) intel(0): Register 0x68000 (TV_CTL) changed from 0x10000000 to 
0x000c0000
 (WW) intel(0): Register 0x68010 (TV_CSC_Y) changed from 0x00000000 to 
0x0332012d
 (WW) intel(0): Register 0x68014 (TV_CSC_Y2) changed from 0x00000000 to 
0x07d30104
@@ -735,11 +735,73 @@
 (II) intel(0): fbc disabled on plane a
 (II) intel(0): fbc disabled on plane a
 (II) intel(0): fbc disabled on plane a
-(II) intel(0): xf86UnbindGARTMemory: unbind key 0
-(II) intel(0): xf86UnbindGARTMemory: unbind key 1
-(II) intel(0): xf86UnbindGARTMemory: unbind key 2
-(II) intel(0): xf86UnbindGARTMemory: unbind key 3
-(II) intel(0): xf86UnbindGARTMemory: unbind key 4
-(II) intel(0): [drm] removed 1 reserved context for kernel
-(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0xf89e9000 at 0xb7ba4000
-(II) intel(0): [drm] Closed DRM master.
+(II) intel(0): fbc disabled on plane a
+(II) intel(0): fbc disabled on plane a
+(II) intel(0): fbc disabled on plane a
+(II) intel(0): fbc disabled on plane a

What's interesting is that:

-Register 0x71024 (PIPEBSTAT) changed from 0x00000202 to 0x00000242
+Register 0x71024 (PIPEBSTAT) changed from 0x80000202 to 0x80000242

-PIPEBSTAT before: status: VSYNC_INT_STATUS VBLANK_INT_STATUS
+PIPEBSTAT before: status: FIFO_UNDERRUN VSYNC_INT_STATUS VBLANK_INT_STATUS

-PIPEBSTAT after: status: VSYNC_INT_STATUS LBLC_EVENT_STATUS 
VBLANK_INT_STATUS
+PIPEBSTAT after: status: FIFO_UNDERRUN VSYNC_INT_STATUS LBLC_EVENT_STATUS

Also the blank X log file ends with:

(II) intel(0): xf86UnbindGARTMemory: unbind key 0
(II) intel(0): xf86UnbindGARTMemory: unbind key 1
(II) intel(0): xf86UnbindGARTMemory: unbind key 2
(II) intel(0): xf86UnbindGARTMemory: unbind key 3
(II) intel(0): xf86UnbindGARTMemory: unbind key 4
(II) intel(0): [drm] removed 1 reserved context for kernel
(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0xf89e9000 at 0xb7ba4000
(II) intel(0): [drm] Closed DRM master.

It seems like a problem with the intel drm/dri kernel modules (not the 
fb, I guess).
I didn't try disabling gdm yet (currently _busy_ with midterms, until 
after Thursday).

Justin
