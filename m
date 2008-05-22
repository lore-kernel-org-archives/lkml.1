Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbYEVUyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbYEVUyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYEVUy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:54:29 -0400
Received: from sous-sol.org ([216.99.217.87]:54135 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145AbYEVUy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:54:28 -0400
Date: Thu, 22 May 2008 13:53:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Dave Jones <davej@codemonkey.org.uk>, Andrew Morgan <morgan@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com
Subject: Re: capget() overflows buffers.
Message-ID: <20080522205341.GA30402@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk> <20080522175744.GE4018@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522175744.GE4018@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> Yes, this thing is broken.

Andrew, I think this should be considered a serious problem.  The
interface ABI is stable for old programs, and fine for anything new
or old that's using libcap.  But the API has changed subtly (taking a
pointer to a blob, to a pointer to an array of blobs), and is easily
broken for programs recompiled against new headers not using libcap.

For the squid issue at least it does capget/capset, so it's likely to
write back in capset the caps it got in capget (when it doesn't hit
glibc heap overflow protection).

But bind, for example, could have garbage in the upper 32bits on a 64bit
caps system that does not HAVE_LIBCAP:

(Note: snipped it down to make it readable, removed some ifdef
HAVE_LIBCAP, etc)

linux_setcaps(cap_t caps) {
	struct __user_cap_header_struct caphead;
	struct __user_cap_data_struct cap;	<-- just one set of u32s
<snip>
	memset(&caphead, 0, sizeof(caphead));
	caphead.version = _LINUX_CAPABILITY_VERSION; <-- v2
	caphead.pid = 0;
	memset(&cap, 0, sizeof(cap));
	cap.effective = caps;
	cap.permitted = caps;
	cap.inheritable = 0;			<-- fill in just that set
<snip>
	if (syscall(SYS_capset, &caphead, &cap) < 0) {
                                          ^^^ kernel pulls 2 sets of
					  u32s, send is just junk from
					  stack



For the squid case that Bojan described:
(Note: snipped it down again)

restoreCapabilities(int keep)
{
    cap_user_header_t head = (cap_user_header_t) xcalloc(1, sizeof(cap_user_header_t));
    cap_user_data_t cap = (cap_user_data_t) xcalloc(1, sizeof(cap_user_data_t));
    head->version = _LINUX_CAPABILITY_VERSION;
    if (capget(head, cap) != 0) {
<snip>
    head->pid = 0;
    cap->inheritable = 0;
    cap->effective = (1 << CAP_NET_BIND_SERVICE);
<snip>
    if (!keep)
        cap->permitted &= cap->effective;
    if (capset(head, cap) != 0) {

I don't see a nice solution, short reverting, and adding a new set of
syscalls to support 64-bit.

thanks,
-chris
