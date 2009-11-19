Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZKSSW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZKSSW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZKSSW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:22:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbZKSSWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:22:25 -0500
Message-ID: <4B058C76.9090609@redhat.com>
Date: Thu, 19 Nov 2009 18:20:38 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>  <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Thu, 19 Nov 2009, Thomas Gleixner wrote:
> 
> Can the GCC folks please shed some light on this:
> 
> standard function start:
> 
> 	 push	%ebp
> 	 mov	%esp, %ebp
> 	 ....
> 	 call   mcount
> 
> modified function start on a handful of functions only seen with gcc
> 4.4.x on x86 32 bit:
> 
> 	push   %edi
> 	lea    0x8(%esp),%edi
> 	and    $0xfffffff0,%esp
> 	pushl  -0x4(%edi)
> 	push   %ebp
> 	mov    %esp,%ebp
> 	...
> 	call   mcount
> 
> This modification leads to a hard to solve problem in the kernel
> function graph tracer which assumes that the stack looks like:
> 
>        return address
>        saved  ebp
> 
> With the modified function start sequence this is not longer true and
> the manipulation of the return address on the stack fails silently.
> 
> Neither gcc 4.3 nor gcc 3.4 are generating such function frames, so it
> looks like a gcc 4.4.x feature.
> 
> There is no real obvious reason why the edi magic needs to be done
> _before_ 
> 
> 	push   %ebp
> 	mov    %esp,%ebp

OK, I found it.  There is a struct defined as

struct entry {
 ...
} __attribute__((__aligned__((1 << (4)))));

and then in timer_stats_update_stats you have a local variable of type
struct entry:

void timer_stats_update_stats()
{
 spinlock_t *lock;
 struct entry *entry, input;

So, gcc has to 16-align the stack pointer to satisfy the alignment
for struct entry.

Andrew.

