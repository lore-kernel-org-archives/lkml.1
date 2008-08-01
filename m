Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYHAWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYHAWbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYHAWbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:31:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981AbYHAWbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:31:10 -0400
Date: Fri, 1 Aug 2008 15:30:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
In-Reply-To: <m3wsj0l7cv.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0808011524150.6819@nehalem.linux-foundation.org>
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org> <m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807301016020.3334@nehalem.linux-foundation.org>
 <m3abfyqgbg.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0808011308470.3277@nehalem.linux-foundation.org> <m3wsj0l7cv.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Aug 2008, Vitaly Mayatskikh wrote:
> 
> Well, I have sanity test for it (at http://people.redhat.com/vmayatsk/copy_user_x8664/), 
> but unfortunately it shows what I want to see, not the truth. I'm going
> to make a large regression testing next week.

I was actually thinking more along the lines of actually doing a 
test-suite with the few most relevant system calls (to catch the few cases 
that matter), and judicious use of mmap/munmap to make sure to trigger it 
in-kernel.

It probably doesn't really need all that many system calls to trigger all 
the relevant paths. A "read()" should trigger the "to_user()" case, and a 
write() to a file should trigger the 'from_user_nocache()" case. And while 
the "from_user()" case with zeroing migth be harder to see (because all 
_normal_ users should also look at the error case and return EFAULT), I 
think there are a few cases where we just depend on the zeroing.

Doing a

	git grep '	copy_from_user('

(that's a tab in that grep thing) shows at least the termios code doing 
it, for example. But fewer cases than I expected.

			Linus
