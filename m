Return-Path: <linux-kernel-owner+w=401wt.eu-S934326AbXHVWpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326AbXHVWpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932651AbXHVWpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:45:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:45568 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762722AbXHVWpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:45:10 -0400
Message-ID: <46CCBC3C.7010307@windriver.com>
Date: Wed, 22 Aug 2007 17:44:12 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [Kgdb-bugreport] 2.6.23-rc3-mm1: kgdb build failure on powerpc
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<200708222104.29432.m.kozlowski@tuxland.pl> <20070822124743.fc316963.akpm@linux-foundation.org>
In-Reply-To: <20070822124743.fc316963.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------020302000603070906050901"
X-OriginalArrivalTime: 22 Aug 2007 22:44:12.0779 (UTC) FILETIME=[F5FEA3B0:01C7E50D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020302000603070906050901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Wed, 22 Aug 2007 21:04:28 +0200
> Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
>
>   
>> Hello,
>>
>> 	Got that on imac g3.
>>
>>   CC      kernel/kgdb.o
>> kernel/kgdb.c: In function 'kgdb_handle_exception':
>> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
>> kernel/kgdb.c:940: warning: type defaults to 'int' in declaration of '_o_'
>> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
>> kernel/kgdb.c:940: warning: type defaults to 'int' in declaration of '_n_'
>> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
>> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
>> kernel/kgdb.c:940: error: invalid lvalue in unary '&'
>> kernel/kgdb.c:940: warning: type defaults to 'int' in declaration of 'type name'
>> make[1]: *** [kernel/kgdb.o] Blad 1
>> make: *** [kernel] Blad 2
>>
>>     
>
>   
Against the tip of the kernel + kgdb patches this config builds.  I 
wonder if is the compiler or the macros for atomic_read or cmpxchg have 
changed for in the -mm tree.  Perhaps it is not relevant though if you 
read on.
> I'm not surprised.
>
> 	while (cmpxchg(&atomic_read(&debugger_active), 0, (procid + 1)) != 0) {
>
> a) cmpxchg isn't available on all architectures
>
>   
It was available for all the archs that the kgdb had been implemented on 
at the time.
> b) we can't just go and take the address of atomic_read()'s return value!
>
>   
Perhaps yes, perhaps no I guess it depends on what actually gets 
generated...  In the past the intent of this was to guard for the race 
to be the master processor and looked like some attempt to do it 
atomically.  This code had been in use for a number of years at this point.
> c) that's pretty ugly-looking stuff anyway.
>
>   

Perhaps there is a cleaner way to do the same thing and avoid the 
cmpxchg all together.  I used the attached patch to eliminate the 
cmpxchg operation.


Jason.

--------------020302000603070906050901
Content-Type: text/plain;
 name="kgdb_enter_atomic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kgdb_enter_atomic.patch"

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 kernel/kgdb.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -121,6 +121,7 @@ struct task_struct *kgdb_usethread, *kgd
 
 int debugger_step;
 atomic_t debugger_active;
+static atomic_t kgdb_sync = ATOMIC_INIT(-1);
 
 /* Our I/O buffers. */
 static char remcom_in_buffer[BUFMAX];
@@ -638,8 +639,14 @@ static void kgdb_wait(struct pt_regs *re
 	kgdb_info[processor].task = current;
 	atomic_set(&procindebug[processor], 1);
 
+	/* The master processor must be active to enter here, but this is
+	 * gaurd in case the master processor had not been selected if
+	 * this was an entry via nmi.
+	 */
+	while (!atomic_read(&debugger_active));
+
 	/* Wait till master processor goes completely into the debugger.
-	 * FIXME: this looks racy */
+	 */
 	while (!atomic_read(&procindebug[atomic_read(&debugger_active) - 1])) {
 		int i = 10;	/* an arbitrary number */
 
@@ -973,8 +980,13 @@ int kgdb_handle_exception(int ex_vector,
 	/* Hold debugger_active */
 	procid = raw_smp_processor_id();
 
-	while (cmpxchg(&atomic_read(&debugger_active), 0, (procid + 1)) != 0) {
+	while (1) {
 		int i = 25;	/* an arbitrary number */
+		if (atomic_read(&kgdb_sync) < 0 &&
+			atomic_inc_and_test(&kgdb_sync)) {
+			atomic_set(&debugger_active, procid + 1);
+			break;
+		}
 
 		while (--i)
 			cpu_relax();
@@ -991,6 +1003,7 @@ int kgdb_handle_exception(int ex_vector,
 	if (atomic_read(&cpu_doing_single_step) != -1 &&
 	    atomic_read(&cpu_doing_single_step) != procid) {
 		atomic_set(&debugger_active, 0);
+		atomic_set(&kgdb_sync, -1);
 		clocksource_touch_watchdog();
 		kgdb_softlock_skip[procid] = 1;
 		local_irq_restore(flags);
@@ -1557,6 +1570,7 @@ int kgdb_handle_exception(int ex_vector,
  kgdb_restore:
 	/* Free debugger_active */
 	atomic_set(&debugger_active, 0);
+	atomic_set(&kgdb_sync, -1);
 	clocksource_touch_watchdog();
 	kgdb_softlock_skip[processor] = 1;
 	local_irq_restore(flags);

--------------020302000603070906050901--
