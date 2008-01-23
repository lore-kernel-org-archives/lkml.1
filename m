Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbYAWQMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbYAWQMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbYAWQJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:09:58 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:41727 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756209AbYAWQJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:09:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAOf1lkdMROHU/2dsb2JhbACBV6xngX8
Date: Wed, 23 Jan 2008 11:04:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Dave Hansen <haveblue@us.ibm.com>, mbligh@google.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [RFC] Userspace tracing memory mappings
Message-ID: <20080123160454.GA15405@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:26:45 up 80 days, 20:32,  6 users,  load average: 0.03, 0.30,
	0.40
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since memory management is not my speciality, I would like to know if
there are some implementation details I should be aware of for my
LTTng userspace tracing buffers. Here is what I want to do :

Upon a new alloc_tracebuf syscall :

- map the ZERO_PAGE in the current process. Reserve enough pages to hold
  16 per cpu trace buffers at the same time. (supports up to 16 active
  traces at the same time). Could be mapped write-only by the traced
  process.
- Also reserve a few ZERO_PAGES for the buffer control
  (current read/write offset...) : mapped RW by the process
- Also need some space for the kernel to export control information.
  This could be pages mapped read-only by the process (seqlock,
  tracing active....)
- When the process tries to write to these pages, allocate physical pages.
- The read-only (as seen by the process) pages should be allocated when
  the kernel has its first trace active. Can be the ZERO_PAGE before
  that.

When the process issues its first buffer switch (that's a second added
syscall) or exits before its first buffer switch, for every active trace
on the system, we create a debugfs file in the trace directory. A
userspace daemon gets inotified of the file creation and maps the
buffers specific to a single trace. (mmap on a file) The daemon already
uses ioctl on the file to get the buffer offset to read. This is the
"disk writer" daemon.

I don't think the kernel really has to map the buffers in its address
space. For kernel crash buffer extraction, I guess we can simply deal
with pages instead of virtual addresses. By doing so, we could extract
the userspace tracing buffers upon kernel crash.

We have to be aware that a new trace can be allocated/activated on the
system while the process is running. Therefore, the kernel and the
process would share a few pages (RW for the kernel, RO for the traced
process) where the trace control information would be held. I would
re-create the trace control information update mechanism I currently
have in LTTng for kernel-only tracing (I use RCU), but, since RCU is not
available in user-space, I would use a write seqlock in the kernel and a
read seqlock in userspace. These pages would therefore have to be mapped
at 3 different locations :

- Buffers
  - traced process (write)
  - disk writing daemon (read-only)
- Buffer control information (buffer read/write offsets)
  - traced process (RW)
  - kernel mapping (RW) (disk writing daemon issues an ioctl for offset
    updates and hence doesn't need to map this information)
- Tracing control information
  - kernel memory (RW)
  - traced process (read-only)

So if we want the tightest control possible, we would have to create 3
different mappings, initially populated with the zero page, populated by
page faults, and shared between two locations each.

Comments/ideas/concerns are welcome.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
