Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbXFCTnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbXFCTnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 15:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXFCTnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 15:43:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbXFCTnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 15:43:40 -0400
Message-ID: <466319DB.80800@redhat.com>
Date: Sun, 03 Jun 2007 12:43:23 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2> <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
>> I agree with Ingo, no need for a second magic value.  Use the same value
>>  as FD_UNSEQ_ALLOC which will just mean this exact value should never be
>> used as a file descriptor.
> 
> I explained this in my answer to Ingo...

And if we have a new syscall we don't need any of that special dup2
behavior you describe.  I really don't think this should be added.  dup2
should just do what POSIX specifies, nothing more.  I would even suggest
to not allow to dup2() to a descriptor > RLIMIT_NOFILE unless it is
already allocated.  I.e., don't allow creating arbitrary high descriptors.

This behavior is completely consistent with the current implementation.
 No bad surprises.  In fact, it eliminates parts of the ABI
incompatibility I talked about.


> Random can be expensive. At the moment is FIFO. I'm missing though how 
> this can be a security flaw, when the legacy one is exactly predictable.

It's not an added security issue.  It would mean removing a possible
security the current file descriptor allocation has.

If randomizing each allocator is too expensive then randomize at the
very least the number of the first descriptor you give out.


> I can do a new syscall, no problem (I actually even slightly prefer). We 
> cannot break dup2() and F_DUPFD though, so we have to handle those too.

There is no requirement to duplicate everything since non-sequential
descriptors are a new feature.  Existing program will not be affected.
As said above, I think it is better if dup2() to a high descriptor which
does not exist is not allowed.  You have to be able to dup2() over an
existing one but that's it.

For F_DUPFD I also don't see justification for an extension to
non-sequential descriptors.  The concept of "greater than" makes not
much sense for non-sequential descriptors.  I think I would be more than
happy to restrict the specified lower bound to RLIMIT_NOFILE as it is now.

If latter this turns out to be a big limitation we can still extend the
dup2/fcntl functionality.  But removing functionality is harder.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGYxnb2ijCOnn/RHQRAkyoAJ4+L3W/aVYaQ/IG0HPm0tt5PKPcRACgoJYF
bChz20uicqD9tBbDtU1yruM=
=4vNd
-----END PGP SIGNATURE-----
