Return-Path: <linux-kernel-owner+w=401wt.eu-S1760982AbZEHMUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982AbZEHMUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZEHMU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:20:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbZEHMU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:20:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090507011716.BA522FC39E@magilla.sf.frob.com>
References: <20090507011716.BA522FC39E@magilla.sf.frob.com> <20090505224729.GA965@redhat.com> <20090506224650.GZ3036@sequoia.sous-sol.org> <20090506231332.GA3756@redhat.com> <20090506232703.GA3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905070946480.22586@tundra.namei.org>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 3/3] ptrace: do not use task_lock() for attach
Date: Fri, 08 May 2009 13:18:20 +0100
Message-ID: <23342.1241785100@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> Good catch, Chris and Oleg!  This one is yet another dhowells blue plate
> special, deeply subtle change buried inside the ginormous commit d84f4f9. ;-}

Well...  Unfortunately it was an all-or-nothing patch, leastways if you wanted
the kernel to compile afterwards.

> He even mentioned this one in the log:
> 
>  (a) selinux_setprocattr() no longer does its check for whether the
> 	 current ptracer can access processes with the new SID inside the lock
> 	 that covers getting the ptracer's SID.  Whilst this lock ensures that
> 	 the check is done with the ptracer pinned, the result is only valid
> 	 until the lock is released, so there's no point doing it inside the
> 	 lock.

I knew there was a reason I carefully documented the major changes.

> Before d84f4f9, the extraction, avc check, and SID switch were all under
> task_lock().  What David's comment ignores is that "the lock that covers
> getting the ptracer's SID" (i.e. task_lock) is also the lock that excludes
> ptrace attempts, with their security checks against the (old or new) SID.
> i.e.:

I mainly focused on making sure ptrace and execve still worked in relation to
each other.  Unfortunately, I didn't see that selinux_setprocattr() might
interact with ptrace() in the same manner.

> Indeed, cred_exec_mutex is the equivalent lock for that post-d84f4f9.

Yeah.  Perhaps it should be renamed cred_ptrace_mutex.

David
