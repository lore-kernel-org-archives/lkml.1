Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0CHSoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:44:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:57969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0CHSnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:43:55 -0500
Subject: Re: odd lockdep messages
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
In-Reply-To: <24605.1268073053@localhost>
References: <24605.1268073053@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 19:43:51 +0100
Message-ID: <1268073831.4997.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 13:30 -0500, Valdis.Kletnieks@vt.edu wrote:
> (Not sure when this started, just noticed it... Wasn't present in
> 2.6.33-rc7-mmotm0210, is in 2.6.33-mmotm0302 and -mmotm0304).
> 
> Seen in dmesg:
> 
>  dmesg | grep -C 5 'BUG: key'
> [    0.978944] Monitor-Mwait will be used to enter C-1 state
> [    0.979944] Monitor-Mwait will be used to enter C-2 state
> [    0.980943] Monitor-Mwait will be used to enter C-3 state
> [    0.981056] Marking TSC unstable due to TSC halts in idle
> [    0.981298] Switching to clocksource hpet
> [    1.012163] BUG: key ffff88011efbf500 not in .data!
> [    1.012284] BUG: key ffff88011efbf548 not in .data!
> [    1.015935] thermal LNXTHERM:01: registered as thermal_zone0
> [    1.016070] ACPI: Thermal Zone [THM] (39 C)
> [    1.022610] Real Time Clock Driver v1.12b
> [    1.022955] Linux agpgart interface v0.103
> [    1.023342] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> --
> [    1.876870] iwlagn 0000:0c:00.0: setting latency timer to 64
> [    1.876914] iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
> [    1.899041] iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
> [    1.899170] iwlagn 0000:0c:00.0: irq 31 for MSI/MSI-X
> [    1.899467] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-5000-2.ucode
> [    1.899537] BUG: key ffff88011c57e670 not in .data!
> [    1.899629] console [netcon0] enabled
> [    1.899644] netconsole: network logging started
> [    1.899699] ohci1394 0000:03:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    2.053034] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.052015] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
> --
> [   10.518458] usb 5-1: Manufacturer: Broadcom Corp
> [   10.518460] usb 5-1: SerialNumber: 0123456789ABCD
> [   10.520315] usb 5-1: config 0 descriptor??
> [   10.586699] iwlagn 0000:0c:00.0: request for firmware file 'iwlwifi-5000-2.ucode' failed.
> [   10.586873] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-5000-1.ucode
> [   10.586962] BUG: key ffff88011c57e670 not in .data!
> [   10.594431] iwlagn 0000:0c:00.0: request for firmware file 'iwlwifi-5000-1.ucode' failed.
> [   10.594436] iwlagn 0000:0c:00.0: no suitable firmware found!
> [   10.594658] iwlagn 0000:0c:00.0: PCI INT A disabled
> [   10.611235] usb 1-4.1: new low speed USB device using ehci_hcd and address 5
> [   10.713441] usb 1-4.1: New USB device found, idVendor=045e, idProduct=0023
> 
> (-0302 threw BUG: 3 times, the first 2 and the last. In -0304, the third
> one appears as well).
> 
> Worth instrumenting and chasing down? If so, what should a crash test dummy
> be doing here? ;)

Can that be wreckage due to the new per-cpu stuff?

Its a message printed when the below function fails, and that per-cpu
stuff seems the one most likely to break, given that there was quite a
lot of churn in that department recently.

---

/*
 * Is this the address of a static object:
 */
static int static_obj(void *obj)
{
        unsigned long start = (unsigned long) &_stext,
                      end   = (unsigned long) &_end,
                      addr  = (unsigned long) obj;
#ifdef CONFIG_SMP
        int i;
#endif

        /*
         * static variable?
         */
        if ((addr >= start) && (addr < end))
                return 1;

        if (arch_is_kernel_data(addr))
                return 1;

#ifdef CONFIG_SMP
        /*
         * percpu var?
         */
        for_each_possible_cpu(i) {
                start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
                end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
                                        + per_cpu_offset(i);

                if ((addr >= start) && (addr < end))
                        return 1;
        }
#endif

        /*
         * module var?
         */
        return is_module_address(addr);
}


