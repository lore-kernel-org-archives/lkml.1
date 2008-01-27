Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYA0Rzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYA0Rzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYA0Rzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:55:39 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:45865 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYA0Rzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:55:38 -0500
Date: Sun, 27 Jan 2008 19:55:36 +0200
From: Pekka Paalanen <pq@iki.fi>
To: mingo@redhat.com
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] x86: mmiotrace - trace memory mapped IO
Message-ID: <20080127195536.50809974@daedalus.pq.iki.fi>
In-Reply-To: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the patch itself is slightly bigger than recommended for LKML, so
it is available at:
http://jumi.lut.fi/~paalanen/scratch/mmio24/0002-x86-mmiotrace-trace-memory-mapped-IO.patch.txt

This seems to work fine on UP machine, I have not tested yet with
with an SMP machine. Originally mmio-trace was UP-only, so there
probably still are SMP issues. Mmio-trace has existed with its current
purpose for about a year now.

The following is a copy of the patch description:

Mmiotrace is a tool for trapping memory mapped IO (MMIO) accesses within
the kernel. It is used for debugging and especially for reverse
engineering evil binary drivers.

Mmiotrace works by wrapping the ioremap family of kernel functions and
marking the returned pages as not present. Access to the IO memory
triggers a page fault, which will be handled by mmiotrace's custom page
fault handler. This will single-step the faulted instruction with the
MMIO page marked as present. Access logs are directed to user space via
relay and debug_fs.

This page fault approach is necessary, because binary drivers have
readl/writel etc. calls inlined and therefore extremely difficult to
trap with with e.g. kprobes.

This patch depends on the custom page fault handlers patch.

---

More information on mmio-trace can be found at
http://nouveau.freedesktop.org/wiki/MmioTrace
and the out-of-three module with user space parts is at
http://gitweb.freedesktop.org/?p=users/pq/mmio-trace.git;a=summary

The out-of-tree git does not include all changes I made for the
in-tree version.

Mmiotrace does not appear to procude excruciating slowness when used.
Starting X with traced nvidia binary drivers takes a couple of seconds
longer than normally. Starting X, running glxgears for a moment and
shutting down X results in an mmio-trace log of roughly 1.5 million
events. Replace glxgears by running Quake3-demo's first demo play
twice and end up with 3.5 million events. Quake3-demo framerate with
mmio-traced driver goes down to 59 fps, compared to the normal 83 fps.

I know of one bad failure case with mmio-trace. It may trigger a
complete system freeze when tracing a certain nvidia driver version
on a machine with an 8000-series (nv50) graphics chip. Netconsole,
serial console and NMI watchdog have so far been useless, and I
am starting to believe that it is the nvidia driver that does
something bad to make mmio-trace fall over. I have heard that more
recent nvidia drivers do not make it crash anymore.

I'm hoping mmiotrace could be included in 2.6.25. It would help
FOSS driver projects (Nouveau, maybe madwifi, too) to gather the
information they need. Very often the information comes from
ordinary users, for whom going through kernel patching would be
a major struggle.


Thanks,
Pekka
