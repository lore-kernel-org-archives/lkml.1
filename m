Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYL2KTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYL2KTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYL2KS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:18:56 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51609 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbYL2KSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:18:55 -0500
Date: Mon, 29 Dec 2008 11:18:49 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 0/13] use USB API functions rather than constants
Message-ID: <Pine.LNX.4.64.0812291118150.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches introduces calls to the following functions:

usb_endpoint_dir_in(epd)
usb_endpoint_dir_out(epd)
usb_endpoint_is_bulk_in(epd)
usb_endpoint_is_bulk_out(epd)
usb_endpoint_is_int_in(epd)
usb_endpoint_is_int_out(epd)
usb_endpoint_num(epd)
usb_endpoint_type(epd)
usb_endpoint_xfer_bulk(epd)
usb_endpoint_xfer_control(epd)
usb_endpoint_xfer_int(epd)
usb_endpoint_xfer_isoc(epd)

In some cases, introducing one of these functions is not possible, and it
just replaces an explicit integer value by one of the following constants:

USB_ENDPOINT_XFER_BULK
USB_ENDPOINT_XFER_CONTROL
USB_ENDPOINT_XFER_INT
USB_ENDPOINT_XFER_ISOC

The complete semantic patch that makes these changes is below
(http://www.emn.fr/x-info/coccinelle/).  Most of the transformations are
straightforward, based on the definition of the added function.  A few are
slightly less straightforward, as follows:

1. Normally, the direction of an endpoint is determined by extracting the
direction information and comparing it to USB_DIR_IN or USB_DIR_OUT (rules
r5 and r8).  But the mask for extracting the direction information is the
same as USB_DIR_IN, so it is fairly common to just perform an & with
USB_DIR_IN.  When the result is used as a test expression, the effect is
the same as the normal case, so I have used usb_endpoint_dir_in in these
cases as well (rules r6 and r7).

2. Normally, the direction of an endpoint is compared in a positive way to
USB_DIR_IN or USB_DIR_OUT, corresponding to the definitions of
usb_endpoint_dir_in and usb_endpoint_dir_out, respectively.  Sometimes,
however, it is compared in a negative way.  Since the mask for extracting
the direction information has only one bit that is non-zero, there are only
two possible values, and an endpoint that is not in must be out, and vice
versa.  This is taken case of by rules r9 and r10.

There is one case where the field bEndpointAddress is bit-anded with a
constant that is not one of the constants considered here.  This is noted
in the log of the patch ([6/13]) where it occurs.

// <smpl>
@r1@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_CONTROL\|0\))
+ usb_endpoint_xfer_control(epd)

@r2@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_ISOC\|1\))
+ usb_endpoint_xfer_isoc(epd)

@r3@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_BULK\|2\))
+ usb_endpoint_xfer_bulk(epd)

@r4@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_INT\|3\))
+ usb_endpoint_xfer_int(epd)

@r5@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)

// Since USB_ENDPOINT_DIR_MASK selects only one bit and USB_DIR_IN is nonzero,
// anding with USB_DIR_IN in a test expression has the same effect as the above
@r6 expression@ struct usb_endpoint_descriptor *epd; @@

- (epd->bEndpointAddress & \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)
  || ...

// The same comment applies here
@r7 expression@ struct usb_endpoint_descriptor *epd; @@

- (epd->bEndpointAddress & \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)
  && ...

@r8@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_OUT\|0\))
+ usb_endpoint_dir_out(epd)

// Not IN must be OUT, since USB_ENDPOINT_DIR_MASK extracts a single bit
@r9@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) !=
-  \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_out(epd)

// Not OUT must be IN, since USB_ENDPOINT_DIR_MASK extracts a single bit
@r10@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) !=
-  \(USB_DIR_OUT\|0\))
+ usb_endpoint_dir_in(epd)

@r11 expression@ struct usb_endpoint_descriptor *epd; @@

- (epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\))
+ usb_endpoint_dir_in(epd)
  && ...

@r12 expression@ struct usb_endpoint_descriptor *epd; @@

- (epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\))
+ usb_endpoint_dir_in(epd)
  || ...

@r13@ struct usb_endpoint_descriptor *epd; @@

- (epd->bEndpointAddress & \(USB_ENDPOINT_NUMBER_MASK\|0x0f\))
+ usb_endpoint_num(epd)

@r14@ struct usb_endpoint_descriptor *epd; @@

- (epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\))
+ usb_endpoint_type(epd)

@r15@ struct usb_endpoint_descriptor *epd; @@

usb_endpoint_type(epd) !=
- 0
+ USB_ENDPOINT_XFER_CONTROL

@r16@ struct usb_endpoint_descriptor *epd; @@

usb_endpoint_type(epd) !=
- 1
+ USB_ENDPOINT_XFER_ISOC

@r17@ struct usb_endpoint_descriptor *epd; @@

usb_endpoint_type(epd) !=
- 2
+ USB_ENDPOINT_XFER_BULK

@r18@ struct usb_endpoint_descriptor *epd; @@

usb_endpoint_type(epd) !=
- 3
+ USB_ENDPOINT_XFER_INT

@r19@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_in(epd))
+ usb_endpoint_is_bulk_in(epd)

@r20@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_xfer_bulk(epd) && usb_endpoint_dir_out(epd))
+ usb_endpoint_is_bulk_out(epd)

@r21@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_xfer_int(epd) && usb_endpoint_dir_in(epd))
+ usb_endpoint_is_int_in(epd)

@r22@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_xfer_int(epd) && usb_endpoint_dir_out(epd))
+ usb_endpoint_is_int_out(epd)

@inc@
@@

#include <linux/usb.h>

@depends on !inc && (r1||r2||r3||r4||r5||r6||r7||r8||r9||r10||
r11||r12||r13||r14||r15||r16||r17||r18||r19||r20||r21||r22)@
@@

+ #include <linux/usb.h>
  #include <linux/usb/...>
// </smpl>
