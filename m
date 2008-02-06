Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbYBGAVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbYBGAVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbYBFX7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:32954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764147AbYBFX7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:10 -0500
Date: Wed, 6 Feb 2008 15:53:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oneukum@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 53/73] Input: fix open count handling in input interfaces
Message-ID: <20080206235351.GB13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-fix-open-count-handling-in-input-interfaces.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Oliver Neukum <oliver@neukum.org>

patch 064450140f1eab959bd0eca0245f449993216074 in mainline.

If input_open_device() fails we should not leave interfaces marked
as opened.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/evdev.c    |    5 ++++-
 drivers/input/joydev.c   |    5 ++++-
 drivers/input/mousedev.c |    5 ++++-
 drivers/input/tsdev.c    |    5 ++++-
 4 files changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -192,8 +192,11 @@ static int evdev_open_device(struct evde
 
 	if (!evdev->exist)
 		retval = -ENODEV;
-	else if (!evdev->open++)
+	else if (!evdev->open++) {
 		retval = input_open_device(&evdev->handle);
+		if (retval)
+			evdev->open--;
+	}
 
 	mutex_unlock(&evdev->mutex);
 	return retval;
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -205,8 +205,11 @@ static int joydev_open_device(struct joy
 
 	if (!joydev->exist)
 		retval = -ENODEV;
-	else if (!joydev->open++)
+	else if (!joydev->open++) {
 		retval = input_open_device(&joydev->handle);
+		if (retval)
+			joydev->open--;
+	}
 
 	mutex_unlock(&joydev->mutex);
 	return retval;
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -428,8 +428,11 @@ static int mousedev_open_device(struct m
 		mixdev_open_devices();
 	else if (!mousedev->exist)
 		retval = -ENODEV;
-	else if (!mousedev->open++)
+	else if (!mousedev->open++) {
 		retval = input_open_device(&mousedev->handle);
+		if (retval)
+			mousedev->open--;
+	}
 
 	mutex_unlock(&mousedev->mutex);
 	return retval;
--- a/drivers/input/tsdev.c
+++ b/drivers/input/tsdev.c
@@ -185,8 +185,11 @@ static int tsdev_open_device(struct tsde
 
 	if (!tsdev->exist)
 		retval = -ENODEV;
-	else if (!tsdev->open++)
+	else if (!tsdev->open++) {
 		retval = input_open_device(&tsdev->handle);
+		if (retval)
+			tsdev->open--;
+	}
 
 	mutex_unlock(&tsdev->mutex);
 	return retval;

-- 
