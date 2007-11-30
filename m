Return-Path: <linux-kernel-owner+w=401wt.eu-S1763584AbXK3LAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763584AbXK3LAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760206AbXK3LAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:00:32 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:5085 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbXK3LAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RutN32BBYfIPaPV9F9S7uU8lloYSs/UfOasUC5h3lnPooVFyid4n4IHNNr+MFUoohjxqkWQqKVjXhoLGzFXKKrqNU05LV9/LEC7xBhO/FivE29vH2iOU2zGQvZQT41WD7e3d3URdjC0BJDh0UQ2DMeZfGTs9HNFJNR0lFdkDuig=
Message-ID: <a430082a0711300300s4880a104q80567fab4ba92a4c@mail.gmail.com>
Date: Fri, 30 Nov 2007 12:00:30 +0100
From: "Markus Metzger" <markus.t.metzger@googlemail.com>
To: mingo@elte.hu
Subject: [patch 2/2] man: man pages for ptrace BTS extensions
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       ak@suse.de, markus.t.metzger@intel.com, suresh.b.siddha@intel.com,
       mtk-manpages@gmx.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

resend using a different mailer


Describe extensions to ptrace interface for branch trace store

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: man/man2/ptrace.2
===================================================================
--- man.orig/man2/ptrace.2	2007-11-22 20:25:21.%N +0100
+++ man/man2/ptrace.2	2007-11-22 20:25:33.%N +0100
@@ -40,7 +40,10 @@
 .\"        PTRACE_SETSIGINFO, PTRACE_SYSEMU, PTRACE_SYSEMU_SINGLESTEP
 .\"    (Thanks to Blaisorblade, Daniel Jacobowitz and others who helped.)
 .\"
-.TH PTRACE 2 2006-03-24 "Linux 2.6.16" "Linux Programmer's Manual"
+.\" Modified Nov 2007, Markus Metzger <markus.t.metzger@intel.com>
+.\"     Added PTRACE_BTS_* commands
+.\"
+.TH PTRACE 2 2007-11 "Linux 2.6.16" "Linux Programmer's Manual"
 .SH NAME
 ptrace \- process trace
 .SH SYNOPSIS
@@ -312,6 +315,96 @@
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
+In addition to branches, timestamps may optionally be recorded when
+the traced process arrives and departs, respectively. This information
+can be used to obtain a qualitative execution order, if more than one
+process is traced.
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
+		unsigned long long timestamp;
+	} variant;
+};
+.fi
+.LP
+.TP
+PTRACE_BTS_MAX_BUFFER
+This is not a ptrace command but a macro that defines the maximal size
+of the BTS buffer in number of BTS records.
+.TP
+PTRACE_BTS_ALLOCATE_BUFFER
+Allocate a new BTS buffer big enough to hold \fIdata\fP \fBstruct
+ptrace_bts_record\fP entries.
+\fIData\fP must be in the range of 0..PTRACE_BTS_MAX_BUFFER.
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
+PTRACE_BTS_GET_INDEX
+Returns the index of the next entry to be (over)written by the tracing
+hardware. This can be used to determine the end of the current
+execution trace.
+(\fIaddr\fP and \fIdata\fP are ignored.)
+.TP
+PTRACE_BTS_READ_RECORD
+Reads the BTS record at index \fIdata\fP into \fIaddr\fP. The caller
+is responsible for allocating memory at \fIaddr\fP of at least
+\fB sizeof(struct ptrace_bts_record)\fP bytes. The index \fIdata\fP
+must be in the range 0..PTRACE_BTS_GET_BUFFER_SIZE - 1.
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
 .SH NOTES
 Although arguments to
 .BR ptrace ()
@@ -409,6 +502,16 @@
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
 .SH "SEE ALSO"
