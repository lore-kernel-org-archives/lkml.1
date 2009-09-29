Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZI2SOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZI2SOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZI2SOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:14:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:4497 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZI2SOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,475,1249282800"; 
   d="scan'208";a="193041846"
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
From: reinette chatre <reinette.chatre@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       johannes@sipsolutions.net
In-Reply-To: <20090929171249.GB14405@elf.ucw.cz>
References: <20090929171249.GB14405@elf.ucw.cz>
Content-Type: text/plain
Date: Tue, 29 Sep 2009 11:14:50 -0700
Message-Id: <1254248090.26521.1530.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Tue, 2009-09-29 at 10:12 -0700, Pavel Machek wrote:

> wlan0: Selected IBSS BSSID 02:18:41:de:3f:02 based on configured SSID
> wlan0: Trigger new scan to find an IBSS to join
> wlan0: Trigger new scan to find an IBSS to join
> wlan0: Creating new IBSS network, BSSID f2:d3:80:82:ed:6a
> wlan0: Creating new IBSS network, BSSID 52:17:bf:45:d6:9d
> skb_over_panic: text:c07b4113 len:130 put:36 head:e4c3edf0
> data:e4c3edf0 tail:0xe4c3ee72 end:0xe4c3ee70 dev:<NULL>

Looks like the ibss code is trying to use more space in skb than it
allocated. It thus does not seem specific to iwl3945. I am not familiar
with that code, but it looks that the skb allocation in
ieee80211_ibss_join does not accommodate the ibss probe response that is
inserted in __ieee80211_sta_join_ibss. I hope that Johannes can guide us
here.

> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:127!
> invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file:
> /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/status
> Modules linked in:
> 
> Pid: 1353, comm: iwl3945 Not tainted (2.6.31 #72) 17097HU
> EIP: 0060:[<c06d7189>] EFLAGS: 00010286 CPU: 0
> EIP is at skb_put+0x89/0x90
> EAX: 00000079 EBX: e4c3ee72 ECX: c0230881 EDX: 01eef000
> ESI: 00000024 EDI: f5e20fc0 EBP: f5dcde04 ESP: f5dcddd8
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process iwl3945 (pid: 1353, ti=f5dcc000 task=f72e4698
> task.ti=f5dcc000)
> Stack:
>  c0a28c24 c07b4113 00000082 00000024 e4c3edf0 e4c3edf0 e4c3ee72
> e4c3ee70
> <0> c09ac8b9 0000009c 66666667 f5dcde74 c07b4113 00000037 00000007
> 00000282
> <0> 00000002 00000000 00000040 00000006 00000064 f5e1bbc0 f5e1be23
> c03e82b1
> Call Trace:
>  [<c07b4113>] ? __ieee80211_sta_join_ibss+0x143/0x3d0
>  [<c07b4113>] ? __ieee80211_sta_join_ibss+0x143/0x3d0
>  [<c03e82b1>] ? extract_entropy+0x51/0xa0
>  [<c07b4677>] ? ieee80211_sta_find_ibss+0x227/0x450
>  [<c07fcdc2>] ? mutex_lock_nested+0x1c2/0x230
>  [<c07b48b7>] ? ieee80211_ibss_notify_scan_completed+0x17/0x80
>  [<c07b4909>] ? ieee80211_ibss_notify_scan_completed+0x69/0x80
>  [<c07b1b85>] ? ieee80211_scan_completed+0xc5/0x450
>  [<c0239e29>] ? del_timer_sync+0x59/0x70
>  [<c0239dd0>] ? del_timer_sync+0x0/0x70
>  [<c052a4df>] ? iwl_bg_scan_completed+0x3f/0x80
>  [<c024089d>] ? worker_thread+0x16d/0x280
>  [<c024083a>] ? worker_thread+0x10a/0x280
>  [<c052a4a0>] ? iwl_bg_scan_completed+0x0/0x80
>  [<c02449d0>] ? autoremove_wake_function+0x0/0x50
>  [<c0240730>] ? worker_thread+0x0/0x280
>  [<c02446dc>] ? kthread+0x7c/0x90
>  [<c0244660>] ? kthread+0x0/0x90
>  [<c020385f>] ? kernel_thread_helper+0x7/0x18
> Code: 44 24 14 8b 81 a0 00 00 00 89 74 24 0c 89 44 24 10 8b 41 50 c7
> 04 24 24 8c a2 c0 89 44 24 08 8b
> 45 04 89 44 24 04 e8 a7 40 12 00 <0f> 0b eb fe 8d 76 00 55 89 e5 57 56
> 53 83 ec 18 89 45 e4 89 55
> EIP: [<c06d7189>] skb_put+0x89/0x90 SS:ESP 0068:f5dcddd8
> ---[ end trace 5d5762000564cd5a ]---

Reinette


