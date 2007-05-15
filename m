Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbXEOIPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbXEOIPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbXEOIPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:15:42 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:34589 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755887AbXEOIPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:15:41 -0400
Message-ID: <46496C1F.3090209@panasas.com>
Date: Tue, 15 May 2007 11:15:27 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org
Subject: synchronization in usb_serial_put
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2007 08:15:29.0288 (UTC) FILETIME=[3313D880:01C796C9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I think there is a race between usb_serial_put() and
usb_serial_get_by_index() (and get_free_serial()) with regards
to handling the serial port refcount.

usb_serial_get_by_index() gets a reference on the serial port under
table_lock while return_serial releases all the returned ports
from the table under the same lock.  However, the table_lock is not
taken around the call to kref_put, theoretically allowing to sneak
in and grab a reference after kref_put has already determined that
the reference count is zero (and before calling destroy_serial)
causing use after free.

How about this fix?

>From b91b9cffd8bbb727c6480dfb18f79655806237e6 Mon Sep 17 00:00:00 2001
From: Benny Halevy <bhalevy@ns1.bhalevy.com>
Date: Tue, 15 May 2007 10:41:31 +0300
Subject: [PATCH] fix usb_serial_put synchronization


Signed-off-by: Benny Halevy <bhalevy@ns1.bhalevy.com>
---
 drivers/usb/serial/usb-serial.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 87f3788..4e5b996 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -120,11 +120,9 @@ static void return_serial(struct usb_serial *serial)
 	if (serial == NULL)
 		return;
 
-	spin_lock(&table_lock);
 	for (i = 0; i < serial->num_ports; ++i) {
 		serial_table[serial->minor + i] = NULL;
 	}
-	spin_unlock(&table_lock);
 }
 
 static void destroy_serial(struct kref *kref)
@@ -172,7 +170,9 @@ static void destroy_serial(struct kref *kref)
 
 void usb_serial_put(struct usb_serial *serial)
 {
+	spin_lock(&table_lock);
 	kref_put(&serial->kref, destroy_serial);
+	spin_unlock(&table_lock);
 }
 
 /*****************************************************************************

