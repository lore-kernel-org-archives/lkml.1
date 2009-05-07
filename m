Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbZEGBol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbZEGBol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbZEGBo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:44:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759670AbZEGBo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:44:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: James Morris <jmorris@namei.org>
X-Fcc: ~/Mail/linus
Cc: Chris Wright <chrisw@sous-sol.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] ptrace: do not use task_lock() for attach
In-Reply-To: James Morris's message of  Thursday, 7 May 2009 09:48:29 +1000 <alpine.LRH.2.00.0905070946480.22586@tundra.namei.org>
References: <20090505224729.GA965@redhat.com>
	<20090506224650.GZ3036@sequoia.sous-sol.org>
	<20090506231332.GA3756@redhat.com>
	<20090506232703.GA3036@sequoia.sous-sol.org>
	<alpine.LRH.2.00.0905070946480.22586@tundra.namei.org>
X-Shopping-List: (1) Indecent annoyers
   (2) Critical onion caution
   (3) Inelastic deception briefs
   (4) Scandalous respectable interruptions
   (5) Disorienting witch expulsions
Message-Id: <20090507011716.BA522FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 18:17:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I can tell, yes.
> 
> (Added David Howells and security folk to the cc -- please make sure at 
> least that the LSM list is cc'd when changing code which affects LSM 
> modules).

Good catch, Chris and Oleg!  This one is yet another dhowells blue plate
special, deeply subtle change buried inside the ginormous commit d84f4f9. ;-}
He even mentioned this one in the log:

 (a) selinux_setprocattr() no longer does its check for whether the
	 current ptracer can access processes with the new SID inside the lock
	 that covers getting the ptracer's SID.  Whilst this lock ensures that
	 the check is done with the ptracer pinned, the result is only valid
	 until the lock is released, so there's no point doing it inside the
	 lock.

Before d84f4f9, the extraction, avc check, and SID switch were all under
task_lock().  What David's comment ignores is that "the lock that covers
getting the ptracer's SID" (i.e. task_lock) is also the lock that excludes
ptrace attempts, with their security checks against the (old or new) SID.
i.e.:

			if (!error)
				tsec->sid = sid;
			task_unlock(p);

That ensured that ptrace_attach/ptrace_traceme would be seen to atomically
check the bits that affect the SELinux ptrace controls and change the bits
that affect "if (tracer)".
     
Indeed, cred_exec_mutex is the equivalent lock for that post-d84f4f9.


Thanks,
Roland
