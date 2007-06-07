Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbXFGPl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbXFGPl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXFGPlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:41:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2488 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbXFGPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:41:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 08:41:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070607110623.53322dae@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0706070811270.6059@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu>
 <Pine.LNX.4.64.0706061619560.10383@alien.or.mcafeemobile.com>
 <20070607110623.53322dae@the-village.bc.nu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Alan Cox wrote:

> > I don't think it's a matter of versioning. Many userspace libraries 
> > expects their fds to be compact (for many reasons - they use select, they 
> > use them to index 0-based arrays, etc...), and if the kernel suddendly 
> > starts returning values in the 1<<28 up arena, they sure won't be happy.
> > So I believe that the correct way is that the caller specifically selects 
> > the feature, leaving the legacy fd allocation as default.
> 
> I don't understand the connection between this paragraph (with which I
> agree) and the urge to add a ton of ugly syscall hacks. "Caller
> specifically selects feature" - > prctl(). Libraries get unhappy ->
> linker issue.

I meant, caller specifically selects the feature, on a per-fd basis. If 
you select the task flag runtime, then all the allocated fds will be in 
the non-sequential area. Even fds allocated inside the library code, with 
libraries not expecting this. I fail to understand how a linker can nicely 
solve this. If my app is using, for its own reasons, fds in the 
non-sequential area, and library XYZ internally uses fds and does not like 
them in that area, I still want to link to that library. As long as I do 
not pass my fds to the library ("XYZ internally .."), this must still 
work. The contrary is also true. If my app is not non-sequential fd aware, 
and my library wants to use them in order to keep them alive from apps 
doing the for-each-fd-close loop, with a per-fd policy, you can still mix 
them together.
Or are you planning to have two sets of each userspace (userspace is not 
only glibc, there's other stuff too) libraries?



- Davide


