Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbYBRInR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbYBRInR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbYBRInD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:43:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:42074 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbYBRInB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:43:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,370,1199692800"; 
   d="scan'208";a="520345254"
Date: Mon, 18 Feb 2008 09:42:42 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, eranian@googlemail.com
Subject: [patch 2/2] x86, ptrace, man: corresponding man pages
Message-ID: <20080218094242.A27736@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Man pages describing the user API of the ptrace BTS extensions.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: man/man2/ptrace.2
===================================================================
--- man.orig/man2/ptrace.2	2008-02-13 09:35:47.%N +0100
+++ man/man2/ptrace.2	2008-02-13 09:41:31.%N +0100
@@ -40,6 +40,9 @@
 .\"        PTRACE_SETSIGINFO, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP
 .\"    (Thanks to Blaisorblade, Daniel Jacobowitz and others who helped.)
 .\"
+.\" Modified Feb 2008, Markus Metzger <markus.t.metzger@intel.com>
+.\"     Added PTRACE_BTS_* commands
+.\"
 .TH PTRACE 2 2007-11-15 "Linux" "Linux Programmer's Manual"
 .SH NAME
 ptrace \- process trace
@@ -378,6 +381,135 @@
 detached in this way regardless of which method was used to initiate
 tracing.
 (\fIaddr\fP is ignored.)
+.LP
+The following ptrace commands provide access to the hardware's last
+branch recording. They may not be available on all architectures.
+.LP
+Last branch recording stores an execution trace of the traced
+process. For every (conditional) control flow change, the source and
+destination address are stored. On some architectures, control flow
+changes inside the kernel are recorded, as well. On later
+architectures, these are automatically filtered out.
+.LP
+The buffer (called Branch Trace Store) can be configured to be either
+circular, or to send a signal to the traced task when it is about to
+overflow. Not all methods may be available on all architectures.
+.LP
+The buffer can be accessed in two ways matching the above
+configurations: either as an array of BTS records from newest
+record to older records, one record at a time; or all records at once,
+from oldest to newest.
+.LP
+The former is mostly used for circular buffers to capture a tail of
+the execution trace (e.g. for debugging); the latter is mostly used to
+collect a continuous trace (e.g. for profiling) where the user drains
+the hardware buffer into a larger private buffer or into a file.
+.LP
+In addition to branches, timestamps (in jiffies) may optionally be
+recorded when the traced process arrives and departs,
+respectively. This information can be used to obtain a qualitative
+execution order, if more than one process is traced.
+.LP
+A BTS record is defined as:
+.LP
+.nf
+enum ptrace_bts_qualifier {
+	PTRACE_BTS_INVALID = 0,
+	PTRACE_BTS_BRANCH,
+	PTRACE_BTS_TASK_ARRIVES,
+	PTRACE_BTS_TASK_DEPARTS
+};
+.sp
+struct ptrace_bts_record {
+	u64 qualifier;
+	union {
+		/* PTRACE_BTS_BRANCH */
+		struct {
+			u64 from_ip;
+			u64 to_ip;
+		} lbr;
+		/* PTRACE_BTS_TASK_ARRIVES or
+		   PTRACE_BTS_TASK_DEPARTS */
+		u64 timestamp;
+	} variant;
+};
+.fi
+.LP
+For configuring last branch recording and for querying its status, the
+following struct is used:
+.LP
+.nf
+struct ptrace_bts_config {
+	u32 size;
+	u32 flags;
+	u32 signal;
+	u32 bts_size;
+};
+.fi
+.LP
+\fISize\fP is either the requested or the actual size of the kernel
+BTS buffer in bytes.
+\fIFlags\fP is a bitmask of options, which are specified by the
+following flags:
+.RS
+.TP
+.BR PTRACE_BTS_O_TRACE
+Collect branch trace records.
+.TP
+.BR PTRACE_BTS_O_SCHED
+Collect scheduling timing information.
+.TP
+.BR PTRACE_BTS_O_SIGNAL
+Send \fIsignal\fP to the traced task in case of a buffer overflow. May
+only be used together with PTRACE_BTS_O_ALLOC for configuration purposes.
+.TP
+.BR PTRACE_BTS_O_ALLOC
+Allocate a BTS buffer of size \fIsize\fP. Frees any previously
+allocated buffer for the same task.
+.RE
+\fISignal\fP is the signal to send to the traced task in case of a
+buffer overflow.
+\fIBts_size\fP is the actual size of the \fIptrace_bts_record\fP
+structure in bytes. It is ignored for configuration purposes.
+.TP
+.BR PTRACE_BTS_CONFIG
+Configure last branch recording. \fIaddr\fP points to a
+\fIptrace_bts_config\fP structure (see above); \fIdata\fP specifies
+the size of that structure.
+Returns the number of bytes read.
+.TP
+.BR PTRACE_BTS_STATUS
+Writes the actual configuration into a \fIptrace_bts_config\fP
+structure pointed to by \fIaddr\fP. The caller is responsible for
+allocating memory at \fIaddr\fP to hold a \fIptrace_bts_config\fP
+structure. \fIData\fP specifies the size of that structure.
+Returns the number of bytes written.
+.TP
+.BR PTRACE_BTS_SIZE
+Returns the number of BTS records available for draining. For a
+circular buffer, this number is meaningless.
+(\fIaddr\fP and \fIdata\fP are ignored.)
+.TP
+.BR PTRACE_BTS_GET
+Reads a single BTS record at index \fIdata\fP into \fIaddr\fP. The
+caller is responsible for allocating memory at \fIaddr\fP to hold one
+\fIptrace_bts_record\fP structure.
+The bigger the index, the older the record; the latest record can
+always be found at index 0.
+Returns the number of bytes written.
+.TP
+.BR PTRACE_BTS_CLEAR
+Clears the BTS buffer. This command can be used after a manual
+draining using PTRACE_BTS_GET commands.
+(\fIaddr\fP and \fIdata\fP are ignored.)
+.TP
+.BR PTRACE_BTS_DRAIN
+Reads all available BTS records into the buffer pointed to by
+\fIaddr\fP and clears the buffer. Records are read from oldest to
+newest. Returns the number of BTS records drained. The caller
+is responsible for allocating enough memory to hold an array of
+PTRACE_BTS_SIZE \fIptrace_bts_record\fP structures. \fIData\fP
+specifies the size of that buffer.
 .SH "RETURN VALUE"
 On success,
 .B PTRACE_PEEK*
@@ -432,6 +564,16 @@
 .B ESRCH
 The specified process does not exist, or is not currently being traced
 by the caller, or is not stopped (for requests that require that).
+.TP
+.B EOPNOTSUPP
+The operation is not supported on this architecture.
+.TP
+.B ENOMEM
+Not enough memory to allocate the BTS buffer.
+.TP
+.B ENXIO
+An attempt to access BTS information has been made without allocating
+a BTS buffer first.
 .SH "CONFORMING TO"
 SVr4, 4.3BSD
 .SH NOTES
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

