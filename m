Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbZEQU6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbZEQU6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZEQU61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:58:27 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:37623 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbZEQU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:58:22 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] input: mt: Augment the event semantics documentation
Date: Sun, 17 May 2009 22:51:19 +0200
Message-Id: <1242593479-9238-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1242593479-9238-1-git-send-email-rydberg@euromail.se>
References: <1242593479-9238-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.194.102
X-Scan-Result: No virus found in message 1M5nKd-0003Iq-8G.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1M5nKd-0003Iq-8G 8fa307e6337fc139345d4f68b76d7a1a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Through the collaboration to adapt the N-trig and Stantum HID
drivers to the MT protocol, some semantic clarifications to the
protocol have been made. This patch adds them to the MT documentation.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Tested-by: Stéphane Chatty <chatty@enac.fr>
---
 Documentation/input/multi-touch-protocol.txt |   88 +++++++++++++++++++-------
 1 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index 9f09557..dd755c2 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -18,8 +18,12 @@ Usage
 Anonymous finger details are sent sequentially as separate packets of ABS
 events. Only the ABS_MT events are recognized as part of a finger
 packet. The end of a packet is marked by calling the input_mt_sync()
-function, which generates a SYN_MT_REPORT event. The end of multi-touch
-transfer is marked by calling the usual input_sync() function.
+function, which generates a SYN_MT_REPORT event. This instructs the
+receiver to accept the data for the current finger and prepare to receive
+another. The end of a multi-touch transfer is marked by calling the usual
+input_sync() function. This instructs the receiver to perform actions based
+on the received packets, and prepare to receive a new set of finger
+packets.
 
 A set of ABS_MT events with the desired properties is defined. The events
 are divided into categories, to allow for partial implementation.  The
@@ -27,11 +31,13 @@ minimum set consists of ABS_MT_TOUCH_MAJOR, ABS_MT_POSITION_X and
 ABS_MT_POSITION_Y, which allows for multiple fingers to be tracked.  If the
 device supports it, the ABS_MT_WIDTH_MAJOR may be used to provide the size
 of the approaching finger. Anisotropy and direction may be specified with
-ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and ABS_MT_ORIENTATION. Devices with
-more granular information may specify general shapes as blobs, i.e., as a
-sequence of rectangular shapes grouped together by an
-ABS_MT_BLOB_ID. Finally, the ABS_MT_TOOL_TYPE may be used to specify
-whether the touching tool is a finger or a pen or something else.
+ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and ABS_MT_ORIENTATION.  The
+ABS_MT_TOOL_TYPE may be used to specify whether the touching tool is a
+finger or a pen or something else.  Devices with more granular information
+may specify general shapes as blobs, i.e., as a sequence of rectangular
+shapes grouped together by an ABS_MT_BLOB_ID. Finally, for the few devices
+that currently support it, the ABS_MT_TRACKING_ID event may be used to
+report finger tracking from hardware [5].
 
 
 Event Semantics
@@ -44,24 +50,24 @@ ABS_MT_TOUCH_MAJOR
 
 The length of the major axis of the contact. The length should be given in
 surface units. If the surface has an X times Y resolution, the largest
-possible value of ABS_MT_TOUCH_MAJOR is sqrt(X^2 + Y^2), the diagonal.
+possible value of ABS_MT_TOUCH_MAJOR is sqrt(X^2 + Y^2), the diagonal [4].
 
 ABS_MT_TOUCH_MINOR
 
 The length, in surface units, of the minor axis of the contact. If the
-contact is circular, this event can be omitted.
+contact is circular, this event can be omitted [4].
 
 ABS_MT_WIDTH_MAJOR
 
 The length, in surface units, of the major axis of the approaching
 tool. This should be understood as the size of the tool itself. The
 orientation of the contact and the approaching tool are assumed to be the
-same.
+same [4].
 
 ABS_MT_WIDTH_MINOR
 
 The length, in surface units, of the minor axis of the approaching
-tool. Omit if circular.
+tool. Omit if circular [4].
 
 The above four values can be used to derive additional information about
 the contact. The ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR approximates
@@ -70,14 +76,17 @@ different characteristic widths [1].
 
 ABS_MT_ORIENTATION
 
-The orientation of the ellipse. The value should describe half a revolution
-clockwise around the touch center. The scale of the value is arbitrary, but
-zero should be returned for an ellipse aligned along the Y axis of the
-surface. As an example, an index finger placed straight onto the axis could
-return zero orientation, something negative when twisted to the left, and
-something positive when twisted to the right. This value can be omitted if
-the touching object is circular, or if the information is not available in
-the kernel driver.
+The orientation of the ellipse. The value should describe a signed quarter
+of a revolution clockwise around the touch center. The signed value range
+is arbitrary, but zero should be returned for a finger aligned along the Y
+axis of the surface, something negative when twisted to the left, and
+something positive when twisted to the right. When completely aligned with
+the X axis, the range max should be returned.  Orientation can be omitted
+if the touching object is circular, or if the information is not available
+in the kernel driver. Partial orientation support is possible if the device
+can distinguish between the two axis, but not (uniquely) any values in
+between. In such cases, the range of ABS_MT_ORIENTATION should be [0, 1]
+[4].
 
 ABS_MT_POSITION_X
 
@@ -98,8 +107,35 @@ ABS_MT_BLOB_ID
 
 The BLOB_ID groups several packets together into one arbitrarily shaped
 contact. This is a low-level anonymous grouping, and should not be confused
-with the high-level contactID, explained below. Most kernel drivers will
-not have this capability, and can safely omit the event.
+with the high-level trackingID [5]. Most kernel drivers will not have this
+capability, and can safely omit the event.
+
+ABS_MT_TRACKING_ID
+
+The TRACKING_ID identifies an initiated contact throughout its life cycle
+[5]. There are currently only a few devices that support it, so this event
+should normally be omitted.
+
+
+Event Computation
+-----------------
+
+The flora of different hardware unavoidably leads to some devices fitting
+better to the MT protocol than others. To simplify and unify the mapping,
+this section gives recipes for how to compute certain events.
+
+For devices reporting contacts as rectangular shapes, signed orientation
+cannot be obtained. Assuming X and Y are the lengths of the sides of the
+touching rectangle, here is a simple formula that retains the most
+information possible:
+
+   ABS_MT_TOUCH_MAJOR := max(X, Y)
+   ABS_MT_TOUCH_MINOR := min(X, Y)
+   ABS_MT_ORIENTATION := bool(X > Y)
+
+The range of ABS_MT_ORIENTATION should be set to [0, 1], to indicate that
+the device can distinguish between a finger along the Y axis (0) and a
+finger along the X axis (1).
 
 
 Finger Tracking
@@ -109,14 +145,18 @@ The kernel driver should generate an arbitrary enumeration of the set of
 anonymous contacts currently on the surface. The order in which the packets
 appear in the event stream is not important.
 
-The process of finger tracking, i.e., to assign a unique contactID to each
+The process of finger tracking, i.e., to assign a unique trackingID to each
 initiated contact on the surface, is left to user space; preferably the
-multi-touch X driver [3]. In that driver, the contactID stays the same and
+multi-touch X driver [3]. In that driver, the trackingID stays the same and
 unique until the contact vanishes (when the finger leaves the surface). The
 problem of assigning a set of anonymous fingers to a set of identified
 fingers is a euclidian bipartite matching problem at each event update, and
 relies on a sufficiently rapid update rate.
 
+There are a few devices that support trackingID in hardware. The X driver
+can make use of these native identifiers to reduce evdev bandwidth and cpu
+usage.
+
 Notes
 -----
 
@@ -138,3 +178,5 @@ prototype implements finger matching, basic mouse support and two-finger
 scrolling. The project aims at improving the quality of current multi-touch
 functionality available in the synaptics X driver, and in addition
 implement more advanced gestures.
+[4] See the section on event computation.
+[5] See the section on finger tracking.
-- 
1.5.6.3

