Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYLZL0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYLZL0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 06:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYLZL0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 06:26:41 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:51805 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYLZL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 06:26:41 -0500
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Dec 2008 06:26:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1IAHVJVEnZ07hnPGdsb2JhbACBbIceilgBAQEBNQGpK1iPNIZE
Message-ID: <4954BAAB.9090108@zappa.cx>
Date: Fri, 26 Dec 2008 12:06:19 +0100
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decided to try out 2.6.28 on a xen VM yesterday.
Used my old 2.6.27 .config as a base and did an "make oldconfig" and
answered any questions that came up.

Everything went fine and the new kernel booted and worked nicely.

Now I wanted to try the new ext4 fs (for no particular reason other than
it being new)
So to start with I tried it without updating the actual fs layout to
ext4, I left it at ext3 and only mounted it as ext4.

That meant adding this to the xen VM config file:
extra = "console=hvc0 rootfstype=ext4"

And also changing to ext4 in /etc/fstab

That also worked fine and I saw that some stuff was being enabled (like
barriers)
But today I noticed that something was wrong with the VM and I noticed
after a while that the root volume was read-only (this VM only has a
root partition).

I noticed the time that the logs were written to last and that was
around the time my backups are being run.

I use a little script that backup this xen VM from xen dom0.

Here is the interesting part of my script:
/usr/sbin/xm sysrq xenfw1 s
/usr/sbin/xm pause xenfw1
sync
/sbin/lvm lvcreate --snapshot --permission rw --size 1G --name xenfw1_s
/dev/3w250g/xenfw1 > /dev/null
/usr/sbin/xm unpause xenfw1
/bin/mount -o ro,noatime /dev/3w250g/xenfw1_s /mnt/snapshots/xenfw1 ||
/bin/rmdir /mnt/snapshots/xenfw1
# Here's where the actual backups take place
/bin/umount /mnt/snapshots/xenfw1 2> /dev/null
/sbin/lvm lvremove --force /dev/3w250g/xenfw1_s > /dev/null

After the "lvcreate --snapshot" if I check within the xen VM (with cat
/proc/mounts) I can see that / changed from rw to ro:
Before snapshot:
/dev/root / ext4 rw,noatime,barrier=1,noextents,data=ordered 0 0
After snapshot:
/dev/root / ext4 ro,noatime,barrier=1,noextents,data=ordered 0 0

It was not possible to do "mount -o remount,rw /":
mount -o remount,rw
/                                                                                      

mount: block device /dev/xvda1 is write-protected, mounting read-only  

I don't see how this could be an expected behaviour so I thought it
might be good to report it here.
I hope I explained the scenario good enough, I can reproduce this if you
want more details (now I'm back on ext3 on this xen VM)

P.S. I'm currently not subscribed so please CC me on any posts regarding
this.

/Andreas Sundstrom
