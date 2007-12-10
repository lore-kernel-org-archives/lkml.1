Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbXLJLxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbXLJLxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXLJLxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:53:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:12164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXLJLxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:53:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,276,1194249600"; 
   d="scan'208";a="240014403"
Date: Mon, 10 Dec 2007 12:51:52 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 4/4] man: updated man pages
Message-ID: <20071210125152.A15109@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update ptrace man pages to reflect the interface changes from the last two patches in the series.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: man/man2/ptrace.2
===================================================================
--- man.orig/man2/ptrace.2	2007-12-10 11:22:19.%N +0100
+++ man/man2/ptrace.2	2007-12-10 11:28:56.%N +0100
@@ -40,6 +40,9 @@
 .\"        PTRACE_SETSIGINFO, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP
 .\"    (Thanks to Blaisorblade, Daniel Jacobowitz and others who helped.)
 .\"
+.\" Modified Nov 2007, Markus Metzger <markus.t.metzger@intel.com>
+.\"     Added PTRACE_BTS_* commands
+.\"
 .TH PTRACE 2 2007-11-15 "Linux" "Linux Programmer's Manual"
 .SH NAME
 ptrace \- process trace
@@ -378,6 +381,94 @@
 detached in this way regardless of which method was used to initiate
 tracing.
 (\fIaddr\fP is ignored.)
+.LP
+The following ptrace commands provide access to the hardware's last
+branch recording. They may not be available on all architectures.
+.LP
+Last branch recording stores an execution trace of the traced process
+in a circular buffer (called Branch Trace Store). For every
+(conditional) control flow change, the source and destination address
+are stored. On some architectures, control flow changes inside the
+kernel may be recorded, as well. On later architectures, these are
+automatically filtered out.
+.LP
+The buffer can be accessed as an array of BTS records from newest
+record to older records. 
+.LP
+In addition to branches, timestamps (in jiffies) may optionally be
+recorded when the traced process arrives and departs,
+respectively. This information can be used to obtain a qualitative
+execution order, if more than one process is traced.
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
+	enum ptrace_bts_qualifier qualifier;
+	union {
+		/* PTRACE_BTS_BRANCH */
+		struct {
+			void *from_ip;
+			void *to_ip;
+		} lbr;
+		/* PTRACE_BTS_TASK_ARRIVES or
+		   PTRACE_BTS_TASK_DEPARTS */
+		unsigned long timestamp;
+	} variant;
+};
+.fi
+.LP
+.TP
+PTRACE_BTS_MAX_BUFFER_SIZE
+Returns the maximal BTS buffer size.
+.TP
+PTRACE_BTS_ALLOCATE_BUFFER
+Allocate a new BTS buffer big enough to hold \fIdata\fP \fBstruct
+ptrace_bts_record\fP entries.
+\fIData\fP must be in the range of 0..PTRACE_BTS_MAX_BUFFER_SIZE.
+If a buffer is already allocated, that buffer is freed after the new
+buffer was successfully allocated. The new buffer initially contains
+invalid entries.
+Typically, a buffer is allocated once when tracing starts. It is
+automatically deallocated when the parent detaches from the child.
+(\fIaddr\fP is ignored.)
+.TP
+PTRACE_BTS_GET_BUFFER_SIZE
+Returns the actual BTS buffer size in number of BTS records. The
+command fails, if no buffer has been allocated.
+(\fIaddr\fP and \fIdata\fP are ignored.)
+.TP
+PTRACE_BTS_READ_RECORD
+Reads the BTS record at index \fIdata\fP into \fIaddr\fP. The caller
+is responsible for allocating memory at \fIaddr\fP of at least
+\fB sizeof(struct ptrace_bts_record)\fP bytes. The index \fIdata\fP
+must be in the range 0..PTRACE_BTS_GET_BUFFER_SIZE - 1. The bigger the
+index, the older the record; the latest record can always be found at
+index 0.
+.TP
+PTRACE_BTS_CONFIG
+Configures last branch recording from \fIdata\fP in the parent.
+(\fIaddr\fP is ignored.)
+\fIdata\fP is interpreted
+as a bitmask of options, which are specified by the following flags:
+.RS
+.TP
+PTRACE_BTS_O_TRACE_TASK
+Record last branch records for control flow changes.
+.TP
+PTRACE_BTS_O_TIMESTAMPS
+Record timestamps when child arrives and departs, respectively.
+.RE
+.TP
+PTRACE_BTS_STATUS
+Returns the current BTS configuration as a bitmask of the above
+options.
+(\fIaddr\fP and \fIdata\fP are ignored.)
 .SH "RETURN VALUE"
 On success,
 .B PTRACE_PEEK*
@@ -432,6 +523,16 @@
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
