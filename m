Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0CKWkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:40:08 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:52227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0CKWkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:40:05 -0500
Subject: firmware loading vs. initrd
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 14:39:34 -0800
Message-ID: <1268347174.4142.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We recently converted a few wireless drivers to use
request_firmware_nowait() in order to be able to load firmware from
probe. We would like to continue with that so we can load the firmware
before registering with any other subsystems, as we had discussed at the
wireless summit last year.

However, in actually trying this today, I noticed that there's a problem
with this. I made my drivers all built in, and then I ended up with it
not working because the firmware agent that was in my initrd was telling
[1], and the kernel that the firmware could not be found.

I thought of modifying the firmware agent in the initrd to not tell the
kernel it doesn't have it, but that is problematic when using
request_firmware(), the kernel boot will be delayed until the timeout
(one minute).

This can be solved by adding an environment variable to the uevent that
tells userspace whether or not this is coming from request_firmware() or
request_firmware_nowait(). I will follow up with a patch doing that.

Additionally, however, we need to make a change like below to the
firmware agent in order to not reply to asynchronous firmware loads
during the initrd stage. I'm not sure how to actually check that we're
running in an initrd (is that possible?) nor did I actually verify that
the NOWAIT environment variable is set properly.

Thoughts? It seems like this would solve our problems nicely if we can
determine whether we're in the initrd or not.

johannes

--- /lib/udev/firmware.agent	2010-02-18 16:40:39.000000000 -0800
+++ firmware.agent	2010-03-11 12:00:40.000000000 -0800
@@ -21,6 +21,16 @@
     exit 0
 done
 
+if [ "$NOWAIT" = "1" ] && [ INITRD? ] ; then
+	# Leave the request open in case we are
+	# running from initrd -- we'll deal with
+	# it when we process things again after
+	# the root filesystem is mounted.
+
+	# exit 1 instead?
+	exit 0
+fi
+
 # the firmware was not found
 echo -1 > /sys/$DEVPATH/loading
 


