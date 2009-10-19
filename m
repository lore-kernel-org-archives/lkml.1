Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZJSKcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZJSKcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 06:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZJSKcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 06:32:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbZJSKcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 06:32:42 -0400
Message-ID: <4ADC3FF3.7010007@redhat.com>
Date: Mon, 19 Oct 2009 12:31:15 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-acpi@vger.kernel.org, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jon Masters <jcm@redhat.com>, Len Brown <lenb@kernel.org>,
       tokunaga.keiich@jp.fujitsu.com, Olaf Dabrunz <Olaf.Dabrunz@gmx.net>,
       greg@kroah.com
Subject: boot interrupts - the next step
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

boot interrupts are a major pain for linux interrupt handling. I'm not
going into detail here, explaining it all over again. In case you want to
know more refer to the links below.

http://lkml.org/lkml/2009/9/4/350
http://lkml.org/lkml/2008/6/2/269
http://people.redhat.com/sassmann/publications/boot_irq_quirks_rtlws10.pdf
http://people.redhat.com/sassmann/publications/Boot_Interrupts_and_IRQ_Threads.pdf

While we're still fighting this chipset generations boot interrupts
there's something we can do to prevent next gens chipsets from generating
these.

Therefore we need support from BIOS people. In fact ACPI has a method
to "report to the BIOS the current interrupt model used by the OS"¹.
That method is called _PIC. So calling _PIC(1) tells the BIOS the OS has
chosen to run in APIC mode and gives the BIOS the possibility to make
adjustments. Now that is where the BIOS should _disable_ all sources of
boot interrupts.

As the implementation of how to disable boot interrupts is really
chipset specific it's the BIOSes task to disable them in the APIC mode
case. All the boot interrupt quirks we've been adding to the kernel are
just workarounds for buggy BIOSes!

An example of how this can look like, taken from the AMD SB700/710/750
BIOS developers guide²:
During the BIOS POST, the BIOS will do normal PCI IRQ routing through
port C00h/C01h. Once APIC is fully enabled by the OS, the routing in
C00h/C01 must be all cleared to zero. The following is a sample ASL code
that may be incorporated into the BIOS:

         Name(PICF,0x00)
         Method(_PIC, 0x01, NotSerialized)
         {
                 Store (Arg0, PICF)
                 If(Arg0) {
                          \_SB.PCI0.LPC0.DSPI() // clear interrupt at 0xC00/0xC01
                 }
         }
[...] (full implementation snipped)
Note: 0xC00/0xC01 are the PCI interrupt mapping registers in this case.

It's not that hard to do once you're aware of it.
This is a call to all chipset manufacturers/BIOS developers/everyone
involved: Please get the appropriate changes into your BIOS/BIOS
developers guide! Thanks!

¹ ACPI Specification 4.0 (sec 5.8.1)
² http://developer.amd.com/assets/43366_sb7xx_bdg_pub_1.00.pdf (sec 10.5)

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
