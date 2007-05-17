Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXEQVYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXEQVYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXEQVXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:23:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:45735 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbXEQVXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="229271147"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] enhancing the kernel's graphics subsystem
Date: Thu, 17 May 2007 14:23:45 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Jakob Bornecrantz" <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171423.46748.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patches at http://www.kernel.org/pub/linux/kernel/people/jbarnes/patches
  drm-modesetting-core.patch
  drm-modesetting-i915.patch
  console-unregister.patch
(Sorry the first two are slightly too big for lkml; they're against the 
DRM tree at git://git.freedesktop.org/git/mesa/drm.)

In collaboration with the FB guys, we've been working on enhancing the 
kernel's graphics subsystem in an attempt to bring some sanity to the 
Linux graphics world and avoid the situation we have now where several 
kernel and userspace drivers compete for control of graphics devices.

In the interest of getting some early feedback, I thought I'd post a 
description of how we've structured things so far, along with some of 
the early code, to get some feedback on the direction.

Why in the kernel?

There are several reasons to pull modesetting and proper multihead 
support into the kernel:
  - suspend/resume
  - debugging (e.g. panic)
  - non-X uses
  - more reliable VT switch
Each of the above is covered in more detail below.

Suspend/resume

Currently, the kernel has to rely on an external application (X, 
vbetool, etc.), or worse, ACPI, to reset video devices to the proper 
state after resume.  If one of these systems has trouble or crashes 
during or shortly after resume, the system will become unusable, with 
little indication as to why (see Debugging below).  Putting code into 
the kernel to perform low level modesetting (i.e. without video BIOS 
support) will allow the kernel to resume to the correct mode 
automatically and more quickly than would be possible otherwise.

Debugging

As mentioned above, if something goes wrong with modesetting during 
resume, the user has very little indication of where things went wrong.  
Likewise, if a panic or oops occurs while an application like X is 
running, the user will experience a hard hang, rather than the much 
more pleasant "blue penguin of death" (to be coded).  With kernel 
modesetting support, the kernel should be able to display panic and 
oops messages directly on the console, even if a graphical application 
is running, since it would have awareness of the current mode, display 
depth, pitch, and other variables needed to display output.  Another 
possibility is multihead debugging:  one display could run the user's 
applications (i.e. a "normal" display) while a secondary display could 
run a system level debugger, allowing the user to stop the machine, 
investigate memory, step through programs, etc. (admittedly this is 
somewhat far fetched).

Non-X uses

As it stands, non-X based applications wanting to use video devices have 
two options:  either take over the hardware themselves or use the 
existing kernel fb layer.  The former is obviously a tall order given 
the complexity of current graphics devices, while the latter isn't 
featureful enough to expose multiple outputs, perform per-device 
locking so that multiple clients can share the device, etc.  A kernel 
based modsetting and multihead API would make developing such 
applications much easier.

VT switch

Currently, the kernel relies on an external program to restore the 
graphics state when a VT switch occurs.  This doesn't always work, with 
similar results to the suspend/resume case:  an apparently hung or 
unusable machine.  Of course, the kernel can't unconditionally preempt 
the graphics device to set a new mode, but having modesetting in the 
kernel will give it a much better chance of coordinating with the DRM 
command dispatch code to find a good time to set a new mode.

Interfaces

With the above patches, the kernel DRM layer manages the output devices, 
available modes, and calls into the low level DRM drivers to set modes 
and probe outputs devices for attached displays, much like the X 
server's internal RandR 1.2 APIs.  It also provides userspace with an 
interface to these functions (Jakob based these APIs on the X server's 
Randr extension, but there are differences).

DRM/FB cooperation

Another major factor to consider when enhancing modesetting in the 
kernel is DRM and FB cooperation.  Currently, FB isn't aware of DRM 
drivers, and DRM is only minimally aware of FB (such that it can bind 
to PCI devices even after FB drivers have already done so).  As a 
result, any modesetting done by either layer results in memory 
allocation that may not be honored by the other side (and/or the X 
server, which has its own idea of how memory is being used).  To 
properly address interoperability, both the FB and DRM layers need to 
share a common memory manager, common suspend/resume code, and common 
modesetting code.  In addition, applications must use these layers in 
some way to avoid conflicts (e.g. X should call into the DRM or FB 
layers to do memory allocation).

What about the FB layer?

Today, the FB layer is really only well aware of a single head, and 
doesn't do full EDID parsing, therefore its knowledge of available 
modes is limited.  On the plus side, it's able to fetch EDID data where 
possible and generate modes using the VESA CVT specification.

In kernel APIs

The kernel APIs are broken up into several parts, as documented in 
drm_crtc.h.  There are two sets of callbacks that a driver must 
implement to fully support the model, one for the driver's CRTC(s), and 
one for its supported outputs.

Userland APIs

DRM_IOCTL_MODE_GETRESOURCES - get number of CRTCs, FBs
DRM_IOCTL_MODE_GETCRTC - get info about a given CRTC
DRM_IOCTL_MODE_GETOUTPUT - get info about a given output
DRM_IOCTL_MODE_SETCRTC - set CRTC parameters
DRM_IOCTL_MODE_ADDFB - add a new FB object
DRM_IOCTL_MODE_RMFB - remove an FB object
DRM_IOCTL_MODE_GETFB - get info about an FB object

Notes on the current codebase

The current codebase is still incomplete in many ways:  locking needs to 
be (re-)added around our various list manipulation paths, we need 
better initial configuration logic, only the Intel driver has any 
support (and it's still missing suspend/resume and accelerated FB 
functions), we need to check modes against monitor limitations (which 
come from EDID or the user), CVT and GTF based mode generation still 
isn't used by the DRM modesetting code, and much more.  I'm hoping that 
by posting this now, we can get some ideas about what requirements 
other people have for graphics on Linux so we can prioritize our work.

And of course, large chunks of this code came from X.Org's modesetting 
and Intel driver code, but it should all be marked with the proper 
copyrights and licenses if it wasn't written from scratch.

Comments, questions, suggestions?

Thanks,
Jesse
