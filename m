Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZD1Xeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZD1Xeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZD1XeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:34:21 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:52277 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbZD1XeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:34:20 -0400
Message-ID: <49F79279.4030904@oracle.com>
Date: Tue, 28 Apr 2009 16:34:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Document the multi-touch (MT) protocol
References: <1240916817-18995-1-git-send-email-rydberg@euromail.se> <1240916817-18995-2-git-send-email-rydberg@euromail.se>
In-Reply-To: <1240916817-18995-2-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49F7922A.0032:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg wrote:
> This patchs adds documentation for the multi-touch protocol to
> Documentation/input/.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  Documentation/input/multi-touch-protocol.txt |  140 ++++++++++++++++++++++++++
>  1 files changed, 140 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/input/multi-touch-protocol.txt
> 
> diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
> new file mode 100644
> index 0000000..2e99cd6
> --- /dev/null
> +++ b/Documentation/input/multi-touch-protocol.txt
> @@ -0,0 +1,140 @@
> +Multi-touch (MT) Protocol
> +-------------------------
> +	Copyright (C) 2009	Henrik Rydberg <rydberg@euromail.se>
> +
> +
> +Introduction
> +------------
> +
> +In order to utilize the full power of the new multi-touch devices, a way to
> +report detailed finger data to user space is needed. This document
> +describes the multi-touch (MT) protocol which allows kernel drivers to
> +report details for an arbitrary number of fingers.
> +
> +
> +Usage
> +-----
> +
> +Anonymous finger details are sent sequentially as separate packets of ABS
> +events. Only the ABS_MT events are recognized as part of a finger
> +packet. The end of a packet is marked by calling the input_mt_sync()
> +function, which generates a SYN_MT_REPORT event. The end of multi-touch
> +transfer is marked by calling the usual input_sync() function.
> +
> +A set of ABS_MT events with the desired properties are defined. The events

                                                      is defined.

> +are divided into categories, to allow for partial implementation.  The
> +minimum set consists of ABS_MT_TOUCH_MAJOR, ABS_MT_POSITION_X and
> +ABS_MT_POSITION_Y, which allows for multiple fingers to be tracked.  If the
> +device supports it, the ABS_MT_WIDTH_MAJOR may be used to provide the size
> +of the approaching finger. Anisotropy and direction may be specified with
> +ABS_MT_TOUCH_MINOR, ABS_MT_WIDTH_MINOR and ABS_MT_ORIENTATION. Devices with
> +more granular information may specify general shapes as blobs, i.e., as a
> +sequence of rectangular shapes grouped together by a

                                                   by an

> +ABS_MT_BLOB_ID. Finally, the ABS_MT_TOOL_TYPE may be used to specify
> +whether the touching tool is a finger or a pen or something else.
> +
> +
> +Event Semantics
> +---------------
> +
> +The word "contact" is used to describe a tool which is in direct contact
> +with the surface. A finger, a pen or a rubber all classify as contacts.
> +
> +ABS_MT_TOUCH_MAJOR
> +
> +The length of the major axis of the contact. The length should be given in
> +surface units. If the surface has a X time Y resolution, the largest

                                     an X times Y

> +possible value of ABS_MT_TOUCH_MAJOR is sqrt(X^2 + Y^2), the diameter.

                                                                diagonal. ??

> +
> +ABS_MT_TOUCH_MINOR
> +
> +The length, in surface units, of the minor axis of the contact. If the
> +contact is circular, this event can be omitted.
> +
> +ABS_MT_WIDTH_MAJOR
> +
> +The length, in surface units, of the major axis of the approaching
> +tool. This should be understood as the size of the tool itself. The
> +orientation of the contact and the approaching tool are assumed to be the
> +same.
> +
> +ABS_MT_WIDTH_MINOR
> +
> +The length, in surface units, of the minor axis of the approaching
> +tool. Omit if circular.
> +
> +The above four values can be used to derive additional information about
> +the contact. The ratio ABS_MT_TOUCH_MAJOR / ABS_MT_WIDTH_MAJOR approximates
> +the notion of pressure. The fingers of the hand and the palm all have
> +different characteristic widths [1].
> +
> +ABS_MT_ORIENTATION
> +
> +The orientation of the ellipse. The value should describe half a revolution
> +clockwise around the touch center. The scale of the value is arbitrary, but
> +zero should be returned for an ellipse aligned along the Y axis of the
> +surface. As an example, an index finger placed straight onto the axis could
> +return zero orientation, something negative when twisted to the left, and
> +something positive when twisted to the right. This value can be omitted if
> +the touching object is circular, or if the information is not available in
> +the kernel driver.
> +
> +ABS_MT_POSITION_X
> +
> +The surface X coordinate of the center of the touching ellipse.
> +
> +ABS_MT_POSITION_Y
> +
> +The surface Y coordinate of the center of the touching ellipse.
> +
> +ABS_MT_TOOL_TYPE
> +
> +The type of approaching tool. A lot of kernel drivers cannot distinguish
> +between different tool types, such as a finger or a pen. I such cases, the

                                                            In such

> +event should be omitted. The protocol currently supports MT_TOOL_FINGER and
> +MT_TOOL_PEN [2].
> +
> +ABS_MT_BLOB_ID
> +
> +The BLOB_ID groups several packets together into one arbitrarily shaped
> +contact. This is a low-level anonymous grouping, and should not be confused
> +with the high-level contactID, explained below. Most kernel drivers will
> +not have this capability, and can safely omit the event.
> +
> +
> +Finger Tracking
> +---------------
> +
> +The kernel driver should generate an arbitrary enumeration of the set of
> +anonymous contacts currently on the surface. The order in which the packets
> +appear in the event stream is not important.
> +
> +The process of finger tracking, i.e., to assign a unique contactID to each
> +initiated contact on the surface, is left to user space; preferably the
> +multi-touch X driver [3]. In that driver, the contactID stays the same and
> +unique until the contact vanishes (when the finger leaves the surface). The
> +problem of assigning a set of anonymous fingers to a set of identified
> +fingers is a euclidian bipartite matching problem at each event update, and
> +relies on a sufficiently rapid update rate.
> +
> +Notes
> +-----
> +
> +In order to stay compatible with existing applications, the data
> +reported in a finger packet must not be recognized as single-touch
> +events. In addition, all finger data must bypass input filtering,
> +since subsequent events of the same type refer to different fingers.
> +
> +The first kernel driver to utilize the MT protocol is the bcm5974 driver,
> +where examples can be found.
> +
> +[1] With the extension ABS_MT_APPROACH_X and ABS_MT_APPROACH_Y, the
> +difference between the contact position and the approaching tool position
> +could be used to derive tilt.
> +[2] The list can of course be extended.
> +[3] The multi-touch X driver is currently in the prototyping stage. At the
> +time of writing (April 2009), the MT protocol is not yet merged, and the
> +prototype implements finger matching, basic mouse support and two-finger
> +scrolling. The project aims at improving the quality of current multi-touch
> +functionality available in the synaptics X driver, and in addition
> +implement more advanced gestures.


-- 
~Randy
