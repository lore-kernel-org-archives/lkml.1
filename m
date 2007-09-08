Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbXIHSrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbXIHSrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 14:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbXIHSrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 14:47:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:36013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256AbXIHSrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 14:47:01 -0400
Date: Sat, 8 Sep 2007 18:46:59 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36-pre1
Message-ID: <20070908184659.GA22833@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just released Linux 2.4.36-pre1.

It's basically the same as 2.4.35.2, with an add-on I'd like people
to experiment with : In private discussions, Solar Designer proposed
to restrict the ability to map the NULL address to CAP_RAW_IO capable
processes only. The idea behind this was to prevent "normal" users
from trying to exploit NULL dereferences in the kernel which have
not been discovered yet. This is purely a preventive measure. Alan
Cox indicated that it was desirable to be able to dynamically disable
the feature because some (very) rare programs map the NULL pointer
to speed up their walk through linked lists by avoiding NULL pointer
checks.

Chris Wright noted that 2.6 already has a somewhat similar feature
brought by Eric Paris, which introduces a sysctl by which the admin
can set the lower mappable address. 

Finally a combination of both methods was implemented. The same sysctl
as in 2.6 was implemented to set the lowest mappable address for non
CAP_RAW_IO capable processes. By default, it is set to zero (disabled)
which means NULL is mappable for everybody. To enable protection,
simply echo the first mappable address into /proc/sys/vm/mmap_min_addr :

  # echo 4096 > /proc/sys/vm/mmap_min_addr

We chose to use the same sysctl and semantics as in 2.6 to ease the
transition from 2.4 to 2.6 without requiring to remove protection.

Extensive tests have been ran with this feature. Some of my desktop
machines already run with it enabled, and our appliances at Exceliance
ship with it enabled by default. Solar Designer tested both Xorg and
Wine as a normal user, and the same feature is enabled by default in
the Openwall Linux 2.4.35-ow2 kernel.

Please report any breakage you would detect when enabling it. We're
pretty confident that almost every applications will not see any
difference since no normal application maps NULL. But it would be
interesting to identify the "special" ones. Applications running
as root will never be impacted. Depending on the application,
typical breakage would translate into memory allocation error or
segmentation fault. Something clearly detectable anyway.

Another issue I'll try to get solved is the current status of the
e100 driver. I got hit in production by its very unreliable VLAN
support (version 2.3.43 !). I got 3.5.17 to fix all of my issues,
so I'll check with the e100 maintainers if we can upgrade it. It
will make the maintenance easier for them too by getting rid of
a very old and buggy version.

Last but not least, please note that this version _will not_ build
under gcc-4.2, so it's not necessary to report it. I'll try to find
a solution.

I estimate that depending on what will be updated, 2.4.36 could see
the light by the end of this year. 2.4.35.x will still evolve in
parallel, of course !

Willy
--

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.36-pre1.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.36.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git


Summary of changes from v2.4.35 to v2.4.36-pre1
============================================

Marc Haisenko (1):
      b44: fix force mac address before ifconfig up

Willy Tarreau (12):
      build fix for lvm with gcc 4
      fix wdt83627 build breakage with gcc 4.x
      wdt83627: fix wdt_init() return code
      module fdomain_cs requires fdomain_setup()
      do not use gcc's builtin strpbrk
      fix incorrect use of -fno-unit-at-a-time on GCC >= 4
      second build fix for some rare buggy versions of GCC 4
      CVE-2007-3848 Privilege escalation via PR_SET_PDEATHSIG
      i386: do_test_wp_bit() must not be inlined
      restore -fno-unit-at-a-time on GCC >= 4
      sysctl to prevent normal processes from mapping NULL
      Change VERSION to 2.4.36-pre1

