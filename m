Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZA2SqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZA2SqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZA2SqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:46:07 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:51255 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZA2SqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:46:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 29 Jan 2009 10:46:04 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Bron Gondwana <brong@fastmail.fm>
Subject: Re: [patch] drop epoll max_user_instances and rely only on
 max_user_watches
In-Reply-To: <20090129005716.6dd51929.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901291020510.15448@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901282010250.21401@alien.or.mcafeemobile.com> <20090129005716.6dd51929.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Andrew Morton wrote:

> 
> > Subject: [patch] drop epoll max_user_instances and rely only on max_user_watches
> 
> nanonit: please prepare titles in the form "subsystem-id:
> what-i-did-to-it", so a suitable name here would be
> 
> 	epoll: drop max_user_instances and rely only on max_user_watches

Sorry, I forgot, again. I sent those by hand, while I have that logic in 
my scripts.



> On Wed, 28 Jan 2009 20:56:07 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Linus suggested to put limits where the money is, and max_user_watches 
> > already does that w/out the need of max_user_instances. That has the 
> > advantage to mitigate the potential DoS while allowing pretty generous 
> > default behavior.
> 
> A reader of this changelog would be wondering what this DoS is.

	for i 1..1021
		fd[i] = epoll_create()
	for i 1..1021
		for j 1..1021, j != i
			epoll_ctl(fd[i], ADD, fd[j])

I'm not sure we want to advertise it too much though.


> > Allowing top 4% of low memory (per user) to be allocated in epoll 
> > watches, we have:
> > 
> > LOMEM    MAX_WATCHES (per user)
> > 512MB    ~178000
> > 1GB      ~356000
> > 2GB      ~712000
> > 
> > A box with 512MB of lomem, will meet some challenge in hitting 180K 
> > watches, socket buffers math teaches us.
> > No more max_user_instances limits then.
> 
> So the max consumable memory is
> 
> 	number-of-users * max_user_watches * sizeof(whatever)
> 
> ?
> 
> So if enough users gang up (or if one person has access to a lot of
> UIDs), there's still a DoS?
> 
> I suspect we can live with that.

I think so, given that we've seen that putting too restrictive limits 
creates more problems. A similar thing, even though milder, exist on 
sys_poll too. sys_poll eats (on a 32bit box) 28 bytes of kernel memory for 
each 12 bytes of user memory, worse figures on a 64bit box.



> I assume that because you based all this on all the other patches, you
> view it as 2.6.30 material?
> 
> > @@ -581,10 +570,6 @@
> 
> please use `diff -p'.  It helps.

Need to add to my quilt diff options :)



> The code I have is
> 
> 	if (error < 0)
> 		ep_free(ep);
> 	else
> 		atomic_inc(&ep->user->epoll_devs);
> 
> so I obviously nuked the `else' as well.

That's the right thing.


- Davide


