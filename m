Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbYG0Gaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbYG0Gaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbYG0GaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:30:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590AbYG0GaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:30:09 -0400
Date: Sun, 27 Jul 2008 08:29:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] lost sysctl fix
Message-ID: <20080727062956.GA24749@elte.hu>
References: <14615.1217125366@turing-police.cc.vt.edu> <20080726202525.3ac3052f.akpm@linux-foundation.org> <21657.1217130229@turing-police.cc.vt.edu> <20080727040908.GX28946@ZenIV.linux.org.uk> <20080727051702.GY28946@ZenIV.linux.org.uk> <20080727053122.GZ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727053122.GZ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> try_attach() should walk into the matching subdirectory, not the first one...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> [and yes, that's what that crap had been]

does this explain the following crash -tip testing just triggered with 
latest -git:

[   12.293289] calling  butterfly_init+0x0/0x14
[   12.298036] BUG: unable to handle kernel NULL pointer dereference at 00000004
[   12.302065] IP: [<c012c169>] __register_sysctl_paths+0x1af/0x253
[   12.308058] *pdpt = 0000000000b81001 *pde = 0000000000000000 
[   12.314809] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   12.323850] 
[   12.326808] Pid: 1, comm: swapper Not tainted (2.6.26-tip-01710-g55a4e73-dirty #22360)
[   12.340001] EIP: 0060:[<c012c169>] EFLAGS: 00010246 CPU: 1
[   12.350001] EIP is at __register_sysctl_paths+0x1af/0x253
[   12.350001] EAX: 00000001 EBX: f5b7bb60 ECX: c0a40e7e EDX: 00000000
[   12.360002] ESI: 00000000 EDI: f5b8660c EBP: f6c25ed4 ESP: f6c25e98
[   12.370002]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   12.370002] Process swapper (pid: 1, ti=f6c25000 task=f6c40000 task.ti=f6c25000)
[   12.380003] Stack: c0a80b4c c0a7f17c f5b7bb60 f5b7bb90 00000000 c0a7f184 f5aba4d0 f5b7bb64 
[   12.390003]        00000001 00000001 c0a40e7e 00000000 f5b1e840 c082448c f5b475e0 f6c25ee0 
[   12.400003]        c012c230 f5b8676c f6c25ee8 c012c246 f6c25f08 c03d2213 f5b865b0 f5b475e0 
[   12.410004] Call Trace:
[   12.410004]  [<c012c230>] ? register_sysctl_paths+0x23/0x25
[   12.420004]  [<c012c246>] ? register_sysctl_table+0x14/0x16
[   12.430005]  [<c03d2213>] ? parport_device_proc_register+0xb3/0xda
[   12.430005]  [<c03d1863>] ? parport_register_device+0x17e/0x1be
[   12.440005]  [<c05d9661>] ? butterfly_attach+0x96/0x1e9
[   12.450005]  [<c03d1416>] ? parport_register_driver+0x25/0x65
[   12.450005]  [<c0b4f6f9>] ? butterfly_init+0x12/0x14
[   12.459919]  [<c0101042>] ? do_one_initcall+0x42/0x11d
[   12.460006]  [<c0b4f6e7>] ? butterfly_init+0x0/0x14
[   12.469746]  [<c01338d6>] ? start_workqueue_thread+0x22/0x25
[   12.480007]  [<c0133bd2>] ? __create_workqueue_key+0xa9/0x14a
[   12.480007]  [<c0b26607>] ? kernel_init+0x17c/0x1e3
[   12.489747]  [<c0b2648b>] ? kernel_init+0x0/0x1e3
[   12.490007]  [<c01048b7>] ? kernel_thread_helper+0x7/0x10
[   12.500007]  =======================
[   12.500007] Code: 00 75 34 83 7f 2c 00 75 2e 8b 75 f0 eb 1d 83 7e 14 00 74 14 85 c0 74 10 8b 55 ec e8 0d e0 20 00 85 c0 0f 84 87 00 00 00 83 c6 2c <8b> 46 04 85 c0 75 dc 83 3e 00 75 d7 83 7d e8 00 74 15 83 7d e4 
[   12.530008] EIP: [<c012c169>] __register_sysctl_paths+0x1af/0x253 SS:ESP 0068:f6c25e98
[   12.530008] Kernel panic - not syncing: Fatal exception
[   12.535690] Pid: 1, comm: swapper Tainted: G      D   2.6.26-tip-01710-g55a4e73-dirty #22360
[   12.544884]  [<c0126077>] panic+0x44/0xe4
[   12.550001]  [<c0104bff>] oops_end+0x61/0x85
[   12.552430]  [<c010510d>] die+0x5c/0x64
[   12.554614]  [<c0114850>] do_page_fault+0x67f/0x73f
[   12.560635]  [<c013afbb>] ? sysctl_check_table+0x445/0x46e
[   12.567413]  [<c01141d1>] ? do_page_fault+0x0/0x73f
[   12.576820]  [<c07a96b2>] error_code+0x72/0x80
[   12.581092]  [<c012c169>] ? __register_sysctl_paths+0x1af/0x253
[   12.584465]  [<c012c230>] register_sysctl_paths+0x23/0x25
[   12.591447]  [<c012c246>] register_sysctl_table+0x14/0x16
[   12.601870]  [<c03d2213>] parport_device_proc_register+0xb3/0xda
[   12.609130]  [<c03d1863>] parport_register_device+0x17e/0x1be
[   12.615959]  [<c05d9661>] butterfly_attach+0x96/0x1e9
[   12.620001]  [<c03d1416>] parport_register_driver+0x25/0x65
[   12.623174]  [<c0b4f6f9>] butterfly_init+0x12/0x14
[   12.627408]  [<c0101042>] do_one_initcall+0x42/0x11d
[   12.633537]  [<c0b4f6e7>] ? butterfly_init+0x0/0x14
[   12.641475]  [<c01338d6>] ? start_workqueue_thread+0x22/0x25
[   12.650001]  [<c0133bd2>] ? __create_workqueue_key+0xa9/0x14a
[   12.653274]  [<c0b26607>] kernel_init+0x17c/0x1e3
[   12.657343]  [<c0b2648b>] ? kernel_init+0x0/0x1e3
[   12.663027]  [<c01048b7>] kernel_thread_helper+0x7/0x10
[   12.668949]  =======================
[   12.672750] Rebooting in 1 seconds..Press any key to enter the menu

?

	Ingo
