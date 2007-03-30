Return-Path: <linux-kernel-owner+w=401wt.eu-S1945956AbXC3JjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945956AbXC3JjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 05:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945960AbXC3JjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 05:39:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945956AbXC3JjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 05:39:15 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1175226172.15391.66.camel@roc-desktop> 
References: <1175226172.15391.66.camel@roc-desktop> 
To: bryan.wu@analog.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 30 Mar 2007 10:39:00 +0100
Message-ID: <10785.1175247540@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Bryan <bryan.wu@analog.com> wrote:

> It takes lots of time in malloc()->mmap()->do_mmap_private()->memset(). When
> malloc a big area, memset() the area to zero makes the performance very bad.

Ummm...

How do you then cope with attempting to run that same application under
MMU-mode Linux?  Won't MMU mmap() give EINVAL?  If so, then that'd be grounds
for NAK'ing this patch in the form given.

My theory is that NOMMU binaries should run just as well under an MMU-mode
kernel as under a NOMMU kernel.

What you're asking for is also a security risk - though obviously on NOMMU-mode
one that's fairly irrelevant.  It might even make a lot of sense there to move
the clearance into uClibc where possible rather than doing it in the kernel.

On MMU-mode kernels, the option should just be ignored.

I'd also recommend you stick a 'D' on the end of 'MAP_UNINITIALIZE' or may be
call it MAP_UNCLEARED'.  But that's a minor point, but you're not telling
mmap() to go and uninitialise the memory...

Lastly, why do you actually need VM_UNINITIALIZE at all?  The flag is only used
in a place where MAP_UNINITIALIZE is still available (okay, you'll have to hand
it down as an extra argument).  That looks like a waste of a VM_xxx flag, and
we don't have that many to spare.

David
