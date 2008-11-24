Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYKXD5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYKXD5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 22:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYKXD5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 22:57:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYKXD5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 22:57:39 -0500
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Date: Mon, 24 Nov 2008 14:55:30 +1100
Subject: [PATCH 0/2] RFC:  allow md devices to disappear when not in use.
Cc: Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Doug Ledford <dledford@redhat.com>
Message-ID: <20081124035516.3465.66413.stgit@notabene.brown>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches - which are in -next if you need to see
their context - make two fairly significant changes to the way md
devices are (or can be) created and destroyed.

They include a smallish change to fs/block_dev.c so I'm cc:ing recent
modifiers of that file.

Currently, md devices spring into existence when a corresponding
device-special file is opened, and they remain around forever, or
until the module is unloaded.

The first of these patches causes md devices to disappear when they
are no longer in use.  More precisely: after the last close when the
array is completely unconfigured.
This opens up a small race if one process is opening the device about
the same time that another process is closing it for the last time.
Closing this race requires the small change in fs/block_dev.c

The second patch allows md device to be created with a name rather
than a number.  Sometimes it is more convenient to think about arrays
by name, and supporting this in the kernel is a useful idea (From Doug
Ledford).

If you write e.g. "md_foo" to "/sys/modules/md_mod/parameters/new_array"
then an md device was an arbitrary minor number will be created named
md_foo rather than e.g. md256. (the "md_" prefix is required).

Current tools seem to cope perfectly with md devices disappearing when
finished with.  They are not likely to cope with "md_foo" device
naming, but that would only be used if a new tool requested it, so it
is up to that tool (mdadm) to not cause confusion.

Any review comments most welcome.

Thanks,
NeilBrown


---

NeilBrown (2):
      Allow md devices to be created by name.
      md: make devices disappear when they are no longer needed.


 drivers/md/md.c           |  175 ++++++++++++++++++++++++++++++++++++++-------
 fs/block_dev.c            |   14 ++++
 include/linux/raid/md_k.h |    5 +
 3 files changed, 165 insertions(+), 29 deletions(-)

-- 

