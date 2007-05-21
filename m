Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbXEUBRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbXEUBRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXEUBRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:17:23 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:44327 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbXEUBRW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:17:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support 2.6.22-rc1-v7
In-Reply-To: Your message of "Fri, 18 May 2007 00:09:53 +0200."
             <1179439793.12981.39.camel@chaos>
From: Valdis.Kletnieks@vt.edu
References: <1178485128.31213.98.camel@localhost.localdomain>
            <1179439793.12981.39.camel@chaos>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1179710073_3707P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 20 May 2007 21:14:33 -0400
Message-ID: <19834.1179710073@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1179710073_3707P
Content-Type: text/plain; charset=us-ascii

On Fri, 18 May 2007 00:09:53 +0200, Thomas Gleixner said:
> Broken out version is available here:
> http://www.tglx.de/projects/hrtimers/2.6.22-rc1/linux-2.6.22-rc1-x86_64-highres-v7.patches.tar.bz2

By the time I got there, you'd put the -v8 version out there.  It applied
to a 2.6.22-rc1-mm1 tree with only minor bashing (basically, the patches
clocksource-fix-mismerge.diff and clocksource-watchdog-resumed-lockless.patch
appear to already be in -rc1-mm1, and hpet-check-counter.diff in a ever-so
slightly different form).  I also threw on the 22-rc1 patch from linuxpowertop
to tweak some timeouts in the kernel...

Boots and runs on a Dell Latitude D820 laptop with an Intel Core2 T7200.
Intel's 'powertop' was reporting as low as 25 wakeups/sec in single-user
mode, even with CONFIG_HZ=1000.  This is looking like a good -mm candidate...

Some 'powertop' results (I'm not at all clear why it's reporting 3000+ wakeups/
sec on the non-NOHZ kernels with HZ=1000. I can see 1000, or 2000 because it's
a dual-core, but 3000?).  It doesn't look like NOHZ gains me a *lot* of extra
battery time, but a bit (I believe the wattages to be reasonably accurate, the
'hours left' to be a crock...).  

-rc1-mm1 with X desktop running:
Cn          Avg residency (5s)  Long term residency avg
C0 (cpu running)        (18.8%)
C1                0.0ms ( 0.0%)                   0.0ms
C2                0.3ms ( 2.6%)                   0.3ms
C3                0.5ms (78.6%)                   0.5ms

Wakeups-from-idle per second :  3183.2 
Power usage (ACPI estimate) :  27.4 W (2.7 hours left)

Top causes for wakeups:
  16.4% (62.4)       <interrupt> : nvidia 
  13.2% (50.0)       S06cpuspeed : queue_delayed_work_on (delayed_work_timer_ 
  12.6% (48.0)               esd : schedule_timeout (process_timeout) 
   8.4% (31.8)           gkrellm : schedule_timeout (process_timeout) 
   7.7% (29.2)       <interrupt> : uhci_hcd:usb4 
   6.6% (25.2)              Xorg : do_setitimer (it_real_fn) 
   6.6% (25.0)       <interrupt> : uhci_hcd:usb3, HDA Intel 
   5.3% (20.0)            gyachi : schedule_timeout (process_timeout) 
   3.3% (12.6)               e16 : schedule_timeout (process_timeout) 
   2.6% (10.0)     <kernel core> : ehci_work (ehci_watchdog) 

Suggestion: Enable the CONFIG_NO_HZ kernel configuration option.

-rc1-mm1-hrt8 with X desktop running:
Cn          Avg residency (5s)  Long term residency avg
C0 (cpu running)        ( 8.5%)
C1                0.0ms ( 0.0%)                   0.0ms
C2                0.8ms ( 8.3%)                   1.0ms
C3                1.5ms (83.2%)                   1.5ms

Wakeups-from-idle per second :  1290.0 
Power usage (ACPI estimate) :  26.8 W (2.7 hours left)

Top causes for wakeups:
  23.8% (62.0)       <interrupt> : nvidia 
  15.8% (41.2)       S06cpuspeed : queue_delayed_work_on (delayed_work_timer_ 
  14.6% (38.0)           gkrellm : schedule_timeout (process_timeout) 
   8.7% (22.6)              Xorg : do_setitimer (it_real_fn) 
   7.6% (19.8)            gyachi : schedule_timeout (process_timeout) 
   3.8% (10.0)     <kernel core> : ehci_work (ehci_watchdog) 
   3.4% ( 8.8)               e16 : schedule_timeout (process_timeout) 
   3.2% ( 8.4)       firefox-bin : futex_wait (hrtimer_wakeup) 
   3.1% ( 8.0)     <kernel core> : usb_hcd_poll_rh_status (rh_timer_func) 
   2.5% ( 6.6)             pcscd : schedule_timeout (process_timeout) 

-rc1-mm1 single-user:
C0 (cpu running)        (10.0%)
C1                0.0ms ( 0.0%)                   0.0ms
C2                0.5ms ( 0.0%)                   0.6ms
C3                0.6ms (90.0%)                   0.6ms

Wakeups-from-idle per second :  3003.0 
Power usage (ACPI estimate) :  24.5 W (3.1 hours left)

Top causes for wakeups:
  42.1% ( 8.0)     <kernel core> : usb_hcd_poll_rh_status (rh_timer_func) 
  26.3% ( 5.0)     <kernel core> : fbcon_add_cursor_timer (cursor_timer_handl 
  14.7% ( 2.8)     <kernel core> : queue_delayed_work_on (delayed_work_timer_
   6.3% ( 1.2)       <interrupt> : libata 
   5.3% ( 1.0)             kedac : schedule_timeout (process_timeout) 
   1.1% ( 0.2)              init : schedule_timeout (process_timeout) 
   1.1% ( 0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
   1.1% ( 0.2)           pdflush : blk_plug_device (blk_unplug_timeout) 
   1.1% ( 0.2)     <kernel core> : neigh_table_init_no_netlink (neigh_periodi
   1.1% ( 0.2)        rc.sysinit : start_this_handle (commit_timeout) 

Suggestion: Enable the CONFIG_NO_HZ kernel configuration option.

-rc1-mm1-hrt8 single-user:
Cn          Avg residency (5s)  Long term residency avg
C0 (cpu running)        ( 0.1%)
C1                0.0ms ( 0.0%)                   0.0ms
C2                1.9ms ( 0.2%)                   1.9ms
C3               58.6ms (99.7%)                  58.6ms

Wakeups-from-idle per second :  36.0 
Power usage (ACPI estimate) :  23.2 W (2.9 hours left)

Top causes for wakeups:
  48.2% ( 8.0)     <kernel core> : usb_hcd_poll_rh_status (rh_timer_func) 
  30.1% ( 5.0)     <kernel core> : fbcon_add_cursor_timer (cursor_timer_handl 
  12.0% ( 2.0)     <kernel core> : queue_delayed_work_on (delayed_work_timer_ 
   6.0% ( 1.0)             kedac : schedule_timeout (process_timeout) 
   1.2% ( 0.2)              init : schedule_timeout (process_timeout) 
   1.2% ( 0.2)     <kernel core> : neigh_table_init_no_netlink (neigh_periodi 
   1.2% ( 0.2)        rc.sysinit : start_this_handle (commit_timeout)

--==_Exmh_1179710073_3707P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFGUPJ5cC3lWbTT17ARApV3AJUf457f1C6is3pFhnQcQD596DoPAKCgKvlO
FBo2pWFTkjolrpDZlKrh0w==
=obpu
-----END PGP SIGNATURE-----

--==_Exmh_1179710073_3707P--
