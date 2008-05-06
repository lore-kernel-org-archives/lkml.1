Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbYEFQJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbYEFQJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764154AbYEFQJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:09:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:63798 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761661AbYEFQJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RnXf0c3hrhp9SZHSSDMW4u3Afn45Qobm9fqE7mglYy/i1kthb5gn8PiZvfhyXTCIrWt1P6Hnv2lUiGaNYDlTwXYGYEAxJUZnL+by3LfNh72/18DYKxMRJ2WNkypZ/fTUj6kpcVXqAUJh4VA7UrHB2oHGHlJ4ZqoMcdchqxWT6No=
Message-ID: <19f34abd0805060909q635d2d43j9414e5f179c9e22f@mail.gmail.com>
Date: Tue, 6 May 2008 18:09:21 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Lin Ming" <ming.m.lin@intel.com>, "Bob Moore" <robert.moore@intel.com>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running kmemcheck on top of v2.6.26-rc1 gives the following (never
before seen) warning:

Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)

Pid: 1, comm: swapper Not tainted (2.6.26-rc1-00010-g7966e04 #2)
EIP: 0060:[<c027ecaa>] EFLAGS: 00010286 CPU: 0
EIP is at acpi_ps_get_next_arg+0x1b8/0x262
EAX: f7c12ec0 EBX: f7d20428 ECX: f7ca1b00 EDX: 00000001
ESI: 00000049 EDI: f7d20400 EBP: f7c61e38 ESP: c06c9dc8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: f7c46456 CR3: 006ba000 CR4: 000006c0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff4ff0 DR7: 00000400
 [<c0119192>] kmemcheck_read+0xe2/0x140
 [<c0119326>] kmemcheck_access+0x136/0x1a0
 [<c04bd286>] do_page_fault+0x5e6/0x690
 [<c04bb2da>] error_code+0x72/0x78
 [<c027f991>] acpi_ps_parse_loop+0x4dd/0x7f8
 [<c027ee36>] acpi_ps_parse_aml+0xb4/0x332
 [<c02802c0>] acpi_ps_execute_method+0x13d/0x20d
 [<c027c8a2>] acpi_ns_evaluate+0x10e/0x1b0
 [<c0283210>] acpi_ut_evaluate_object+0x51/0x18d
 [<c0283406>] acpi_ut_execute_STA+0x22/0x7b
 [<c027c18b>] acpi_ns_get_device_callback+0x5a/0x121
 [<c027e410>] acpi_ns_walk_namespace+0xf0/0x10c
 [<c027c0b5>] acpi_get_devices+0x47/0x5d
 [<c068db45>] pnpacpi_init+0x65/0xa0
 [<c06735c7>] kernel_init+0x127/0x290
 [<c0104cc7>] kernel_thread_helper+0x7/0x10
 [<ffffffff>] 0xffffffff
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered


This faulting instruction comes from

$ addr2line -e vmlinux -i c027ecaa
drivers/acpi/parser/psargs.c:694

Which was changed/introduced in
commit bc7a36ab74e09da7bb63e2477b0740ac992b290e
Author: Lin Ming <ming.m.lin@intel.com>
Date:   Thu Apr 10 19:06:42 2008 +0400

    ACPICA: Fixes for Unload and DDBHandles

    Implemented support for the use of DDBHandles as an Indexed
    Reference, as per the ACPI spec.

    http://www.acpica.org/bugzilla/show_bug.cgi?id=486.

    Implemented support for UserTerm (Method invocation) for the Unload operator
    as per the ACPI spec.

    http://www.acpica.org/bugzilla/show_bug.cgi?id=580

    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

I've tried reverting this particular commit and the warning does indeed go away.

Now, please keep in mind that kmemcheck is a work in progress and may
produce false positives</disclaimer> :-)

I think it might be worth looking at, though.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
