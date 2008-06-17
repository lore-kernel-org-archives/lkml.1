Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYFQUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYFQUmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYFQUmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:42:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260AbYFQUmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:42:08 -0400
Date: Tue, 17 Jun 2008 13:41:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Linus Torvalds wrote:
> 
> I actually am starting to think that the bug is in 
> __copy_to_user_inatomic_nocache().

Confirmed.

The uncached user copies are totally broken. The number of bytes left 
uncopied is simply wrong, because of how it does that unrolled loop and 
doesn't account for the fact that just doing loads does not actually 
increase the number of bytes copied at all.

So because the "copy_to_user_inatomic()" logic cares _deeply_ about how 
many bytes were actually copied, when the copy count is wrong, the code 
ends up thinking that it copied more bytes than it actually did, resulting 
in the corruption in the page cache.

Nasty.

That whole file is a mess. Sadly, so is the regular "copy_user_64.S" too 
(it has the same totally broken comment, too!), this is not just the 
uncached version.

And the only reason that it only shows up with the uncached version in 
_practice_ is that the routine that uses the x86 string instructions (ie 
the "rep movsq" in copy_user_generic_string) actually gets this all right. 

So the bug is hidden in that case - which is most CPU's out there (all 
CPU's that have X86_FEATURE_REP_GOOD set).

I don't think that code is reasonably salvageable. Damn. 

		Linus
