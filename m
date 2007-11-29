Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbXK2P7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbXK2P7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbXK2P7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:59:05 -0500
Received: from rtr.ca ([76.10.145.34]:3690 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbXK2P7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:59:04 -0500
Message-ID: <474EE1C6.2080100@rtr.ca>
Date: Thu, 29 Nov 2007 10:59:02 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] base/class.c: prevent ooops due to insert/remove race (v2)
References: <474E3964.7040200@rtr.ca> <20071129043307.GA4766@suse.de>
In-Reply-To: <20071129043307.GA4766@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Nov 28, 2007 at 11:00:36PM -0500, Mark Lord wrote:
>> While doing insert/remove (quickly) tests on USB, I managed to trigger
>> an Oops on 2.6.23.1 on the call to strlen() in make_class_name().
>>
>> This patch prevents this oops.
>>
>> There is still the larger problem of the overall race
>> that caused this in the first place, but much of the rest
>> of the code in class.c appears to also do NULL checks to
>> avoid Oops'ing, so this continues the tradition.
>>
>> Signed-off-by:  Mark Lord <mlord@pobox.com>
> 
> As this is a bandage over the real problem, I'd prefer to not apply this
> one right now until we find the root cause.
...

Ahh... okay.. but since nobody is actually actively trying
to "find the root cause", there's a problem with that approach.

Rather than have systems continue to crash (reboot required to regain
use of USB after the Oops), here is an improved version of the patch
that addresses Greg's concern.

This version still prevents the Oops, but also flags the BUG so that
it will not go unnoticed.

This should make everyone happier.

* * * *

While doing insert/remove (quickly) tests on USB, I managed to trigger
an Oops on 2.6.23.1 on the call to strlen() in make_class_name().

This patch prevents the oops, but still keeps the bug visible.

There is still the larger problem of the overall race
that caused this in the first place, but much of the rest
of the code in class.c appears to also do NULL checks to
avoid Oops'ing, so this continues the tradition.

Signed-off-by:  Mark Lord <mlord@pobox.com> 
---

Patch applies to both 2.6.24 and 2.6.23.

--- linux/drivers/base/class.c.orig	2007-11-29 10:51:43.000000000 -0500
+++ linux/drivers/base/class.c	2007-11-29 10:54:42.000000000 -0500
@@ -354,6 +354,10 @@
 	char *class_name;
 	int size;
 
+	if (!name) {
+		BUG_ON(1);
+		return NULL;
+	}
 	size = strlen(name) + strlen(kobject_name(kobj)) + 2;
 
 	class_name = kmalloc(size, GFP_KERNEL);
