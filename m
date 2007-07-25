Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbXGYWEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbXGYWEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbXGYWD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:03:56 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36328 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbXGYWDz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:03:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
In-Reply-To: Your message of "Wed, 25 Jul 2007 04:03:04 PDT."
             <20070725040304.111550f4.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185400994_3376P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Jul 2007 18:03:14 -0400
Message-ID: <23659.1185400994@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185400994_3376P
Content-Type: text/plain; charset=us-ascii

On Wed, 25 Jul 2007 04:03:04 PDT, Andrew Morton said:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/

It built and booted on the first try for my Dell Latitude D820 laptop, Core2
T7200 x86_64 kernel. Now at about 5 hours of uptime. I guess I got lucky and my
stock .config doesn't trip over any of the issues others are hitting.  I did
hit *one* problem:

Under 2.6.22-rc6-mm1, 'modprobe tpm_tis' did this:

[   10.028000] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[   10.088000] tpm_tis 00:0f: Unable to request irq: 8 for probe

and the modprobe returned immediately.  Under 23-rc1-mm1, the modprobe
takes a *long* time:

[   23.787331] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
[   23.787353] tpm0 (IRQ 3) handled a spurious interrupt
[  143.803891] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62
[  143.803920] tpm0 (IRQ 3) handled a spurious interrupt
[  263.736163] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62
[  383.668381] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62
[  385.667261] tpm_tis 00:0f: tpm_transmit: tpm_send: error -62

then it finally returns.  I snuck in a few 'echo t > /proc/sysrq_trigger',
and it's always waiting here:

[  193.154317] modprobe      S 0000001eeae8252d  5488  1446      1
[  193.154321]  ffff8100043d7a98 0000000000000082 0000000000000000 ffffffff80795480
[  193.154325]  ffff8100043d7a48 ffff810003538000 ffffffff806813e0 ffff810003538290
[  193.154329]  0000000004173800 0000000000000202 00000000000000ff ffffffff8023ba74
[  193.154332] Call Trace:
[  193.154336]  [<ffffffff8023ba74>] __mod_timer+0xc4/0xd6
[  193.154340]  [<ffffffff805273cc>] schedule_timeout+0x8d/0xb4
[  193.154344]  [<ffffffff8023b7be>] process_timeout+0x0/0xb
[  193.154347]  [<ffffffff805273c7>] schedule_timeout+0x88/0xb4
[  193.154353]  [<ffffffff880b328a>] :tpm_tis:wait_for_stat+0xb0/0x11a
[  193.154356]  [<ffffffff802460ef>] autoremove_wake_function+0x0/0x38
[  193.154360]  [<ffffffff880b31b0>] :tpm_tis:get_burstcount+0x63/0x8d
[  193.154365]  [<ffffffff880b367e>] :tpm_tis:tpm_tis_send+0x191/0x1d3
[  193.154370]  [<ffffffff803ba945>] tpm_transmit+0x98/0x1f1
[  193.154374]  [<ffffffff803baaf2>] transmit_cmd+0x14/0x2e
[  193.154377]  [<ffffffff803badd8>] tpm_get_timeouts+0xe9/0x13c
[  193.154382]  [<ffffffff880b3ac5>] :tpm_tis:tpm_tis_init+0x405/0x44c
[  193.154387]  [<ffffffff880b3b3a>] :tpm_tis:tpm_tis_pnp_init+0x2e/0x30
[  193.154391]  [<ffffffff8039d8fc>] pnp_device_probe+0x7b/0xa3
[  193.154394]  [<ffffffff803c691e>] driver_probe_device+0xfa/0x17e
[  193.154397]  [<ffffffff803c6a4d>] __driver_attach+0x0/0x94
[  193.154400]  [<ffffffff803c6aa8>] __driver_attach+0x5b/0x94
[  193.154403]  [<ffffffff803c5cd8>] bus_for_each_dev+0x49/0x7a
[  193.154408]  [<ffffffff803c6736>] driver_attach+0x1c/0x1e
[  193.154410]  [<ffffffff803c6046>] bus_add_driver+0x86/0x1a9
[  193.154414]  [<ffffffff803c6cb3>] driver_register+0x72/0x76
[  193.154417]  [<ffffffff8039d692>] pnp_register_driver+0x1c/0x1e
[  193.154421]  [<ffffffff880b8081>] :tpm_tis:init_tis+0x81/0x89
[  193.154425]  [<ffffffff80251d94>] sys_init_module+0x14db/0x1657
[  193.154433]  [<ffffffff8020bece>] system_call+0x7e/0x83

Here's my /proc/interrupts:

           CPU0       CPU1       
  0:   15121156          0   IO-APIC-edge      timer
  1:       3022          0   IO-APIC-edge      i8042
  3:          0          0   IO-APIC-edge      tpm0
  8:          0          0   IO-APIC-edge      rtc
  9:          2          0   IO-APIC-fasteoi   acpi
 12:         85          0   IO-APIC-edge      i8042
 14:      46529          0   IO-APIC-edge      libata
 15:         94          0   IO-APIC-edge      libata
 16:    1301032          0   IO-APIC-fasteoi   nvidia
 17:        148          0   IO-APIC-fasteoi   iwl3945
 19:         10          0   IO-APIC-fasteoi   ohci1394, yenta
 20:       9548          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 21:      10544          0   IO-APIC-fasteoi   uhci_hcd:usb3, HDA Intel
 22:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
506:        111      68979   PCI-MSI-edge      eth0
NMI:          0          0 
LOC:   15121050   15120952 
ERR:          0

(tpm0 on 3 is new with 23-rc1-mm1.  I have *no* idea why 22-rc6-mm1 tried to
put it on irq 8. Yes, kernel is currently tainted with nvidia module, but
at the time of the traceback listed above, I had not yet even gotten the module
built, so the kernel was untainted at that point).

--==_Exmh_1185400994_3376P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGp8iicC3lWbTT17ARAgjxAJ4jBDqVyL0h0r/HnCR8IN9cK5DZLwCeKYbF
bTUqxIS1Qz7B2Cspiq+Thso=
=yXd3
-----END PGP SIGNATURE-----

--==_Exmh_1185400994_3376P--
