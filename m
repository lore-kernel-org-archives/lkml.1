Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbXHaIJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbXHaIJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 04:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXHaIIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 04:08:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbXHaIIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 04:08:48 -0400
Date: Fri, 31 Aug 2007 01:07:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakob Oestergaard <jakob@unthought.net>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <20070831074028.GR21979@unthought.net>
Message-ID: <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
 <1188535485.6626.85.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
 <1188536658.6626.98.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org>
 <20070831074028.GR21979@unthought.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Jakob Oestergaard wrote:
> 
> Trond has a point Linus.

I don't dispute that the new code does somethign good.

But it changes existing behaviour.

When we add NEW BEHAVIOUR, we don't add it to old interfaces when that 
breaks old user mode! We add a new flag saying "I want the new behaviour".

This is not rocket science, guys. This is very basic kernel behaviour. The 
kernel exists only to serve user space, and that means that there is no 
more important thing to do than to make sure you don't break existing 
users, unless you have some *damns* strong reasons.

> What he "broke" is, for example, a ro mount being mounted as rw.

No. What he broke was a working and sane setup.

The fact that he may *also* have broken insane setups is totally 
irrelevant. Don't go off on some tangent that has nothing to do with the 
regression in question!

> If ext3 in some rare case (which would still mean it hit a few thousand users)
> failed to remember that a file had been marked read-only and allowed writes to
> it, wouldn't we want to fix that too?  It would cause regressions, but we'd fix
> it, right?

Stop blathering. Of course we fix security holes. But we don't break 
things that don't need breaking. This wasn't a security hole.

You are making up irrelevant arguments that have nothing to do with this 
regression.

If you want new behaviour, you add a new flag saying you want new 
behaviour. You don't just start behaving differently from what you've 
always done before (and what *other* UNIXes do, for that matter).

Besides, even *if* it was a matter of somebody doing a mount with "rw", 
when the previous mount was "ro", returning EBUSY is still the wrong thing 
to do! If the user asks for a new mount that is read-write, he should just 
get it - ie we should not re-use the old client handles, and we should do 
what Solaris apparently does, namely to just make it a totally different 
mount.

In other words, it should (as I already mentioned once) have used 
"nosharecache" by default, which makes it all work.

Then, people who want to re-use the caches (which in turn may mean that 
everything needs to have the same flags), THOSE PEOPLE, who want the NEW 
SEMANTICS (errors and all) should then use a "sharecache" flag.

See? You don't have to screw people over.

> mount passes back the error code on a failed mount. autofs passes that error
> along too (when people configure syslog correctly). In short; when these
> serious mistakes are made and caught, the admin sees an error in his logs.

Bullshit. "Seeing the error in his logs" doesn't help anything. The 
problem wasn't the lack of error, the problem was that it was a new and 
unnecessary error in the first place. Logging it doesn't make it any less 
buggy.

			Linus
