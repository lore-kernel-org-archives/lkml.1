Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZKSSl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZKSSl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZKSSl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:41:27 -0500
Received: from www.tglx.de ([62.245.132.106]:36315 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZKSSlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:41:25 -0500
Date: Thu, 19 Nov 2009 19:39:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Haley <aph@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <4B058C76.9090609@redhat.com>
Message-ID: <alpine.LFD.2.00.0911191934130.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu> <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain> 
 <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain> <alpine.LFD.2.00.0911191607440.24119@localhost.localdomain> <4B058C76.9090609@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Andrew Haley wrote:
> OK, I found it.  There is a struct defined as
> 
> struct entry {
>  ...
> } __attribute__((__aligned__((1 << (4)))));
> 
> and then in timer_stats_update_stats you have a local variable of type
> struct entry:
> 
> void timer_stats_update_stats()
> {
>  spinlock_t *lock;
>  struct entry *entry, input;
> 
> So, gcc has to 16-align the stack pointer to satisfy the alignment
> for struct entry.

This does not explain why GCC < 4.4.x actually puts

     push %ebp
     mov  %esp, %ebp

first and why GCC 4.4.x decides to create an extra copy of the return
address instead of just keeping the mcount stack magic right at the
function entry.

Thanks,

	tglx
