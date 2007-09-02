Return-Path: <linux-kernel-owner+w=401wt.eu-S933412AbXIBNmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbXIBNmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 09:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbXIBNmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 09:42:24 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:64782 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbXIBNmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 09:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=WrQNXwl0HdN8X075p4XyKuYnKMnL7/zt7bT4g231q2sdrEyXh7qGAS76WHKlOUffNbvv7+beJsOlr8e4TwimTdsBwuijv216LezJ8ru1eU4CHvLlvuNhshEgu/wAyWnnq6j5ckKHRXqnzXy/TLHBdpzgvu8c2OthN4X1evhjhq0=
Message-ID: <46DABD6A.2030708@gmail.com>
Date: Sun, 02 Sep 2007 22:40:58 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg K-H <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: regarding sysfs/kobject separation
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, just a note to tell you guys what's going on.

It's taking more time than I expected but it's near completion.  I'm
testing things now.  After that, they need to be split and documented.
It'll be a BIG change and due to other things including moronic military
reserve training, I'll probably be able to post it after next week.
Sorry about the delay but I think the result will be pretty good in the end.

* Suicidal nodes don't need special treatment.  If a file tries to
commit suicide, sysfs will detect the condition and deactivate and drain
the node except for the suiciding reference.

* much more compact and flexible interface based on sysfs_dirent instead
of kobject.

* Backward compatibility is fully maintained.  All kobject based
interface is reimplemented in terms of the new interface.

* Plugged creation and batched error handling.  Sysfs directories can be
'plugged' on creation such that it can be made visible atomically after
all its subtrees are constructed.  Also, the user doesn't have to check
for failure at every step.  For example, the user can do the following.

	dir = sysfs_add_dir(parent, "my_dir", SYSFS_PLUGGED | 0777);
	sysfs_add_file(dir, ...);
	...
	dir2 = sysfs_add_dir(dir, ...);
	sysfs_add_link(dir, "link-to-dir2", dir2);
	...
	if (sysfs_check_batch_error(dir) == 0)
		sysfs_unplug(dir);
	else
		sysfs_remove(dir);

And all the nodes under and including @dir will show up atomically if
all operations succeeded or removed without ever bothering userland.

* Automatic symlink handling.  Symlink names can be formatted with the
name of its target.  e.g. if the symlink name is specified as
"link-%1:%0" and points to "devices/mybus0/mydev0", its name becomes
"link-mybus0-mydev0" && the symlink will be automatically renamed when
the target node or one of its ancestor is moved or renamed.  The symlink
is also plugged and removed together with its target.  So, once created,
the user doesn't have to care about the symlink.  sysfs will take care
of it.

* I think most of the changes wouldn't hinder implementation of tagged
nodes.  In fact, most of the new rename logic which handles symlink
rename together is taken from tagged node implementation, so with some
luck it should be easier to support tagged nodes.

*** Future plans.

* Move uevent support over to sysfs and bridging the current users.
This makes sense because sysfs hierarchy is all that userland can see
and sysfs users which don't use kobject also needs uevent support.

* Convert device model (drivers/base/*) over to the new sysfs_dirent
based interface and make device/driver <-> sysfs association flexible.
Automatic sysfs association is a good thing.  In most cases, it makes
sense and makes drivers simpler but it also needs to be flexible such
that drivers with special needs can override how the device and driver
are represented to userland.  I think such flexibility can be achieved
without too much problem now that sysfs and kobject are separated.

Thanks.

-- 
tejun
