Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbXIBA6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbXIBA6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932923AbXIBA6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:58:33 -0400
Received: from mail.tmr.com ([64.65.253.246]:38745 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885AbXIBA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:58:32 -0400
Message-ID: <46DA0AB1.8050504@tmr.com>
Date: Sat, 01 Sep 2007 20:58:25 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
References: <000701c7eb49$cff701c0$6fe50540$@com>	 <1188513433.6626.24.camel@heimdal.trondhjem.org>	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org>
In-Reply-To: <1188577275.6649.133.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Thu, 2007-08-30 at 20:49 -0700, Linus Torvalds wrote:
>> Please send in a fix. If the fix involves making "nosharecache" the 
>> default, then that is better than making policy decisions like this in the 
>> kernel. The kernel should do what the user asks and not put in unnecessary 
>> roadblocks.
> 
> The best I can do given the constraints appears to be to have the kernel
> first look for a superblock that matches both the fsid and the
> user-specified mount options, and then spawn off a new superblock if
> that search fails. The attached patch does just that.
> 
I'm glad I read the whole thread, because when I saw it earlier and 
didn't respond, this was the question I had, why not replace the error 
with forcing "nosharecache" on, which is essentially what you have done.

> Note that this is not the same as specifying nosharecache everywhere
> since nosharecache will never attempt to match an existing superblock.
> 
> Finally, for the record: I still feel very uncomfortable about not being
> able to report the state of the client setup back to the sysadmin.
> AFAIK, the only way to do so is to stat the mountpoints, and compare the
> device ids.
> 
Since clients may not know the server setup, and it may change for 
policy or error recovery reason, I think this patch is needed.

The cases I think are common are:

1 - single export, multiple client mounts

export /base - rw

mount /base/share - ro		[ client enforces r/o or not ]
mount /base/upload - rw

2 - export parts of a filesystem (/base) [ server enforces access ]

export /base/share - ro		[ hopefully really r/o on client ]
export /base/upload - rw	[ should work for write ]

3 - mount the same f/s with different permissions on client

export /base - rw

mount /base on point1 - rw	[ hopefully really r/w ]
mount /base on point2 - ro	[ hopefully r/o ]

I consider this *really* bad practice, but I have seen it in enough 
places to know others don't agree. It assumes the client will protect 
the r/o data.

4 - export f/s and part of f/s

export /base/ - ro
export /base/upload - rw

clients may mount one or both, with the upload directory as part of base 
or elsewhere. What will happen here?

> Trond


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
