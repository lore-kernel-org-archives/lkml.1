Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459Ab0AKBl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0AKBl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755Ab0AKBl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:41:28 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:40139 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0AKBl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:41:28 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Date: Mon, 11 Jan 2010 01:41:27 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hidvk7$7cg$3@taverner.cs.berkeley.edu>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <f73f7ab81001101418x3b3f8652j256f6311ad6244c5@mail.gmail.com>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1263174087 7568 128.32.153.193 (11 Jan 2010 01:41:27 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 11 Jan 2010 01:41:27 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett  wrote:
>No, there is a *MUCH* bigger security issue here.  There are existing
>PAM modules which lazily fork background processes to handle
>authentication, authorization, logging, etc.  Now assume that one of
>those PAM modules is hooked from /etc/pam.d/su.
>
>(1) Mallory runs "disablenetwork su -"
>(2) The PAM module lazily starts its background daemon with a
>10-minute idle timeout.
>(3) The daemon has network disabled, and so it is completely nonfunctional.
>(4) The daemon automatically denies all logins because it cannot
>communicate with the login server
>(5) Alice tries to run "su -" from her regular terminal.
>(6) Alice's "su" process communicates with the running daemon and
>fails because "the network is down".
>
>All of that software is perfectly reasonably designed... the daemon is
>even fail-secure in the event that the network really is inaccessible.
> Unfortunately it lets Mallory easily DoS every superuser login on the
>system without generating a single audit log.  The only process that
>knows what he did is the one that cannot communicate with the remote
>audit daemon.

It's just a DOS.  There are a gazillion and one ways to DOS a typical
Linux system, especially if the attacker has an account on the system.

One alternative way: Mallory can mount such a DOS simply by flooding
the network.  That's not rocket science.

Another alternative way that might work (I don't know): What happens if
Mallory uses rlimit (RLIMIT_NOFILE) to set the maximum number of open
file descriptors very low, then runs "su -"?  Do we get the same DOS
outcome you listed above?  I'd guess yes, unless because these resource
limits are inherited across fork and exec.

I think stopping DOS is just really hard.  I'm not convinced this
is increasing the power of real-life attackers to any significant
extent.

>Now, you can try to claim "Nobody has it configured like that" or
>"None of the standard Linux PAM modules do that"... but that does not
>resolve the problem.  A sysadmin and part-time programmer (not knowing
>about a little-documented "disablenetwork" feature) could very easily
>write software like that and assume that it is secure.

I don't know.  I'm not really persuaded by your invocation of a
hypothetical sysadmin who writes their own setuid programs.  Writing
setuid programs (or programs invoked by setuid programs) securely is
really hard.  In all honesty, if your average "sysadmin and part-time
programmer" tries to roll their own setuid program for this kind of
thing, there's a fair chance that it will have a security hole --
and that's probably true whether or not you enable disablenetwork.
Introducing disablenetwork may increase the chances of insecurity in
setuid programs written by non-experts somewhat, but I bet it's only a
small increment compared to the overall risk.

>The #1 rule for setuid binaries is that you DO NOT INHERIT ANYTHING.
>Any kernel feature or setuid program which violates that rule is just
>going to cause big security holes.  Security models must be either
>obviously correct or mathematically provable (or both)... and this is
>neither.

Yeah, but we can also argue the other way from first principles too: If
you're writing a setuid program that *assumes* the network is reliable,
and fails insecurely if a packet doesn't get through, then you're
probably doing something wrong.  Networks are fundamentally unreliable.
Security-critical software shouldn't be written in a way that fails
unsafely if the network is unavailable.
