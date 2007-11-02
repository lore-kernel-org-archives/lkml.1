Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbXKBRat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbXKBRat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbXKBRak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:30:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42046 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbXKBRaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:30:39 -0400
Subject: Re: [patch] PID namespace design bug, workaround
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
In-Reply-To: <20071102010419.23f3db5c.akpm@linux-foundation.org>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
	 <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org>
	 <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org>
	 <20071102010419.23f3db5c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 10:30:22 -0700
Message-Id: <1194024622.6271.108.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 01:04 -0700, Andrew Morton wrote:
> > > That is the "fix" you were referring to?  I was hoping you have a sketch
> > > for a real solution.  If nobody can think of a way to fix this PID
> > 
> > Looks like we misunderstood each other. Can you please elaborate on 
> > what exactly is broken in pid namespaces?
> 
> Isn't it this?
> 
> http://lkml.org/lkml/2007/11/1/141

I think we're still a bit murky on exactly what the issues are.  Ingo,
Ulrich, is this the right track?  The kind of issues that you're
concerned about?

There are certainly more of these, but here is one In the futex
userspace address, we install the current pid's vnr into a userspace
address.  

static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
                         int detect, ktime_t *time, int trylock)
{
...
        newval = task_pid_vnr(current);
        curval = cmpxchg_futex_value_locked(uaddr, 0, newval);

We obviously don't have any restrictions on who else might be mapping
that address, so that pid can theoretically leak out to any other task.
In another pid namespace, the pid at that userspace address is certainly
nonsensical.

-- Dave

