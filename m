Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbYHAWxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbYHAWxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbYHAWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:53:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:34903 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171AbYHAWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=qIqSXCbQHSp924bkQO9lIrsznvvo96bhY0vMSHQT33sEGj+3XlEG+JZMsmDd1v+hlA
         ArpLKIaOqp69zkcSwpxXMorkhxDuJWDeRAVYNzIukmk4kM786jq/lD72h1Ipv5fP/+Fu
         f0CLL9ZxTQc57A7+5bk3rLNjl7SbXg3nOKJ6k=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org>
	<m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0807301016020.3334@nehalem.linux-foundation.org>
	<m3abfyqgbg.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0808011308470.3277@nehalem.linux-foundation.org>
	<m3wsj0l7cv.fsf@gravicappa.englab.brq.redhat.com>
	<alpine.LFD.1.10.0808011524150.6819@nehalem.linux-foundation.org>
Date: Sat, 02 Aug 2008 00:53:32 +0200
In-Reply-To: <alpine.LFD.1.10.0808011524150.6819@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 1 Aug 2008 15:30:26 -0700 (PDT)")
Message-ID: <m3sktol53n.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I was actually thinking more along the lines of actually doing a 
> test-suite with the few most relevant system calls (to catch the few cases 
> that matter), and judicious use of mmap/munmap to make sure to trigger it 
> in-kernel.

Well, my test is a kernel module (with help of systemtap). It tests
copy_from_user, copy_to_user, copy_user_generic_unrolled,
copy_user_generic_string and __copy_user_nocache directly. Test
allocates a page in kernel space and uses a page in user space (this is
for range checks in copy_from/to_user) and tries to make a fault in
every possible place of these routines. I don't know how to get a
userspace page from kernel module easily, and did a dirty hack with
available pages and sys_mprotect. However, it works.

> It probably doesn't really need all that many system calls to trigger all 
> the relevant paths. A "read()" should trigger the "to_user()" case, and a 
> write() to a file should trigger the 'from_user_nocache()" case. And while 
> the "from_user()" case with zeroing migth be harder to see (because all 
> _normal_ users should also look at the error case and return EFAULT), I 
> think there are a few cases where we just depend on the zeroing.

I found it hard to do a good testing for copy_user from user space
program and have used systemtap.

> Doing a
>
> 	git grep '	copy_from_user('
>
> (that's a tab in that grep thing) shows at least the termios code doing 
> it, for example. But fewer cases than I expected.
>
> 			Linus

It might be a good idea to find such potentially faulty places.

-- 
wbr, Vitaly
