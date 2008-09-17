Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYIQSO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYIQSO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYIQSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:14:19 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58117 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbYIQSOS (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:14:18 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: srostedt@redhat.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc6-mmotm0913 - massive CONFIG_FTRACE overhead?
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221675218_5364P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Sep 2008 14:13:38 -0400
Message-ID: <19164.1221675218@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221675218_5364P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <19158.1221675218.1@turing-police.cc.vt.edu>

Scenario: Dell Latitude D820 laptop, Core2 Duo T7200 2.0Gz CPU, 64-bit kernel.

System ran fine on rc5-mmotm0829.  When I built -mmotm0913, I changed the
CONFIG_FTRACE from 'n' to 'y'.  The resulting kernel chews a *lot* of
system-mode time - even running 'xmms' (which on the older kernel only took
4-5% total CPU) was showing 20-25% system time.  This morning, it was hitting
up to 95% system time while downloading my e-mail, a fetchmail/sendmail/procmail
pipeline.  I ran some oprofile numbers (60 seconds worth of data per run):

Running xmms last night, 20-25% system CPU:
samples  %        symbol name
9712     22.0677  read_hpet
7003     15.9123  ftrace_caller
3931      8.9321  ftrace_call
2763      6.2781  native_read_tsc
1678      3.8128  hpet_next_event
1420      3.2265  tg_shares_up
610       1.3860  get_parent_ip
560       1.2724  test_ti_thread_flag
507       1.1520  native_sched_clock
479       1.0884  sched_clock_cpu
459       1.0429  __switch_to
428       0.9725  in_lock_functions
349       0.7930  getnstimeofday

Two runs from this morning, up to 80-95% system CPU:
samples  %        symbol name
11206    26.5068  ftrace_caller
8624     20.3993  ftrace_call
6252     14.7885  read_hpet
1746      4.1300  native_read_tsc
869       2.0555  tg_shares_up
696       1.6463  get_parent_ip
628       1.4855  hpet_next_event
599       1.4169  test_ti_thread_flag
441       1.0431  in_lock_functions
436       1.0313  __might_sleep
412       0.9745  flush_tlb_page
276       0.6529  system_call

samples  %        symbol name
16008    31.5131  ftrace_caller
12858    25.3120  ftrace_call
6174     12.1540  read_hpet
1212      2.3859  native_read_tsc
755       1.4863  get_parent_ip
731       1.4390  tg_shares_up
626       1.2323  __might_sleep
626       1.2323  test_ti_thread_flag
526       1.0355  in_lock_functions
479       0.9430  flush_tlb_page
353       0.6949  __phys_addr
314       0.6181  system_call

Roughly 2/3 of my total CPU capacity is getting sucked down by those top 4
functions. Is it *expected* that ftrace will suck down so much CPU, or am I
doing something wrong/stupid?

Digging further:

% grep FTRACE .config
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set

% cat /proc/cmdline 
root=/dev/VolGroup00/root vga=794 quiet log_buf_len=2m usbcore.autosuspend=1

Based on the help text, I'd expect my kernel is built with it, but it's
disabled, so it should be low-cost.  However:

%  cat /proc/sys/kernel/ftrace_enabled
1

Oddly enough, I find in kernel/trace/ftrace.c, function ftrace_init():

        last_ftrace_enabled = ftrace_enabled = 1;

Comparing to the Kconfig help:

          tracing is enabled by the administrator. If it's runtime disabled
          (the bootup default), then the overhead of the instructions is very
          small and not measurable even in micro-benchmarks.

Is the init in ftrace_init wrong, or is the help wrong, or am I looking at
the wrong variable (which probably means the variable name is poorly chosen?)

--==_Exmh_1221675218_5364P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0UjScC3lWbTT17ARAhBhAKDB3cyw+wQ1jf7MNMF+MeRCUuUZAQCdFArH
JL8QbPKtiE6k5wd31h32s3Q=
=BDMj
-----END PGP SIGNATURE-----

--==_Exmh_1221675218_5364P--
