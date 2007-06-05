Return-Path: <linux-kernel-owner+w=401wt.eu-S1763604AbXFEHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763604AbXFEHX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 03:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbXFEHXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 03:23:49 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:32819 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761418AbXFEHXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 03:23:48 -0400
Date: Tue, 5 Jun 2007 09:25:01 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, akpm@linux-foundation.org
Message-ID: <20070605072501.GA15273@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [RFC] PPS: Implementing LinuxPPS API with new syscalls
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

after a little studing on new generic netlink interface and some
letters with Andrew Morton I decided to drop using the netlink API at
all and start using new specific syscalls.

Looking at current LinuxPPS API and at RFC2783 I think we need the
following syscalls:

   asmlinkage long sys_time_pps_find(int cmd, int __user *source,
                                          char __user *name, int namelen,
                                          char __user *path, int pathlen);
   asmlinkage long sys_time_pps_getparams(int source,
                                          struct pps_params __user *params);
   asmlinkage long sys_time_pps_setparams(int source,
                                          const struct pps_params __user *params);
   asmlinkage long sys_time_pps_getcap(int source, int __user *mode);
   asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
                                          struct pps_info __user *info,
                                          const struct timespec __user *timeout);

In fact:

* the two LinuxPPS functions time_pps_findsource() and
time_pps_findpath() can be implemented with sys_time_pps_find()
specifying proper finding command into "cmd",

* the RFC2783 time_pps_create() and time_pps_destroy() are not needed
since no PPS sources are created or destryed from userspace. The former
can be simply implemented as follow:

   static int time_pps_create(int source, pps_handle_t *handle)
   {
           /* In LinuxPPS there are no differences between a PPS source and
            * a PPS handle so we return the same value. */
           *handle = source;
    
           return 0;
   }

while the latter is just a "return 0".

* the RFC2783 time_pps_kcbind() is not implemented into Linux so it is
just a "return -EOPNOTSUPP".

Also using syscalls the problem regarding the pps_handle_t type
disappears, even if the needed of using time_pps_findsource() or
time_pps_findpath() still remains.

Regarding the file timepps.h I think I should reintroduce it into the
kernel header files since it's needed to define new PPS types and new
syscalls wrappers for RFC2783 compatibility.

Comments? Suggestions? :)

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
