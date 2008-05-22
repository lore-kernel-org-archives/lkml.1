Return-Path: <linux-kernel-owner+w=401wt.eu-S935654AbYEVWw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935654AbYEVWw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933729AbYEVWw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:52:28 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:52843 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762008AbYEVWw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:52:27 -0400
Message-ID: <4835F929.7010200@kernel.org>
Date: Thu, 22 May 2008 15:52:25 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com
Subject: Re: capget() overflows buffers.
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org> <20080522205341.GA30402@sequoia.sous-sol.org>
In-Reply-To: <20080522205341.GA30402@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chris Wright wrote:
| * Chris Wright (chrisw@sous-sol.org) wrote:
|> Yes, this thing is broken.
|
| Andrew, I think this should be considered a serious problem.  The
| interface ABI is stable for old programs, and fine for anything new
| or old that's using libcap.  But the API has changed subtly (taking a
| pointer to a blob, to a pointer to an array of blobs), and is easily
| broken for programs recompiled against new headers not using libcap.

[There is a warning about this issue in the kernel header file.]

The kernel is not crashing, the application is...

If you take this compiled binary, that crashes on 2.6.25, and try to run
it on 2.6.24 it will fail there too - since the magic its 'forcing' is
not valid on that kernel. So the compiled 'binary' we're discussing does
not have an existence proof that it will successfully run anywhere.

In point of fact, the kernel is binary compatible with old binaries. The
problem is that _LINUX_CAPABILITY_VERSION #define now points to _2
instead of _1 by default and Squid etc., are not paying attention to the
value of the new magic cookie but expecting the previous revision of the
ABI to work.

As such, I don't agree that there is a problem with the ABI, and I don't
agree with your assertion about things being broken. I maintain there is
a problem with the application source code.

One 'solution' is to force everyone to notice at compile time by simply
removing the definition of _LINUX_CAPABILITY_VERSION and force all new
source code to be explicit about which ABI it wants to use...

Cheers

Andrew

| For the squid issue at least it does capget/capset, so it's likely to
| write back in capset the caps it got in capget (when it doesn't hit
| glibc heap overflow protection).
|
| But bind, for example, could have garbage in the upper 32bits on a 64bit
| caps system that does not HAVE_LIBCAP:
|
| (Note: snipped it down to make it readable, removed some ifdef
| HAVE_LIBCAP, etc)
|
| linux_setcaps(cap_t caps) {
| 	struct __user_cap_header_struct caphead;
| 	struct __user_cap_data_struct cap;	<-- just one set of u32s
| <snip>
| 	memset(&caphead, 0, sizeof(caphead));
| 	caphead.version = _LINUX_CAPABILITY_VERSION; <-- v2
| 	caphead.pid = 0;
| 	memset(&cap, 0, sizeof(cap));
| 	cap.effective = caps;
| 	cap.permitted = caps;
| 	cap.inheritable = 0;			<-- fill in just that set
| <snip>
| 	if (syscall(SYS_capset, &caphead, &cap) < 0) {
|                                           ^^^ kernel pulls 2 sets of
| 					  u32s, send is just junk from
| 					  stack
|
|
|
| For the squid case that Bojan described:
| (Note: snipped it down again)
|
| restoreCapabilities(int keep)
| {
|     cap_user_header_t head = (cap_user_header_t) xcalloc(1,
sizeof(cap_user_header_t));
|     cap_user_data_t cap = (cap_user_data_t) xcalloc(1,
sizeof(cap_user_data_t));
|     head->version = _LINUX_CAPABILITY_VERSION;
|     if (capget(head, cap) != 0) {
| <snip>
|     head->pid = 0;
|     cap->inheritable = 0;
|     cap->effective = (1 << CAP_NET_BIND_SERVICE);
| <snip>
|     if (!keep)
|         cap->permitted &= cap->effective;
|     if (capset(head, cap) != 0) {
|
| I don't see a nice solution, short reverting, and adding a new set of
| syscalls to support 64-bit.
|
| thanks,
| -chris
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFINfkp+bHCR3gb8jsRAll6AKCfgKejl/TtJX6KfbbEb8dQbleMXgCgp20B
fsAGaykQUensyYfL9hxlp9Q=
=w+GH
-----END PGP SIGNATURE-----
