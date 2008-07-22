Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbYGVIrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbYGVIrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbYGVIra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:47:30 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:36982 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYGVIr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:47:29 -0400
Date: Tue, 22 Jul 2008 10:47:10 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, nikola.ciprich@linuxbox.cz,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.22: USB getting stuck on SuperMicro PDSME+ boards
Message-ID: <20080722084710.GD21035@develbox.linuxbox.cz>
References: <20080722074357.GC21035@develbox.linuxbox.cz> <200807220948.28649.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807220948.28649.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 876340 records(22-07-2008)
X-Envelope-From: ciprich@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olivirier,

thanks for reply. I know it would be best to try 2.6.26, but that's what
I can't do. So I'd like to find if the problem was already fixed, and 
if it was, then to backport the fix to our kernel. And if it wasn't, then to fix
it even for 2.6.27 :)

I took traces You asked me about, here is the snippet of the ones I think could
be interesting:
Stuck khubd:
[8468184.549854]  =======================
[8468184.549883] khubd         D df881e24     0   138      2
[8468184.549964]        df933730 00000046 00000002 df881e24 c0312e65 00000001 d832b3c0 00000002
[8468184.550199]        df933894 df933894 c1408a00 df10f200 c040c080 c040c080 df702e58 df702e58
[8468184.550362]        df81d998 c040c080 00000286 00001c25 00000000 00000000 00000296 00000296
[8468184.550524] Call Trace:
[8468184.550554]  [<c0312e65>] schedule_timeout+0x75/0xc0
[8468184.550644]  [<c0312e65>] schedule_timeout+0x75/0xc0
[8468184.550727]  [<c03136dd>] __mutex_lock_slowpath+0xfd/0x230
[8468184.550810]  [<c0312334>] wait_for_common+0x94/0x140
[8468184.550869]  [<c0120710>] default_wake_function+0x0/0x10
[8468184.550904]  [<c01c5031>] sysfs_addrm_finish+0x161/0x1c0
[8468184.550988]  [<c01c3be2>] sysfs_hash_and_remove+0x42/0x70
[8468184.551023]  [<c0268a77>] usb_remove_sysfs_dev_files+0x67/0x80
[8468184.551032]  [<c02651fc>] usb_unbind_device+0xc/0x10
[8468184.551089]  [<c0258054>] __device_release_driver+0x64/0xa0
[8468184.551172]  [<c025849e>] device_release_driver+0x1e/0x40
[8468184.551229]  [<c025792a>] bus_remove_device+0x5a/0x80
[8468184.551286]  [<c0255d11>] device_del+0x151/0x260
[8468184.551393]  [<c025f38d>] usb_disconnect+0xad/0x120
[8468184.551453]  [<c02607af>] hub_thread+0x35f/0xcd0
[8468184.551551]  [<c011e4db>] __wake_up_common+0x4b/0x80
[8468184.551562]  [<c013c6c0>] autoremove_wake_function+0x0/0x50
[8468184.551576]  [<c0260450>] hub_thread+0x0/0xcd0
[8468184.551584]  [<c013c412>] kthread+0x42/0x70
[8468184.551589]  [<c013c3d0>] kthread+0x0/0x70
[8468184.551598]  [<c0104eaf>] kernel_thread_helper+0x7/0x18
[8468184.551608]  =======================

lshw stuck accessing /proc/bus/usb/devices:
[8468184.571118] lshw          D df1f7ef0     0 23354      1
[8468184.571150]        df0299b0 00000086 00000002 df1f7ef0 df1f7ee8 00000000 00000000 c037b0ae
[8468184.571386]        df029b14 df029b14 c1408a00 dfb51900 c040c080 c040c080 deece800 dfb50206
[8468184.571523]        c9908614 c040c080 0009bd4e 00000000 00000001 dee63184 ffffffff 00000000
[8468184.571710] Call Trace:
[8468184.571724]  [<c031447c>] __down+0x8c/0xf4
[8468184.571732]  [<c0120710>] default_wake_function+0x0/0x10
[8468184.571767]  [<c031424b>] __down_failed+0x7/0xc
[8468184.571775]  [<c026e99d>] usb_device_read+0xbd/0x150
[8468184.571812]  [<c0182565>] vfs_read+0xb5/0x180
[8468184.571869]  [<c026e8e0>] usb_device_read+0x0/0x150
[8468184.571878]  [<c0182ae1>] sys_read+0x41/0x70
[8468184.571886]  [<c010425e>] sysenter_past_esp+0x5f/0x85

Does it help somehow? is there anything else I could do?
anyways thanks a lot for Your time
best regards
nik


> Try to get a sysrq-t trace when it happens again. We need to know which
> lock it hangs on. Also can you try 2.6.26? The bug may already be fixed.
> 
> 	Regards
> 		Oliver
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
