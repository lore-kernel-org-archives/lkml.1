Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZA0XKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZA0XKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZA0XKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:10:43 -0500
Received: from ns.skekraft.net ([213.199.96.131]:54875 "EHLO mail.skekraft.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZA0XKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:10:42 -0500
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Robert Love <rml@tech9.net>
Subject: PROBLEM: in_atomic() misuse all over the place
Cc: Pavel Machek <pavel@ucw.cz>
Content-Disposition: inline
From: Roger Larsson <roger.larsson@e-gatan.se>
Date: Wed, 28 Jan 2009 00:10:37 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200901280010.37633.roger.larsson@e-gatan.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resent, non html)

[1.] One line summary of the problem:    
in_atomic() is used to select path of execution, most likely to suppress 
warning logs when running a preemptive kernel.

[2.] Full description of the problem/report:

The problem is that in_atomic() only works on preemptive kernels...

Result: preemptive kernel warns about a potential deadlock in all kernels,
developer silence with the help of in_atomic()
bug remains in SMP/UP kernels...

[3.] Keywords (i.e., modules, networking, kernel):
in_atomic(), preemptive, sleeping

[4.] Kernel version (from /proc/version):
	2.6.28.2 (review)

[5.] Output of Oops..

"sleeping function called from invalid context"

[6.] A small shell script or example program which triggers the
     problem (if possible)

Small example of the strange code I found is this

file:  include/net/sock.h

   static inline gfp_t gfp_any(void)
   {
     return in_atomic() ? GFP_ATOMIC : GFP_KERNEL;
   }

	//  I can find no comment on why this strange code would be OK.
	//  An it is in its turn used in several drivers...

If the processor can get to this function while atomic in a preemptive kernel 
it will likely be able to get there in other kernels as well, especially SMP.

It returns GFP_ATOMIC when being atomic in a preemptive kernel, allocating 
with that flag will not sleep. But calling this with another kernel will 
ALWAYS return GFP_KERNEL, and it may cause a sleeping allocate...

Other places that I think misuse of in_atomic is Arch code, USB code, ...

There are 77 uses of in_atomic directly (grep | wc)
36 in ./arch
23 in ./drivers
2 in ./sound/core/seq/seq_virmidi.c
1 in ./include/net/sock.h
The remaining 15 are probably OK (kernel, mm/filemap)

But the sock.h gfp_any() spreads further...
1 in ./Documentation
2 in ./drivers
9 in ./net


Suggestion: should in_atomic() that by default return the safer 1 instead of 
the unsafe 0. And add an in_atomic_warn() with default of 0 to use where it is
OK - like when deciding to log a warning.

/RogerL

