Return-Path: <linux-kernel-owner+w=401wt.eu-S1161221AbXBZVhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161221AbXBZVhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161219AbXBZVhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:37:09 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:43125 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161222AbXBZVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:37:07 -0500
Date: Mon, 26 Feb 2007 13:32:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/13] syslets: core, documentation
Message-Id: <20070226133210.65566d7a.randy.dunlap@oracle.com>
In-Reply-To: <20070221211521.GE7579@elte.hu>
References: <20070221211355.GA7302@elte.hu>
	<20070221211521.GE7579@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 22:15:21 +0100 Ingo Molnar wrote:

> From: Ingo Molnar <mingo@elte.hu>
> 
> Add Documentation/syslet-design.txt with a high-level description
> of the syslet concepts.

Just a few comments & questions...

> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  Documentation/syslet-design.txt |  137 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 137 insertions(+)
> 
> Index: linux/Documentation/syslet-design.txt
> ===================================================================
> --- /dev/null
> +++ linux/Documentation/syslet-design.txt
> @@ -0,0 +1,137 @@
> +Syslets / asynchronous system calls
> +===================================
> +
> +the core syslet concepts are:
> +
> +The Syslet Atom:
> +----------------
> +
> +The syslet atom is a small, fixed-size (44 bytes on 32-bit) piece of
> +user-space memory, which is the basic unit of execution within the syslet
> +framework. A syslet represents a single system-call and its arguments.
> +In addition it also has condition flags attached to it that allows the
> +construction of larger programs (syslets) from these atoms.
> +
> +Arguments to the system call are implemented via pointers to arguments.
> +This not only increases the flexibility of syslet atoms (multiple syslets
> +can share the same variable for example), but is also an optimization:
> +copy_uatom() will only fetch syscall parameters up until the point it
> +meets the first NULL pointer. 50% of all syscalls have 2 or less
> +parameters (and 90% of all syscalls have 4 or less parameters).
> +
> + [ Note: since the argument array is at the end of the atom, and the
> +   kernel will not touch any argument beyond the final NULL one, atoms

I would s/final/first/ since one could put many (unneeded) NULL pointers
in the argument array.

> +   might be packed more tightly. (the only special case exception to
> +   this rule would be SKIP_TO_NEXT_ON_STOP atoms, where the kernel will
> +   jump a full syslet_uatom number of bytes.) ]
...

> +Completion of asynchronous syslets:
> +-----------------------------------
> +
> +Completion of asynchronous syslets is done via the 'completion ring',
> +which is a ringbuffer of syslet atom pointers user user-space memory,

   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^^^^ ^^^^ ??

> +provided by user-space as an argument to the sys_async_exec() syscall.
> +The kernel fills in the ringbuffer starting at index 0, and user-space
> +must clear out these pointers. Once the kernel reaches the end of
> +the ring it wraps back to index 0. The kernel will not overwrite
> +non-NULL pointers (but will return an error), user-space has to
> +make sure it completes all events it asked for.

Last sentence is actually 2 sentences, so (e.g.) change the comma
to a semi-colon, xor begin the sentence with "Since".

How does the kernel return an error if the ring buffer is full?
Just a syscall negative error return code?


> +int main(int argc, char *argv[])
> +{
> +	unsigned long int fd_out = 1; /* standard output */
> +	char *buf = "Hello Syslet World!\n";
> +	unsigned long size = strlen(buf);
> +	struct syslet_uatom atom, *done;
> +
> +	async_head_init();
> +
> +	/*
> +	 * Simple syslet consisting of a single atom:
> +	 */
> +	init_atom(&atom, __NR_sys_write, &fd_out, &buf, &size,
> +		  NULL, NULL, NULL, NULL, SYSLET_ASYNC, NULL);

init_atom() (was) above.  sys_async_exec(), sys_async_wait() are
new syscalls.  What are async_head_init() and async_head_exit()?


> +	done = sys_async_exec(&atom);
> +	if (!done) {
> +		sys_async_wait(1);
> +		if (completion_ring[curr_ring_idx] == &atom) {
> +			completion_ring[curr_ring_idx] = NULL;
> +			printf("completed an async syslet atom!\n");
> +		}
> +	} else {
> +		printf("completed an cached syslet atom!\n");
> +	}
> +
> +	async_head_exit();
> +
> +	return 0;
> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
