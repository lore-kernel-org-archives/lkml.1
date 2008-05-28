Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYE1Shp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYE1Shp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 14:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYE1Shi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 14:37:38 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:45120 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYE1Shh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 14:37:37 -0400
To: akpm@linux-foundation.org, zanussi@comcast.net
Subject: [RFC Patch 0/1] Merging Documentation/trace.txt with Documentation/filesystems/relay.txt
Reply-To: prasad@linux.vnet.ibm.com
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, hch@infradead.org,
       prasad@linux.vnet.ibm.com
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
In-Reply-To: <op.ubvmdr1i03j166@prasadkr_t60p.in.ibm.com>
References: <op.ua9axd2a03j166@prasadkr_t60p.in.ibm.com> <op.ua9a1r0y03j166@prasadkr_t60p.in.ibm.com> <op.ua90vfwv03j166@prasadkr_t60p.in.ibm.com> <20080519162149.50f58b80.akpm@linux-foundation.org> <op.ubgxivbq03j166@prasadkr_t60p.in.ibm.com> <20080520131225.46175b3b.akpm@linux-foundation.org> <op.ubla5cik03j166@prasadkr_t60p.in.ibm.com> <op.ubvmdr1i03j166@prasadkr_t60p.in.ibm.com>
Content-Transfer-Encoding: 8BIT
Date: Thu, 29 May 2008 00:07:07 +0530
Message-ID: <op.ubvnb50b03j166@prasadkr_t60p.in.ibm.com>
User-Agent: Opera Mail/9.26 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the "trace" documentation with that of "relay" as a
part of renaming/merging "trace" with "relay. It also renames the
functions wherever required.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
  Documentation/filesystems/relay.txt |  215 ++++++++++++++++++++++++++++++++++++
  Documentation/trace.txt             |  210 -----------------------------------
  2 files changed, 215 insertions(+), 210 deletions(-)

Index: linux-relay_NEW-2.6.25-mm1/Documentation/filesystems/relay.txt
===================================================================
--- linux-relay_NEW-2.6.25-mm1.orig/Documentation/filesystems/relay.txt
+++ linux-relay_NEW-2.6.25-mm1/Documentation/filesystems/relay.txt
@@ -470,6 +470,213 @@ unmapped.  The client can use this notif
  within the kernel application, such as enabling/disabling logging to
  the channel.

+Enhanced Relay interface using debugfs -- Relay debugfs
+========================================================
+Relay debugfs Setup and Control
+================================
+In the kernel, the 'relay debugfs' interface provides a simple mechanism for
+starting and managing data channels (relays) to user space.  The
+'relay debugfs' interface builds on the relay interface.  For a complete
+description of the relay interface, please see:
+Documentation/filesystems/relay.txt.
+
+The 'relay debugfs' interface provides a single layer in a complete tracing
+application.  'relay debugfs' provides a kernel API that can be used for the
+setup and control of tracing channels.  User of 'relay debugfs' must provide a
+data layer responsible for formatting and writing data into the 'relay debugfs'
+channels.
+
+A layered approach to tracing
+=============================
+A complete kernel tracing application consists of a data provider and
+a data consumer.  Both provider and consumer contain three layers; each
+layer works in tandem with the corresponding layer in the opposite side.
+The layers are represented in the following diagram.
+
+Provider Data layer
+	Formats raw data and provides data-related service.
+	For example, adding timestamps used by consumer to sort data.
+
+Provider Control layer
+	Provided by the 'relay debugfs' interface, this layer creates 'relay
+	debugfs' channels and informs the data layer and consumer of the current
+	state of the 'relay debugfs' channels.
+
+Provider Buffering layer
+	Provided by relay. This layer buffers data in the
+	kernel for consumption by the consumer's buffer
+	layer.
+
+Provider (in-kernel facility)
+-----------------------------------------------------------------------------
+Consumer (user application)
+
+
+Consumer Buffer layer
+	Reads/consumes data from the provider's data buffers.
+
+Consumer Control layer
+	Communicates to the provider's control layer to control the state
+	of the 'relay debugfs' channels.
+
+Consumer Data layer
+	Sorts and formats data as provided by the provider's data layer.
+
+The provider is coded as a kernel facility.  The consumer is coded as
+a user application.
+
+
+'relay debugfs' - Features
+===========================
+'relay debugfs' exploits services and features provided by relay.  These
+features are:
+- The creation and destruction of relay channels.
+- Buffer management.  Overwrite or non-overwrite modes can be selected
+  as well as global or per-CPU buffering.
+
+Overwrite mode can be called "flight recorder mode".  Flight recorder
+mode is selected by setting the TRACE_FLIGHT_CHANNEL flag when
+creating 'relay debugfs' channels.  In flight mode when a tracing buffer is
+full, the oldest records in the buffer will be discarded to make room
+as new records arrive. In the default non-overwrite mode, new records
+may be written only if the buffer has room.  In either case, to
+prevent data loss, a user space reader must keep the buffers
+drained. 'relay debugfs' provides a means to detect the number of records that
+have been dropped due to a buffer-full condition (non-overwrite mode
+only).
+
+When per-CPU buffers are used, relay creates one debugfs file for each
+running CPU.  The user-space consumer of the data is responsible for
+reading the per-CPU buffers and collating the records presumably using
+a time stamp or sequence number included in the 'relay debugfs' records.  The
+use of global buffers eliminates this extra work of sequencing
+records; however the provider's data layer must hold a lock when
+writing records.  The lock prevents writers running on different CPUs
+from overwriting each other's data.  However, buffering may be slower
+because writes to the buffer are serialized. Global buffering is
+selected by setting the TRACE_GLOBAL_CHANNEL flag when creating 'relay debugfs'
+channels.
+
+'relay debugfs' User Interface
+==============================
+When a 'relay debugfs' channel is created and started, the following
+directories and files are created in the root of the mounted debugfs.
+
+/debug (root of the debugfs)
+	/<relay_debugfs-root-dir>
+		/<relay_debugfs-name>
+			relay[0...N-1]     Per-CPU 'relay debugfs' data, one
+					   file per CPU.
+
+			state		   Start or stop tracing by
+					   by writing the strings
+					   "start" or "stop" to this
+					   file. Read the file to get the
+					   current state.
+
+			dropped		   The number of records dropped
+					   due to a full-buffer condition,
+					   for non-TRACE_FLIGHT_CHANNELs
+					   only.
+
+			rewind		   Trigger a rewind by writing
+					   to this file.  i.e. start
+					   next read at the beginning
+					   again. Only available for
+					   TRACE_FLIGHT_CHANNELS.
+
+
+			nr_sub		   Number of sub-buffers
+					   in the channel.
+
+			sub_size	   Size of sub-buffers in
+					   the channel.
+
+'relay debugfs' data is gathered from the 'relay debugfs'[0...N-1] files using
+one of the available interfaces provided by relay.
+
+When using the read(2) interface, as data is read it is marked as
+consumed by the relay subsystem.  Therefore, subsequent reads will
+only return unconsumed data.
+
+'relay debugfs' Kernel API
+==========================
+An overview of the 'relay debugfs' Kernel API is now given. More details of the
+API can be found in linux/trace.h.
+
+The steps a kernel data provider takes to utilize the 'relay debugfs' interface
+are:
+1) Set up a 'relay debugfs' channel - relay_setup()
+2) Start the 'relay debugfs' channel - relay_start()
+3) Write one or more 'relay debugfs' records into the channel (using the relay
+   API).
+
+   Important: When writing a 'relay debugfs' record the provider must insure
+   that preemption is disabled and that 'relay debugfs' state is  set to
+   "running". A typical function used to write records into a 'relay debugfs'
+   channel should follow the following semantics:
+
+	rcu_read_lock();	    // disables preemption
+	if (relay_running(relay)){
+		relay_write(....); // use any available relay data
+				   // function
+	}
+	rcu_read_unlock();	   // enables preemption
+
+4) Stop and start tracing as desired - relay_start()/relay_stop()
+5) Destroy the 'relay debugfs' channel and underlying relay channel -
+   relay_cleanup().
+
+Kernel Configuration
+--------------------
+To use 'relay debugfs', configure your kernel with CONFIG_TRACE=y.
+'relay debugfs' depends on both CONFIG_RELAY and CONFIG_DEBUG_FS, these will be
+automatically configured when CONFIG_TRACE is selected (if not already
+configured).
+
+Using the User Interface
+------------------------
+Reading 'relay debugfs' data and controlling the 'relay debugfs' can be done
+using commands such as cat, echo and sort.  However, If you are logging binary
+'relay debugfs' data a custom application may be required to read and process
+the 'relay debugfs' data. This section shows several examples of reading
+'relay debugfs' data and controling the 'relay debugfs'.  All examples assume
+that the relay_debugfs directory is your current working directory.
+
+Viewing the current 'relay debugfs' state:
+$cat state
+
+Turning the 'relay debugfs' on and off:
+$echo start > state
+$echo stop > state
+
+Reading data when using global buffers (USE_GLOBAL_BUFFERS):
+$echo stop > state
+$cat  relay0
+$echo start > state
+
+Reading data when using per-cpu buffers:
+When using per-cpu buffers the user should add a time stamp or sequence
+number to each 'relay debugfs' records.  This is used by the consumer to sort
+the 'relay debugfs' records into chronological order.  In the following example
+the user has placed a time stamp at the front of each the record.  The format of
+a record is now shown.
+
+:<time stamp>:<field 1>:<field 2>:..........
+
+Collect the data from the per-cpu 'relay debugfs' buffers, sorting
+chronologically:
+$sort --field-separator=: --key=2.1 relay*
+
+Verify that no data was lost by examining the dropped file:
+$ cat  dropped
+
+To collect a larger amount of data the 'relay debugfs' buffers can be read
+continuously using something like:
+
+while [ 1 ] ; do
+	sort --field-separator=: --key=2.1   relay*
+done

  Resources
  =========
@@ -493,3 +700,11 @@ Tom Zanussi		<zanussi@us.ibm.com>

  Also thanks to Hubertus Franke for a lot of useful suggestions and bug
  reports.
+
+'relay debugfs' is adapted from blktrace authored by Jens Axboe
+(axboe@kernel.dk).
+
+Major contributions were made by:
+Tom Zanussi <zanussi@us.ibm.com>
+Martin Hunt <hunt@redhat.com>
+David Wilder <dwilder@us.ibm.com>
Index: linux-relay_NEW-2.6.25-mm1/Documentation/trace.txt
===================================================================
--- linux-relay_NEW-2.6.25-mm1.orig/Documentation/trace.txt
+++ /dev/null
@@ -1,210 +0,0 @@
-Trace Setup and Control
-=======================
-In the kernel, the trace interface provides a simple mechanism for
-starting and managing data channels (traces) to user space.  The
-trace interface builds on the relay interface.  For a complete
-description of the relay interface, please see:
-Documentation/filesystems/relay.txt.
-
-The trace interface provides a single layer in a complete tracing
-application.  Trace provides a kernel API that can be used for the setup
-and control of tracing channels.  User of trace must provide a data layer
-responsible for formatting and writing data into the trace channels.
-
-A layered approach to tracing
-=============================
-A complete kernel tracing application consists of a data provider and
-a data consumer.  Both provider and consumer contain three layers; each
-layer works in tandem with the corresponding layer in the opposite side.
-The layers are represented in the following diagram.
-
-Provider Data layer
-	Formats raw trace data and provides data-related service.
-	For example, adding timestamps used by consumer to sort data.
-
-Provider Control layer
-	Provided by the trace interface, this layer creates trace channels
-	and informs the data layer and consumer of the current state
-	of the trace channels.
-
-Provider Buffering layer
-	Provided by relay. This layer buffers data in the
-	kernel for consumption by the consumer's buffer
-	layer.
-
-Provider (in-kernel facility)
------------------------------------------------------------------------------
-Consumer (user application)
-
-
-Consumer Buffer layer
-	Reads/consumes data from the provider's data buffers.
-
-Consumer Control layer
-	Communicates to the provider's control layer to control the state
-	of the trace channels.
-
-Consumer Data layer
-	Sorts and formats data as provided by the provider's data layer.
-
-The provider is coded as a kernel facility.  The consumer is coded as
-a user application.
-
-
-Trace - Features
-================
-Trace exploits services and features provided by relay.  These features
-are:
-- The creation and destruction of relay channels.
-- Buffer management.  Overwrite or non-overwrite modes can be selected
-  as well as global or per-CPU buffering.
-
-Overwrite mode can be called "flight recorder mode".  Flight recorder
-mode is selected by setting the TRACE_FLIGHT_CHANNEL flag when
-creating trace channels.  In flight mode when a tracing buffer is
-full, the oldest records in the buffer will be discarded to make room
-as new records arrive. In the default non-overwrite mode, new records
-may be written only if the buffer has room.  In either case, to
-prevent data loss, a user space reader must keep the buffers
-drained. Trace provides a means to detect the number of records that
-have been dropped due to a buffer-full condition (non-overwrite mode
-only).
-
-When per-CPU buffers are used, relay creates one debugfs file for each
-running CPU.  The user-space consumer of the data is responsible for
-reading the per-CPU buffers and collating the records presumably using
-a time stamp or sequence number included in the trace records.  The
-use of global buffers eliminates this extra work of sequencing
-records; however the provider's data layer must hold a lock when
-writing records.  The lock prevents writers running on different CPUs
-from overwriting each other's data.  However, buffering may be slower
-because writes to the buffer are serialized. Global buffering is
-selected by setting the TRACE_GLOBAL_CHANNEL flag when creating trace
-channels.
-
-Trace User Interface
-===================
-When a trace channel is created and started, the following
-directories and files are created in the root of the mounted debugfs.
-
-/debug (root of the debugfs)
-	/<trace-root-dir>
-		/<trace-name>
-			trace[0...N-1]     Per-CPU trace data, one
-					   file per CPU.
-
-			state		   Start or stop tracing by
-					   by writing the strings
-					   "start" or "stop" to this
-					   file. Read the file to get the
-					   current state.
-
-			dropped		   The number of records dropped
-					   due to a full-buffer condition,
-					   for non-TRACE_FLIGHT_CHANNELs
-					   only.
-
-			rewind		   Trigger a rewind by writing
-					   to this file.  i.e. start
-					   next read at the beginning
-					   again. Only available for
-					   TRACE_FLIGHT_CHANNELS.
-
-
-			nr_sub		   Number of sub-buffers
-					   in the channel.
-
-			sub_size	   Size of sub-buffers in
-					   the channel.
-
-Trace data is gathered from the trace[0...N-1] files using one of the
-available interfaces provided by relay.
-
-When using the read(2) interface, as data is read it is marked as
-consumed by the relay subsystem.  Therefore, subsequent reads will
-only return unconsumed data.
-
-Trace Kernel API
-===============
-An overview of the trace Kernel API is now given. More details of the
-API can be found in linux/trace.h.
-
-The steps a kernel data provider takes to utilize the trace interface are:
-1) Set up a trace channel - trace_setup()
-2) Start the trace channel - trace_start()
-3) Write one or more trace records into the channel (using the relay API).
-
-   Important: When writing a trace record the provider must insure that
-   preemption is disabled and that trace state is  set to "running". A
-   typical function used to write records into a trace channel should
-   follow the following semantics:
-
-	rcu_read_lock();	    // disables preemption
-	if (trace_running(trace)){
-		relay_write(....); // use any available relay data
-				   // function
-	}
-	rcu_read_unlock();	   // enables preemption
-
-4) Stop and start tracing as desired - trace_start()/trace_stop()
-5) Destroy the trace channel and underlying relay channel -
-   trace_cleanup().
-
-Kernel Configuration
---------------------
-To use trace, configure your kernel with CONFIG_TRACE=y. Trace depends on
-both CONFIG_RELAY and CONFIG_DEBUG_FS, these will be automatically configured
-when CONFIG_TRACE is selected (if not already configured).
-
-Using the User Interface
-------------------------
-Reading trace data and controlling the trace can be done using commands such
-as cat, echo and sort.  However, If you are logging binary trace data a
-custom application may be required to read and process the trace data.
-This section shows several examples of reading trace data and controling
-the trace.  All examples assume that the "trace" directory is your current
-working directory.
-
-Viewing the current trace state:
-$cat state
-
-Turning the trace on and off:
-$echo start > state
-$echo stop > state
-
-Reading data when using global buffers (USE_GLOBAL_BUFFERS):
-$echo stop > state
-$cat  trace0
-$echo start > state
-
-Reading data when using per-cpu buffers:
-When using per-cpu buffers the tracer should add a time stamp or sequence
-number to each trace records.  This is used by the consumer to sort the trace
-records into chronological order.  In the following example the tracer has
-placed a time stamp at the front of each the record.  The format of a record
-is now shown.
-
-:<time stamp>:<field 1>:<field 2>:..........
-
-Collect the data from the per-cpu trace buffers, sorting chronologically:
-$sort --field-separator=: --key=2.1 trace*
-
-Verify that no data was lost by examining the dropped file:
-$ cat  dropped
-
-To collect a larger amount of data the trace buffers can be read
-continuously using something like:
-
-while [ 1 ] ; do
-	sort --field-separator=: --key=2.1   trace*
-done
-
-
-Credits
-=======
-Trace is adapted from blktrace authored by Jens Axboe (axboe@kernel.dk).
-
-Major contributions were made by:
-Tom Zanussi <zanussi@us.ibm.com>
-Martin Hunt <hunt@redhat.com>
-David Wilder <dwilder@us.ibm.com>
