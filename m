Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbXENINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbXENINs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbXENINk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:13:40 -0400
Received: from igraine.blacknight.ie ([81.17.252.25]:51638 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbXENINj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:13:39 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 04:13:38 EDT
Date: Mon, 14 May 2007 08:49:28 +0100
From: Robert Fitzsimons <robfitz@273k.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: video4linux@list.redhat.com, Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: V4L Regression (Was: Linux 2.6.22-rc1)
Message-ID: <20070514074928.GA13702@localhost>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=-0.012, required 7,
	autolearn=disabled, RCVD_IN_NERDS_IE -2.00, RCVD_IN_SORBS_DUL 1.99)
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Existing v4l applications are failing with the latest release
candidate.

This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.22-rc1)
xinerama 0: 1280x1024+0+0
/dev/video0 [v4l2]: ioctl VIDIOC_G_FBUF: Invalid argument
v4l-conf had some trouble, trying to continue anyway
ioctl: VIDIOC_G_FBUF(capability=0x0 [];flags=0x0 [];base=(nil);fmt.width=0;fmt.h
eight=0;fmt.pixelformat=0x00000000 [....];fmt.field=ANY;fmt.bytesperline=0;fmt.s
izeimage=0;fmt.colorspace=unknown;fmt.priv=0): Invalid argument
ioctl: VIDIOC_TRY_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=701;fmt.
win.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.w
in.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): Invalid argument
ioctl: VIDIOC_S_FMT(type=VIDEO_OVERLAY;fmt.win.w.left=3;fmt.win.w.top=701;fmt.wi
n.w.width=384;fmt.win.w.height=288;fmt.win.field=ANY;fmt.win.chromakey=0;fmt.win
.clips=(nil);fmt.win.clipcount=0;fmt.win.bitmap=(nil)): Invalid argument

After bisecting I tracked the problem down to this commit:

 206ebaf32795cf1582b1e2ff2ec6a560c9e986b8
 V4L/DVB (5272): Add V4L2_CAP_VIDEO_OUTPUT_POS capability
    
 Add V4L2_CAP_VIDEO_OUTPUT_POS capability and x, y position coordinates
 to struct v4l2_pix_format.
 This is needed to support positioning the MPEG/YUV output of the cx23415.
    
 Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
 Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

This commit changes the ABI by adding two new fields to the existing
struct v4l2_pix_format which is used by the existing VIDIOC_G_FBUF
ioctl.  v4l applications compiled against a previous version of the
kernel will fail in the generic ioctl code due to the size mismatch of
the arguments.

Commenting out the two new fields and recompiling allows the exists
application to work correctly.

Possibly the commit should be reverted or reworked to not change the
ABI?

Robert

