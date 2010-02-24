Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0BXM2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:28:35 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:38438 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab0BXM2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:28:34 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
       stas@lvk.cs.msu.su, Rodolfo Giometti <giometti@enneenne.com>,
       john stultz <johnstul@us.ibm.com>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCHv2 0/6] pps: time synchronization over LPT
Date: Wed, 24 Feb 2010 15:28:10 +0300
Message-Id: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.6.1
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a complete solution (well, the kernel part) for fast
high-precision time synchronization between computers using their LPT
ports. My tests show that it is able to achieve synchronization in the
order of 1-2 microseconds and keep it for as long as needed. We are
using this facility in my company for distributed real-time simulation.

The idea is to have a single master computer whose local clock is used
as a standard. It then provides time information through both PPS
high-precision signal over LPT and NTP over network. Then any other
computer can combine these two time sources (this is what ntpd can do).
Client-side ntpd constantly checks that the local time divergence from
the master's time is less then 128ms. If this is true it uses PPS
signal to further decrease the difference. ntpd can try to do itself
but it's too slow and imprecise. This is really a job for the kernel.

All stuff related to the PPS signals in Linux kernel is handled by the
code from LinuxPPS project. It can be controlled from user-space
through PPSAPI (RFC 2783) and ntpd can use it to pass control over
synchronization to the kernel. Unfortunately this is an optional
feature of PPSAPI and it was not implemented. Also Linux code from
NTPv4 reference model was missing all the pieces that deal with PPS.
This patchset closes both gaps to achieve the highest precision and
speed. It:

 * adds missing hardpps() function to the NTPv4 Linux kernel code

 * adds getnstime_raw_and_real() to atomically get both MONOTONIC_RAW
   and REALTIME clock timestamps for hardpps()

 * adds missing optional PPSAPI method to bind the particular PPS
   source to feed information to the time subsystem through hardpps()

Also it adds the actual parallel port PPS generator and client.

This patchset is tested against the vanilla 2.6.32.9 kernel. But we are
actually using it on 2.6.31.12-rt20 rt-preempt kernel most of the time.
Also there is a version which should be applied on top of LinuxPPS out
of tree patches (i.e. all clients and low-level irq timestamps stuff).
Those who are interested in other versions of the patchset can find
them in my git repository:
http://lvk.cs.msu.su/~lasaine/timesync/linux-2.6-timesync.git

There is one problem however: hardpps() works bad when used on top
of 2.6.33-rc* with CONFIG_NO_HZ enabled. The reason for this is commit
a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it hardpps() is able
to sync to 1us precision in about 10 seconds. With it 

Changelog
v1 -> v2:
 * fix issues pointed out by John Stultz:
   * style fixes
   * add a about the authorship of the original code
   * replace timespec with pps_normtime struct where timespec is used
     in a wrong way
   * fix seqlock usage in hardpps()
 * unbind kernel consumer on device removal
 * send raw timestamp instead of the last difference to hardpps() which
   simplifies the code and is less error-prone
 * update comments in the kernel consumer code to match the reality
 * split the patch that adds MONOTONIC_RAW timestmaps into two
 * other small fixes

Alexander Gordeev (6):
  ntp: add hardpps implementation
  pps: unify timestamp gathering
  pps: capture MONOTONIC_RAW timestamps as well
  pps: add kernel consumer support
  pps: add parallel port PPS signal generator
  pps: add parallel port PPS client

 Documentation/ioctl/ioctl-number.txt     |    2 +-
 drivers/pps/Kconfig                      |    5 +
 drivers/pps/Makefile                     |    1 +
 drivers/pps/clients/Kconfig              |   16 ++
 drivers/pps/clients/Makefile             |    9 +
 drivers/pps/clients/pps_parport.c        |  211 +++++++++++++++
 drivers/pps/generators/Kconfig           |   17 ++
 drivers/pps/generators/Makefile          |    9 +
 drivers/pps/generators/pps_gen_parport.c |  264 +++++++++++++++++++
 drivers/pps/kapi.c                       |   41 +++-
 drivers/pps/pps.c                        |   67 +++++-
 include/linux/pps.h                      |    7 +
 include/linux/pps_kernel.h               |   30 ++-
 include/linux/time.h                     |    2 +
 include/linux/timex.h                    |    1 +
 kernel/time/Kconfig                      |    7 +
 kernel/time/ntp.c                        |  420 ++++++++++++++++++++++++++++-
 kernel/time/timekeeping.c                |   34 +++
 18 files changed, 1119 insertions(+), 24 deletions(-)
 create mode 100644 drivers/pps/clients/Kconfig
 create mode 100644 drivers/pps/clients/Makefile
 create mode 100644 drivers/pps/clients/pps_parport.c
 create mode 100644 drivers/pps/generators/Kconfig
 create mode 100644 drivers/pps/generators/Makefile
 create mode 100644 drivers/pps/generators/pps_gen_parport.c

