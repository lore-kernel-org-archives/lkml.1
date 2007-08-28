Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXH1Gjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXH1Gjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXH1GjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:39:23 -0400
Received: from colo.lackof.org ([198.49.126.79]:38932 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbXH1GjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:39:22 -0400
Date: Tue, 28 Aug 2007 00:39:05 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, parisc-linux@parisc-linux.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [parisc-linux] [patch 15/23] Add cmpxchg_local to parisc
Message-ID: <20070828063905.GA3916@colo.lackof.org>
References: <20070812145434.520271946@polymtl.ca> <20070812145840.691277845@polymtl.ca> <20070827210432.GA22484@colo.lackof.org> <20070827211140.GB10627@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827211140.GB10627@Krystal>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 05:11:40PM -0400, Mathieu Desnoyers wrote:
...
> > Can you add a description to Documentation/atomic_ops.txt ?
> > *sigh* sorry for being "late to the party" on this one...
> 
> Does Documentation/local_ops.txt answer your questions ? If not, please
> tell me and I'll gladly explain more.

Yes, it does mostly - thanks. 

A few questions/nits:
o Did you attempt quantify how many places in the kernel could use this?
  I'm just trying to get a feel for how useful this really is vs just 
  using existing mechanisms (that people understand) to implement a 
  non-SMP-safe counter that protects updates (writes) against interrupts.
  If you did, adding some referencs to local_ops.txt would be helpful
  so folks could look for examples of "correct usage".

o Wording in local_ops.txt: "on the 
	"... it will then appear to be written out of order wrt
	 other memory writes on the owner CPU."

  I'd like to suggest "by the owner CPU".

o How can a local_t counter protect updates (writes) against interrupts 
  but not preemption?
  I always thought preemption required some sort of interrupt or trap.
  Maybe the local_ops.txt explains that and I just missed it.

  DaveM explained updates "in flight" would not be visible to interrupts
  and I suspect that's the answer to my question....but then I don't "feel
  good" the local_ops are safe to update in interrupts _and_ the process
  context kernel.  Maybe the relationship between local_ops, preemption,
  and interrupts could be explained more carefully in local_ops.txt.

o OK to add a reference for local_ops.txt to atomic_ops.txt?
  They are obviously related and anyone "discovering" one of the docs
  should be made aware of the other.
  Patch+log entry appended below. Please sign-off if that's ok with you.


thanks,
grant

Diff+Commit entry against 2.6.22.5:

local_t is a variant of atomic_t and has related ops to match.
Add reference for local_t documentation to atomic_ops.txt. 

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>


--- 2.6.22.5-ORIG/Documentation/atomic_ops.txt	2007-08-27 22:50:27.000000000 -0700
+++ 2.6.22.5-ggg/Documentation/atomic_ops.txt	2007-08-27 22:54:44.000000000 -0700
@@ -14,6 +14,10 @@
 
 	typedef struct { volatile int counter; } atomic_t;
 
+local_t is very similar to atomic_t. If the counter is per CPU and only
+updated by one CPU, local_t is probably more appropriate. Please see
+Documentation/local_ops.txt for the semantics of local_t.
+
 	The first operations to implement for atomic_t's are the
 initializers and plain reads.
 
