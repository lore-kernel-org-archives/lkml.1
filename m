Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0BFEYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 23:24:05 -0500
Received: from ozlabs.org ([203.10.76.45]:40101 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab0BFEYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 23:24:03 -0500
Date: Sat, 6 Feb 2010 15:20:38 +1100
From: Anton Blanchard <anton@samba.org>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Serge Hallyn <serue@us.ibm.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl
Subject: Re: Stack size protection broken on ppc64
Message-ID: <20100206042038.GB32246@kryten>
References: <3984.1265416993@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3984.1265416993@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> On recent ppc64 kernels, limiting the stack (using 'ulimit -s blah') is
> now more restrictive than it was before.  On 2.6.31 with 4k pages I
> could run 'ulimit -s 16; /usr/bin/test' without a problem.  Now with
> mainline, even 'ulimit -s 64; /usr/bin/test' gets killed.
> 
> Using 64k pages is even worse.  I can't even run '/bin/ls' with a 1MB
> stack (ulimit -s 1024; /bin/ls).  Hence, it seems new kernels are too
> restrictive, rather than the old kernels being too liberal.

It looks like this is causing it:

#define EXTRA_STACK_VM_PAGES    20      /* random */

...

#ifdef CONFIG_STACK_GROWSUP
        stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
#else
        stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
#endif

Which got added back in 2005 in a memory overcommit patch. It only took 5
years for us to go back and review that random setting :)

The comment from Andries explains the purpose:

    (1) It reserves a reasonable amount of virtual stack space (amount
        randomly chosen, no guarantees given) when the process is started, so
        that the common utilities will not be killed by segfault on stack
        extension.

This explains why 64kB is much worse. The extra stack reserve should be in kB
and we also need to be careful not to ask for more than our rlimit.

Anton
