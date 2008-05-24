Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYEXG0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYEXG0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 02:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760578AbYEXG0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 02:26:00 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:41448 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760513AbYEXGZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 02:25:59 -0400
Message-ID: <4837B4F5.4000100@kernel.org>
Date: Fri, 23 May 2008 23:25:57 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: capget() overflows buffers.
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org> <20080523155718.GI30402@sequoia.sous-sol.org>
In-Reply-To: <20080523155718.GI30402@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Wright wrote:
| caps is essentially
|
CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SETGID|CAP_DAC_READ_SEARCH|CAP_SYS_RESOURCE
|
| linux_setcaps(cap_t caps) {
| 	struct __user_cap_header_struct caphead;
| 	struct __user_cap_data_struct cap;	<-- 12 bytes on stack
| 	memset(&caphead, 0, sizeof(caphead));
| 	caphead.version = _LINUX_CAPABILITY_VERSION;  <-- v2 now
| 	caphead.pid = 0;
| 	memset(&cap, 0, sizeof(cap));		<-- start initializing 12 bytes
| 	cap.effective = caps;
| 	cap.permitted = caps;
| 	cap.inheritable = 0;			<-- finish initializing 12 bytes
| 	if (syscall(SYS_capset, &caphead, &cap) < 0) <-- kernel copies in 24
bytes
|
| So it's blindly setting v2.  The kernel is sucking in 24 bytes.  The
| second set of u32s (the extra 12 bytes) is just garbage from the stack.

So, this syscall will either fail (because the process isn't
sufficiently capable to execute the system-call, and/or the "garbage"
has something like pP < pE, and the resulting attempt violates the pE'
<= pP' rule), or the syscall succeeds...

In the case that it is discovered to fail (on any tested architecture
like in the redhat bug tracked here:
https://bugzilla.redhat.com/show_bug.cgi?id=447518 ), clearly the code
is going to get recompiled to make it work.

| This could include setting CAP_MAC_OVERRIDE or CAP_MAC_ADMIN, percisely
| the kinds of things you _wouldn't_ want set when the goal of the above
| code is to drop privs.

Your concern is for the situation when the garbage happens to correspond
to an apparently meaningful setting for the upper capability bits? The
problem being that this privileged application is more privileged than
intended? I agree that this is not ideal.

In practice, however, this is only a real problem if named (or a
similarly structured program) has a security related bug in it. No?

Is this your concern, or have I missed something?

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFIN7T0+bHCR3gb8jsRAu87AJ4+ar3LeRol8/szzwgFvDYidQkFbgCeNEqj
0CfYnVW19WRc3H/gXs2wSVY=
=pQ8d
-----END PGP SIGNATURE-----
