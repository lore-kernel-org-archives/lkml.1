Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbXIZNc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbXIZNc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbXIZNcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:32:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbXIZNcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:32:11 -0400
Date: Wed, 26 Sep 2007 15:31:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Schwartz <davids@webmaster.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926133138.GA23187@elte.hu>
References: <20070926112919.GN3337@deprecation.cyrius.com> <MDEHLPKNGKAHNMBLJOLKCEPKHAAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEPKHAAC.davids@webmaster.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Schwartz <davids@webmaster.com> wrote:

> > > I think the real fix would be for iperf to use blocking network IO 
> > > though, or maybe to use a POSIX mutex or POSIX semaphores.
> >
> > So it's definitely not a bug in the kernel, only in iperf?
> 
> Martin:
> 
> Actually, in this case I think iperf is doing the right thing (though not
> the best thing) and the kernel is doing the wrong thing. [...]

it's not doing the right thing at all. I had a quick look at the source 
code, and the reason for that weird yield usage was that there's a 
locking bug in iperf's "Reporter thread" abstraction and apparently 
instead of fixing the bug it was worked around via a horrible yield() 
based user-space lock.

the (small) patch below fixes the iperf locking bug and removes the 
yield() use. There are numerous immediate benefits of this patch:

 - iperf uses _much_ less CPU time. On my Core2Duo test system, before 
   the patch it used up 100% CPU time to saturate 1 gigabit of network 
   traffic to another box. With the patch applied it now uses 9% of 
   CPU time.

 - sys_sched_yield() is removed altogether

 - i was able to measure much higher bandwidth over localhost for 
   example. This is the case for over-the-network measurements as well.

 - the results are also more consistent and more deterministic, hence 
   more reliable as a benchmarking tool. (the reason for that is that
   more CPU time is spent on actually delivering packets, instead of
   mindlessly polling on the user-space "lock", so we actually max out
   the CPU, instead of relying on the random proportion the workload was
   able to make progress versus wasting CPU time on polling.)

sched_yield() is almost always the symptom of broken locking or other 
bug. In that sense CFS does the right thing by exposing such bugs =B-)
 
	Ingo

------------------------->
Subject: iperf: fix locking
From: Ingo Molnar <mingo@elte.hu>

fix iperf locking - it was burning CPU time while polling
unnecessarily, instead of using the proper wait primitives.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 compat/Thread.c |    3 ---
 src/Reporter.c  |   13 +++++++++----
 src/main.cpp    |    2 ++
 3 files changed, 11 insertions(+), 7 deletions(-)

Index: iperf-2.0.2/compat/Thread.c
===================================================================
--- iperf-2.0.2.orig/compat/Thread.c
+++ iperf-2.0.2/compat/Thread.c
@@ -405,9 +405,6 @@ int thread_numuserthreads( void ) {
 void thread_rest ( void ) {
 #if defined( HAVE_THREAD )
 #if defined( HAVE_POSIX_THREAD )
-    // TODO add checks for sched_yield or pthread_yield and call that
-    // if available
-    usleep( 0 );
 #else // Win32
     SwitchToThread( );
 #endif
Index: iperf-2.0.2/src/Reporter.c
===================================================================
--- iperf-2.0.2.orig/src/Reporter.c
+++ iperf-2.0.2/src/Reporter.c
@@ -111,6 +111,7 @@ report_statistics multiple_reports[kRepo
 char buffer[64]; // Buffer for printing
 ReportHeader *ReportRoot = NULL;
 extern Condition ReportCond;
+extern Condition ReportDoneCond;
 int reporter_process_report ( ReportHeader *report );
 void process_report ( ReportHeader *report );
 int reporter_handle_packet( ReportHeader *report );
@@ -338,7 +339,7 @@ void ReportPacket( ReportHeader* agent, 
             // item
             while ( index == 0 ) {
                 Condition_Signal( &ReportCond );
-                thread_rest();
+                Condition_Wait( &ReportDoneCond );
                 index = agent->reporterindex;
             }
             agent->agentindex = 0;
@@ -346,7 +347,7 @@ void ReportPacket( ReportHeader* agent, 
         // Need to make sure that reporter is not about to be "lapped"
         while ( index - 1 == agent->agentindex ) {
             Condition_Signal( &ReportCond );
-            thread_rest();
+            Condition_Wait( &ReportDoneCond );
             index = agent->reporterindex;
         }
         
@@ -553,6 +554,7 @@ void reporter_spawn( thread_Settings *th
         }
         Condition_Unlock ( ReportCond );
 
+again:
         if ( ReportRoot != NULL ) {
             ReportHeader *temp = ReportRoot;
             //Condition_Unlock ( ReportCond );
@@ -575,9 +577,12 @@ void reporter_spawn( thread_Settings *th
                 // finished with report so free it
                 free( temp );
                 Condition_Unlock ( ReportCond );
+            	Condition_Signal( &ReportDoneCond );
+		if (ReportRoot)
+			goto again;
             }
-            // yield control of CPU is another thread is waiting
-            thread_rest();
+            Condition_Signal( &ReportDoneCond );
+            usleep(10000);
         } else {
             //Condition_Unlock ( ReportCond );
         }
Index: iperf-2.0.2/src/main.cpp
===================================================================
--- iperf-2.0.2.orig/src/main.cpp
+++ iperf-2.0.2/src/main.cpp
@@ -96,6 +96,7 @@ extern "C" {
     // records being accessed in a report and also to
     // serialize modification of the report list
     Condition ReportCond;
+    Condition ReportDoneCond;
 }
 
 // global variables only accessed within this file
@@ -141,6 +142,7 @@ int main( int argc, char **argv ) {
 
     // Initialize global mutexes and conditions
     Condition_Initialize ( &ReportCond );
+    Condition_Initialize ( &ReportDoneCond );
     Mutex_Initialize( &groupCond );
     Mutex_Initialize( &clients_mutex );
 
