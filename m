Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbZLUAjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbZLUAjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 19:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbZLUAjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 19:39:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbZLUAjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 19:39:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC] Asynchronous suspend/resume - test results
Date: Mon, 21 Dec 2009 01:40:19 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912210140.19713.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After the Dmitry's suggestion to use PSMOUSE_CMD_RESET_DIS during suspend
(and analogously for atkbd), I found that it reduced the suspend time
significantly and changed the picture quite a bit.  For this reason I re-ran
the async suspend and resume tests on the nx6325 and Wind U100.

This time I marked the following devices as "async":
- all USB devices (including interfaces and endpoints)
- ACPI battery
- sd and its parent
- serio and i8042
- all PCI devices (including bridges)
for all tests (except for the sync suspend/resume test).

The results are as follows (all times in milliseconds):

			HP nx6325	MSI Wind U100

sync suspend		1391 (+/- 32)	 703 (+/- 26)
sync resume		3027 (+/- 6)	3562 (+/- 25)

async suspend		1306 (+/- 66)	 659 (+/- 22)
async resume		2809 (+/- 250)	3564 (+/- 35)

async "upfront" suspend	1038 (+/- 46)	 564 (+/- 50)
async "upfront" resume	1783 (+/- 7)	1925 (+/- 41)

where the "upfront" versions are with all of the async threads started in an
additional loop over dpm_list before the main "sync" suspend/resume loop.

The raw data are at:

http://www.sisk.pl/kernel/data/async-suspend-new.pdf
http://www.sisk.pl/kernel/data/nx6325/
http://www.sisk.pl/kernel/data/wind/

(hopefully this time I didn't make mistakes in the file names).

The data seem to suggest that "normal" async suspend and resume may be a little
(10% - 20%) faster than sync suspend and resume, but not as much as the
versions where all of the async threads had been started before the main
suspend (resume) thread began handling the "sync" devices.

IMO it also is worth noting that the "async upfront suspend" time on the Wind
is pretty close to the suspend time of the slowest device (~ .5 s).  The same
applies to the "async upfront resume" time on the Wind (the slowest device
resumes in ~1.5 s) and the "async upfront suspend" time on the nx6325 (the
slowest device suspends in ~1 s).  So, it looks like with the above set of
async devices we can approach pretty close to the achievable limit on both
test boxes.

I'm not sure what the next step should be at this point.  To me, the picture is
quite clear now, but perhaps we ought to run more tests on some other machines
or something.  Please let me know what you think.

Rafael
