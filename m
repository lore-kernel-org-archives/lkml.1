Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXF0M4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXF0M4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbXF0M4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:56:43 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:56781 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbXF0M4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:56:42 -0400
Date: Wed, 27 Jun 2007 14:58:02 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070627125802.GI13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com> <1182855427.12109.203.camel@pmac.infradead.org> <20070626170622.GA13886@enneenne.com> <1182879520.3263.19.camel@shinybook.infradead.org> <20070627101449.GH13886@enneenne.com> <1182939510.6409.17.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182939510.6409.17.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 11:18:30AM +0100, David Woodhouse wrote:
> On Wed, 2007-06-27 at 12:14 +0200, Rodolfo Giometti wrote:
> > On Tue, Jun 26, 2007 at 06:38:40PM +0100, David Woodhouse wrote:
> > > 
> > > 64-bit kernels can run 32-bit userspace programs. But some structures
> > > come out _differently_ between 32-bit and 64-bit compilation, so the
> > > system call needs a special 'compat' handler instead of just running the
> > > normal 64-bit system call.
> > > 
> > > The 'struct timespec' is one structure which is sometimes different for
> > > 32-bit vs. 64-bit, so any system call taking a 'struct timespec' must
> > > have a separate compat_sys_xxxx() to handle that. See something like
> > > compat_sys_clock_settime() in kernel/compat.c for an example (but don't
> > > use set_fs() like it does; just see how it handles the compat_timespec).
> > 
> > Did you mean something like this?
> 
> How will 64-bit system calls work if you do it like that? You need to
> provide _both_ sys_time_pps_fetch() and compat_sys_time_pps_fetch().

Sorry, I'm new to this 32/64 bits issues...

Now is it correct?

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index befe292..b9df17b 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 #include <linux/pps.h>
 #include <asm/uaccess.h>
 
@@ -362,6 +363,22 @@ sys_time_pps_fetch_exit:
        return ret;
 }
 
+#ifdef CONFIG_COMPAT
+asmlinkage long compat_sys_time_pps_fetch(int source, const int tsformat,
+                               struct pps_info __user *info, 
+                               const struct compat_timespec __user *timeout)
+{
+       int ret;
+       struct timespec to;
+
+       ret = get_compat_timespec(&to, timeout);
+       if (ret)
+               return -EFAULT;
+       
+       return sys_time_pps_fetch(source, tsformat, info, &to);
+}
+#endif
+
 /*
  * Module staff
  */

Since I have no way to test this code maybe is better add no function
at all and simply using a warning message if someone try compiling
this code with CONFIG_COMPAT enabled...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
