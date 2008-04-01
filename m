Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYDAJke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYDAJke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYDAJkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:40:18 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:46031 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbYDAJkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:40:15 -0400
Date: Tue, 1 Apr 2008 11:40:06 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20080401094006.GD7279@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it> <12048053473401-git-send-email-giometti@linux.it> <20080328032139.7af69ff9.akpm@linux-foundation.org> <20080401085950.GZ7279@enneenne.com> <20080401020946.a62ee645.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401020946.a62ee645.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 02:09:46AM -0700, Andrew Morton wrote:
> On Tue, 1 Apr 2008 10:59:50 +0200 Rodolfo Giometti <giometti@enneenne.com> wrote:
> 
> > On Fri, Mar 28, 2008 at 03:21:39AM -0700, Andrew Morton wrote:
> > > On Thu,  6 Mar 2008 13:09:00 +0100 Rodolfo Giometti <giometti@linux.it> wrote:
> > > 
> > > > This patch adds the kernel side of the PPS support currently named
> > > > "LinuxPPS".
> > > 
> > > powerpc:
> > > 
> > > drivers/pps/pps.c: In function 'pps_cdev_ioctl':
> > > drivers/pps/pps.c:166: warning: format '%lld' expects type 'long long int', but argument 2 has type '__s64'
> > > drivers/pps/kapi.c: In function 'pps_event':
> > > drivers/pps/kapi.c:225: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type '__s64'
> > > drivers/pps/sysfs.c: In function 'pps_show_assert':
> > > drivers/pps/sysfs.c:42: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
> > > drivers/pps/sysfs.c:42: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
> > > drivers/pps/sysfs.c: In function 'pps_show_clear':
> > > drivers/pps/sysfs.c:56: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
> > > drivers/pps/sysfs.c:56: warning: format '%lld' expects type 'long long int', but argument 3 has type '__s64'
> > 
> > Oops! I have no powerpc system... how can I solve this issue?
> 
> Use %lld (if these things can legitimately be negative - otherwise %llu)
> and cast the argument to (long long) or (unsigned long long).

Ok, here my modifications:

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 34b3b22..d75c8c8 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -245,7 +245,7 @@ void pps_event(int source, int event, void *data)
                return;
 
        pr_debug("PPS event on source %d at %llu.%06u\n",
-                       pps->id, ts.sec, ts.nsec);
+                       pps->id, (unsigned long long) ts.sec, ts.nsec);
 
        spin_lock_irqsave(&pps->lock, flags);
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index a82b1d8..5cbfeb9 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -164,7 +164,8 @@ static int pps_cdev_ioctl(struct inode *inode, struct file *
                        err = wait_event_interruptible(pps->queue, pps->go);
                else {
                        pr_debug("timeout %lld.%09d\n",
-                                       fdata.timeout.sec, fdata.timeout.nsec);
+                                       (long long) fdata.timeout.sec,
+                                       fdata.timeout.nsec);
                        ticks = fdata.timeout.sec * HZ;
                        ticks += fdata.timeout.nsec / (NSEC_PER_SEC / HZ);
 
diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
index 3af773a..0520f62 100644
--- a/drivers/pps/sysfs.c
+++ b/drivers/pps/sysfs.c
@@ -38,7 +38,7 @@ static ssize_t pps_show_assert(struct device *dev,
                return 0;
 
        return sprintf(buf, "%lld.%09d#%d\n",
-                       pps->assert_tu.sec, pps->assert_tu.nsec,
+                       (long long) pps->assert_tu.sec, pps->assert_tu.nsec,
                        pps->assert_sequence);
 }
 DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
@@ -52,7 +52,7 @@ static ssize_t pps_show_clear(struct device *dev,
                return 0;
 
        return sprintf(buf, "%lld.%09d#%d\n",
-                       pps->clear_tu.sec, pps->clear_tu.nsec,
+                       (long long) pps->clear_tu.sec, pps->clear_tu.nsec,
                        pps->clear_sequence);
 }
 DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);

This compile clearly on x86. I'm going to propose a new patch ASAP.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
