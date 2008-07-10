Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYGJP6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYGJP6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYGJP54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:57:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYGJP5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:57:55 -0400
Message-ID: <48763129.9060903@redhat.com>
Date: Thu, 10 Jul 2008 08:56:25 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710104852.797fe79c@cuia.bos.redhat.com> <20080710154035.GA12043@redhat.com>
In-Reply-To: <20080710154035.GA12043@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Vivek Goyal wrote:
>>    it can even be hidden from the application by hooking into
>>    the exec() call
>>
> 
> This means hooking into libc. So libc will parse rules file, determine
> the right cgroup, place application there and then call exec?

As with any "solution" based on userlevel code, the problem is overhead
and interfaces.

Such a rules file would be a real file, I assume, and as such we'd have
to read it every time an exec call is made.  At least we'd have to check
using a stat() call that nothing changed.  That's always a big overhead.

Once the information is available, how is it used?  We'd have to pass
additional information to the exec syscalls.  And it has to happen so
that if the exec call fails the original process is not affected (i.e.,
premature changing isn't an option).  The method also must be
thread-safe in a limited way: executing failing exec syscalls in
multiple threads mustn't disturb the process.

There is one set of problems which I don't care about but others likely
will: what happens if some program uses the syscalls directly?  And what
happens with old libcs and old statically linked programs?  It's exactly
the kind of problem why I tell people to never linked statically but
some people don't listen.


The additional file update check is hurting performance but since I hope
what we will get an inotify-like interface that doesn't need normal file
descriptors (or any file descriptors) I think I can live with it.
Somebody would "just" have to implement, e.g., the anonfd functionality
discussed some time ago.  (Make sure to talk to Al Viro who already
mentioned to me that it'll be "fun").

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh2MSkACgkQ2ijCOnn/RHTepgCgrlkwQMItX2QGW6Tw//lw4vH2
ItIAoJ7qyQE31jpQ2D8fBIO/yqmrwgcH
=NQMC
-----END PGP SIGNATURE-----
