Return-Path: <linux-kernel-owner+w=401wt.eu-S965173AbXHaML7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965173AbXHaML7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 08:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964879AbXHaMLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 08:11:51 -0400
Received: from pat.uio.no ([129.240.10.15]:40680 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964790AbXHaMLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 08:11:50 -0400
Subject: Re: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakob Oestergaard <jakob@unthought.net>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
	 <1188535485.6626.85.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
	 <1188536658.6626.98.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302215280.25853@woody.linux-foundation.org>
	 <20070831074028.GR21979@unthought.net>
	 <alpine.LFD.0.999.0708310055010.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 08:11:38 -0400
Message-Id: <1188562298.6649.39.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.041)
X-UiO-Scanned: 5DC3F5105AA904E67C01C982F9E3A38AE51849E3
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 384 total 3586973 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 01:07 -0700, Linus Torvalds wrote:
> 

> If you want new behaviour, you add a new flag saying you want new 
> behaviour. You don't just start behaving differently from what you've 
> always done before (and what *other* UNIXes do, for that matter).
> 
> Besides, even *if* it was a matter of somebody doing a mount with "rw", 
> when the previous mount was "ro", returning EBUSY is still the wrong thing 
> to do! If the user asks for a new mount that is read-write, he should just 
> get it - ie we should not re-use the old client handles, and we should do 
> what Solaris apparently does, namely to just make it a totally different 
> mount.
> 
> In other words, it should (as I already mentioned once) have used 
> "nosharecache" by default, which makes it all work.
> 
> Then, people who want to re-use the caches (which in turn may mean that 
> everything needs to have the same flags), THOSE PEOPLE, who want the NEW 
> SEMANTICS (errors and all) should then use a "sharecache" flag.

That would be a major change in existing semantics. The default has been
"sharecache" ever since Al Viro introduced the "sget()" function some 6
or 7 years ago. The problem was that we never advertised the fact that
the kernel was overriding your mount options, and so sysadmins were
(rightly IMO) complaining that they should _know_ when the client does
this.

The list of known problems with a "nosharecache" default is nasty too:
        
        - file and directory attribute and data caching breaks.
        Applications will see stale data in cases where they otherwise
        would not expect it.
        
        - the existing dcache and icache issues when a file is renamed
        or deleted on the server are now extended to also include the
        case where the rename or deletion occurs on an alias in another
        directory on the client itself. In particular, sillyrename will
        break.
        
        - file locking breaks (the server knows that the client holds
        locks on one file, whereas the client thinks it holds locks on
        several).
        
        - the NFSv4 delegation model breaks: the client will be using
        OPEN when it could use cached opens. More importantly, when
        performing an operation that requires it to return the
        delegation on the aliased file, it won't know until the server
        sends it a callback.

...and of course, the amount of unnecessary traffic to the server
increases. I'm not aware of any sane way of dealing with those issues,
and I doubt Solaris has a solution for them either.

Trond

