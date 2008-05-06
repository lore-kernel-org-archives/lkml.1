Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYEFUjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYEFUjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbYEFUi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:38:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:54540 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbYEFUix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IeXbIk5H7bsJpLhc4VqwtZxMoJOF5mDbUHY2FFrZM87VLrs62e8YuTdN5lu8SzL/1JUXm4Kxfk1GFF62pephpbYleKA71LO4y2Hfq4hfV/WWbT1iuBTOYex6Y54g/cRIqJbwwwRifzVr4/Z34eXGe2rWEhCEfeSIidWIJffYHMQ=
Message-ID: <84144f020805061338yd6e3declaf5ff9ca344c28ba@mail.gmail.com>
Date: Tue, 6 May 2008 23:38:51 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: ACPI: kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
Cc: "Lin Ming" <ming.m.lin@intel.com>, "Bob Moore" <robert.moore@intel.com>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Len Brown" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0805060909q635d2d43j9414e5f179c9e22f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805060909q635d2d43j9414e5f179c9e22f@mail.gmail.com>
X-Google-Sender-Auth: 2302b88b9df5aac3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 7:09 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>  Running kmemcheck on top of v2.6.26-rc1 gives the following (never
>  before seen) warning:
>
>  Linux Plug and Play Support v0.97 (c) Adam Belay
>  pnp: PnP ACPI init
>  ACPI: bus type pnp registered
>  kmemcheck: Caught 16-bit read from freed memory (f7c12ec6)
>
>  Pid: 1, comm: swapper Not tainted (2.6.26-rc1-00010-g7966e04 #2)
>  EIP: 0060:[<c027ecaa>] EFLAGS: 00010286 CPU: 0
>  EIP is at acpi_ps_get_next_arg+0x1b8/0x262
>  EAX: f7c12ec0 EBX: f7d20428 ECX: f7ca1b00 EDX: 00000001
>  ESI: 00000049 EDI: f7d20400 EBP: f7c61e38 ESP: c06c9dc8
>   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>  CR0: 8005003b CR2: f7c46456 CR3: 006ba000 CR4: 000006c0
>  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>  DR6: ffff4ff0 DR7: 00000400
>   [<c0119192>] kmemcheck_read+0xe2/0x140
>   [<c0119326>] kmemcheck_access+0x136/0x1a0
>   [<c04bd286>] do_page_fault+0x5e6/0x690
>   [<c04bb2da>] error_code+0x72/0x78
>   [<c027f991>] acpi_ps_parse_loop+0x4dd/0x7f8
>   [<c027ee36>] acpi_ps_parse_aml+0xb4/0x332
>   [<c02802c0>] acpi_ps_execute_method+0x13d/0x20d
>   [<c027c8a2>] acpi_ns_evaluate+0x10e/0x1b0
>   [<c0283210>] acpi_ut_evaluate_object+0x51/0x18d
>   [<c0283406>] acpi_ut_execute_STA+0x22/0x7b
>   [<c027c18b>] acpi_ns_get_device_callback+0x5a/0x121
>   [<c027e410>] acpi_ns_walk_namespace+0xf0/0x10c
>   [<c027c0b5>] acpi_get_devices+0x47/0x5d
>   [<c068db45>] pnpacpi_init+0x65/0xa0
>   [<c06735c7>] kernel_init+0x127/0x290
>   [<c0104cc7>] kernel_thread_helper+0x7/0x10
>   [<ffffffff>] 0xffffffff
>  pnp: PnP ACPI: found 17 devices
>  ACPI: ACPI bus type pnp unregistered
>
>  This faulting instruction comes from
>
>  $ addr2line -e vmlinux -i c027ecaa
>  drivers/acpi/parser/psargs.c:694

(That's some seriously hairy code in ACPI btw.)

Vegard, can you do disassembly for the faulting instruction? I *think*
it's the "walk_state->op" bit that is hanging to an object that was
already deleted in the strange loop in acpi_ps_parse_loop() but it
would be good to have some more data on this.

                        Pekka
