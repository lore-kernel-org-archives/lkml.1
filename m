Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYLPU6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYLPU6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYLPU6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:58:16 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:46366 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYLPU6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:58:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=IBcQZD+Mbdk2xT2MHHsUaWR5is+J/f0avLOEomvJpKCypkq9w5oc83LYWEzhHkYaIf
         QC7e9NN3UomdMKuRSSVPy6+2LPJ1XS/fnsxkZO21hCAue5EPt289wprh/jOcdj2JTjSw
         6MsUBif2hbdqlNkb6dwz5pyUAQYy0BnzpwPhQ=
Message-ID: <8ccf2e9c0812161258h1d2777a2tffb781935f49f8e2@mail.gmail.com>
Date: Tue, 16 Dec 2008 21:58:12 +0100
From: "Vedran Rodic" <vrodic@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Power management regression - rescheduling interrupts - Thinkpad X60s
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've recently started testing the 2.6.28-rc8 release kernel (git
versions actually).

I've avoided previous releases after 2.6.22 because of problems with
the wireless driver.

My default kernel  is 2.6.22-3 from Debian.

The new kernel is making the laptop use more power, and is spending
more almost all the time in C2 state when idle versus spending most of
the time in C3 state on 2.6.22.

It seems that the problem started occurring somewhere arround 2.6.24
for some people. When I remove the thinkpad_acpi, ehci_hcd and
uhci_hcd modules, there are a lot less  of <kernel IPI> : Rescheduling
interrupts wakeups, but still there are some, and obviously I can't
have a functional system without usb and the thinkpad_acpi enabled.

Here is the powertop output, system is running KDE (I see kernel IPI
wakeups even without X running), and no additional software.

2.6.28-rc8 powertop:

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 7.7%)         1.67 Ghz     1.5%
polling           0.0ms ( 0.0%)         1333 Mhz     0.0%
C1 halt           0.0ms ( 0.0%)         1000 Mhz    98.5%
C2                5.6ms (76.9%)
C3                1.7ms (15.5%)

Wakeups-from-idle per second : 228.8    interval: 15.0s
Power usage (ACPI estimate): 12.4W (1.6 hours)

Top causes for wakeups:
  43.2% ( 82.4)      <kernel IPI> : Rescheduling interrupts
  12.8% ( 24.3)       <interrupt> : extra timer interrupt
  12.1% ( 23.1)       <interrupt> : ehci_hcd:usb1, uhci_hcd:usb5
  12.1% ( 23.1)   USB device 1-5.3.3 : USB Optical Mouse (Logitech)
   6.2% ( 11.8)     <kernel core> : hrtimer_start (tick_sched_timer)
   4.0% (  7.7)     <kernel core> : ehci_work (ehci_watchdog)
   2.1% (  4.0)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func)
   1.4% (  2.7)       <interrupt> : acpi
   0.6% (  1.1)              kwin : schedule_hrtimeout_range (hrtimer_wakeup)
   0.6% (  1.1)              Xorg : schedule_hrtimeout_range (hrtimer_wakeup)

2.6.22-3-686 (Debian) powertop:
Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 1.4%)         1.67 Ghz     1.0%
C1                0.0ms ( 0.0%)         1333 Mhz     0.0%
C2                5.3ms ( 5.7%)         1000 Mhz    99.0%
C3               14.0ms (92.9%)


Wakeups-from-idle per second : 77.3     interval: 20.0s
Power usage (ACPI estimate): 11.3W (2.4 hours)

Top causes for wakeups:
  21.0% ( 11.5)       <interrupt> : uhci_hcd:usb4, ehci_hcd:usb5
  20.5% ( 11.2)       cpufreq-set : queue_delayed_work_on (delayed_work_timer_fn
  18.3% ( 10.0)     <kernel core> : ehci_work (ehci_watchdog)
   9.7% (  5.3)       <interrupt> : extra timer interrupt
   5.1% (  2.8)     <kernel core> : queue_delayed_work_on (delayed_work_timer_fn
   3.6% (  1.9)       <interrupt> : ahci
   3.1% (  1.7)              Xorg : schedule_timeout (process_timeout)
   2.7% (  1.5)           konsole : schedule_timeout (process_timeout)

This was discussed previously in:

http://www.bughost.org/pipermail/power/2007-December/001192.html
https://bugzilla.redhat.com/show_bug.cgi?id=438974
http://kerneltrap.org/mailarchive/linux-kernel/2008/1/21/589349

But the resolution was inconclusive.

Suggested  echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
fails because the file doesn't exist anymore.


The config files, info about the hardware and dmesg (kmesg.log
actually) from 2.6.28-rc8 is at

http://bljak.org/~vedran/bugs/kernel-2.6.28-rc8/
Thanks,

Vedran Rodic
