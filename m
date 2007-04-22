Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXDVSr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXDVSr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932140AbXDVSr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:47:57 -0400
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:49812 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbXDVSry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:47:54 -0400
From: Junio C Hamano <junkio@cox.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] GIT 1.5.1.2
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net>
	<7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
cc: "Randal L. Schwartz" <merlyn@stonehenge.com>, Nicolas Pitre <nico@cam.org>
Date: Sun, 22 Apr 2007 11:47:52 -0700
In-Reply-To: <alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
	(Linus Torvalds's message of "Sun, 22 Apr 2007 10:22:47 -0700 (PDT)")
Message-ID: <7v7is4nt47.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, 21 Apr 2007, Junio C Hamano wrote:
>>
>> The latest maintenance release GIT 1.5.1.2 is available at the
>> usual places:
>
> Well, by "available" you probably mean "not available", because it doesn't 
> actually work.
>
> I get EPERM on pack-e00affefe0f779d0f9b0507aef25a1733f4a9117.idx/pack, 
> because they are
>
> 	-r-------- 1 junio junio  1120880
> 	-r-------- 1 junio junio 15709370
>
> respectively.
> ...
> Oops.

Ok, to clarify the situation.

 * This breakage does not make v1.5.1.2 is a dud release, as what
   caused this is not contained in it.

 * A topic to update git-pack-objects has been cooking in 'next'
   and it graduated to 'master' last night after v1.5.1.2 was
   cut from 'maint'.  This series had a bug that left permission
   bits as set by mkstemp(); newer glibc leaves it as 0600.

 * I almost always run 'master' on kernel.org; I ran "git-repack
   -a -d" there using 'master' that contained the breakage.

 * git-repack lets git-pack-objects to create pack/idx, and then
   drops the write permission bits from them.  That is how they
   got 0400.

 * I've fixed the pack/idx 0444 manually at kernel.org; the
   repository has already mirrored out to git.kernel.org, so
   people should be able to fetch from there now.  alt-git.git
   at repo.or.cz should be usable as well, although I suspect
   the site did not even have this issue.

 * I sent a quickfix as a workaround.  Because we rely on
   git-repack to drop write permissions anyway, and some tests
   to plumbing expects the resulting files to be writable by the
   owner, tweaking 0444 in the quickfix to 0644 would be a good
   workaround to fix the problem -and- pass all the test.

So I'll push out a 0644 quickfix on 'master' shortly.

However.

 * To reiterate, people planning to update to v1.5.1.2 should
   not be alarmed with this gotcha.  That comes from the
   maintenance branch and is not affected by this breakage.

 * Letting mkstemp() to create the file and then forcing 0644 is
   not strictly correct, as it makes the files created by people
   with 007 umask readable to the general public.  The code
   before mkstemp() conversion was aware of this issue and used
   open(..., 0666) to let the user's umask applied, I think.

So while the quickfix is an improvement, it not a real fix X-<.


