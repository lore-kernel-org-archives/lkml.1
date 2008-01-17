Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYAQPng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYAQPng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYAQPn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:43:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbYAQPn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:43:28 -0500
Message-ID: <478F7768.90203@redhat.com>
Date: Thu, 17 Jan 2008 07:42:32 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vinay Sridhar <vinay@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
       wli@holomorphy.com, akpm@linux-foundation.org, sripathik@in.ibm.com
Subject: Re: [RFC] Per-thread getrusage
References: <1200558425.5992.17.camel@srivinay.in.ibm.com>
In-Reply-To: <1200558425.5992.17.camel@srivinay.in.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Vinay Sridhar wrote:
> There are two ways to implement this in the kernel:
> 1) Introduce an additional parameter 'tid' to sys_getrusage() and put
> code in glibc to handle getrusage() and pthread_getrusage() calls
> correctly.
> 2) Introduce a new system call to handle pthread_getrusage() and leave
> sys_getrusage() untouched.

You're doing two things at once:

a) provide a way to get a thread's usage

b) provide a way to get another process's/thread's usage


The former is a trivial extension and I completely agree.  RUSAGE_THREAD
is trivial to implement and should go in ASAP.

The second part isn't that easy.  The first question is: do we really
need this?  It is a new type of interface.  We have the /proc filesystem
etc for programs which want to look at other process' data.  Second,
more importantly right now, your patch seems not to include any security
support.  Correct me if I'm wrong, but find_task_by_pid will always
succeed, regardless of whether the calling thread belongs to another UID
or not.  I.e., your patch enables any process to read any other process'
usage.  That's a no-no.


I suggest that you split the patch in two.  The first should implement
RUSAGE_THREAD.  You'll immediately get an ACK from me for that.  The
second part then should introduce a way to get another process' usage.
This patch should only be used initially as a starting point for
discussions.  You'll have to argue why it is necessary in the first place.

The argument might have to do with why you want a pthread_getrusage()
interface (which, btw, is a bad name since the interface is nothing like
getrusage, getrusage doesn't allow requesting any other process' data).
 Yes, for intra-process lookups relying on /proc is no good idea.  But
then, I have not seen any reason so far why such an API is needed and
why a thread cannot just be responsible for reading its own usage data.
 Anyway, if pthread_getrusage (or whatever it'll be called) is the only
usage then the syscall should require that the TID parameter is from a
thread in the same process which would solve the security problem.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHj3do2ijCOnn/RHQRAiKdAKCSooiEWcxr780hJGenElyDiWPWKgCdE+6Y
j6ibmGsPT4aYxhSfpimSdiw=
=jOC9
-----END PGP SIGNATURE-----
