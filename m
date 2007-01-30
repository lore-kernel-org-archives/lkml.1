Return-Path: <linux-kernel-owner+w=401wt.eu-S965586AbXA3PIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbXA3PIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965590AbXA3PIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:08:16 -0500
Received: from twin.jikos.cz ([213.151.79.26]:44493 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965586AbXA3PIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:08:15 -0500
Date: Tue, 30 Jan 2007 16:07:04 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Adrian Bunk <bunk@stusta.de>
cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC: -mm patch] CONFIG_INPUT_DEBUG improvements
In-Reply-To: <20070130011156.GD3754@stusta.de>
Message-ID: <Pine.LNX.4.64.0701301603590.9448@twin.jikos.cz>
References: <20070127234928.64d8e437.akpm@osdl.org> <20070130011156.GD3754@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Adrian Bunk wrote:

> This patch contains the following CONFIG_INPUT_DEBUG improvements:
> - remove Makefile code for the nonexisting CONFIG_INPUT_DEBUG
> - simpler Makefile for hid-debug.o
> - replace all HID debug #define's with CONFIG_INPUT_DEBUG

Adrian,

thanks for the patch. In seems broken to me though (as I have written 
accidentaly in different mail, so resending for mailinglists to get it) - 
the option that should replace the legacy DEBUG macro should be 
CONFIG_HID_DEBUG, not CONFIG_INPUT_DEBUG - your patch gets it right only 
on some places.

I applied the patch below to hid tree. Thanks.


HID: move away from DEBUG defines in favor of CONFIG_HID_DEBUG

CONFIG_INPUT_DEBUG is non-existent option, so remove anything depending
on it.

Also, as we have new CONFIG_HID_DEBUG, this should be used on places
where ifdef DEBUG was used before.

Suggested by Adrian Bunk.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---
commit c6bc8f433a5a6aec13b4d1aa64c980e8f5c0badc
tree 291a94074fea15b714ce66eacad2827c80eae28f
parent 6015269d31d8d07b80ef22000ba1d21feed1e537
author Jiri Kosina <jkosina@suse.cz> Tue, 30 Jan 2007 16:02:24 +0100
committer Jiri Kosina <jkosina@suse.cz> Tue, 30 Jan 2007 16:02:24 +0100

 drivers/hid/Makefile    |   15 ++-------------
 drivers/hid/hid-core.c  |    6 ++----
 drivers/hid/hid-debug.c |    1 -
 drivers/hid/hid-input.c |    6 ++----
 4 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 84c823e..52e97d8 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -1,19 +1,8 @@
 #
 # Makefile for the HID driver
 #
-
-# Multipart objects.
-hid-objs	:= hid-core.o hid-input.o
-
-# Optional parts of multipart objects.
-ifeq ($(CONFIG_HID_DEBUG),y)
-hid-objs	+= hid-debug.o
-endif
-
-ifeq ($(CONFIG_INPUT_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-
+hid-objs			:= hid-core.o hid-input.o
 
 obj-$(CONFIG_HID)		+= hid.o
+hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4648733..d848db6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -28,8 +28,6 @@
 #include <linux/input.h>
 #include <linux/wait.h>
 
-#undef DEBUG_DATA
-
 #include <linux/hid.h>
 #include <linux/hiddev.h>
 #include <linux/hid-debug.h>
@@ -950,7 +948,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 		return -1;
 	}
 
-#ifdef DEBUG_DATA
+#ifdef CONFIG_HID_DEBUG
 	printk(KERN_DEBUG __FILE__ ": report (size %u) (%snumbered)\n", size, report_enum->numbered ? "" : "un");
 #endif
 
@@ -960,7 +958,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 		size--;
 	}
 
-#ifdef DEBUG_DATA
+#ifdef CONFIG_HID_DEBUG
 	{
 		int i;
 		printk(KERN_DEBUG __FILE__ ": report %d (size %u) = ", n, size);
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index d6abe34..89241be 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -28,7 +28,6 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
-//#include <linux/input.h>
 #include <linux/hid.h>
 
 struct hid_usage_entry {
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 2301f98..1c7376a 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -31,8 +31,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 
-#undef DEBUG
-
 #include <linux/hid.h>
 #include <linux/hid-debug.h>
 
@@ -248,7 +246,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 
 	field->hidinput = hidinput;
 
-#ifdef DEBUG
+#ifdef CONFIG_HID_DEBUG
 	printk(KERN_DEBUG "Mapping: ");
 	hid_resolv_usage(usage->hid);
 	printk(" ---> ");
@@ -683,7 +681,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 	return;
 
 ignore:
-#ifdef DEBUG
+#ifdef CONFIG_HID_DEBUG
 	printk("IGNORED\n");
 #endif
 	return;

-- 
Jiri Kosina
