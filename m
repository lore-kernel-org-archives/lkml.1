Return-Path: <linux-kernel-owner+w=401wt.eu-S1422862AbXCGRiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422862AbXCGRiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422952AbXCGRiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:38:23 -0500
Received: from mail.suse.de ([195.135.220.2]:44078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422862AbXCGRQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:29 -0500
Message-Id: <20070307171451.121451477@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>
Subject: [patch 063/101] HID: fix possible double-free on error path in hid parser
Content-Disposition: inline; filename=hid-fix-possible-double-free-on-error-path-in-hid-parser.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jiri Kosina <jkosina@suse.cz>

HID: fix possible double-free on error path in hid parser

Freeing of device->collection is properly done in hid_free_device() (as
this function is supposed to free all the device resources and could be
called from transport specific code, e.g. usb_hid_configure()).

Remove all kfree() calls preceeding the hid_free_device() call.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.20.1.orig/drivers/hid/hid-core.c
+++ linux-2.6.20.1/drivers/hid/hid-core.c
@@ -670,7 +670,6 @@ struct hid_device *hid_parse_report(__u8
 
 		if (item.format != HID_ITEM_FORMAT_SHORT) {
 			dbg("unexpected long global item");
-			kfree(device->collection);
 			hid_free_device(device);
 			kfree(parser);
 			return NULL;
@@ -679,7 +678,6 @@ struct hid_device *hid_parse_report(__u8
 		if (dispatch_type[item.type](parser, &item)) {
 			dbg("item %u %u %u %u parsing failed\n",
 				item.format, (unsigned)item.size, (unsigned)item.type, (unsigned)item.tag);
-			kfree(device->collection);
 			hid_free_device(device);
 			kfree(parser);
 			return NULL;
@@ -688,14 +686,12 @@ struct hid_device *hid_parse_report(__u8
 		if (start == end) {
 			if (parser->collection_stack_ptr) {
 				dbg("unbalanced collection at end of report description");
-				kfree(device->collection);
 				hid_free_device(device);
 				kfree(parser);
 				return NULL;
 			}
 			if (parser->local.delimiter_depth) {
 				dbg("unbalanced delimiter at end of report description");
-				kfree(device->collection);
 				hid_free_device(device);
 				kfree(parser);
 				return NULL;
@@ -706,7 +702,6 @@ struct hid_device *hid_parse_report(__u8
 	}
 
 	dbg("item fetching failed at offset %d\n", (int)(end - start));
-	kfree(device->collection);
 	hid_free_device(device);
 	kfree(parser);
 	return NULL;

--
