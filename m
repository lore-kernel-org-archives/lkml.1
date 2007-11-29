Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbXK2SKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbXK2SKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbXK2SJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:09:56 -0500
Received: from rtr.ca ([76.10.145.34]:3714 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598AbXK2SJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:09:55 -0500
Message-ID: <474F0071.5010507@rtr.ca>
Date: Thu, 29 Nov 2007 13:09:53 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] base/class.c: prevent ooops due to insert/remove race (v3)
References: <474E3964.7040200@rtr.ca> <20071129043307.GA4766@suse.de> <474EDDA9.1040205@rtr.ca> <20071129162727.GA8352@suse.de> <474EFAC1.1010100@rtr.ca> <474EFB61.8090803@rtr.ca> <474EFBFF.9090400@rtr.ca>
In-Reply-To: <474EFBFF.9090400@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Mark Lord wrote:
>> ...
>> And here is a "prevented" oops, courtesy of the patch (2.6.23.8).
>> These are easy to reproduce (just jiggle the connection on an
>> attached USB multi-card reader with a CF card inserted):
> ...
>> [  347.099562] usb 5-6: USB disconnect, address 10
>> [  347.101077] BUG: unable to handle kernel NULL pointer dereference 
>> at virtual address 00000000
> 
> ...
> 
> 
> Mmmm.. that's odd.  It *did* Oops there.  I wonder how/why ?
...

Ahh.. it was the *other* call to strlen() that was crapping out.
Here's an updated patch to prevent the Oops:

* * * *

While doing insert/remove (quickly) tests on USB,
I managed to trigger an Oops on 2.6.23.8 on a call
to strlen() in make_class_name().

USB maintainers can try this themselves, by plugging in an
external USB XX-in-1 flash reader, with a CF card inserted.
Then just jiggle the connection so that the device connects
and disconnects rapidly.  This may not sound realistic,
but there's definitely a race in there, and this is a quick
way to reproduce it if need be.

The patch below prevents the oops, but still keeps the bug visible.

Signed-off-by:  Mark Lord <mlord@pobox.com> 
---

Patch applies to both 2.6.24 and 2.6.23.

--- old/drivers/base/class.c	2007-11-29 10:51:43.000000000 -0500
+++ linux/drivers/base/class.c	2007-11-29 13:00:15.000000000 -0500
@@ -352,9 +352,22 @@
 char *make_class_name(const char *name, struct kobject *kobj)
 {
 	char *class_name;
+	const char *kname;
 	int size;
 
-	size = strlen(name) + strlen(kobject_name(kobj)) + 2;
+	/* Rapidly inserting/removing a USB device (others?)
+	 * can trigger an Oops on the strlen() call.
+	 * Cause unknown yet, so prevent the Oops
+	 * but don't mask the issue.
+	 */
+	kname = kobject_name(kobj);
+	if (!kname || !name) {
+		printk(KERN_ERR "make_class_name: name=%p kname=%p\n",
+						name, kname);
+		BUG_ON(1);
+		return NULL;
+	}
+	size = strlen(name) + strlen(kname) + 2;
 
 	class_name = kmalloc(size, GFP_KERNEL);
 	if (!class_name)
