Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbXK2UZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbXK2UZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932196AbXK2UZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:25:08 -0500
Received: from rtr.ca ([76.10.145.34]:2814 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbXK2UZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:25:07 -0500
Message-ID: <474F2020.7020004@rtr.ca>
Date: Thu, 29 Nov 2007 15:25:04 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
References: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org> <474F1AAC.7040908@rtr.ca> <20071129201224.GA25356@suse.de> <474F1DB3.4030900@rtr.ca>
In-Reply-To: <474F1DB3.4030900@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resending .. somebody trimmed the CC: list earlier)

Greg KH wrote:
>>>> Mark Lord wrote:
>>>>> ..
>>>>>
>>>>> While doing insert/remove (quickly) tests on USB,
>>>>> I managed to trigger an Oops on 2.6.23.8 on a call
>>>>> to strlen() in make_class_name().
...

> I'll hold off on adding this patch for now.
..

Why?

Bugs that result in Oops in core code (class.c) can bite
just about any subsystem that does hotplug, and should get
prompt attention.  Or so one might think.

* * * *

Patch reproduced below for full CC:

While doing insert/remove (quickly) tests on USB, I managed to trigger
an Oops on 2.6.23.1 on the call to strlen() in make_class_name().

This patch prevents the oops, but still keeps the bug visible.

There is still the larger problem of the overall race
that caused this in the first place, but much of the rest
of the code in class.c appears to also do NULL checks to
avoid Oops'ing, so this continues the tradition.

Signed-off-by:  Mark Lord <mlord@pobox.com> ---

Patch applies to both 2.6.24 and 2.6.23.

--- old/drivers/base/class.c    2007-11-29 10:51:43.000000000 -0500
+++ linux/drivers/base/class.c    2007-11-29 13:00:15.000000000 -0500
@@ -352,9 +352,22 @@
char *make_class_name(const char *name, struct kobject *kobj)
{
    char *class_name;
+    const char *kname;
    int size;

-    size = strlen(name) + strlen(kobject_name(kobj)) + 2;
+    /* Rapidly inserting/removing a USB device (others?)
+     * can trigger an Oops on the strlen() call.
+     * Cause unknown yet, so prevent the Oops
+     * but don't mask the issue.
+     */
+    kname = kobject_name(kobj);
+    if (!kname || !name) {
+        printk(KERN_ERR "make_class_name: name=%p kname=%p\n",
+                        name, kname);
+        BUG_ON(1);
+        return NULL;
+    }
+    size = strlen(name) + strlen(kname) + 2;

    class_name = kmalloc(size, GFP_KERNEL);
    if (!class_name)

