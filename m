Return-Path: <linux-kernel-owner+w=401wt.eu-S969916AbXFICL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969916AbXFICL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 22:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXFICLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 22:11:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXFICLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 22:11:18 -0400
Message-ID: <466A0BFB.3070908@redhat.com>
Date: Fri, 08 Jun 2007 19:10:03 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com> <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk>
In-Reply-To: <20070609014140.GC4095@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> Any real-world examples of exploitable holes based on that?

Return to libc exploit, calling dup2, where some privileged data is
redirected from the normal file descriptor to one of the attackers
choosing.  The latter could be an outgoing socket connection which would
result in leaking the data to the outside.

         normal code                         intruder

                                          so = socket()

    fd = open ("local-file")

                                          dup2(so, fd);

    write (fd, privileged data)


It's just a little function call.  If the arguments of dup2() are known
this is not a big issue to construct.



>> You're confusing the problems.
> 
> No, I'm not.  The entire argument for having a separate set of descriptors
> is based on programs behaving in similar fashion, working correctly now but
> limiting what libraries can do with opening files for internal needs.

It's completely different.

The reason why runtime libraries cannot keep descriptors open unless it
is explicitly part of the API (e.g., opendir) is that POSIX and Unix
forever guarantee that descriptors are allocated sequentially.  Linus
already showed a code sequence:

	close(0);
	.. something else ..
	if (open("myfile", O_RDONLY) < 0)
		exit(1);

This occurs in the real world and it is guaranteed to work.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGagv72ijCOnn/RHQRAqxTAJwLhjuFT22SegEVXrbevpsnOkDxLQCgwgza
7ZOScxEm2lgMJNjG9UDAdfo=
=fenl
-----END PGP SIGNATURE-----
