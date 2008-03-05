Return-Path: <linux-kernel-owner+w=401wt.eu-S1761655AbYCERcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655AbYCERcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761554AbYCERcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:32:32 -0500
Received: from sacred.ru ([62.205.161.221]:42066 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761289AbYCERc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:32:26 -0500
Message-ID: <47CED717.60406@openvz.org>
Date: Wed, 05 Mar 2008 20:23:35 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 0/9] Devices accessibility control group (v4)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 20:23:27 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v3:
* Ported on 2.6.25-rc3-mm1;
* Re-splitted into smaller pieces;
* Added more comments to tricky places.

This controller allows to tune the devices accessibility by tasks,
i.e. grant full access for /dev/null, /dev/zero etc, grant read-only
access to IDE devices and completely hide SCSI disks.

Tasks still can call mknod to create device files, regardless of
whether the particular device is visible or accessible, but they
may not be able to open it later.

This one hides under CONFIG_CGROUP_DEVS option.

To play with it - run a standard procedure:

 # mount -t container none /cont/devs -o devices
 # mkdir /cont/devs/0
 # echo -n $$ > /cont/devs/0/tasks

and tune device permissions.

The only configuration file called devices.permissions accepts 
strings like '[cb] <major>:(<minor>|*) [r-][w-]' to provide read,
write or read-write access to a particular device. Asterisk as the
minor means "all devices with a given major".

This will be described in Documentation/controllers/devices.txt
file in more details.

Here are some historical notes.

The third version was here:
http://openvz.org/pipermail/devel/2008-February/010832.html
Changes from v2:
* Fixed problems pointed out by Sukadev with permissions
  revoke. Now we have to perform kobject re-lookup on
  each char device open, just like for block ones, so I
  think this is OK.

The second version was here:
http://openvz.org/pipermail/devel/2008-January/010160.html
Changes from v1:
* Added the block devices support :) It turned out to
  be a bit simpler than the char one (or I missed
  something significant);
* Now we can enable/disable not just individual devices,
  but the whole major with all its minors (see the TODO
  list beyond as well);
* Added the ability to restrict the read/write permissions
  to devices, not just visible/invisible state.

The first version was here:
http://openvz.org/pipermail/devel/2007-September/007647.html

Thanks,
Pavel
