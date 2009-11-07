Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZKGURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZKGURZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 15:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZKGURV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 15:17:21 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43732 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZKGURU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 15:17:20 -0500
Date: Sat, 7 Nov 2009 12:18:10 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org,
       arnd@arndb.de, Containers <containers@lists.linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [v11][PATCH 8/9] Define clone_with_pids() syscall
Message-ID: <20091107201810.GA26787@us.ibm.com>
References: <20091105053053.GA11289@us.ibm.com> <20091105054124.GH16142@us.ibm.com> <20091106180210.GA31652@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106180210.GA31652@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn [serue@us.ibm.com] wrote:
| Quoting Sukadev Bhattiprolu (sukadev@us.ibm.com):
| > +	stack_size = (unsigned long)kca.child_stack_size;
| > +	child_stack = (unsigned long)kca.child_stack_base + stack_size;
| > +
| > +	if (!child_stack)
| > +		child_stack = regs->sp;
| 
| I'm hooking up the s390 version right now.  Do you think you should
| make this
| 
| 	if (!kca.child_stack_base)
| 		child_stack = regs->sp;
| 
| ?
| 
| I suppose that in general if I pass in a NULL kca.child_stack_base
| I'll also pass in a 0 stacksize, but as a user I'd expect that if
| I pass in NULL, the size gets ignored.  Instead, if I pass in NULL
| plus a size, then the kernel will take (void *)size as the stacktop.

Good point. Like copy_thread() on IA64, how about ignoring 'stack_size'
if base is NULL ?

        child_stack = 0UL;
        if (kca.child_stack_base)
                child_stack = (unsigned long)kca.child_stack_base + stack_size;

        if (!child_stack)
                child_stack = regs->sp;

The other question is whether we should force all architectures to pass in
the stack *base* ? clone(2) man page says:

	Stacks grow  downwards  on  all  processors  that  run  Linux (except
	the  HP  PA  processors), so child_stack usually points to the topmost
	address of the memory space set up for the child stack.

To be compatibile with clone() on most architectures, should we rename
'clone_args.child_stack_base' to 'clone_args.child_stack' and let
architectures use this field like they currently use the 'child_stack'
parameter to clone(2) ?

So x86 would pass in address of top-of-stack while HP-PA can pass in address
of base-of-stack.

Arnd, Roland, Peter please let me know if you have any inputs on this.

Sukadev
