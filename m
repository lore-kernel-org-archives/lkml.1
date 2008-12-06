Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYLFDqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYLFDqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 22:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYLFDqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 22:46:12 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60730 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYLFDqK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 22:46:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Moore, Robert" <robert.moore@intel.com>, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.28-rc6-mmotm1126 - acpi AE_AM_INFINITE_LOOP errors..
In-Reply-To: Your message of "Wed, 26 Nov 2008 12:35:50 EST."
             <4372.1227720950@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <4018.1227716135@turing-police.cc.vt.edu> <4911F71203A09E4D9981D27F9D8308580DBD34C2@orsmsx503.amr.corp.intel.com>
            <4372.1227720950@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228535162_5654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Dec 2008 22:46:03 -0500
Message-ID: <6103.1228535163@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228535162_5654P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Nov 2008 12:35:50 EST, Valdis.Kletnieks@vt.edu said:

Adding come cc:s, and a quick recap for those who didn't see it before:

Dell Latitude D820 laptop, x86_64 kernel, and Robert Moore's patch to detect
infinite looping in the ACPI interpreter is tripping, apparently because
something else in ACPI changed and caused loops that used to terminate to
instead hang now.   I've been able to narrow it down to something that
hit the linux-next tree between 11/17 (was good in mmotm1117) and 11/26.

> On Wed, 26 Nov 2008 08:24:26 PST, "Moore, Robert" said:
> > 
> > You could try making the max loop count larger, it is a 32-bit value:
> > 
> > acconfig.h
> > 
> > /* Maximum number of While() loop iterations before forced abort */
> > 
> > -#define ACPI_MAX_LOOP_ITERATIONS        0xFFFF
> > +#define ACPI_MAX_LOOP_ITERATIONS        0x00FFFFFF
> 
> That "works", for some sub-optimal value of "works".  It does indeed
> shut up *some* of the messages, but boot was taking *forever* (or more correctly,
> I gave up when it had taken more than 6 minutes to get through the initial
> udev and modprobe flurry that usually takes all of 12 seconds or less to
> complete.
> 
> I'm suspecting that something *else* is busticated in the ACPI code, and
> loops that used to complete quickly are missing whatever terminating
> condition they had, and the new infinite loop detector is in fact tripping
> properly and catching the (newly introduced) error condition?

I'm still seeing this in -rc7-mmotm1203.  For mmotm1126, I bisected it down
to almost certainly being in linux-next already, which makes me wonder why
I'm apparently the only person seeing it.

Here's one of the hanging ACPI calls again:

[  127.995256] modprobe      D ffff88007edcb800  5176   862    861
[  127.995256]  ffff88007ec639a8 0000000000000046 000000017e42f250 ffffffff8079d7c0
[  127.995256]  ffffffff8079d750 ffffffff8081e7c0 ffffffff8081e7c0 ffff88007eddd7f0
[  127.995256]  ffff88007f2677f0 ffff88007edddb48 000000008079ea80 ffff88007edddb48
[  127.995256] Call Trace:
[  127.995256]  [<ffffffff80283516>] ? __alloc_pages_internal+0x10d/0x493
[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
[  127.995256]  [<ffffffff80568bc6>] schedule_timeout+0x22/0xb4
[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
[  127.995256]  [<ffffffff805699de>] __down_common+0x9d/0xdf
[  127.995256]  [<ffffffff80569a31>] __down_timeout+0x11/0x13
[  127.995256]  [<ffffffff8024f639>] down_timeout+0x48/0x61
[  127.995256]  [<ffffffff803a5b1d>] acpi_os_wait_semaphore+0x49/0x58
[  127.995256]  [<ffffffff803be893>] acpi_ut_acquire_mutex+0x3e/0x82
[  127.995256]  [<ffffffff803b29ce>] acpi_ex_enter_interpreter+0xb/0x2b
[  127.995256]  [<ffffffff803b5840>] acpi_ns_evaluate+0x1ac/0x230
[  127.995256]  [<ffffffff803b52b4>] acpi_evaluate_object+0xfc/0x204
[  127.995256]  [<ffffffff8038ebd3>] ? pci_get_subsys+0x7b/0x8f
[  127.995256]  [<ffffffffa005fe16>] acpi_processor_start+0x1ba/0x78a [processor]
[  127.995256]  [<ffffffff803c09b3>] acpi_start_single_object+0x2a/0x54
[  127.995256]  [<ffffffff803c1fc7>] acpi_device_probe+0x78/0x8c
[  127.995256]  [<ffffffff803f349f>] driver_probe_device+0xe7/0x195
[  127.995256]  [<ffffffff803f35af>] __driver_attach+0x62/0x8c
[  127.995256]  [<ffffffff803f354d>] ? __driver_attach+0x0/0x8c
[  127.995256]  [<ffffffff803f2d10>] bus_for_each_dev+0x4c/0x83
[  127.995256]  [<ffffffff803f32c3>] driver_attach+0x1c/0x1e
[  127.995256]  [<ffffffff803f260d>] bus_add_driver+0xb5/0x1ff
[  127.995256]  [<ffffffff803f37a0>] driver_register+0xa8/0x128
[  127.995256]  [<ffffffffa006a000>] ? acpi_processor_init+0x0/0x10a [processor]
[  127.995256]  [<ffffffff803c22f6>] acpi_bus_register_driver+0x3e/0x40
[  127.995256]  [<ffffffffa006a097>] acpi_processor_init+0x97/0x10a [processor]
[  127.995256]  [<ffffffff80209058>] _stext+0x58/0x138
[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
[  127.995256]  [<ffffffff8056aa0d>] ? _spin_unlock_irqrestore+0x5e/0x6c
[  127.995256]  [<ffffffff8037b6e6>] ? __up_read+0x7c/0x85
[  127.995256]  [<ffffffff8024ef3b>] ? up_read+0x9/0xb
[  127.995256]  [<ffffffff8024fa3e>] ? __blocking_notifier_call_chain+0x58/0x6a
[  127.995256]  [<ffffffff8025f536>] sys_init_module+0xbd/0x1db
[  127.995256]  [<ffffffff8020bb3b>] system_call_fastpath+0x16/0x1b

A sampling of the errors I get:

[    7.334948] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[    7.334987] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[    7.335030] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20081031]
[    8.421295] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[    8.421331] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[    8.421364] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20081031]
[    9.601269] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[    9.601305] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
[    9.601339] ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20081031]
[   10.688615] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
... About 3,300 skipped..
[ 1330.394509] ACPI Exception (battery-0368): AE_AML_INFINITE_LOOP, Evaluating _BST [20081031]
[ 1331.365827] ACPI Error (psparse-0536): Method parse/execution failed [\SXX6] (Node ffff88007f851a98), AE_AML_INFINITE_LOOP
[ 1331.365864] ACPI Error (psparse-0536): Method parse/execution failed [\SXX4] (Node ffff88007f851a58), AE_AML_INFINITE_LOOP
[ 1331.365894] ACPI Error (psparse-0536): Method parse/execution failed [\SX11] (Node ffff88007f8519f8), AE_AML_INFINITE_LOOP
[ 1331.365923] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88007f858378), AE_AML_INFINITE_LOOP
[ 1332.321972] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[ 1332.322004] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.AGP_.VID_._DOS] (Node ffff88007f85def8), AE_AML_INFINITE_LOOP
[ 1332.322042] ACPI Exception (battery-0368): AE_AML_INFINITE_LOOP, Evaluating _BST [20081031]
[ 1333.338699] ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
[ 1333.338738] ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.VID_._DOS] (Node ffff88007f85dbf8), AE_AML_INFINITE_LOOP

The executive summary:

% grep 'ACPI E'  messages-20081204 | cut -c54- | sort | uniq -c
     29 ACPI Error (psparse-0536): Method parse/execution failed [\SMI_] (Node ffff88007f851238), AE_AML_INFINITE_LOOP
    646 ACPI Error (psparse-0536): Method parse/execution failed [\SX11] (Node ffff88007f8519f8), AE_AML_INFINITE_LOOP
    646 ACPI Error (psparse-0536): Method parse/execution failed [\SXX4] (Node ffff88007f851a58), AE_AML_INFINITE_LOOP
    646 ACPI Error (psparse-0536): Method parse/execution failed [\SXX6] (Node ffff88007f851a98), AE_AML_INFINITE_LOOP
     13 ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.AC__._PSR] (Node ffff88007f8584b8), AE_AML_INFINITE_LOOP
    440 ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88007f858378), AE_AML_INFINITE_LOOP
      6 ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.AGP_.VID_._DOS] (Node ffff88007f85def8), AE_AML_INFINITE_LOOP
      6 ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.PCIE.GDCK._STA] (Node ffff88007f85f678), AE_AML_INFINITE_LOOP
      4 ACPI Error (psparse-0536): Method parse/execution failed [\_SB_.PCI0.VID_._DOS] (Node ffff88007f85dbf8), AE_AML_INFINITE_LOOP
    206 ACPI Error (psparse-0536): Method parse/execution failed [\_TZ_.THM_.GINF] (Node ffff88007f858858), AE_AML_INFINITE_LOOP
    206 ACPI Error (psparse-0536): Method parse/execution failed [\_TZ_.THM_._TMP] (Node ffff88007f858878), AE_AML_INFINITE_LOOP
     13 ACPI Exception (ac-0135): AE_AML_INFINITE_LOOP, Error reading AC Adapter state [20081031]
    440 ACPI Exception (battery-0368): AE_AML_INFINITE_LOOP, Evaluating _BST [20081031]

It isn't just one thing - looks like the battery, video, the sensor for AC/battery,
and the thermal sensor, and probably other stuff, are all affected.

I've got a -mmotm1203 kernel built with CONFIG_ACPI_DEBUG and CONFIG_ACPI_FUNCTION_TRACE
but discovered that booting with log_buf_len=64m still wasn't enough for
even one or two ACPI calls if you turn on *all* the debugging.  Anybody have
a good suggestion on what logging levels and layers I should be starting with?


--==_Exmh_1228535162_5654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJOfV6cC3lWbTT17ARAv7HAJ4rY8PXiqBah7f+tUHU/4HLtSLqyACfV8J6
YvZUjK9WXcFl/sFXTRS4BYQ=
=N+a2
-----END PGP SIGNATURE-----

--==_Exmh_1228535162_5654P--
