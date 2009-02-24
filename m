Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZBXFQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZBXFQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 00:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZBXFQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 00:16:25 -0500
Received: from mail-ew0-f164.google.com ([209.85.219.164]:62786 "EHLO
	mail-ew0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZBXFQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 00:16:24 -0500
X-Greylist: delayed 129946 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Feb 2009 00:16:23 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=L2/4HhStfhianQB32MefBksdyOGbTLGkHW0OxFhnWhr7UnlemT1SEtVZy0ooshrnPW
         VsuV8vtfYSP3cSeIgcvs9+RRaEXw1XBvS6bGACma0pU1dY+vX7e4B4MwaHyp68Dot1cQ
         LfOiil/8JLEUFkSsLsD7S5Ycxv5iFguyBU+9g=
Date: Tue, 24 Feb 2009 06:16:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/3] tracing/ftrace: ftrace_bprintk
Message-ID: <20090224051618.GA5142@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These three patches are part of a patchset posted by Lai Jiangshan in december 2008.
They introduce a binary version of ftrace_printk() called ftrace_bprintk()

While having the same goal: print a generic message entry into the ring buffer,
their approaches are very different.

- ftrace_printk() does the formatting job on tracing time, insert the whole resulting string
  into the ring buffer, and then the string is printed on output time without a lot of modifications.

- ftrace_bprintk() does no formatting on tracing time. Instead, it looks at the format string
  to find the types and the numbers of the arguments and directly stores them as-is into the
  ring-buffer. Then the format string is stored into the ring-buffer too, but only by its address,
  it is not copied. Then on output time only, the final string is formatted and sent to the user.
  This gives a result about as fast as a traditional tracer with fixed fields types, except that
  we can print random types and numbers of fields here.


The first patch adds the generic support for binary formatting.
The second adds the support for binary print types on ftrace
and the last introduces ftrace_bprintk() which supports safely the modules
by listening on the module loading/unloading notifier to keep track of
unwanted freed format strings.

Lai Jiangshan (3):
      add binary printf
      ftrace: infrastructure for supporting binary record
      ftrace: add ftrace_bprintk()


 include/asm-generic/vmlinux.lds.h |    3 +
 include/linux/ftrace.h            |   25 ++
 include/linux/module.h            |    5 +
 include/linux/string.h            |    7 +
 kernel/module.c                   |    6 +
 kernel/trace/Kconfig              |    6 +
 kernel/trace/Makefile             |    1 +
 kernel/trace/trace.c              |   70 ++++++
 kernel/trace/trace.h              |   12 +
 kernel/trace/trace_bprintk.c      |  217 ++++++++++++++++++
 kernel/trace/trace_output.c       |   76 +++++++
 lib/Kconfig                       |    3 +
 lib/vsprintf.c                    |  442 +++++++++++++++++++++++++++++++++++++


