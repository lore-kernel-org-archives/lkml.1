Return-Path: <linux-kernel-owner+w=401wt.eu-S1946094AbXBBVaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946094AbXBBVaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946096AbXBBVaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:30:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41292 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946094AbXBBVaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:30:30 -0500
Date: Fri, 2 Feb 2007 13:30:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070202213019.202e8db5@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702021322310.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202195932.15b9b4ed@localhost.localdomain>
 <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
 <20070202213019.202e8db5@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Feb 2007, Alan wrote:
> 
> The brown and sticky will hit the rotating air impeller pretty hard if you
> are not very careful about how that ends up scheduled

Why do you think that?

With cooperative scheduling (like the example Zach posted), there is 
absolutely no "brown and sticky" wrt any CPU usage. Which is why 
cooperative scheduling is a *good* thing. If you want to blow up your 
1024-node CPU cluster, you'd to it with "real threads".

Also, with sane default limits of fibrils per process (say, in the 5-10), 
it also ends up beign good for IO. No "insane" IO bombs, but an easy way 
for users to just just get a reasonable amount of IO parallelism without 
having to use threading (which is hard).

So, best of both worlds.

Yes, *of*course* you want to have limits on outstanding work. And yes, a 
database server would set those limits much higher ("Only a thousand 
outstanding IO requests? Can we raise that to ten thousand, please?") than 
a regular process ("default: 5, and the super-user can raise it for you if 
you're good").

But there really shouldn't be any downsides.

(Of course, there will be downsides. I'm sure there will be. But I don't 
see any really serious and obvious ones).

> Other minor evil. If we use fibrils we need to be careful we
> know in advance how many fibrils an operation needs so we don't deadlock
> on them in critical places like writeout paths when we either hit the per
> task limit or we have no page for another stack.

Since we'd only create fibrils on a system call entry level, and system 
calls are independent, how would you do that anyway?

Once a fibril has been created, it will *never* depend on any other fibril 
resources ever again. At least not in any way that any normal non-fibril 
call wouldn't already do as far as I can see.

		Linus
