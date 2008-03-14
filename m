Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYCNSDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYCNSDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYCNSD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:03:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40286 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYCNSDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:03:25 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Dave Hansen <haveblue@us.ibm.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <47D9C853.3040701@imap.cc>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	 <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>
	 <47D9C853.3040701@imap.cc>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 11:03:22 -0700
Message-Id: <1205517802.12763.18.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 01:35 +0100, Tilman Schmidt wrote:
> On 13.03.2008 21:46 you wrote:
> > Could you send me your full dmesg along with your kernel .config?  i
> > think this is an ordering issue in bootup, but I'd like to be sure.
> > Bonus points if I can also have your initrd. :)
> 
> And later:
> 
> > If you can send me your vmlinux (not vmlinuz), I'll see how the
> > initcalls are laid out in it.
> 
> Ok, you asked for it. Find the lot at:
> 
> http://gollum.phnxsoft.com/~ts/linux/
> 
> I guess you know what to expect, sizewise. :-)
> 
> (Don't worry about the cpufreq.debug note, that's for a different issue.)
> 
> > What distro and compiler are you on?
> 
> openSUSE 10.3 and the toolchain it brought along, including GCC 4.2.1.

Tim, thanks for the excellent debugging info.  It's making this much
easier.  I actually booted your vmlinux in a kvm image and I got the
same error.  However, it is in a *completely* bogus place.  Certainly
before initcalls get run and before the lock you saw the BUG_ON() for
got initialized. 

I'm going to go try and find a gcc-4.2 and compile on that.

Andrew, I don't think this is an actual bug in the r/o bind mount code,
but a random, way early call to populate_rootfs(), somehow.  I'll keep
looking into it, though.

Notice in the dmesg that this all happens even before the first initcall
is made?  It isn't the SMP alternates freeing, at least.  I booted this
on SMP, too, with the same results. 

[    0.074025] Intel machine check architecture supported.
[    0.075013] Intel machine check reporting enabled on CPU#0.
[    0.076010] Compat vDSO mapped to ffffe000.
[    0.078030] Checking 'hlt' instruction... OK.
[    0.083987] SMP alternatives: switching to UP code
[    0.084023] Freeing SMP alternatives: 9k freed
[    0.086006] BUG: spinlock bad magic on CPU#0, swapper/0
[    0.087002]  lock: c1754380, .magic: 00000000, .owner: swapper/0, .owner_cpu: 0
[    0.088003] Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1-testing #2
[    0.089001]  [<c01f728c>] spin_bug+0x7c/0x87
[    0.091002]  [<c01f72b0>] _raw_spin_unlock+0x19/0x71
[    0.093001]  [<c0301922>] _spin_unlock+0x1d/0x3c
[    0.095001]  [<c01981aa>] mnt_want_write+0x62/0x88
[    0.097000]  [<c018c382>] sys_mkdirat+0x86/0xd6
[    0.098695]  [<c04260ab>] ? clean_path+0x16/0x4a
[    0.100000]  [<c017fd6f>] ? kfree+0xd8/0xec
[    0.101999]  [<c018c3e2>] sys_mkdir+0x10/0x12
[    0.103999]  [<c0426353>] do_name+0x112/0x1b3
[    0.104999]  [<c042558b>] write_buffer+0x1d/0x2c
[    0.106999]  [<c04255fe>] flush_window+0x64/0xb3
[    0.108998]  [<c04272f5>] unpack_to_rootfs+0x62c/0x8b9
[    0.111000]  [<c0127d76>] ? printk+0x15/0x17
[    0.112671]  [<c0118982>] ? free_init_pages+0x82/0x8d
[    0.113998]  [<c04275a2>] populate_rootfs+0x20/0x109
[    0.115997]  [<c0429ed2>] ? alternative_instructions+0x153/0x158
[    0.117997]  [<c04248f5>] start_kernel+0x343/0x355
[    0.119997]  [<c0424019>] i386_start_kernel+0x8/0xa
[    0.121996]  =======================
[    0.124073] Unpacking initramfs... done
[    0.732294] Freeing initrd memory: 8767k freed
[    0.732921] ACPI: Core revision 20070126
[    0.734193] ACPI: Checking initramfs for custom DSDT
[    0.736621] Parsing all Control Methods:
[    0.737060] Table [DSDT](id 0001) - 170 Objects with 14 Devices 75 Methods 5 Regions
[    0.737904]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.740962] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[    0.744478] CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
[    0.750695] Total of 1 processors activated (5393.60 BogoMIPS).
[    0.755342] ENABLING IO-APIC IRQs
[    0.757878] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.768883] Brought up 1 CPUs
[    0.788092] CPU0 attaching sched-domain:
[    0.788887]  domain 0: span 01
[    0.790183]   groups: 01
[    0.791974] PM: Adding info for No Bus:platform
[    0.793050] khelper used greatest stack depth: 3236 bytes left
[    0.796000] calling  init_cpufreq_transition_notifier_list+0x0/0x18()
[    0.797889] initcall init_cpufreq_transition_notifier_list+0x0/0x18() returned 0 after 0 msecs
[    0.800889] calling  net_ns_init+0x0/0xdc()
[    0.801884] net_namespace: 620 bytes
[    0.803889] initcall net_ns_init+0x0/0xdc() returned 0 after 1 msecs
[    0.805896] calling  cpufreq_tsc+0x0/0x11()


-- Dave

