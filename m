Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbZKXIyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbZKXIyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932332AbZKXIyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:54:12 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:38048 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbZKXIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dI9OAAgFRdb6Zmjo8NgxZGSjVuwGClokchxirH3AHUczV/zALploelcRa+zNye14rg
         W1qEfefAtCOfmFOh4s0tyx4A1XbH6ymg4JkRYoVhc5m83Z+GNWRUWGlC5aV4gz+lAU+t
         McY6nM4Nnrdu22zpwhftr6Qdz+2+xXOnc6aSU=
MIME-Version: 1.0
Date: Tue, 24 Nov 2009 03:54:15 -0500
Message-ID: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
Subject: PATCH: fix multiple eMagic 6|2m regressions introduced in 2.6.27
From: Monty Montgomery <xiphmont@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, tapio.laxstrom@iptime.fi,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

The eMagic driver code cleanup from 2.6.26->2.6.27 introduces three
new bugs that prevent the emi62 usb audio device from working.  2.6.31
continues to be identically broken. Note that this is the 6|2, not the
2|6; the 2|6 works properly. The 6|2 does not function at all and will
oops the kernel when plugged in.

Bug 1: a mirror of the loop termination bug that was fixed in the 2|6
driver last January, causing a similar oops as the 2|6 did in 2.6.27.

Bug 2: the firmware load loop that is supposed to load the firmware
section that sits in the device's RAM mistakenly uses
ANCHOR_LOAD_EXTERNAL instead of ANCHOR_LOAD_INTERNAL, a bug from
copy/pasting out of the preceeding loop.  This is clearly a regression
from the 2.6.26 source which uses the proper target.

Bug 3: Fixing the first two problems prevents the oops and allows the
USB stack to successfully allocate an endpoint without crashing the
eMagic.  However, the eMagic crashes and lights its red INTERNAL ERROR
led later as it tries to start up.  This problem can be traced to the
linux/firmware/emi62/bistream.HEX file, which is loading different
FPGA firmware as compared to the driver pre-2.6.27.  In fact, it is
loading an exact copy of the bistream firmware file that belongs to
the emi26 driver rather than the firmware that previously belonged to
the emi62. A new firmware/emi62/bitstream.HEX file generated from the
old driver's header corrects the problem and the 6|2 works as it did
before.

Note that the current firmware/emi62/bitstream.HEX mistakenly
identifies itself as:

// VERSION= 1.0.0.191
// DATE= 2002oct28

...this is incorrect and apparently cut out of the old emi62 driver's
firmware header and pasted onto the other firmware file.

Due to the size of the patch (the replacement firmware file is 250kB),
I've not attached it but rather stashed it at:

http://web.mit.edu/xiphmont/Public/emi/emi62.patch

Though it was generated against 2.6.29.4, I've tested it with 2.6.31.6.

(not currently subbed to the kernel list, please make sure I'm CCed on
replies.  Thanks!)

Monty
