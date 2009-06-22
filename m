Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbZFXSvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbZFXSvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZFXSvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:51:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39456 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZFXSvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:51:05 -0400
Date: Mon, 22 Jun 2009 20:31:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Thomas <davidleothomas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Magic Security Dust: Appropriating SECCOMP
Message-ID: <20090622183152.GA2284@ucw.cz>
References: <3a8893170906232205x18417861v446a2905a4ccf21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a8893170906232205x18417861v446a2905a4ccf21@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 01:05:30, David Thomas wrote:
> "Code I trust processing data I don't" is a common situation.
> Web browsers, movie players, image viewers, document readers,
> video games, and many other applications deal with data
> that could be malicious.  I was looking for an easy way to
> restrict the damage my software might do should my handling
> of malicious data be less than perfect.  The options I found,
> under Linux, were SECCOMP and ptrace.  SECCOMP seemed much too
> narrow, while ptrace seemed more complicated than I needed and
> also incurs a performance penalty.  So I modified SECCOMP as
> described below, and have been running on this kernel since
> November with no apparent issues or change in performance.
> I was wondering what thoughts people had, before I updated
> the patch to the latest kernel.
> 
> For those unfamiliar, SECCOMP allows a process to restrict
> the set of syscalls it can later access through a flag set
> with prctl.
> 
> While SECCOMP originally worked from "modes" with lists of
> allowable syscalls, I thought it better to have a set of
> flags.  There were two reasons for this.  First, it allows
> easier checking of whether a syscall should be permitted
> (a simple bitwise-and).  Second, I find it easier to reason
> about composing groups of syscalls than remembering precisely
> what is permitted/denied in a list of modes.  As there was
> previously only a mode 1, having flag zero provide the same
> syscalls maintains backwards-compatibility.
> 
> Moving the checks from the audit/trace code out to the
> individual syscalls means that each syscall we're doing one
> check and a correctly predicted branch, instead of n checks
> with (usually) a mis-predicted branch.  This also means greater
> granularity at build time - rather than merely "SECCOMP or no
> SECCOMP", an individual build can check the flags for open and
> fork but not for read and write, or any other combination.
> Because no process will be relying on these checks to *add*
> functionality, this will be completely transparent to user-space
> and can be configured as best suits the individual deployment,
> balancing the users' paranoia against their need for speed.
> 
> This is not meant to replace SELINUX, jails, or other
> security mechanisms, but to supplement them.  This makes it
> easier for a developer to limit the damage a process might
> unintentionally do, regardless of the setup of the end user.
> Lest anyone get the wrong idea, "magic security dust" is of
> course tongue-in-cheek - security issues require thought and
> care with or without this patch.  This just seems another tool
> which attacks these issues from a slightly different direction.
> 
> Specific points for further discussion, if this is something
> people are interested in:
> 
> * Which syscalls are grouped under what flags, and what
> appropriate names for those flags might be.  Bear in mind that
> starting from an over-constrained set of flags provides a better
> path forward, as we won't be breaking anything that worked
> before if we add new flags or new syscalls to existing flags.
> 
> * What to do during fork or exec when permitted - note that no
> decision is reflected in the code I already have, as there's
> presently no flag that permits either of these.

See previous discussion with google...

...list of syscalls permitted is really bad abstraction. (And you'll
add security holes if you allow setuid exec with restricted mask).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
