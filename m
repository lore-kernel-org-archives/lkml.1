Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXIZPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXIZPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbXIZPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:47:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbXIZPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:47:07 -0400
Date: Wed, 26 Sep 2007 08:46:32 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070926084632.0c82fdba@fujitsu-loaner>
In-Reply-To: <20070926133138.GA23187@elte.hu>
References: <20070926112919.GN3337@deprecation.cyrius.com>
	<MDEHLPKNGKAHNMBLJOLKCEPKHAAC.davids@webmaster.com>
	<20070926133138.GA23187@elte.hu>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_Mv6OolZz+qDFySrY9Yh.4d7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_Mv6OolZz+qDFySrY9Yh.4d7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is the combined fixes from iperf-users list.

Begin forwarded message:

Date: Thu, 30 Aug 2007 15:55:22 -0400
From: "Andrew Gallatin" <gallatin@gmail.com>
To: iperf-users@dast.nlanr.net
Subject: [PATCH] performance fixes for non-linux


Hi,

I've attached a patch which gives iperf similar performance to netperf
on my FreeBSD, MacOSX and Solaris hosts.  It does not seem to
negatively impact Linux.  I only started looking at the iperf source
yesterday, so I don't really expect this to be integrated as is, but a
patch is worth a 1000 words :)

Background: On both Solaris and FreeBSD, there are 2 things slowing
iperf down: The gettimeofday timestamp around each socket read/write
is terribly expensive, and the sched_yield() or usleep(0) causes iperf
to take 100% of the time (system time on BSD, split user/system time
on Solaris and MacOSX), which slows things down and confuses the
scheduler.

To address the gettimeofday() issue,  I treat TCP different than UDP,
and TCP tests behave as though only a single (huge) packet was sent.
Rather then ending the test based on polling gettimeofday()
timestamps, an interval timer / sigalarm handler is used.  I had
to increase the packetLen from an int to a max_size_t.

To address the sched_yield/usleep issue, I put the reporter thread
to sleep on a condition variable.  For the TCP tests at least, there
is no reason to have it running during the test and it is best
to just get it out of the way rather than burning CPU in a tight
loop.

I've also incorporated some fixes from the FreeBSD ports collection:

--- include/headers.h
use a 64-bit type for max_size_t

--- compat/Thread.c
oldTID is not declared anywhere.  Make this compile
(seems needed for at least FreeBSD & MacOSX)

--- src/Client.cpp
BSDs can return ENOBUFS during a UDP test when the socket
buffer fills. Don't exit when this happens.

I've run the resulting iperf on FreeBSD, Solaris, MacOSX and Linux,
and it seems to work for me.  It is nice not to have a 100% CPU
load when running an iperf test across a 100Mb/s network.

Drew



--MP_Mv6OolZz+qDFySrY9Yh.4d7
Content-Type: text/x-patch; name=non-linux.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=non-linux.diff

Index: include/Reporter.h
===================================================================
--- include/Reporter.h	(revision 11)
+++ include/Reporter.h	(working copy)
@@ -74,7 +74,7 @@
  */
 typedef struct ReportStruct {
     int packetID;
-    int packetLen;
+    max_size_t packetLen;
     struct timeval packetTime;
     struct timeval sentTime;
 } ReportStruct;
Index: include/headers.h
===================================================================
--- include/headers.h	(revision 11)
+++ include/headers.h	(working copy)
@@ -180,7 +180,7 @@
 // from the gnu archive
 
 #include <iperf-int.h>
-typedef uintmax_t max_size_t;
+typedef uint64_t max_size_t;
 
 /* in case the OS doesn't have these, we provide our own implementations */
 #include "gettimeofday.h"
Index: include/Client.hpp
===================================================================
--- include/Client.hpp	(revision 11)
+++ include/Client.hpp	(working copy)
@@ -69,6 +69,9 @@
     // connects and sends data
     void Run( void );
 
+    // TCP specific version of above
+    void RunTCP( void );
+
     void InitiateServer();
 
     // UDP / TCP
Index: compat/Thread.c
===================================================================
--- compat/Thread.c	(revision 11)
+++ compat/Thread.c	(working copy)
@@ -202,7 +202,7 @@
 #if   defined( HAVE_POSIX_THREAD )
             // Cray J90 doesn't have pthread_cancel; Iperf works okay without
 #ifdef HAVE_PTHREAD_CANCEL
-            pthread_cancel( oldTID );
+            pthread_cancel( thread->mTID );
 #endif
 #else // Win32
             // this is a somewhat dangerous function; it's not
Index: src/Reporter.c
===================================================================
--- src/Reporter.c	(revision 11)
+++ src/Reporter.c	(working copy)
@@ -110,6 +110,8 @@
 
 char buffer[64]; // Buffer for printing
 ReportHeader *ReportRoot = NULL;
+int threadWait = 0;
+int threadSleeping = 0;
 extern Condition ReportCond;
 int reporter_process_report ( ReportHeader *report );
 void process_report ( ReportHeader *report );
@@ -349,7 +351,9 @@
             thread_rest();
             index = agent->reporterindex;
         }
-        
+	if (threadSleeping)
+           Condition_Signal( &ReportCond );
+
         // Put the information there
         memcpy( agent->data + agent->agentindex, packet, sizeof(ReportStruct) );
         
@@ -378,6 +382,9 @@
         packet->packetLen = 0;
         ReportPacket( agent, packet );
         packet->packetID = agent->report.cntDatagrams;
+	if (threadSleeping)
+           Condition_Signal( &ReportCond );
+
     }
 }
 
@@ -389,6 +396,9 @@
 void EndReport( ReportHeader *agent ) {
     if ( agent != NULL ) {
         int index = agent->reporterindex;
+	if (threadSleeping)
+           Condition_Signal( &ReportCond );
+
         while ( index != -1 ) {
             thread_rest();
             index = agent->reporterindex;
@@ -457,6 +467,10 @@
              * Update the ReportRoot to include this report.
              */
             Condition_Lock( ReportCond );
+	    if ( isUDP(agent) )
+	      threadWait = 0;
+	    else
+	      threadWait = 1;
             reporthdr->next = ReportRoot;
             ReportRoot = reporthdr;
             Condition_Signal( &ReportCond );
@@ -577,7 +591,17 @@
                 Condition_Unlock ( ReportCond );
             }
             // yield control of CPU is another thread is waiting
-            thread_rest();
+	    // sleep on a condition variable, as it is much cheaper
+	    // on most platforms than issuing schedyield or usleep
+	    // syscalls
+	    Condition_Lock ( ReportCond );
+	    if ( threadWait && ReportRoot != NULL) {
+	      threadSleeping = 1;
+	      Condition_TimedWait (& ReportCond, 1 );
+	      threadSleeping = 0;
+	    }
+	    Condition_Unlock ( ReportCond );
+	    
         } else {
             //Condition_Unlock ( ReportCond );
         }
Index: src/Server.cpp
===================================================================
--- src/Server.cpp	(revision 11)
+++ src/Server.cpp	(working copy)
@@ -98,6 +98,7 @@
  * ------------------------------------------------------------------- */ 
 void Server::Run( void ) {
     long currLen; 
+    max_size_t totLen = 0;
     struct UDP_datagram* mBuf_UDP  = (struct UDP_datagram*) mBuf; 
 
     ReportStruct *reportstruct = NULL;
@@ -115,22 +116,28 @@
                 reportstruct->packetID = ntohl( mBuf_UDP->id ); 
                 reportstruct->sentTime.tv_sec = ntohl( mBuf_UDP->tv_sec  );
                 reportstruct->sentTime.tv_usec = ntohl( mBuf_UDP->tv_usec ); 
-            }
+		reportstruct->packetLen = currLen;
+		gettimeofday( &(reportstruct->packetTime), NULL );
+            } else {
+		totLen += currLen;
+	    }
         
-            reportstruct->packetLen = currLen;
-            gettimeofday( &(reportstruct->packetTime), NULL );
-        
             // terminate when datagram begins with negative index 
             // the datagram ID should be correct, just negated 
             if ( reportstruct->packetID < 0 ) {
                 reportstruct->packetID = -reportstruct->packetID;
                 currLen = -1; 
             }
-            ReportPacket( mSettings->reporthdr, reportstruct );
+	    if ( isUDP (mSettings))
+		ReportPacket( mSettings->reporthdr, reportstruct );
         } while ( currLen > 0 ); 
         
         // stop timing 
         gettimeofday( &(reportstruct->packetTime), NULL );
+	if ( !isUDP (mSettings)) {
+		reportstruct->packetLen = totLen;
+		ReportPacket( mSettings->reporthdr, reportstruct );
+	}
         CloseReport( mSettings->reporthdr, reportstruct );
         
         // send a acknowledgement back only if we're NOT receiving multicast 
Index: src/Client.cpp
===================================================================
--- src/Client.cpp	(revision 11)
+++ src/Client.cpp	(working copy)
@@ -115,6 +115,79 @@
 const double kSecs_to_usecs = 1e6; 
 const int    kBytes_to_Bits = 8; 
 
+void Client::RunTCP( void ) {
+    long currLen = 0; 
+    struct itimerval it;
+    max_size_t totLen = 0;
+
+    int delay_target = 0; 
+    int delay = 0; 
+    int adjust = 0; 
+    int secs;
+    int usecs;
+    int err;
+
+    char* readAt = mBuf;
+
+    // Indicates if the stream is readable 
+    bool canRead = true, mMode_Time = isModeTime( mSettings ); 
+
+    ReportStruct *reportstruct = NULL;
+
+    // InitReport handles Barrier for multiple Streams
+    mSettings->reporthdr = InitReport( mSettings );
+    reportstruct = new ReportStruct;
+    reportstruct->packetID = 0;
+
+    lastPacketTime.setnow();
+    if ( mMode_Time ) {
+	memset (&it, 0, sizeof (it));
+	it.it_value.tv_sec = (int) (mSettings->mAmount / 100.0);
+	it.it_value.tv_usec = (int) 10000 * (mSettings->mAmount -
+	    it.it_value.tv_sec * 100.0);
+	err = setitimer( ITIMER_REAL, &it, NULL );
+	if ( err != 0 ) {
+	    perror("setitimer");
+	    exit(1);
+	}
+    }
+    do {
+        // Read the next data block from 
+        // the file if it's file input 
+        if ( isFileInput( mSettings ) ) {
+            Extractor_getNextDataBlock( readAt, mSettings ); 
+            canRead = Extractor_canRead( mSettings ) != 0; 
+        } else
+            canRead = true; 
+
+        // perform write 
+        currLen = write( mSettings->mSock, mBuf, mSettings->mBufLen ); 
+        if ( currLen < 0 ) {
+            WARN_errno( currLen < 0, "write2" ); 
+            break; 
+        }
+	totLen += currLen;
+
+        if ( delay > 0 ) {
+            delay_loop( delay ); 
+        }
+        if ( !mMode_Time ) {
+            mSettings->mAmount -= currLen;
+        }
+
+    } while ( ! (sInterupted  || 
+                   (!mMode_Time  &&  0 >= mSettings->mAmount)) && canRead ); 
+
+    // stop timing
+    gettimeofday( &(reportstruct->packetTime), NULL );
+    reportstruct->packetLen = totLen;
+    ReportPacket( mSettings->reporthdr, reportstruct );
+    CloseReport( mSettings->reporthdr, reportstruct );
+
+    DELETE_PTR( reportstruct );
+    EndReport( mSettings->reporthdr );
+}
+
 /* ------------------------------------------------------------------- 
  * Send data using the connected UDP/TCP socket, 
  * until a termination flag is reached. 
@@ -130,6 +203,13 @@
     int adjust = 0; 
 
     char* readAt = mBuf;
+
+#if HAVE_THREAD
+    if ( !isUDP( mSettings ) ) {
+	RunTCP();
+	return;
+    }
+#endif
     
     // Indicates if the stream is readable 
     bool canRead = true, mMode_Time = isModeTime( mSettings ); 
@@ -215,7 +295,7 @@
 
         // perform write 
         currLen = write( mSettings->mSock, mBuf, mSettings->mBufLen ); 
-        if ( currLen < 0 ) {
+        if ( currLen < 0 && errno != ENOBUFS ) {
             WARN_errno( currLen < 0, "write2" ); 
             break; 
         }
Index: src/main.cpp
===================================================================
--- src/main.cpp	(revision 11)
+++ src/main.cpp	(working copy)
@@ -123,6 +123,7 @@
     // Set SIGTERM and SIGINT to call our user interrupt function
     my_signal( SIGTERM, Sig_Interupt );
     my_signal( SIGINT,  Sig_Interupt );
+    my_signal( SIGALRM,  Sig_Interupt );
 
 #ifndef WIN32
     // Ignore broken pipes

--MP_Mv6OolZz+qDFySrY9Yh.4d7--
