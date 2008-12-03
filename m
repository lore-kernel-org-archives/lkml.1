Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYLCFCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYLCFCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYLCFCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:02:36 -0500
Received: from ivent.com.au ([125.7.48.1]:35003 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbYLCFCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:02:35 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <804dabb00812022035k1876a521qa41cd4634b70f9a2@mail.gmail.com>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <73639.1228272932@turing-police.cc.vt.edu>
	 <1228276959.6679.27.camel@lappy.spacevs.com>
	 <804dabb00812022035k1876a521qa41cd4634b70f9a2@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 16:02:25 +1100
Message-Id: <1228280545.6679.40.camel@lappy.spacevs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - picard.ivent.com.au
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rabidhost.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 12:35 +0800, Peter Teoh wrote:
> On Wed, Dec 3, 2008 at 12:02 PM, Geoffrey McRae <geoff@rabidhost.com> wrote:
> >
> > My initial concept is to implement a HTTP server that is designed from
> > the ground up to use this new functionallity. Each server that has been
> > pre-forked will just sit there until the parent sets its uid/gid and
> > hands it the request to handle.
> >
> 
> I think the above is the core issue - you have something privileged to
> be executed.   So why not execute it in a small, code-verifiable
> implementation, just like the Privilege Separation idea of SSH?
> 
> http://www.citi.umich.edu/u/provos/papers/privsep.pdf

This would incur that any dependant programs such as PHP would need to
be re-written to talk to the privlaged process for privlaged operations,
thus increasing the complexness of the application. Also, if there is a
exploitable bug in the communication between the parent and child, the
parent with superuser access could be compromised.

The method I am suggesting fills these gaps, the parent cant be
compromised since the children can not talk to it, and it does not have
elevated privlages once it has started up, so even if it was compomised
somehow, the worst it could do is screw up unprivlaged user's files
within the uid/gids specified in the enable_setpresuid function.

So there are two advantages here:

* The parent is much harder to compromise as the child cant talk to it.
* The child does not have high enough privlages to change its own
uid/gid, but has enough access to perform all required tasks without
needing any special privlages.

> 
> Everything is done in userspace.   SInce the privileged component is
> small, it is easy to verify for correctness.   The rest execute with
> lesser privilege.
> 
> Recently, the hypervisor has been used to implement this verifiable
> source code concept:   see:
> 
> http://www.ghs.com/news/20081117_integrity_EAL6plus_security.html
> 
> where GreenHill achieved EAL6 certification - as it built its entire
> kernel on top of the hypervisor.   (called Separation Kernel,
> conceptually similar to that of Privilege Separation in SSH).
> 
> Just my 2cts :-).
> 

Again, this is alot of overhead and complexaty that for the kind of task
that I am trying to accomplish.

Right now the only forseeable problem is that if a process holds a fd
open when the parent app changes its uid/gid, which still, the worst
that it can do is read/write another user's file. But the solution to
this should be trivial, just close all fds the process should not have
access to in the kernel when the uid/gid is changed.

If a program crashes because it did not expect its uid to change, it
should either be updated to handle being used in this manner, or not be
used at all. Most programs, including PHP in my initial testing perform
flawlessly when their uid/gid is changed before they are handed a new
script to parse.

-Geoff

