Return-Path: <linux-kernel-owner+w=401wt.eu-S933450AbZAOU3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450AbZAOU3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbZAOUBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:01:32 -0500
Received: from kroah.org ([198.145.64.141]:49246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765934AbZAOUBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:01:10 -0500
Date: Thu, 15 Jan 2009 11:58:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 46/94] [PATCH 15/44] [CVE-2009-0029] System call wrappers
	part 05
Message-ID: <20090115195857.GT14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0015--CVE-2009-0029-System-call-wrappers-part-05.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 362e9c07c7220c0a78c88826fc0d2bf7e4a4bb68 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/itimer.c       |    5 ++---
 kernel/posix-timers.c |   43 +++++++++++++++++++------------------------
 2 files changed, 21 insertions(+), 27 deletions(-)

--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -260,9 +260,8 @@ unsigned int alarm_setitimer(unsigned in
 	return it_old.it_value.tv_sec;
 }
 
-asmlinkage long sys_setitimer(int which,
-			      struct itimerval __user *value,
-			      struct itimerval __user *ovalue)
+SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
+		struct itimerval __user *, ovalue)
 {
 	struct itimerval set_buffer, get_buffer;
 	int error;
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -470,10 +470,9 @@ static void release_posix_timer(struct k
 
 /* Create a POSIX.1b interval timer. */
 
-asmlinkage long
-sys_timer_create(const clockid_t which_clock,
-		 struct sigevent __user *timer_event_spec,
-		 timer_t __user * created_timer_id)
+SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
+		struct sigevent __user *, timer_event_spec,
+		timer_t __user *, created_timer_id)
 {
 	struct k_itimer *new_timer;
 	int error, new_timer_id;
@@ -659,8 +658,8 @@ common_timer_get(struct k_itimer *timr, 
 }
 
 /* Get the time remaining on a POSIX.1b interval timer. */
-asmlinkage long
-sys_timer_gettime(timer_t timer_id, struct itimerspec __user *setting)
+SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
+		struct itimerspec __user *, setting)
 {
 	struct k_itimer *timr;
 	struct itimerspec cur_setting;
@@ -689,8 +688,7 @@ sys_timer_gettime(timer_t timer_id, stru
  * the call back to do_schedule_next_timer().  So all we need to do is
  * to pick up the frozen overrun.
  */
-asmlinkage long
-sys_timer_getoverrun(timer_t timer_id)
+SYSCALL_DEFINE1(timer_getoverrun, timer_t, timer_id)
 {
 	struct k_itimer *timr;
 	int overrun;
@@ -758,10 +756,9 @@ common_timer_set(struct k_itimer *timr, 
 }
 
 /* Set a POSIX.1b interval timer */
-asmlinkage long
-sys_timer_settime(timer_t timer_id, int flags,
-		  const struct itimerspec __user *new_setting,
-		  struct itimerspec __user *old_setting)
+SYSCALL_DEFINE4(timer_settime, timer_t, timer_id, int, flags,
+		const struct itimerspec __user *, new_setting,
+		struct itimerspec __user *, old_setting)
 {
 	struct k_itimer *timr;
 	struct itimerspec new_spec, old_spec;
@@ -814,8 +811,7 @@ static inline int timer_delete_hook(stru
 }
 
 /* Delete a POSIX.1b interval timer. */
-asmlinkage long
-sys_timer_delete(timer_t timer_id)
+SYSCALL_DEFINE1(timer_delete, timer_t, timer_id)
 {
 	struct k_itimer *timer;
 	unsigned long flags;
@@ -903,8 +899,8 @@ int do_posix_clock_nonanosleep(const clo
 }
 EXPORT_SYMBOL_GPL(do_posix_clock_nonanosleep);
 
-asmlinkage long sys_clock_settime(const clockid_t which_clock,
-				  const struct timespec __user *tp)
+SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
+		const struct timespec __user *, tp)
 {
 	struct timespec new_tp;
 
@@ -916,8 +912,8 @@ asmlinkage long sys_clock_settime(const 
 	return CLOCK_DISPATCH(which_clock, clock_set, (which_clock, &new_tp));
 }
 
-asmlinkage long
-sys_clock_gettime(const clockid_t which_clock, struct timespec __user *tp)
+SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
+		struct timespec __user *,tp)
 {
 	struct timespec kernel_tp;
 	int error;
@@ -933,8 +929,8 @@ sys_clock_gettime(const clockid_t which_
 
 }
 
-asmlinkage long
-sys_clock_getres(const clockid_t which_clock, struct timespec __user *tp)
+SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
+		struct timespec __user *, tp)
 {
 	struct timespec rtn_tp;
 	int error;
@@ -963,10 +959,9 @@ static int common_nsleep(const clockid_t
 				 which_clock);
 }
 
-asmlinkage long
-sys_clock_nanosleep(const clockid_t which_clock, int flags,
-		    const struct timespec __user *rqtp,
-		    struct timespec __user *rmtp)
+SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
+		const struct timespec __user *, rqtp,
+		struct timespec __user *, rmtp)
 {
 	struct timespec t;
 

