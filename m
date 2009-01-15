Return-Path: <linux-kernel-owner+w=401wt.eu-S935553AbZAOWVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935553AbZAOWVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbZAOWCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:41 -0500
Received: from kroah.org ([198.145.64.141]:38453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764391AbZAOWCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:25 -0500
Date: Thu, 15 Jan 2009 14:00:05 -0800
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
Subject: [patch 35/85] [PATCH 15/44] [CVE-2009-0029] System call wrappers
	part 05
Message-ID: <20090115220005.GJ17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0015--CVE-2009-0029-System-call-wrappers-part-05.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -273,9 +273,8 @@ unsigned int alarm_setitimer(unsigned in
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
@@ -463,10 +463,9 @@ static void release_posix_timer(struct k
 
 /* Create a POSIX.1b interval timer. */
 
-asmlinkage long
-sys_timer_create(const clockid_t which_clock,
-		 struct sigevent __user *timer_event_spec,
-		 timer_t __user * created_timer_id)
+SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
+		struct sigevent __user *, timer_event_spec,
+		timer_t __user *, created_timer_id)
 {
 	int error = 0;
 	struct k_itimer *new_timer = NULL;
@@ -682,8 +681,8 @@ common_timer_get(struct k_itimer *timr, 
 }
 
 /* Get the time remaining on a POSIX.1b interval timer. */
-asmlinkage long
-sys_timer_gettime(timer_t timer_id, struct itimerspec __user *setting)
+SYSCALL_DEFINE2(timer_gettime, timer_t, timer_id,
+		struct itimerspec __user *, setting)
 {
 	struct k_itimer *timr;
 	struct itimerspec cur_setting;
@@ -712,8 +711,7 @@ sys_timer_gettime(timer_t timer_id, stru
  * the call back to do_schedule_next_timer().  So all we need to do is
  * to pick up the frozen overrun.
  */
-asmlinkage long
-sys_timer_getoverrun(timer_t timer_id)
+SYSCALL_DEFINE1(timer_getoverrun, timer_t, timer_id)
 {
 	struct k_itimer *timr;
 	int overrun;
@@ -783,10 +781,9 @@ common_timer_set(struct k_itimer *timr, 
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
@@ -839,8 +836,7 @@ static inline int timer_delete_hook(stru
 }
 
 /* Delete a POSIX.1b interval timer. */
-asmlinkage long
-sys_timer_delete(timer_t timer_id)
+SYSCALL_DEFINE1(timer_delete, timer_t, timer_id)
 {
 	struct k_itimer *timer;
 	unsigned long flags;
@@ -930,8 +926,8 @@ int do_posix_clock_nonanosleep(const clo
 }
 EXPORT_SYMBOL_GPL(do_posix_clock_nonanosleep);
 
-asmlinkage long sys_clock_settime(const clockid_t which_clock,
-				  const struct timespec __user *tp)
+SYSCALL_DEFINE2(clock_settime, const clockid_t, which_clock,
+		const struct timespec __user *, tp)
 {
 	struct timespec new_tp;
 
@@ -943,8 +939,8 @@ asmlinkage long sys_clock_settime(const 
 	return CLOCK_DISPATCH(which_clock, clock_set, (which_clock, &new_tp));
 }
 
-asmlinkage long
-sys_clock_gettime(const clockid_t which_clock, struct timespec __user *tp)
+SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
+		struct timespec __user *,tp)
 {
 	struct timespec kernel_tp;
 	int error;
@@ -960,8 +956,8 @@ sys_clock_gettime(const clockid_t which_
 
 }
 
-asmlinkage long
-sys_clock_getres(const clockid_t which_clock, struct timespec __user *tp)
+SYSCALL_DEFINE2(clock_getres, const clockid_t, which_clock,
+		struct timespec __user *, tp)
 {
 	struct timespec rtn_tp;
 	int error;
@@ -990,10 +986,9 @@ static int common_nsleep(const clockid_t
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
 

