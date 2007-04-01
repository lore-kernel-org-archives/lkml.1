Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXDAS2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXDAS2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933805AbXDAS2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:28:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795AbXDAS2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:28:08 -0400
Date: Sun, 1 Apr 2007 20:28:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] enhance initcall_debug, measure latency
Message-ID: <20070401182801.GA25956@elte.hu>
References: <20070401181614.GA25648@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070401181614.GA25648@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Subject: [patch] enhance initcall_debug, measure latency
> From: Ingo Molnar <mingo@elte.hu>
> 
> enhance the initcall_debug boot option:
> 
>  - measure the time the initcall took to execute and report
>    it in units of milliseconds.

some boot time analysis using this facility:

with an allyesconfig bzImage kernel, here are all initcalls that took 
more than 10 msecs to execute (51 initcalls out of 1981). The list was 
generated via:

  dmesg | grep ' ran for ' | sort -r -n -t' ' -k +5

some entries (like old ISA drivers which have to auto-detect the hard 
way) are not a surprise. Some others, like eeprom_init() or 
acpi_pci_root_init(), are.

the 51 entries took 121.8 seconds to execute:

  echo `dmesg | grep ' ran for ' |
   sort -r -n -t' ' -k +5 | cut -d' ' -f5 |
   grep -vE '^..$|^.$'` | sed 's/ /+/g' | bc

  121822

while the other 1930 entries took only 8 seconds to execute:

  echo `dmesg | grep ' ran for ' |
   sort -r -n -t' ' -k +5 | cut -d' ' -f5 |
   grep -E '^..$|^.$'` | sed 's/ /+/g' | bc

  8265

so 93.6% of the allyesconfig bootup time is in 2.5% of the initcalls. If 
they were fixed then an allyesconfig bzImage, which would be capable to 
run on every PC known to mankind without any module whatsoever, would 
take around 10 seconds to boot up (which is acceptable for kernel bootup 
time).

	Ingo

initcall 0xc1f5487d ran for 23083 msecs: pca_isa_init+0x0/0x143()
initcall 0xc1f54fba ran for 17121 msecs: pcf8574_init+0x0/0x20()
initcall 0xc1f0c06f ran for 14710 msecs: net_olddevs_init+0x0/0x169()
initcall 0xc1f47582 ran for 10497 msecs: sjcd_init+0x0/0x3c5()
initcall 0xc1f54fda ran for 8560 msecs: pcf8591_init+0x0/0x44()
initcall 0xc1f54f5a ran for 8543 msecs: eeprom_init+0x0/0x20()
initcall 0xc1f479b4 ran for 6928 msecs: sony535_init+0x0/0x4e4()
initcall 0xc1f4720d ran for 5239 msecs: optcd_init+0x0/0x33b()
initcall 0xc1f54f9a ran for 4280 msecs: pca9539_init+0x0/0x20()
initcall 0xc1f3701d ran for 3248 msecs: init_this_scsi_driver+0x0/0xe1()
initcall 0xc1f2b387 ran for 3090 msecs: cadet_init+0x0/0x1c9()
initcall 0xc1f2b7ea ran for 1923 msecs: rtrack_init+0x0/0x125()
initcall 0xc1f2dabf ran for 1112 msecs: ide_init+0x0/0xe5()
initcall 0xc1f54f3a ran for 1070 msecs: ds1374_init+0x0/0x20()
initcall 0xc1f54f1a ran for 1070 msecs: ds1337_init+0x0/0x20()
initcall 0xc1f2767d ran for 958 msecs: init_bw_qcams+0x0/0x17()
initcall 0xc1f52549 ran for 851 msecs: sermouse_init+0x0/0x29()
initcall 0xc1f631ef ran for 582 msecs: i810_init_module+0x0/0xa7()
initcall 0xc1f1152d ran for 521 msecs: init_nic+0x0/0x3d()
initcall 0xc1f531bd ran for 507 msecs: spaceball_init+0x0/0x29()
initcall 0xc1f2e365 ran for 496 msecs: ide_generic_init+0x0/0x16()
initcall 0xc1f2765a ran for 484 msecs: cqcam_init+0x0/0x23()
initcall 0xc1f54644 ran for 452 msecs: nforce2_init+0x0/0x29()
initcall 0xc1ef3007 ran for 451 msecs: acpi_pci_root_init+0x0/0x2d()
initcall 0xc1f5320f ran for 433 msecs: stinger_init+0x0/0x29()
initcall 0xc1f4daa3 ran for 378 msecs: ohci_hcd_mod_init+0x0/0x73()
initcall 0xc1f55295 ran for 342 msecs: sensors_w83781d_init+0x0/0x45()
initcall 0xc1f55d1a ran for 336 msecs: sm_lm78_init+0x0/0x45()
initcall 0xc1ef5cbf ran for 303 msecs: isapnp_init+0x0/0x4a7()
initcall 0xc1f1fa80 ran for 292 msecs: com90xx_init+0x0/0x1026()
initcall 0xc1f4d9ff ran for 287 msecs: ehci_hcd_init+0x0/0x5d()
initcall 0xc1edd69f ran for 285 msecs: param_sysfs_init+0x0/0x191()
initcall 0xc1ef9f22 ran for 272 msecs: epca_module_init+0x0/0x434()
initcall 0xc1f3f4db ran for 262 msecs: init_this_scsi_driver+0x0/0xe1()
initcall 0xc1f04f5a ran for 247 msecs: serial8250_init+0x0/0x138()
initcall 0xc1ef314b ran for 210 msecs: acpi_pci_link_init+0x0/0x4b()
initcall 0xc1f56d1f ran for 196 msecs: raid5_init+0x0/0x3f()
initcall 0xc1f55e1f ran for 189 msecs: sensors_max1619_init+0x0/0x20()
initcall 0xc1f55d7f ran for 189 msecs: sensors_lm83_init+0x0/0x20()
initcall 0xc1f55476 ran for 188 msecs: sensors_adm1021_init+0x0/0x20()
initcall 0xc1ef65e3 ran for 185 msecs: pty_init+0x0/0x464()
initcall 0xc1f6b533 ran for 175 msecs: pci_acpi_init+0x0/0xb4()
initcall 0xc1f55cda ran for 168 msecs: sensors_lm75_init+0x0/0x20()
initcall 0xc1f55556 ran for 168 msecs: ds1621_init+0x0/0x20()
initcall 0xc1f554d6 ran for 168 msecs: sensors_adm1029_init+0x0/0x20()
initcall 0xc1f55d5f ran for 167 msecs: sensors_lm80_init+0x0/0x20()
initcall 0xc1f0bf7e ran for 147 msecs: fixed_init+0x0/0x53()
initcall 0xc1ef8aa5 ran for 125 msecs: cy_init+0x0/0x147d()
initcall 0xc1ef23d1 ran for 119 msecs: acpi_init+0x0/0x234()
initcall 0xc1f05b97 ran for 110 msecs: parport_pc_init+0x0/0x2d7()
initcall 0xc1f4b1f7 ran for 105 msecs: butterfly_init+0x0/0x17()
