Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZKQBgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZKQBgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 20:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZKQBgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 20:36:13 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:57572 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZKQBgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 20:36:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O7RmPRfqlSEb8k7HHLxiuZ1lU7giy8LsqEbR1tYX0melBSr3PGszEm7VDABC8LCpkt
         hT5OUDClq+fZf3l7Fwlnm+mjWQiyB481d8XL2tAta1LmX9aEFr6Aqfju6cda98U1qEW0
         0wtqx/jthKzuEXSr4eKXyflgX6gZ0FVUSEhuI=
Date: Tue, 17 Nov 2009 02:36:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>, paulus@in.ibm.com
Subject: Re: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints
	layer on top of perf events
Message-ID: <20091117013617.GF5293@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-6-git-send-email-fweisbec@gmail.com> <20091111130207.GA5676@in.ibm.com> <20091112042502.GA3145@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112042502.GA3145@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 09:55:02AM +0530, K.Prasad wrote:
> 
> I forgot to mention another potential bug here...
> 
> static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
> {
> ..
> ...
> restore:
> 	/*
> 	 * Loop through all the hardware breakpoints, making the
> 	 * appropriate changes to each.
> 	 */
> 	for (i = 0; i < HBP_NUM; i++) {
> 		enabled = decode_dr7(data, i, &len, &type);
> 		bp = thread->ptrace_bps[i];
> 
> 		if (!enabled) {
> 			if (bp) {
> 				/*
> 				 * Don't unregister the breakpoints right-away,
> 				 * unless all register_user_hw_breakpoint()
> 				 * requests have succeeded. This prevents
> 				 * any window of opportunity for debug
> 				 * register grabbing by other users.
> 				 */
> 				if (!second_pass)
> 					continue;
> 				thread->ptrace_bps[i] = NULL;
> 				unregister_hw_breakpoint(bp);
> 			}
> 			continue;
> 		}
> 
> So, the breakpoint is unregistered whenever bits corresponding to
> DR0-DR3 are set to a disabled state in DR7.
> 
> 		/*
> 		 * We shoud have at least an inactive breakpoint at this
> 		 * slot. It means the user is writing dr7 without having
> 		 * written the address register first
> 		 */
> 		if (!bp) {
> 			rc = -EINVAL;
> 			break;
> 		}
> ..
> ...
> }
> 
> Now think of the following sequence of write operations through ptrace:
> 1. Populate address in DRn (where 0 <= n <= 3) (breakpoint registration)
> 2. Enable corresponding bits in DR7 (modify breakpoint to active state)
> 3. Disable bits in DR7 (unregister breakpoint)
> 4. Enable bits in DR7 (returns with failure)
> 
> The assumption that every 'enable' operation in DR7 is preceded by a
> write operation on DR0-DR3 need not be always true.


Right. It just works with gdb because it usually rewrite the whole
sequence while reactivating a breakpoint (addr rewrite + dr7 enable).

But still you're right in that this is buggy. The use of an array
of struct arch_hw_breakpoint per thread should solve it.

Thanks.

