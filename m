Return-Path: <linux-kernel-owner+w=401wt.eu-S1763425AbYCTAj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425AbYCTAj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966903AbYCTAZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:25:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:22799 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966889AbYCTAZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:25:09 -0400
Message-ID: <1a25886d0803181023o785efa42w523ea48896a0331c@mail.gmail.com>
Date: Tue, 18 Mar 2008 10:23:07 -0700
From: "Tim Elliott" <tle@holymonkey.com>
To: "Alexey Starikovskiy" <astarikovskiy@suse.de>
Subject: Re: ACPI regression in 2.6.25-rc6 (function keys stop working)
Cc: "Guillaume Chazarain" <guichaz@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org
In-Reply-To: <47DFC0D5.8020104@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0803171713q31b87939y557f6408543ac881@mail.gmail.com>
	 <47DFC0D5.8020104@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing the same problem on my Lenovo 3000 v100. The function keys
stopped working.

tim@tim-len:~$ cat /proc/interrupts
           CPU0       CPU1
  0:     164105          0   IO-APIC-edge      timer
  1:      12560          0   IO-APIC-edge      i8042
  9:          6          0   IO-APIC-fasteoi   acpi
 12:     117534          0   IO-APIC-edge      i8042
 14:         51          0   IO-APIC-edge      ide0
 16:         31          0   IO-APIC-fasteoi   uhci_hcd:usb4,
i915@pci:0000:00:02.0
 18:     121892          0   IO-APIC-fasteoi   uhci_hcd:usb3, iwl3945
 19:      36197          0   IO-APIC-fasteoi   uhci_hcd:usb2, ahci
 20:       7931          0   IO-APIC-fasteoi   eth0
 22:      11071          0   IO-APIC-fasteoi   sdhc0:slot0, HDA Intel
 23:          5          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
NMI:          0          0   Non-maskable interrupts
LOC:      11296      73879   Local timer interrupts
RES:      23199      49164   Rescheduling interrupts
CAL:        297      27033   function call interrupts
TLB:        838       1286   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

The problem goes away when reverting 2c81ce4c9c37b910210f2640c28e98a0c398dc26

Reverting the above and applying the patch in comment #38 of bug #9998
also works (http://bugzilla.kernel.org/show_bug.cgi?id=9998).

Cheers,
Tim

On 3/18/08, Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
> Hi Guillaume,
>
>  Please check if the patch to call _PSW methods, attached to bug #9998
>  helps to reduce number of ACPI interrupts if you revert the 2c81ce4c9c3
>
>  Thanks,
>  Alex.
>
>
>  Guillaume Chazarain wrote:
>  > Hi,
>  >
>  > There is an ACPI regression in 2.6.25-rc6, which causes the ACPI keys
>  > to stop working on my laptop, an Asus V6VA. git bisect identified the
>  > appended commit as guilty, and reverting it indeed fixes the problem
>  > for me. Attached are my .config, a good dmesg and a bad one. The diff
>  > between both dmesg reveals this interesting hunk:
>  >
>  > @@ -121,8 +121,9 @@
>  >  ACPI: (supports S0 S1 S3 S4 S5)
>  >  ACPI: Using IOAPIC for interrupt routing
>  >  ACPI: EC: non-query interrupt received, switching to interrupt mode
>  > +ACPI: EC: GPE storm detected, disabling EC GPE
>  >  ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
>  > -ACPI: EC: driver started in interrupt mode
>  > +ACPI: EC: driver started in poll mode
>  >  ACPI: PCI Root Bridge [PCI0] (0000:00)
>  >  pci 0000:00:1f.0: Enabled ICH6/i801 SMBus device
>  >  pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
>  >
>  >
>  > Thanks.
>  >
>  >
>  > commit 2c81ce4c9c37b910210f2640c28e98a0c398dc26
>  > Author: Alexey Starikovskiy <astarikovskiy@suse.de>
>  > Date:   Tue Mar 11 13:30:00 2008 -0400
>  >
>  >     ACPI: EC: Handle IRQ storm on Acer laptops
>  >
>  >     On some Acer systems, the HW fails to clear the GPE source,
>  >     causing an interrupt storm.
>  >
>  >     So in EC interrupt mode, we count how many interrupts we
>  >     receive when waiting.  If we get more than 5, we give
>  >     up on interrupt mode and revert to polling mode.
>  >
>  >     Also, for polling mode to work on Acers, we need
>  >     to insert a delay.
>  >
>  >     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
>  >     Signed-off-by: Len Brown <len.brown@intel.com>
>  >
>  > diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
>  > index caf873c..2c77359 100644
>  > --- a/drivers/acpi/ec.c
>  > +++ b/drivers/acpi/ec.c
>  > @@ -129,6 +129,7 @@ static struct acpi_ec {
>  >       struct mutex lock;
>  >       wait_queue_head_t wait;
>  >       struct list_head list;
>  > +     atomic_t irq_count;
>  >       u8 handlers_installed;
>  >  } *boot_ec, *first_ec;
>  >
>  > @@ -181,6 +182,8 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum
>  > ec_event event, int force_poll)
>  >  {
>  >       int ret = 0;
>  >
>  > +     atomic_set(&ec->irq_count, 0);
>  > +
>  >       if (unlikely(event == ACPI_EC_EVENT_OBF_1 &&
>  >                    test_bit(EC_FLAGS_NO_OBF1_GPE, &ec->flags)))
>  >               force_poll = 1;
>  > @@ -227,6 +230,7 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum
>  > ec_event event, int force_poll)
>  >               while (time_before(jiffies, delay)) {
>  >                       if (acpi_ec_check_status(ec, event))
>  >                               goto end;
>  > +                     msleep(5);
>  >               }
>  >       }
>  >       pr_err(PREFIX "acpi_ec_wait timeout,"
>  > @@ -529,6 +533,13 @@ static u32 acpi_ec_gpe_handler(void *data)
>  >       struct acpi_ec *ec = data;
>  >
>  >       pr_debug(PREFIX "~~~> interrupt\n");
>  > +     atomic_inc(&ec->irq_count);
>  > +     if (atomic_read(&ec->irq_count) > 5) {
>  > +             pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
>  > +             acpi_disable_gpe(NULL, ec->gpe, ACPI_ISR);
>  > +             clear_bit(EC_FLAGS_GPE_MODE, &ec->flags);
>  > +             return ACPI_INTERRUPT_HANDLED;
>  > +     }
>  >       clear_bit(EC_FLAGS_WAIT_GPE, &ec->flags);
>  >       if (test_bit(EC_FLAGS_GPE_MODE, &ec->flags))
>  >               wake_up(&ec->wait);
>  >
>  >
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
