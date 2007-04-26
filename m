Return-Path: <linux-kernel-owner+w=401wt.eu-S1031374AbXDZRej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031374AbXDZRej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031376AbXDZRej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:34:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031374AbXDZRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:34:38 -0400
Date: Thu, 26 Apr 2007 10:34:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Xavier Bestel <xavier.bestel@free.fr>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177607026.30284.197.camel@frg-rhel40-em64t-04>
Message-ID: <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
 <1177607026.30284.197.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Xavier Bestel wrote:
> 
> Won't there be problems if e.g. X tries to write something to its
> logfile after snapshot ?

Sure. But that's a user-level issue.

You do have to allow writing after snapshotting, since at a minimum, you'd 
want the snapshot itself to be written. So the kernel has to be fully 
running, and support full user space. No "degraded mode" like now.

So when I said "fully running user mode", I really meant it from the 
perspective of the kernel - not necessarily from the perspective of the 
"user". You do want to limit _what_ user mode does, but you must not limit 
it by making the kernel less capable.

Remounting mounted filesystems read-only sounds like a good idea, for 
example. We can do that. We have the technology. But we shouldn't limit 
user space from doing other things (for example, it might want to actually 
*mount* a new filesystem for writing the snapshot image).

For example, right now we try to "fix" that with the whole process freezer 
thing. And that code has *caused* more problems than it fixed, since it 
tries to freeze all the kernel threads etc, and you simply don't have a 
truly *working*system*.

I think it's fine to freeze processes if that is what you want to do (for 
example, send them SIGSTOP), but we freeze them *too*much* right now, and 
the suspend stuff has taken over policy way too much. We don't actually 
leave the system in a runnable state. I can almost guarantee that you'd be 
*better* off having the snapshot taking thing do a

	kill(-1, SIGSTOP);

in user space than our current broken process freezer. At least that 
wouldn't have screwed up those kernel threads as badly as swsusp did.

And no, I'm not saying that my suggestion is the only way to do it. Go 
wild. But the *current* situation is just broken. Three different things, 
none of which people can agree on. I'd *much* rather see a conceptually 
simpler approach that then required, but even more important is that right 
now people aren't even discussing alternatives, they're just pushing one 
of the three existing things, and that's simply not viable. Because I'm 
not merging another one.

In fact, I personally feel that I shouldn't even have merged 
userspace-swsusp, but if Andrew thinks it needs to be merged, my personal 
feelings simply don't matter that much. I have to trust people. But yes, 
as far as *I* am personally concerned, I think it was a mistake to merge 
it.

			Linus
