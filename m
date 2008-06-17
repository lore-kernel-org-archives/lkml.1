Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbYFQRJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbYFQRJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbYFQRJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:09:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766AbYFQRJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:09:05 -0400
Date: Tue, 17 Jun 2008 10:08:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <1213682570.13708.1258839317@webmail.messagingengine.com>
Message-ID: <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Bron Gondwana wrote:
> 
> And I appear to have sent the one without the usage comments at the top.
> Here they are:

Very interesting. There's certainly something there. 

That said, there's a distracting bug which is visible when doing an strace

 lseek(4, 140333890921392, SEEK_SET)     = -1 EINVAL (Invalid argument)
 write(4, "\0\0\0\0", 4)                 = 4

which is from that

	lseek(newfd, mapbase + offset + size - 8, 0);
	write(newfd, (char *) &zero, 4);

where the addition of "mapbase" is insane. So that will write zeroes to 
the wrong part of the file (offset 64, to be exact). And that will get 
overwritten by the next write, making it all look entirely insane.

That said, that bug may be distracting, but it seems to have nothign at 
all to do with the actual problem. The bug seems to happen only when the 
file is not pre-paged in.

Nick?

		Linus
