Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZKSPkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZKSPkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbZKSPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:40:09 -0500
Received: from www.tglx.de ([62.245.132.106]:51209 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZKSPkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:40:08 -0500
Date: Thu, 19 Nov 2009 16:37:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Thomas Gleixner wrote:

Can the GCC folks please shed some light on this:

standard function start:

	 push	%ebp
	 mov	%esp, %ebp
	 ....
	 call   mcount

modified function start on a handful of functions only seen with gcc
4.4.x on x86 32 bit:

	push   %edi
	lea    0x8(%esp),%edi
	and    $0xfffffff0,%esp
	pushl  -0x4(%edi)
	push   %ebp
	mov    %esp,%ebp
	...
	call   mcount

This modification leads to a hard to solve problem in the kernel
function graph tracer which assumes that the stack looks like:

       return address
       saved  ebp

With the modified function start sequence this is not longer true and
the manipulation of the return address on the stack fails silently.

Neither gcc 4.3 nor gcc 3.4 are generating such function frames, so it
looks like a gcc 4.4.x feature.

There is no real obvious reason why the edi magic needs to be done
_before_ 

	push   %ebp
	mov    %esp,%ebp

Thanks,

	tglx
