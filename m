Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXFFQz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXFFQz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXFFQzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:55:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33641 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbXFFQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:55:13 -0400
X-Sasl-enc: eVkvc8x9R3phIhzM2XK75M/ahAndAmAeC0bcD7cumrX4 1181148912
Date: Wed, 6 Jun 2007 13:55:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN (v2)
Message-ID: <20070606165509.GB18984@khazad-dum.debian.net>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <d120d5000705301325yf76d062vefbc79873d23e602@mail.gmail.com> <20070531005305.GC6883@khazad-dum.debian.net> <200705310033.51230.dtor@insightbb.com> <20070531222814.GB4076@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531222814.GB4076@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have most of the pieces needed to have sane, generic userland keyboard
handling in place for a while now, but it is not sufficiently documented.

This patch documents the requirements and best practices for EV_KEY input
drivers.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Hughes <hughsient@gmail.com>
---

 I have changed the KEY_UNKNOWN preference over positional keycodes around,
 and also added a small paragraph on the expected behaviour of userland
 applications re. EV_MSC MSC_SCAN events.

 Comments?

 Documentation/input/input-programming.txt |   45 ++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/Documentation/input/input-programming.txt b/Documentation/input/input-programming.txt
index d9d5230..30fd051 100644
--- a/Documentation/input/input-programming.txt
+++ b/Documentation/input/input-programming.txt
@@ -272,7 +272,50 @@ present, it is broken sometimes (at keyboards: Toshiba notebooks). To enable
 autorepeat for your device, just set EV_REP in dev->evbit. All will be
 handled by the input system.
 
-1.9 Other event types, handling output events
+1.9 Being friendly to userspace when implementing EV_KEY drivers
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Input drivers that generate EV_KEY events should always support either
+dev->getkeycode()/dev->setkeycode(), or keycode, keycodemax and keycodesize,
+so as to allow userspace to reprogram the keycodes as needed.  They should
+also either always generate EV_MSC MSC_SCAN events along with every EV_KEY
+event, or special case EV_KEY KEY_UNKNOWN as described below.
+
+Userspace applications, on the other hand, should never try to remap keys by
+default based solely on EV_MSC MSC_SCAN if that event is part of an event
+block that contains an EV_KEY event other than EV_KEY KEY_UNKNOWN.
+
+If the input driver doesn't support any of the generic methods to manipulate
+the keycode map, it must never issue a EV_KEY KEY_UNKNOWN event.  If you
+need to issue EV_KEY KEY_UNKNOWN events, please implement the code in your
+driver to manipulate its keycode map.  KEY_UNKNOWN is meant to be something
+that can be replaced by the user with a functional keycode.
+
+If the input driver generates an EV_KEY KEY_UNKNOWN event, it should also
+generate *in the same event block* (i.e. before it issues an EV_SYN) an
+EV_MSC MSC_SCAN event, with the scan code for the "unknown key".  This
+should be done both in "press" and "release" EV_KEY events.  The EV_MSC
+MSC_SCAN event allows a generic userspace keyboard helper daemon to ask the
+user if he would like to map a key in a input device to a valid keycode, and
+assign a function to it.
+
+The scan code of a key (as informed in a EV_MSC MSC_SCAN event) must be its
+index in the keycode map, as implemented by dev->getkeycode() /
+dev->setkeycode(), or keycode, keycodemax and keycodesize for the device.
+
+If a key has a specific function that is known to the driver, it should
+generate the appropriate keycode for that function by default.  E.g., in a
+laptop where the FN+F1 key combination is always marked "HELP" in the
+keyboard, the driver is to generate KEY_HELP and not KEY_FN_F1.
+
+If a positional keycode for a key already exists in input.h (e.g. KEY_FN_F1
+for FN+F1), it should be used instead of KEY_UNKNOWN.  When such a code
+doesn't exist or doesn't make any sense for a key, EV_KEY KEY_UNKNOWN is to
+be used.
+
+Non-positional keycodes like KEY_PROG1 should never be used by default.
+
+1.10 Other event types, handling output events
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The other event types up to now are:
-- 
1.5.1.6


-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
