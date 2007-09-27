Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbXI0JuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbXI0JuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 05:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXI0JuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 05:50:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXI0JuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 05:50:07 -0400
Date: Thu, 27 Sep 2007 11:49:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927094940.GA2894@elte.hu>
References: <20070926085202.GE3337@deprecation.cyrius.com> <1190802208.7318.5.camel@Homer.simpson.net> <20070926104814.GM3337@deprecation.cyrius.com> <20070926112137.GA13876@elte.hu> <20070926112919.GN3337@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926112919.GN3337@deprecation.cyrius.com>
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


* Martin Michlmayr <tbm@cyrius.com> wrote:

> > I think the real fix would be for iperf to use blocking network IO 
> > though, or maybe to use a POSIX mutex or POSIX semaphores.
> 
> So it's definitely not a bug in the kernel, only in iperf?
> 
> (CCing Stephen Hemminger who wrote the iperf patch.)

Martin, could you check the iperf patch below instead of the yield patch 
- does it solve the iperf performance problem equally well, and does CPU 
utilization drop for you too?

	Ingo

-------------------------->
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
 

