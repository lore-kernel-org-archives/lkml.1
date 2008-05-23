Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYEWQFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYEWQFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 12:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYEWQFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 12:05:01 -0400
Received: from sous-sol.org ([216.99.217.87]:34021 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYEWQFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 12:05:00 -0400
Date: Fri, 23 May 2008 08:57:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: capget() overflows buffers.
Message-ID: <20080523155718.GI30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org> <4835F929.7010200@kernel.org> <20080522233757.GD30402@sequoia.sous-sol.org> <48366D9A.70806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48366D9A.70806@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew G. Morgan (morgan@kernel.org) wrote:
> Chris Wright wrote:
> |> The kernel is not crashing, the application is...
> |
> | It's not about crashing.  It's about app security.  Currently, there is
> | nothing guaranteeing named has actually dropped privileges.  That's why
> | I consider this serious.
>
> I have to say the details of this are not clear to me. Can you sketch an
> example?

Sure.  named is doing this:

caps is essentially
CAP_NET_BIND_SERVICE|CAP_SYS_CHROOT|CAP_SETGID|CAP_DAC_READ_SEARCH|CAP_SYS_RESOURCE

linux_setcaps(cap_t caps) {
	struct __user_cap_header_struct caphead;
	struct __user_cap_data_struct cap;	<-- 12 bytes on stack
	memset(&caphead, 0, sizeof(caphead));
	caphead.version = _LINUX_CAPABILITY_VERSION;  <-- v2 now
	caphead.pid = 0;
	memset(&cap, 0, sizeof(cap));		<-- start initializing 12 bytes
	cap.effective = caps;
	cap.permitted = caps;
	cap.inheritable = 0;			<-- finish initializing 12 bytes
	if (syscall(SYS_capset, &caphead, &cap) < 0) <-- kernel copies in 24 bytes

So it's blindly setting v2.  The kernel is sucking in 24 bytes.  The
second set of u32s (the extra 12 bytes) is just garbage from the stack.
This could include setting CAP_MAC_OVERRIDE or CAP_MAC_ADMIN, percisely
the kinds of things you _wouldn't_ want set when the goal of the above
code is to drop privs.

> Otherwise, I find myself generally persuaded..
>
> | Yes, as they should.  I don't think we should ever expect an existing
> | userspace program change just by recompiling against a new kernel header
> | when using an already existing mechanism.  Their app has been working
> | fine since 2.2.
> |
> |   int fd = open("foo", O_FLAGS, mode);
> |
> | compile once...binary compatible going forward (as is cap{s,g}et).
> | update kernel, recompile...source API comaptible...still working
> | (this is broken in cap{s,g}et).
>
> [I guess that this was what libcap was all about, and why there are so
> many comments about using it littered through the kernel... Oh well.]
>
> | History bites us...libcap wasn't always there.  As we see, people roll
> [...]
>
> Not to pick holes in your argument, but libcap *has* always been there.
> It was co-developed with the original kernel patches.

Yeah, that was confusing.  I didn't mean it hadn't been developed.
But all too often it wasn't picked up by distros.  And this is why apps
went the 'roll your own' direction.

> | No, the solution there would be to keep _LINUX_CAPABILITY_VERSION as
> | v1 (otherwise you just broke apps again).  And use another mechanism to
> | signal the availability of 64bit caps.
>
> Point taken. Patch attached.

Thanks, I'll comment on that in a different mail.
-chris
