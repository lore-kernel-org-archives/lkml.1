Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbYBIEYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbYBIEYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 23:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYBIEY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 23:24:28 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:13360 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbYBIEY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 23:24:27 -0500
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: kobject must be initialized before calling kobject_init()?!
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 08 Feb 2008 20:24:25 -0800
Message-ID: <adaabma21vq.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Feb 2008 04:24:25.0632 (UTC) FILETIME=[A73A5200:01C86AD3]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I was perusing the code in lib/kobject.c, and I saw this:

	void kobject_init(struct kobject *kobj, struct kobj_type *ktype)
	{
		// [a couple of of parameter checks...]
		if (kobj->state_initialized) {
			/* do not error out as sometimes we can recover */
			printk(KERN_ERR "kobject (%p): tried to init an initialized "
			       "object, something is seriously wrong.\n", kobj);
			dump_stack();
		}

in other words the first thing you do is check a member of the
structure you're supposed to be initializing -- if someone just
kmalloc()s a struct kobject and passes it into this function, there's
a good chance that state_initialized won't be zero.  In fact, with
slab debugging on, it's guaranteed to be poisoned with a non-zero
value.

So are users supposed to be zeroing out struct kobjects before
initializing them?  If so, this should probably be documented.
And also the code in kobject_init() that sets other fields to be zero
can also be removed:

	kobj->state_in_sysfs = 0;
	kobj->state_add_uevent_sent = 0;
	kobj->state_remove_uevent_sent = 0;

Let me know if the intention is that everyone should zero out their
kobjects when they initialize them, and I'll send a patch updating the
documentation.

There's another similar booby-trap in kobject_init_and_add(), which
ends up calling into kobject_set_name_vargs(), which does

	/* Free the old name, if necessary. */
	kfree(kobj->name);

which is generally a bad thing if kobj->name has not been initialized.

Thanks,
  Roland
