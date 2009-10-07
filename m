Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZJGRyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZJGRyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759602AbZJGRyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:54:46 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:41222
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757978AbZJGRyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:54:45 -0400
Date: Wed, 7 Oct 2009 19:54:03 +0200
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
Message-ID: <20091007175403.GA335@trillian.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

(Please CC me on any replies since I am not subscribed to the list.)

After upgrading to 2.6.31.2 I noticed a strange behaviour with my
/dev/ttySx entries. I tried earlier kernels too and saw the same thing
happening, albeit not as often. So what's the probem?

Short description:
Although I see this in dmesg
serial 00:05: activated
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:06: activated
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

very often after boot either ttyS0 or ttyS1 is missing under /dev.
I tried to figure out what was happening and did the following.

* stopped udevd
* rmmod 8250_pnp
* rmmod 8250

No more /dev/ttySx entries under dev.

Then I started udevd --debug and loaded 8250. 
As a result ttyS[0123] were created. Then I loaded 8250_pnp.
Now here the problem starts (normally after a few rmmod;modprobe cycles). 
I removed the 8250_pnp module again and the ttyS entries stayed (I think 
because of the 8250 module). Upon re-inserting the 8250_pnp module disappeared vanished. 
I think this is part of the relevant udev output

1254937120.013500 [24944] event_queue_delete: seq 10438 done with 0
1254937120.016933 [24944] event_queue_insert: seq 10439 queued, 'remove'
'tty'
1254937120.017101 [24944] udev_monitor_send_device: passed 148 bytes to
monitor 0x813a1f0
1254937120.017245 [25361] worker_new: seq 10439 running
1254937120.017387 [25361] udev_device_read_db: device 0x8149f80 filled
with db symlink data '/dev/ttyS1'
1254937120.017611 [25361] update_link: no reference left, remove
'/dev/char/4:65'
1254937120.018123 [24944] event_queue_insert: seq 10440 queued, 'add'
'tty'
1254937120.018314 [24944] udev_monitor_send_device: passed 136 bytes to
monitor 0x813a1f0
1254937120.018473 [25362] worker_new: seq 10440 running
1254937120.018629 [25362] udev_device_new_from_syspath: device 0x814a048
has devpath '/devices/pnp0/00:06/tty/ttyS1'
1254937120.018763 [25362] udev_rules_apply_to_event: LINK 'char/4:65'
/lib/udev/rules.d/50-udev-default.rules:2
1254937120.018943 [25362] udev_device_new_from_syspath: device 0x813a1f0
has devpath '/devices/pnp0/00:06'
1254937120.019085 [25362] udev_device_new_from_syspath: device 0x814a3d0
has devpath '/devices/pnp0'
1254937120.019207 [25362] udev_rules_apply_to_event: GROUP 20
/lib/udev/rules.d/91-permissions.rules:48
1254937120.019301 [25362] udev_event_execute_rules: no node name set,
will use device name 'ttyS1'
1254937120.019395 [25362] udev_device_update_db: create db link (ttyS1
char/4:65)
1254937120.019476 [25362] udev_node_add: creating device node
'/dev/ttyS1', devnum=4:65, mode=0660, uid=0, gid=20
1254937120.019597 [25362] udev_node_mknod: preserve file '/dev/ttyS1',
because it has correct dev_t
1254937120.019850 [25362] update_link: '/dev/char/4:65' with target
'/dev/ttyS1' has the highest priority 0, create it
1254937120.019994 [25362] node_symlink: preserve already existing
symlink '/dev/char/4:65' to '../ttyS1'
1254937120.020122 [25362] udev_monitor_send_device: passed -1 bytes to
monitor 0x814a8d8
1254937120.020223 [25362] worker_new: seq 10440 processed with 0
1254937120.020375 [24944] event_queue_delete: seq 10440 done with 0
1254937120.020527 [24944] event_queue_insert: seq 10441 queued, 'add'
'drivers'
1254937120.020697 [24944] udev_monitor_send_device: passed 117 bytes to
monitor 0x813a1f0
1254937120.020840 [25362] worker_new: seq 10441 running
1254937120.021093 [25362] udev_monitor_send_device: passed -1 bytes to
monitor 0x814a8d8
1254937120.021212 [25362] worker_new: seq 10441 processed with 0
1254937120.021491 [25361] udev_node_remove: removing device node
'/dev/ttyS1'
1254937120.021695 [25361] udev_monitor_send_device: passed -1 bytes to
monitor 0x8149740
1254937120.021794 [25361] worker_new: seq 10439 processed with 0
1254937120.021941 [24944] event_queue_delete: seq 10441 done with 0
1254937120.022067 [24944] event_queue_delete: seq 10439 done with 0
1254937174.180067 [24944] event_queue_insert: seq 10442 queued, 'add'
'uids'
1254937174.180250 [24944] udev_monitor_send_device: passed 109 bytes to
monitor 0x813a1f0
1254937174.181362 [25361] worker_new: seq 10442 running
1254937174.181645 [25361] udev_monitor_send_device: passed -1 bytes to
monitor 0x8149740
1254937174.182118 [25361] worker_new: seq 10442 processed with 0
1254937174.182249 [24944] event_queue_delete: seq 10442 done with 0
1254937174.217080 [24944] event_queue_insert: seq 10443 queued, 'remove'
'uids'
1254937174.217226 [24944] udev_monitor_send_device: passed 112 bytes to
monitor 0x813a1f0
1254937174.217330 [25361] worker_new: seq 10443 running
1254937174.217466 [25361] udev_monitor_send_device: passed -1 bytes to
monitor 0x8149740
1254937174.217542 [25361] worker_new: seq 10443 processed with 0
1254937174.217647 [24944] event_queue_delete: seq 10443 done with 0


It looks there is a race here. The code sees that ttyS1 is existing and wants to reuse it
but at the same time deletes it. So I end up with either no ttyS0 or
ttyS1. I would not really care if this was just happening during the
rmmod;modprobe shuffle but this also happens fairly often during boot as
well. A headless system is connected via ttyS0 and I have to either
create the entry manually or restart udev to be able to connect to
it. I tried this on 2.6.30.2, 2.6.31 and 2.6.31.2 with the latest udev
from debian and from the git tree.

Kind regards,
Michael
