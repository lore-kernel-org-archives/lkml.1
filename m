Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0CIOdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:33:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:41413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab0CIOdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:33:10 -0500
Date: Tue, 9 Mar 2010 06:18:01 -0800
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: odd lockdep messages
Message-ID: <20100309141801.GB28606@suse.de>
References: <24605.1268073053@localhost>
 <1268073831.4997.69.camel@laptop>
 <4B95AA4C.2030303@kernel.org>
 <4298.1268116039@localhost>
 <4B95EE4C.3020606@kernel.org>
 <5221.1268124692@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5221.1268124692@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 03:51:32AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 09 Mar 2010 15:44:28 +0900, Tejun Heo said:
> 
> (adding some cc: from the other 'BUG: key %p not found' thread)
> 
> > Hmm... the original percpu address check wasn't correct but wasn't too
> > far off either so it wouldn't be surprising nothing triggered it.
> > Yeap, stack trace should tell us where the address is coming from.
> 
> OK, I stuck in a dump_stack(), and took out the built-in firmware so we'd
> get 4 hits rather than 2.  What we got:
> 
> [    1.007551] BUG: key ffff88011c8b7d00 not in .data!
> [    1.007657] Pid: 1, comm: swapper Not tainted 2.6.33-mmotm0304 #5
> [    1.007763] Call Trace:
> [    1.007869]  [<ffffffff81061f63>] lockdep_init_map+0xab/0x10d
> [    1.007977]  [<ffffffff81135d83>] sysfs_add_file_mode+0x61/0xa7
> [    1.008095]  [<ffffffff81135dd5>] sysfs_add_file+0xc/0xe
> [    1.008201]  [<ffffffff81135e95>] sysfs_create_file+0x5a/0x63
> [    1.008320]  [<ffffffff812fb51c>] device_create_file+0x14/0x16
> [    1.008428]  [<ffffffff813d9942>] thermal_zone_device_register+0x3d2/0x63c
> [    1.008538]  [<ffffffff81264be9>] acpi_thermal_add+0x2dc/0x59f
> [    1.008646]  [<ffffffff8123a50b>] acpi_device_probe+0x4b/0x11d
> [    1.008753]  [<ffffffff812fdd25>] driver_probe_device+0xd5/0x166
> [    1.008861]  [<ffffffff812fde12>] __driver_attach+0x5c/0x80
> [    1.008968]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
> [    1.009079]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
> [    1.009185]  [<ffffffff812fd31f>] bus_for_each_dev+0x54/0x89
> [    1.009301]  [<ffffffff812fdb66>] driver_attach+0x19/0x1b
> [    1.009407]  [<ffffffff812fd7b1>] bus_add_driver+0xb4/0x203
> [    1.009513]  [<ffffffff812fe10f>] driver_register+0xb8/0x129
> [    1.009621]  [<ffffffff81b4b7a0>] ? acpi_thermal_init+0x0/0x7b
> [    1.009727]  [<ffffffff8123af12>] acpi_bus_register_driver+0x3e/0x40
> [    1.009835]  [<ffffffff81b4b7f9>] acpi_thermal_init+0x59/0x7b
> [    1.009942]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
> [    1.010064]  [<ffffffff81b2c687>] kernel_init+0x14d/0x1d7
> [    1.010171]  [<ffffffff810033d4>] kernel_thread_helper+0x4/0x10
> [    1.010289]  [<ffffffff81584040>] ? restore_args+0x0/0x30
> [    1.010394]  [<ffffffff81b2c53a>] ? kernel_init+0x0/0x1d7
> [    1.010500]  [<ffffffff810033d0>] ? kernel_thread_helper+0x0/0x10
> 
> [    1.010607] BUG: key ffff88011c8b7d48 not in .data!
> [    1.010711] Pid: 1, comm: swapper Not tainted 2.6.33-mmotm0304 #5
> [    1.010817] Call Trace:
> [    1.010919]  [<ffffffff81061f63>] lockdep_init_map+0xab/0x10d
> [    1.011030]  [<ffffffff81135d83>] sysfs_add_file_mode+0x61/0xa7
> [    1.011138]  [<ffffffff81135dd5>] sysfs_add_file+0xc/0xe
> [    1.011243]  [<ffffffff81135e95>] sysfs_create_file+0x5a/0x63
> [    1.011360]  [<ffffffff812fb51c>] device_create_file+0x14/0x16
> [    1.011467]  [<ffffffff813d99c1>] thermal_zone_device_register+0x451/0x63c
> [    1.011576]  [<ffffffff81264be9>] acpi_thermal_add+0x2dc/0x59f
> [    1.011683]  [<ffffffff8123a50b>] acpi_device_probe+0x4b/0x11d
> [    1.011790]  [<ffffffff812fdd25>] driver_probe_device+0xd5/0x166
> [    1.011897]  [<ffffffff812fde12>] __driver_attach+0x5c/0x80
> [    1.012003]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
> [    1.012114]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
> [    1.012221]  [<ffffffff812fd31f>] bus_for_each_dev+0x54/0x89
> [    1.012340]  [<ffffffff812fdb66>] driver_attach+0x19/0x1b
> [    1.012446]  [<ffffffff812fd7b1>] bus_add_driver+0xb4/0x203
> [    1.012553]  [<ffffffff812fe10f>] driver_register+0xb8/0x129
> [    1.012659]  [<ffffffff81b4b7a0>] ? acpi_thermal_init+0x0/0x7b
> [    1.012766]  [<ffffffff8123af12>] acpi_bus_register_driver+0x3e/0x40
> [    1.012874]  [<ffffffff81b4b7f9>] acpi_thermal_init+0x59/0x7b
> [    1.012980]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
> [    1.013092]  [<ffffffff81b2c687>] kernel_init+0x14d/0x1d7
> [    1.013197]  [<ffffffff810033d4>] kernel_thread_helper+0x4/0x10
> [    1.013314]  [<ffffffff81584040>] ? restore_args+0x0/0x30
> [    1.013421]  [<ffffffff81b2c53a>] ? kernel_init+0x0/0x1d7
> [    1.013526]  [<ffffffff810033d0>] ? kernel_thread_helper+0x0/0x10
> 
> [    2.859634] BUG: key ffff88011fe16270 not in .data!
> [    2.859654] Pid: 828, comm: firmware/iwlwif Not tainted 2.6.33-mmotm0304 #5
> [    2.859656] Call Trace:
> [    2.859665]  [<ffffffff81061f63>] lockdep_init_map+0xab/0x10d
> [    2.859669]  [<ffffffff81135d83>] sysfs_add_file_mode+0x61/0xa7
> [    2.859672]  [<ffffffff81135dd5>] sysfs_add_file+0xc/0xe
> [    2.859675]  [<ffffffff81137f08>] sysfs_create_bin_file+0x5a/0x63
> [    2.859680]  [<ffffffff81303a0f>] _request_firmware+0x421/0x431
> [    2.859683]  [<ffffffff81303a1f>] ? request_firmware_work_func+0x0/0x63
> [    2.859686]  [<ffffffff81303a59>] request_firmware_work_func+0x3a/0x63
> [    2.859690]  [<ffffffff81051d87>] kthread+0x7a/0x82
> [    2.859694]  [<ffffffff810033d4>] kernel_thread_helper+0x4/0x10
> [    2.859699]  [<ffffffff81584040>] ? restore_args+0x0/0x30
> [    2.859702]  [<ffffffff81051d0d>] ? kthread+0x0/0x82
> [    2.859704]  [<ffffffff810033d0>] ? kernel_thread_helper+0x0/0x10
> 
> [   11.534112] BUG: key ffff88011fe16270 not in .data!
> [   11.534116] Pid: 1556, comm: firmware/iwlwif Not tainted 2.6.33-mmotm0304 #5
> [   11.534118] Call Trace:
> [   11.534128]  [<ffffffff81061f63>] lockdep_init_map+0xab/0x10d
> [   11.534133]  [<ffffffff81135d83>] sysfs_add_file_mode+0x61/0xa7
> [   11.534137]  [<ffffffff81135dd5>] sysfs_add_file+0xc/0xe
> [   11.534141]  [<ffffffff81137f08>] sysfs_create_bin_file+0x5a/0x63
> [   11.534151]  [<ffffffff81303a1f>] ? request_firmware_work_func+0x0/0x63
> [   11.534147]  [<ffffffff81303a0f>] _request_firmware+0x421/0x431
> [   11.534154]  [<ffffffff81303a59>] request_firmware_work_func+0x3a/0x63
> [   11.534159]  [<ffffffff81051d87>] kthread+0x7a/0x82
> [   11.534164]  [<ffffffff810033d4>] kernel_thread_helper+0x4/0x10
> [   11.534169]  [<ffffffff81584040>] ? restore_args+0x0/0x30
> [   11.534173]  [<ffffffff81051d0d>] ? kthread+0x0/0x82
> [   11.534176]  [<ffffffff810033d0>] ? kernel_thread_helper+0x0/0x10
> 
> So yeah, this looks like more sysfs breakage.

It is due to sysfs, but it is because we forgot to proper initialize a
sysfs attribute somewhere.  Nothing is "broken" here, the system still
works properly.

Eric, care to look into this one as well?

thanks,

greg k-h
