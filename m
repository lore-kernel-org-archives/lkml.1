Return-Path: <linux-kernel-owner+w=401wt.eu-S1763965AbYHHWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763965AbYHHWYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbYHHWYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:24:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:61902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452AbYHHWYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:24:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Date: Sat, 9 Aug 2008 00:23:51 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
References: <20080807224033.FFB3A2C1@kernel> <1218221451.19082.36.camel@nimitz> <489CB3CA.6050304@cs.columbia.edu>
In-Reply-To: <489CB3CA.6050304@cs.columbia.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808090023.51891.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18U4uwm+o5yHOnd9U46Frt4Ygqrhfcmsr+plOv
 x2iYeCO8jzRoDlrZWDwzAc6Y1C4DdeRoJ9L7q81+fxRqpMLfCu
 saoV3LMrlLNEDcm2h29iA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Oren Laadan wrote:

> > Yeah, this is very true.  My guess is that we'll need something like
> > what we do with modversions. 
> 
> Exactly. The header should eventually contain sufficient information
> to describe the kernel version, configuration, compiler, cpu (arch and
> capabilities), and checkpoint code version.
> 
> How would you suggest to identify the origin tree with an identifier
> (or a text field) in the header ?

Including struct utsname in the header covers most of this. I supposed
you can't do it entirely safe, and you always need to be prepared for
malicious input data, so there probably isn't much point in getting
too fancy beyond what you need to do to prevent user errors.

> If it is preferred, we can change this to write a kernel message and
> return a special error telling that a logical error has occurred.

My recommendation in general is to make kernel code crash loudly if
there is a bug in the kernel itself. Returning error codes makes most
sense if they get sent back to the user, which then can make sense of
it, as documented in the man page of the syscall.

> > Yes, eventually.  I think one good point is that we should probably
> > remove this now so that we *have* to think about security implications
> > as we add each individual patch.  For instance, what kind of checking do
> > we do when we restore an mlock()'d VMA?
> > 
> > I'll pull this check out so it causes pain. (the good kind)
> 
> Hmmm... even if not strictly now, we *will* need admin privileges for
> the CR operations, for the following reasons:
> 
> checkpoint: we save the entire state of a set of processes to a file - so
> we must have privileges to do so, at least within (or with respect to) the
> said container. Even if we are the user who owns the container, we'll need
> root access within that container.
> 
> restart: we restore the entire set of a set of processes, which may require
> some privileged operations (again, at least within or with respect to the
> said container). Otherwise any user could inject any restart data into the
> kernel and create any set of processes with arbitrary permissions.
> 
> In a sense, we need something similar to granting ptrace access.

Exactly. There was a project that implemented checkpoint/restart through
ptrace (don't remember what it was called), so with certain limitations
it should also be possible to implement the syscalls so that any user that
can ptrace the tasks can also checkpoint them.

	Arnd <><
