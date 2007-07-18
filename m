Return-Path: <linux-kernel-owner+w=401wt.eu-S936736AbXGRAVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936736AbXGRAVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbXGRAUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:20:55 -0400
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:57532 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756099AbXGRAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:20:53 -0400
To: linux-kernel@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Occational lockups during boot with post 2.6.22 kernels
From: Peter Osterlund <petero2@telia.com>
Date: 18 Jul 2007 02:20:34 +0200
Message-ID: <m3sl7mk1f1.fsf@telia.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Current -git kernels sometimes lock up on my computer during boot. I
guess it happens about 10-20% of the time. I first saw this maybe a
week ago, but never with kernels <= 2.6.22.

The last reported info on the console is that named is started.
SysRq-T still works and reports the non-sleeping tasks below.

My guess is that wpa_supplicant and events/0 deadlock and later the
named thread also hangs when it needs a deadlocked resource.

I'm using the bcm43xx driver.
 
No lockdep errors are reported before the lockup. Earlier during boot
the kernel reports:

  Good, all 218 testcases passed! |

SysRq-T output:

   =======================
  events/0      D 00000001     0     5      2
         dfe0fe64 00000092 935ee27c 00000001 c0345e48 935ee27c 00000001 c0462fc0
         00000001 dcab5040 dcd44de4 dcd44da4 00000246 dfe0cb90 dfe0fea0 c0345df6
         00000000 00000002 c0346026 00000000 dcd44dd0 dcd44dd0 dcd44dd0 dfe0cb90
  Call Trace:
   [<c0345df6>] __mutex_lock_slowpath+0xb2/0x2c6
   [<c0346026>] mutex_lock+0x1c/0x1f
   [<e08b6bab>] ieee80211softmac_assoc_work+0x24/0x51b [ieee80211softmac]
   [<e08b70b5>] ieee80211softmac_assoc_notify_scan+0x13/0x15 [ieee80211softmac]
   [<e08b7653>] ieee80211softmac_notify_callback+0x41/0x7a [ieee80211softmac]
   [<c012a80c>] run_workqueue+0xbb/0x13d
   [<c012b0b1>] worker_thread+0x9a/0xf9
   [<c012d84e>] kthread+0x36/0x58
   [<c0104b87>] kernel_thread_helper+0x7/0x10
 
   =======================
  klogd         R running      0  2771      1
  wpa_supplican D 00000001     0  2806      1
         dc309d7c 00200082 935ecce6 00000001 c0138e84 935ecce6 00000001 00200046
         dc309dbc dcab5040 dc309db8 dc309dbc dc309db8 dcd44fd4 dc309da0 c0344f98
         00000001 dcfdd350 c01186cc dc309de4 dc309de4 dff61740 dcd44fd4 dc309df0
  Call Trace:
   [<c0344f98>] wait_for_completion+0x91/0xc8
   [<c012a98b>] flush_cpu_workqueue+0x47/0x6f
   [<c012ae46>] flush_workqueue+0x1c/0x1f
   [<c012ae56>] flush_scheduled_work+0xd/0xf
   [<e08b699c>] ieee80211softmac_wx_set_essid+0x144/0x188 [ieee80211softmac]
   [<c0343811>] ioctl_standard_call+0x16b/0x350
   [<c0343d51>] wext_handle_ioctl+0x35b/0x3e5
   [<c02e4ea2>] dev_ioctl+0x322/0x33d
   [<c02d8587>] sock_ioctl+0xba/0x1d8
   [<c0171d02>] do_ioctl+0x22/0x71
   [<c0171da6>] vfs_ioctl+0x55/0x28a
   [<c017200e>] sys_ioctl+0x33/0x51
   [<c0103f36>] sysenter_past_esp+0x5f/0x99
 
   =======================
  named         D 00000001     0  2836   2834
         dbdc5e70 00200082 960324f3 00000001 c0345e48 960324f3 00000001 c0462fc0
         00000001 dd0d6300 c0454e20 c0454de0 00200246 c1694fd0 dbdc5eac c0345df6
         00000000 00000002 c0346026 00000000 c0454e0c c0454e0c c0454e0c c1694fd0
  Call Trace:
   [<c0345df6>] __mutex_lock_slowpath+0xb2/0x2c6
   [<c0346026>] mutex_lock+0x1c/0x1f
   [<c02ec08c>] rtnl_lock+0xd/0xf
   [<c02e4c32>] dev_ioctl+0xb2/0x33d
   [<c02d8587>] sock_ioctl+0xba/0x1d8
   [<c0171d02>] do_ioctl+0x22/0x71
   [<c0171da6>] vfs_ioctl+0x55/0x28a
   [<c017200e>] sys_ioctl+0x33/0x51
   [<c0103f36>] sysenter_past_esp+0x5f/0x99

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
