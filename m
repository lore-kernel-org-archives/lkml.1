Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXJATBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXJATBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXJATBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:01:03 -0400
Received: from THUNK.ORG ([69.25.196.29]:58641 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbXJATBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:01:00 -0400
Date: Mon, 1 Oct 2007 15:00:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071001190042.GA28533@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>,
	Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org> <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au> <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org> <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 11:40:39AM -0400, Stephen Smalley wrote:
> You argued against pluggable schedulers, right?  Why is security
> different?
> 
> Do you really want to encourage people to roll their own security module
> rather than working toward a common security architecture and a single
> balanced solution (which doesn't necessarily mean SELinux, mind you, but
> certainly could draw from parts of it)?   As with pluggable schedulers,
> the LSM approach prevents cross pollination and forces users to make
> poor choices.

Something should be pluggable, and some things not.  We have multiple
filesystems in the tree; but we only have one scheduler and one TCP/IP
stack.

I'm going to argue that security is more like filesystems than
scheduling.  The real problem with security is that there are no "hard
numbers", as Linus puts it.  Instead, there are different sets of
requirements in terms of what is a valid threat model --- which will
very depending on the environment and how the servers are deployed,
and what the capabilities are of the adversary trying to penetrate
said system --- and how end users are willing to compromise between
security and convenience.  This is much like filesystems, where one of
the reasons why people chose different filesystems is because they
have differing requirements and operational environments, and some
filesystems are better suited for certain requirements and
environments than others.

In some environments, say if you are creating a system that will
handle classified data for the U.S. government, there are formal
requirements that your employer, the NSA, sign off on the solution.
This allows the NSA to force the application programmers and end users
to make the tradeoff tilt very much against convenience in favor of
security.  And given the threat models and capabilities of the
adversaries involved, that's probably appropriate.

But that's not necessarily appropriate for all users.  SELINUX is so
horrible to use, that after wasting a large amount of time enabling it
and then watching all of my applications die a horrible death since
they didn't have the appropriate hand-crafted security policy, caused
me to swear off of it.  For me, given my threat model and how much my
time is worth, life is too short for SELinux.

And I can tell you that certain ISV's, when faced with users
complaining that their commericial application which costs ten times
as much as their Linux distribution doesn't work when SELinux is
enabled, simply tells their customers to disable SELinux.

I've often thought that one of the reasons why SELinux folks argue so
strenuously against AppArmor is because since configuring it to
support new applications is so much easier than SELinux, that on an
even playing ground, in many commercial environments that dwarf the
NSA-mandated security pain of the federal sector, there is fear that
AppArmor would be much more popular with customers than SELinux.  Yes,
AppArmor protects against fewer threats; but if the choice is to go
without SELinux because it's too painful to configure SELinux policy,
surely some protection is better than none.

> Some have suggested that security modules are no different than
> filesystem implementations, but filesystem implementations at least are
> constrained by their need to present a common API and must conform with
> and leverage the VFS infrastructure.  Different security modules present
> very different interfaces and behaviors from one another and LSM doesn't
> provide the same kind of common functionality and well-defined semantics
> as the VFS.  The result of merging many wildly different security
> modules will be chaos for application developers and users, likely
> leading them to ignore everything but the least common denominator.
> It almost makes more sense to merge no security modules at all than to
> have LSM and many different security modules.

Look, the reality is that the common interface for application is
system calls returning EPERM.  If you have to rewrite applications to
use a security module, or force application writers to create a
complicated SELinux policy, application writers will simply balk.  It
Just Won't Happen.  Commercial applications like Oracle, DB2,
Websphere, BEA Application Server, Tivoli Storage Manager, and so on
work on multiple OS's, and not just Linux.  If the application
developers are forced to use a Linux-specific API, most of them will
just walk away; it's much simpler and cheaper to tell users to disable
SELinux.  And in the commercial world, we don't have the "big stick"
the NSA has in the federal/defense space to force application writers
to pay attention to SELinux.

The situation is just the same with filesystems.  The common API is
POSIX.  As filesystem writers, we often kvetch about how limiting
certain filesystem interfaces created 30 years ago might be, but the
reality is, very few applications will use extended interfaces, and so
if we broke readdir() and told application writers that they had to
use this wonderful new read_directory() API that was so much better
than the old readdir() interface, they would laugh at us and ignore
us.  Why do security people think they have the ability to dictate to
application writers that they use specialized API's or write arcane
security policies?

						- Ted
