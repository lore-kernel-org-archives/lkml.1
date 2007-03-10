Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbXCJMko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbXCJMko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 07:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbXCJMkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 07:40:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:35882 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933386AbXCJMkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 07:40:42 -0500
Date: Sat, 10 Mar 2007 13:43:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc3-mm1
In-Reply-To: <20070310091820.GB30495@kroah.com>
Message-ID: <Pine.LNX.4.64.0703101337460.10121@jikos.suse.cz>
References: <20070307201839.6f45735b.akpm@linux-foundation.org>
 <200703100933.35743.m.kozlowski@tuxland.pl> <20070310005828.0ab608b1.akpm@linux-foundation.org>
 <20070310091820.GB30495@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Greg KH wrote:

> > hid_parse_report() is doing kmalloc(128k kbytes).  We canot sanely 
> > support that and the code shold be rewritten to not do that.  A simple 
> > though somewhat lame fix would be to switch to vmalloc().
> > It's been this way for some time, so it's odd that the failures have 
> > just popped up now.
> Jiri is the person to ask about this now.  Jiri, any thoughts about
> this?

Hi,

I have just queued the patch below to HID tree for the next upstream 
merge. Mariusz, I guess it solves your issue, right?

I have already been talking with Vojtech some time ago that rewritting the 
hid parser so that it would use less memory (but probably slightly a bit 
more CPU) would be a good thing to do, and it's been sitting in my TODO 
list for quite some time already. It's really not a straightforward 
rewrite, so I would incline to use the vmalloc() solution until the parser 
code has been rewritten. The hid_parser structure in question is living 
for very short time anyway, so it shouldn't be that big issue.

Thanks.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: allocate hid_parser through vmalloc()

hid_parser is non-trivially large structure, so it should be allocated
using vmalloc() to avoid unsuccessful allocations when memory fragmentation
is too high.
This structue has a very short life, it's destroyed as soon as the report
descriptor has been completely parsed.

This should be considered a temporary solution, until the hid_parser is
rewritten to consume less memory during report descriptor parsing.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-core.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f4ee1af..e5894a7 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -26,6 +26,7 @@
 #include <asm/byteorder.h>
 #include <linux/input.h>
 #include <linux/wait.h>
+#include <linux/vmalloc.h>
 
 #include <linux/hid.h>
 #include <linux/hiddev.h>
@@ -654,12 +655,13 @@ struct hid_device *hid_parse_report(__u8 *start, unsigned size)
 	memcpy(device->rdesc, start, size);
 	device->rsize = size;
 
-	if (!(parser = kzalloc(sizeof(struct hid_parser), GFP_KERNEL))) {
+	if (!(parser = vmalloc(sizeof(struct hid_parser)))) {
 		kfree(device->rdesc);
 		kfree(device->collection);
 		kfree(device);
 		return NULL;
 	}
+	memset(parser, 0, sizeof(struct hid_parser));
 	parser->device = device;
 
 	end = start + size;
@@ -668,7 +670,7 @@ struct hid_device *hid_parse_report(__u8 *start, unsigned size)
 		if (item.format != HID_ITEM_FORMAT_SHORT) {
 			dbg("unexpected long global item");
 			hid_free_device(device);
-			kfree(parser);
+			vfree(parser);
 			return NULL;
 		}
 
@@ -676,7 +678,7 @@ struct hid_device *hid_parse_report(__u8 *start, unsigned size)
 			dbg("item %u %u %u %u parsing failed\n",
 				item.format, (unsigned)item.size, (unsigned)item.type, (unsigned)item.tag);
 			hid_free_device(device);
-			kfree(parser);
+			vfree(parser);
 			return NULL;
 		}
 
@@ -684,23 +686,23 @@ struct hid_device *hid_parse_report(__u8 *start, unsigned size)
 			if (parser->collection_stack_ptr) {
 				dbg("unbalanced collection at end of report description");
 				hid_free_device(device);
-				kfree(parser);
+				vfree(parser);
 				return NULL;
 			}
 			if (parser->local.delimiter_depth) {
 				dbg("unbalanced delimiter at end of report description");
 				hid_free_device(device);
-				kfree(parser);
+				vfree(parser);
 				return NULL;
 			}
-			kfree(parser);
+			vfree(parser);
 			return device;
 		}
 	}
 
 	dbg("item fetching failed at offset %d\n", (int)(end - start));
 	hid_free_device(device);
-	kfree(parser);
+	vfree(parser);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(hid_parse_report);

