Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbXIDJFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbXIDJFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 05:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbXIDJFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 05:05:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbXIDJFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 05:05:11 -0400
Date: Tue, 4 Sep 2007 02:04:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <6503.1188894940@redhat.com>
Message-ID: <alpine.LFD.0.999.0709040152080.3088@evo.linux-foundation.org>
References: <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org>
 <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
 <1188577275.6649.133.camel@heimdal.trondhjem.org>
 <6503.1188894940@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Sep 2007, David Howells wrote:
> 
> That helps one case, yes, but what about a superset?  What about two sets that
> might intersect but for which you don't have the common root to hand?

Sure. In which case bind mounts don't work. Fair enough.

> The case I came up with was this:
> 
> 	mount home:/home/fred /home/fred
> 	mount home:/home/jim /home/jim

The much more trivial case is

	mount -o ro server:/usr/bin /usr/share/bin
	mount server:/usr/tmp /usr/share/tmp

and now tell me any reasonable reason why this should fail? (Replace "-o 
ro" with any other attributes).

Quite frankly, if the above two mounts fail - just beause /usr/bin and 
/usr/tmp happen to be on the same filesystem on the server - then the 
implementation is more than just buggy - it's a pure piece of shit.

And quite frankly, as far as I can tell, that was exactly what the NFS 
changes that are being discussed did. They failed the equivalent of the 
second mount, because it didn't have the same flags as the first one.

Can you really honestly say that wasn't totally broken?

> The reason I added all this NFS superblock sharing is so that I could implement
> on-disk local caching much more easily.  If, for instance, two netfs inodes
> aren't shared, but their "index keys" say they should use the same piece of
> cache then all sorts of fun ensues from the disjoint cache coherency.
> 
> Even working out that two inodes are using the same piece of cache isn't
> trivial (though it seems like it ought to be).

I'm just saying that the whole "require all mount flags to be identical, 
and error out if they are not" is pure and utter CRAP.

So anything that does that - for *any* reason what-so-ever - is just 
broken. If you require identical mount-time flags, that absolutely has to 
be a special case (like using "--bind", or perhaps using a special option 
like "sharecache").

It really is that simple. I don't know how anybody could possibly ever 
dispute that.

As far as I can tell, the current situation in NFS is "reasonably ok", but 
I already asked Trond about what happens with "remount" with the "same 
mount options imply sharecache" code that he did, and afaik, I never got 
an answer. In other words, let's change the above two commands to the 
following three commands:

	mount server:/usr/bin /usr/share/bin
	mount server:/usr/tmp /usr/share/tmp
	mount -o remount,ro /usr/share/bin

and I'm claiming that if the above fails (or remounts /usr/share/tmp as 
read-only too), then it's also obvious CRAP (replace "ro" with any other 
possible attribute - whether cache timeouts or similar)

See? It really is that simple. The obvious mount usage above absolutely 
*has* to work, and anything that breaks it is crap, crap, crap. And that 
was exactly what apparently happened here, and I really don't see why 
anybody has the *gall* to claim that the "default to sharecache" code 
wasn't totally broken.

			Linus
