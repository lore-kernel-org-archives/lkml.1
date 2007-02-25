Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbXBYDPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbXBYDPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 22:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933644AbXBYDPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 22:15:08 -0500
Received: from main.gmane.org ([80.91.229.2]:41153 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933643AbXBYDPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 22:15:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Pierre Baillargeon <pierrebai@hotmail.com>
Subject: Async IO idea
Date: Sun, 25 Feb 2007 03:08:38 +0000 (UTC)
Message-ID: <loom.20070225T040733-711@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 74.15.208.15 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070219 Firefox/2.0.0.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm an app programmer, not a kernel hacker. With that caveat...

I've been reading LWN article about AIO and the description of Linus' solution
and the following realization dawned on me: at its heart, the idea is to fork
when blocking. So let's make it explicit with a single new function call:

#define MAYBE_FORK_END    0
#define FORK_ON_BLOCKING  1
#define FORK_ON_SOMETHING 2 /* Other ideas to reuse this? */
int maybe_fork(jmp_buf *, int flags);

Conceptually, this call is a setjump() and from then on, any syscall which
would block would conceptually do fork()+longjump(). To end the potential
forking sequence of calls, one simply calls maybe_fork() with the
MAYBE_FORK_END flag. This solution takes advantage of the knowledge and
coding style already accumulated by programmers.

Demonstration:

/* Prepare async call: save current execution state. */
jmp_buf buffer;
int childpid = maybe_fork(&buffer, FORK_ON_BLOCKING);
if(!childpid)
{
   /* OK, we're at the initial sequence after FORK_ON_BLOCKING. */
   /* No fork as taken place yet. */
   /* Any blocking syscall from here on may cause a fork. */
   read();
   /* Stop the fork potential. */
   int our_new_pid = maybe_fork(0, MAYBE_FORK_END);
   /* Work that depends on read() and maybe done in child, who knows? */
   /* But it *won't* cause a fork if it blocks */
   bar();
   /* Check if we're in child. */
   if(our_new_pid)
   {
      /* Oh my! We blocked in read() and forked there! */
      /* Of course, we're not *forced* to exit() or anything... */
      exit();
   }
}
/* Work potentially done in parallel to async read(). */
foo();
/* Check if we had forked and are in parent. */
if(childpid)
   /* Oh my! We blocked and really are a parent! */
   /* Wait for async ops to finish. */
   int status;
   waitpid(childpid, &status, 0);
}
/* Work that depends on read() but must be done after foo(). */
qat();

/*
 * Non-blocking case:
 *    - getpid(), maybe_fork(), read(), maybe_fork(), bar(), foo(), qat().
 *
 * Blocking case:
 *    - getpid(), maybe_fork(), read() [Blocks and forks there.]
 *       - In child:
 *          - maybe_fork(), bar(), exit()
 *       - In parent:
 *          - first maybe_fork() returns child pid.
 *          - foo(), waitpid(), qat()
 */

Some non-issues with the idea, which are in reality just a re-hash
of longjump():

- A pointer to the jmp_buf must be kept in the process structure to
  be able to (conceptually) longjmp() there.

     This isn't much of an issue. It's the duty of the caller, like
     keeping a proper jmp_buf is required. It could be a security
     risk if the longjmp() would be done in kernel space, but arranging
     for doing it in user-space isn't hard (I would think).

- If there are process-wide state changed in the potentially asynchronous
  calls (say, due to an open() in the middle of a sequence of calls), then
  when/if there is a fork, that change will be visible in the parent process.
  IOW, if you write your code naively, you could leak, say, file descriptors.

     Again, this is only a user-space issue. All that is needed is for
     that state to be visible in the potential parent process, say by
     putting the file descriptor in a variable that is visible in the
     context of the 1st maybe_fork(). This is also equivalent to the
     coding issues of setjump()/longjump(), so it's nothing new.

The great things are:

- You can do as many syscalls as you wish in the async portion.

- No forking in the non-blocking case.

- Very light setup work.

- Reuse known structure, calls and concepts.

- You can have many styles for looping cases:

     * A single maybe_fork(), with all work potentially done in a child.
     * A limited number of maybe_fork() (i.e. a statically declared
       array of jmp_buf, on exhaustion the last child does it all).
     * A first stack-based jmp_buf kept in a pointer, creating further
       ones as needed.

- Support all kinds of blocking code.

- Support new kinds of conditional forking by using new values for the flags.

Just throwing the idea around.


