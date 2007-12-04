Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbXLDSD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbXLDSD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXLDSDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:03:21 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:26296 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbXLDSDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:03:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Lg9Ei3FWLjqta+yYmU1DbUyvlPSRIjtk+X0yT6mD3x5h/Fszvoq8XBe21ggMsZllGvxS9HsnGQMZkXvlALFqPIUYEo/xX9fmD3J6nekQ0Ygpp3EoKCPZhs7AEHQM9twuENQ7qNkK5kjY7k2QrzaPd/zhVbTUhVfL3NvlgvJD0dY=
Message-ID: <a430082a0712041003v676c14b7ma6351af57a1d9bf2@mail.gmail.com>
Date: Tue, 4 Dec 2007 19:03:19 +0100
From: "Markus Metzger" <markus.t.metzger@googlemail.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Cc: akpm@linux-foundation.org, markus.t.metzger@googlemail.com,
       markus.t.metzger@intel.com, mtk.manpages@gmail.com, roland@redhat.com,
       suresh.b.siddha@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for Intel's last branch recording to ptrace. This gives debuggers
access to this hardware feature and allows them to show an execution trace
of the debugged application.

Last branch recording (see section 18.5 in the Intel 64 and IA-32
Architectures Software Developer's Manual) allows taking an execution
trace of the running application without instrumentation. When a branch
is executed, the hardware logs the source and destination address in a
cyclic buffer given to it by the OS.

This can be a great debugging aid. It shows you how exactly you got
where you currently are without requiring you to do lots of single
stepping and rerunning.

This patch manages the various buffers, configures the trace
hardware, disentangles the trace, and provides a user interface via
ptrace. On the high-level design:
- there is one optional trace buffer per thread_struct
- upon a context switch, the trace hardware is reconfigured to either
  disable tracing or to use the appropriate buffer for the new task.
  - tracing induces ~20% overhead as branch records are sent out on
    the bus.
  - the hardware collects trace per processor. To disentangle the
    traces for different tasks, we use separate buffers and reconfigure
    the trace hardware.
- the low-level data layout is configured at cpu initialization time
  - different processors use different branch record formats
- the implementation is done in two layers
  - the lower layer implements the DS/BTS access
  - the higher layer implements a ptrace interface

Per-CPU tracing can be implemented on top of the lower layer.
A per-cpu array of DS pointers needs to be ds_allocate()'d and the
MSR_IA32_DS_AREA and MSR_IA32_DEBUGCTLMSR MSR's need to be properly
configured. Care needs to be taken to not interfere with the ptrace
use of the above MSR's.


patch 1/2 contains the kernel changes
patch 2/2 contains changes to the ptrace man pages


regards,
markus.
