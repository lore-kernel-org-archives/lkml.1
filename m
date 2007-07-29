Return-Path: <linux-kernel-owner+w=401wt.eu-S1761868AbXG2J6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbXG2J6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbXG2J62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:58:28 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39749 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761030AbXG2J62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:58:28 -0400
Date: Sun, 29 Jul 2007 12:00:07 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070729100007.GB9840@enneenne.com>
References: <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS & spinlocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 05:11:17AM +0530, Satyam Sharma wrote:

> Take the race between the time_pps_setparams() syscall and a concurrent
> pps_event() from an interrupt for instance. From sys_time_pps_setparams,
> the parameters for an existing source are not modified / set atomically,
> which means a pps_event() called on the same source in between will see
> invalid parameters ... and bad things will happen.

I think this should be a good solution... :)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 08de71d..f0c42ec 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -29,12 +29,6 @@
 #include <linux/pps.h>
 
 /*
- * Local variables
- */
-
-static spinlock_t pps_lock = SPIN_LOCK_UNLOCKED;
-
-/*
  * Local functions
  */
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 9176c01..91b7e4d 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -35,6 +35,7 @@
 
 struct pps_s pps_source[PPS_MAX_SOURCES];
 DEFINE_MUTEX(pps_mutex);
+spinlock_t pps_lock = SPIN_LOCK_UNLOCKED;
 
 /*
  * Misc functions
@@ -227,6 +228,8 @@ asmlinkage long sys_time_pps_setparams(int source,
                goto sys_time_pps_setparams_exit;
        }
 
+       spin_lock(&pps_lock);
+
        /* Save the new parameters */
        ret = copy_from_user(&pps_source[source].params, params,
                                                sizeof(struct pps_kparams));
@@ -245,6 +248,8 @@ asmlinkage long sys_time_pps_setparams(int source,
                pps_source[source].params.mode |= PPS_CANWAIT;
        pps_source[source].params.api_version = PPS_API_VERS;
 
+       spin_unlock(&pps_lock);
+
 sys_time_pps_setparams_exit:
        mutex_unlock(&pps_mutex);
 
diff --git a/include/linux/pps.h b/include/linux/pps.h
index 6eca3ea..93e7384 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -174,6 +174,7 @@ struct pps_s {
 
 extern struct pps_s pps_source[PPS_MAX_SOURCES];
 extern struct mutex pps_mutex;
+extern spinlock_t pps_lock;
 
 /*
  * Global functions

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
