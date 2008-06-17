Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYFQVmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYFQVmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbYFQVmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:42:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56463 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbYFQVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:42:07 -0400
Message-ID: <48582FAB.1020402@firstfloor.org>
Date: Tue, 17 Jun 2008 23:42:03 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,	bisected,
 reproducable)
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org> <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org> <20080617213618.GL28946@ZenIV.linux.org.uk>
In-Reply-To: <20080617213618.GL28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Jun 17, 2008 at 02:24:39PM -0700, Linus Torvalds wrote:
> 
>> The whole *and*only* reason for copy_to/from_user() existing AT ALL is 
>> exactly the fact that the source or destination access can fault. 
> 
> Erm...  The reason for copy_to_user() existing is that dereferencing
> a user-supplied address in the kernel does not have to access any
> memory reachable in user mode, regardless of any faults. 

Well on x86 it is reachable, so it only handles faults.

> WTF are you
> guys talking about?

Linus seems to think that copy_to_user() should have
copy_in_user semantics(). It happens to be in some cases (when string instructions
are used), but not for the unrolled case.

What seems also confusing him is that x86-64 copy_from/to_user use a shared
subfunction. The trick that this subfunction uses is to assume that
either the destination faults or the source, but never both. It's legal
because the caller should never pass in a faulting source for copy to
or a faulting destination for copy from.

Actually they handle it, but the return value is not correct.

Now he "fixed" copy_to_user to return a kind of correct return value
for source faults, but it'll of course break copy_from_user()'s return value.

It's still unclear why his patch fixes the test case. The caller should
be using copy_in_user perhaps? Or is it just buggy by passing something
unmapped to copy_to_user?

-Andi

