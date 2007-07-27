Return-Path: <linux-kernel-owner+w=401wt.eu-S937410AbXG0OsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937410AbXG0OsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761893AbXG0Ory
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:47:54 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56810 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761713AbXG0Orx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:47:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Kylene Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1 - seems OK on Dell Latitude D820, except for tpm_tis
In-Reply-To: Your message of "Fri, 27 Jul 2007 00:00:32 EDT."
             <5208.1185508832@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <20070725040304.111550f4.akpm@linux-foundation.org> <23659.1185400994@turing-police.cc.vt.edu> <20070725203737.85871711.akpm@linux-foundation.org>
            <5208.1185508832@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1185542889_3434P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 27 Jul 2007 09:28:09 -0400
Message-ID: <23912.1185542889@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1185542889_3434P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <23897.1185542879.1@turing-police.cc.vt.edu>

On Fri, 27 Jul 2007 00:00:32 EDT, Valdis.Kletnieks@vt.edu said:

> Apparently, things go pear-shaped in tis_tpm_send(), when they get to the
> 'if (chip->vendor.irq)' - under 22-rc6-mm1, we never got into this code,
> because earlier initialization complained it couldn't get IRQ8.  Now, we
> get IRQ3, and apparently get into this if statement, and then spend 120
> seconds while wait_for_stat() times out.  So the root cause does look like
> it's this IRQ8/IRQ3 issue.
> 
> I'll try to find time to do a bisect on -rc1-mm1 tomorrow to track down
> what exactly did this.

And we have a winner.  In my bisect 'hunt' file, I ended at:

fs-use-kmem_cache_zalloc-instead.patch GOOD
# remove-kconfig-setting-config_debug_shirq.patch: Ingo worried
remove-kconfig-setting-config_debug_shirq.patch BAD

Looks like Ingo was right. :)  As a cross-check, I tested a 'GOOD' kernel,
but rebuilt with CONFIG_DEBUG_SHIRQ=y, and that *also* died. 

Looks like the problematic code is in tpm_tis.c tpm_tis_init() near here:

                for (i = 3; i < 16 && chip->vendor.irq == 0; i++) {
                        iowrite8(i, chip->vendor.iobase +
                                    TPM_INT_VECTOR(chip->vendor.locality));
                        if (request_irq
                            (i, tis_int_probe, IRQF_SHARED,
                             chip->vendor.miscdev.name, chip) != 0) {
                                dev_info(chip->dev,
                                         "Unable to request irq: %d for probe\n"
,           
                                         i);
                                continue;
                        }

This seems to be misbehaving differently for the two different DEBUG_SHIRQ
cases.

With DEBUG_SHIRQ=n, it starts at IRQ3, gets to at least 8 (where it complains
it can't request it for probing), and possibly all the way to 15, without ever
actually selecting and assigning an IRQ (to refresh memories, in that range
/proc/interrupts only lists:

  8:          0          0   IO-APIC-edge      rtc
  9:          3          0   IO-APIC-fasteoi   acpi
 12:         94          0   IO-APIC-edge      i8042
 14:     148166          0   IO-APIC-edge      libata
 15:         94          0   IO-APIC-edge      libata

So there's certainly IRQ's available.  No idea why it doesn't choose one. But
since it never chose one, it never gets into the "wait for the IRQ" protected
by 'if (chip->vendor.irq)' at the end of tpm_tis_send.

With DEBUG_SHIRQ=y, It starts at IRQ3, and assigns it (which seems a good thing).
Unfortunately, this then hits the timeouts in tpm_tis_send.

Anybody got an idea what *should* be happening here?

Just for the record, I see this in /sys:

% cat /sys/bus/pnp/devices/00:0e/id
BCM0102
PNP0c31

The driver is apparently being selected on the basis of PNP0c31.  One of
the other ID's it looks for is BCM0101 - but this is a BCM0102.  Is this a
misidentification, or does the driver need to handle a 0102 differently, or
is something else odd going on?


--==_Exmh_1185542889_3434P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGqfLpcC3lWbTT17ARArIOAJ9wKWcoNSA0yPMXn4Mf9heeN0VPHwCeKaY1
kTHA5ZCl6vsWCXQgD2XfUfw=
=Ayes
-----END PGP SIGNATURE-----

--==_Exmh_1185542889_3434P--
