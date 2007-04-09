Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbXDIESz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbXDIESz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXDIESz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:18:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:34239 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbXDIESx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=ddED/s068AdIlr8B3scL34slj3VA0qRAlfFZwM1B/9w12MvroPG1Bpa2/9nLqqgy+Ie2V9Ii8U78gB0QpG05G1nMQhY+Pzo28y9gmtJZoLUodHdwtyWXrpRwQ2Krx6FCOOydrJPCyTSnoBPxwy5GjD55prBOJssiadWGgoJVz1I=
Subject: [PATCHSET #master] sysfs: make sysfs disconnect immediately on deletion, take 2
In-Reply-To: 
X-Mailer: git-send-email
Date: Mon, 9 Apr 2007 13:18:46 +0900
Message-Id: <11760923261269-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the second take of sysfs-immediate-disconnct patchset.

In the last take, rwsem was added to s_elem.dir to protect kobj only.
This wasn't enough because attr and bin_attr need to hold onto not
only the kobject of their parents but also the module backing
themselves and ops too, so the first set still needed separate and
duplicate attribute file orphaning mechanism.

In this take, the rwsem is generalized to become active reference
count.  Now each sysfs_dirent has two reference counts - s_count and
s_active.  s_count is a regular reference count which guarantees that
the containing sysfs_dirent is accessible.  As long as s_count
reference is held, all sysfs internal fields in sysfs_dirent are
accessible including s_parent and s_name.

The newly added s_active is active reference count.  This is acquired
by invoking sysfs_get_active() and it's the caller's responsibility to
ensure sysfs_dirent itself is accessible (should be holding s_count
one way or the other).  Dereferencing sysfs_dirent to access objects
out of sysfs proper requires active reference.  This includes access
to the associated kobjects, attributes and ops.

Because attr/bin_attr ops access both the node itself and its parent
for kobject, they need to hold active references to both.
sysfs_get/put_active_two() helpers are provided to help grabbing both
references.  Parent's is acquired first and released last.

Basically, s_count provides the reference counted objects to the upper
layer while s_active guards low level access such that low level
objects can just go away when they want to, and the same mechanism is
applied to all types of sysfs nodes.  I think it's conceptually
cleaner and thus easier to understand this way.

With all the patches applied, the same test used in the last take ran
9+hrs without any problem.

Change from the last take are...

* Patch 3 now doesn't move sysfs_get_kobject() as the it's replaced by
  active references later.

* Patch 12 updated such that sdir->rwsem is generalized into active
  reference count.

Please read the original lifetime rules discussion[1] and description
of the last take[2] for more info.

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/510293
[2] http://thread.gmane.org/gmane.linux.kernel/513334


