Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYIIRLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYIIRLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYIIRKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:10:51 -0400
Received: from dakia3.marvell.com ([65.219.4.28]:35493 "EHLO
	dakia3.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYIIRKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:10:50 -0400
X-ASG-Debug-ID: 1220980247-064102690000-xx1T2L
X-Barracuda-URL: http://dakia3.marvell.com:80/cgi-bin/mark.cgi
X-Barracuda-BBL-IP: 10.68.76.198
X-Barracuda-RBL-IP: 10.68.76.198
X-ASG-Orig-Subj: Re: Building Kernel with -O0
Subject: Re: Building Kernel with -O0
From: "Keith A. Prickett" <keithp@marvell.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080909160452.GB30160@cs181140183.pp.htv.fi>
References: <1220550653.15123.6.camel@CV-LAB2>
	 <20080909160452.GB30160@cs181140183.pp.htv.fi>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Sep 2008 10:10:40 -0700
Message-Id: <1220980240.17292.15.camel@CV-LAB2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1220980247
X-Barracuda-Virus-Scanned: by Marvell Mail Gateway at marvell.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 19:04 +0300, Adrian Bunk wrote:
> On Thu, Sep 04, 2008 at 10:50:53AM -0700, Keith A. Prickett wrote:
> >...
> > It seems building with optimization
> > level 0 should be a natural thing for kernel driver developers to do for
> > debugging purposes.
> > 
> > In summary: I want to compile with optimizations off and the compile is
> > failing now when I try this.  How can this be resolved?
> >...
> 
> There are several places in the kernel where we e.g. rely on gcc 
> removing dead code, and otherwise the linking of the kernel fails.
> 
> Compiling with -O0 never worked, and is not likely to ever work.
I am currently running the kernel compiled with -O0.  The final problem
I ran into was some NULL pointer dereference and compiling ONLY files in
the mm directory with -O2 fixed the issue.

To build with -O0 I had to change a few things (for my ARM
architecture):
1. Ensure the __attribute__((always_inline)) was turned off in the
"inline" #define (compiler.h)

2. Fix some inline assembly in kprobes (ARM only) that, due to no
optimization, needed more registers than the compiler had available.
(Similar to this issue:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=13850)

3. Implement a fix as described here:
(http://lists.arm.linux.org.uk/lurker/message/20050201.210458.5cc93c10.en.html)

4. Change -O2 to -O0 in the root Makefile

5. Add extra cflags in the mm Makefile so it builds with -O2 only in
that directory.

All of this could, potentially be changed by a configuration parameter
and added into the kernel release.  Does someone have a primer on why
this kind of behavior is not desired or "possible"?

Doing this has given me SO much visibility into stack variables data
values while single-stepping the code.  I feel that the time invested to
make this work is well worth the return.  In the book "Writing Solid
Code" (http://www.amazon.com/Writing-Solid-Code-Microsofts-Programming/dp/1556155514) one technique discussed is: stepping through your code.  In order to be able to do this effectively you need optimizations turned off.  


