Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZFXFFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZFXFFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 01:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZFXFF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 01:05:29 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:41287 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZFXFF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 01:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=qR8pwy4pYilthCbtcv7DSjmYXWNFizuBm+CAIyRpd64aaoUWx1i0MYI4jaIl+2KcO9
         onoaTPNdcfcLnPZWxEZ8LhmNxKNEJi84hD2TQy4UaCGT5241FK9kT8IktwjvXQ4cQlMM
         Rdh49C0DA1wvG44FwHDonns5yV2Giw+awY1Bg=
MIME-Version: 1.0
Date: Wed, 24 Jun 2009 01:05:30 -0400
Message-ID: <3a8893170906232205x18417861v446a2905a4ccf21@mail.gmail.com>
Subject: Magic Security Dust: Appropriating SECCOMP
From: David Thomas <davidleothomas@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Code I trust processing data I don't" is a common situation.
Web browsers, movie players, image viewers, document readers,
video games, and many other applications deal with data
that could be malicious.  I was looking for an easy way to
restrict the damage my software might do should my handling
of malicious data be less than perfect.  The options I found,
under Linux, were SECCOMP and ptrace.  SECCOMP seemed much too
narrow, while ptrace seemed more complicated than I needed and
also incurs a performance penalty.  So I modified SECCOMP as
described below, and have been running on this kernel since
November with no apparent issues or change in performance.
I was wondering what thoughts people had, before I updated
the patch to the latest kernel.

For those unfamiliar, SECCOMP allows a process to restrict
the set of syscalls it can later access through a flag set
with prctl.

While SECCOMP originally worked from "modes" with lists of
allowable syscalls, I thought it better to have a set of
flags.  There were two reasons for this.  First, it allows
easier checking of whether a syscall should be permitted
(a simple bitwise-and).  Second, I find it easier to reason
about composing groups of syscalls than remembering precisely
what is permitted/denied in a list of modes.  As there was
previously only a mode 1, having flag zero provide the same
syscalls maintains backwards-compatibility.

Moving the checks from the audit/trace code out to the
individual syscalls means that each syscall we're doing one
check and a correctly predicted branch, instead of n checks
with (usually) a mis-predicted branch.  This also means greater
granularity at build time - rather than merely "SECCOMP or no
SECCOMP", an individual build can check the flags for open and
fork but not for read and write, or any other combination.
Because no process will be relying on these checks to *add*
functionality, this will be completely transparent to user-space
and can be configured as best suits the individual deployment,
balancing the users' paranoia against their need for speed.

This is not meant to replace SELINUX, jails, or other
security mechanisms, but to supplement them.  This makes it
easier for a developer to limit the damage a process might
unintentionally do, regardless of the setup of the end user.
Lest anyone get the wrong idea, "magic security dust" is of
course tongue-in-cheek - security issues require thought and
care with or without this patch.  This just seems another tool
which attacks these issues from a slightly different direction.

Specific points for further discussion, if this is something
people are interested in:

* Which syscalls are grouped under what flags, and what
appropriate names for those flags might be.  Bear in mind that
starting from an over-constrained set of flags provides a better
path forward, as we won't be breaking anything that worked
before if we add new flags or new syscalls to existing flags.

* What to do during fork or exec when permitted - note that no
decision is reflected in the code I already have, as there's
presently no flag that permits either of these.
