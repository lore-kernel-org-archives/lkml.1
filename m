Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0BAP6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:58:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754733Ab0BAP6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:58:07 -0500
Date: Mon, 1 Feb 2010 07:57:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Michal Simek <michal.simek@petalogix.com>
cc: LKML <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions -
 221af7f87b97431e3ee21ce4b0e77d5411cf1549
In-Reply-To: <4B66DE64.8010101@petalogix.com>
Message-ID: <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain>
References: <4B66DE64.8010101@petalogix.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Michal Simek wrote:
>
> Hi Peter and Linus,
> 
> commit 221af7f87b97431e3ee21ce4b0e77d5411cf1549 breaks anything on Microblaze.

Gaah. My original version of that patch very much tried to make it a no-op 
semantically, but then Peter made some preparatory changes for the next 
patch, so it actually changes semantics a bit. I was expecting that to be 
benign, but clearly there are issues.

> None reported any problem that's why I think that is Microblaze related.

Well, our previous handling of the critical stage of 'execve()' when we 
actually switch from the old process to the new was _so_ grotty that many 
architectures ended up playing some really subtle games there. The whole 
point of the patch is to get rid of the games, but it's entirely possible 
that Microblaze (and others) had crazy things going on that broke when we 
made the ordering more straightforward.

That said, Microblaze is not one of the architectures I would have 
expected to have problems. It has one of the most straightforward 
"flush_thread()" implementations in the whole kernel (it's a no-op ;), and 
that's where most of the hacky things were for the architectures that 
needed the change. And it has no "arch_pick_mmap_layout()" issues or 
anything else that tends to depend on personality bits or whatever.

Microblaze is a no-MMU platform, isn't it? Which binary format does it 
use? It looks like _some_ binaries work (it seems to happily be running a 
shell to actually do those startup scripts) while others have problems. Is 
there a difference between "/bin/sh" and the binaries that seem to be 
problematic (like /bin/mount and /bin/ifup).

Are the failing binaries all setuid ones, for example? Or shared vs 
non-shared? Or ELF vs FLAT or whatever?

		Linus
