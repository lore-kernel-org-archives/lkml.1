Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZJUIhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZJUIhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 04:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZJUIhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 04:37:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:14900 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZJUIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 04:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=wucbzWzzd5bMXghmGuRyr54UXmi2oNuXvwNzeIRsH8JT7QuKQJzPv1/BCWNaANTTWw
         DzStgMXAKiRPtwGz4Wx6wdZTkFv1VpbEf3EFK4/FRvgzpp9pqNteEDCsPf4YbNIfrApC
         IflH0uGBr1943JQXF7fwe8NiPd/9FsJxMZLNU=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Wed, 21 Oct 2009 10:37:38 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
References: <20091013044925.GA28181@us.ibm.com> <20091013045556.GJ28435@us.ibm.com> <20091019213636.GB1482@ucw.cz>
In-Reply-To: <20091019213636.GB1482@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910211037.38413.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > +struct clone_struct {
> > +	u64 flags;
> > +	u64 child_stack;
> 
> u64 seems wrong  on 32 bit platforms. ulong?

That would make it incompatible between 64 bit kernels and
32 bit user space, requiring a wrapper. Better leave it at u64.

> > +	If a pid in the @pids list is 0, the kernel will assign the next
> > +	available pid in the pid namespace, for the process.
> > +
> > +	If a pid in the @pids list is non-zero, the kernel tries to assign
> > +	the specified pid in that namespace.  If that pid is already in use
> > +	by another process, the system call fails with -EBUSY.
> ...
> > +	On failure, clone3() returns -1 and sets 'errno' to one of following
> > +	values (the child process is not created).
> 
> Inconsistent with above. Syscalls really return -ERRCODE, errno is
> glibc magic.

Quite the opposite is true.

The man page describes what the user space sees, which is errno. Returning
-ERRCODE to libc from the kernel is part of the architecture specific
kernel ABI and should not be documented in this place but in the architecture
documentation.

> > +	pid_t pids[] = { 77, 99 };
> > +	struct clone_struct cs;
> > +
> > +	cs.flags = (u64) SIGCHLD;
> > +	cs.child_stack = (u64) setup_child_stack();
> > +	cs.nr_pids = 2;
> > +	cs.parent_tid = 0LL;
> > +	cs.child_tid = 0LL;
> > +
> > +	rc = syscall(__NR_clone3, &cs, pids);
> 
> Hmm, is there reason why pids are not at the end of struct
> clone_struct? Passing most parameters in special structure, then pids
> separately is strange...

I suggested doing that, it's a lot easier to handle fixed length data
structures than an array at the end.

	Arnd <><
