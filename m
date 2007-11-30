Return-Path: <linux-kernel-owner+w=401wt.eu-S935322AbXK3P5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935322AbXK3P5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 10:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXK3P4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 10:56:54 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:41537 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbXK3P4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 10:56:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c25iCy8kSGk0Iq15EahnUYxx3D3zHuoDzGcuWJf6rCFL2FwSWFDK3vKjew2lcR0Rdh4MVTK7gSmNgTqPf4CVLxDr/b1UbEMskjgBxBGdDhDrcSCdkCKRHwDIrgWk2ogGE/72xzMcv+R/q7xpyxyZhIqBiUk69mtxZy+vi32SWVA=
Message-ID: <a430082a0711300756s4a8f9d7cr5f495f5ed5559416@mail.gmail.com>
Date: Fri, 30 Nov 2007 16:56:52 +0100
From: "Markus Metzger" <markus.t.metzger@googlemail.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Cc: akpm@linux-foundation.org, markus.t.metzger@googlemail.com,
       markus.t.metzger@intel.com, mtk-manpages@gmx.net,
       suresh.b.siddha@intel.com, roland@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
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

Opens:
- kernel interface

patch 1/2 contains the kernel changes
patch 2/2 contains changes to the ptrace man pages


regards,
markus.
