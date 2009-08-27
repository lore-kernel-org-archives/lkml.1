Return-Path: <linux-kernel-owner+w=401wt.eu-S1751050AbZH0RYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbZH0RYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZH0RYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZH0RYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:24:40 -0400
Message-ID: <4A96C14C.8040105@redhat.com>
Date: Thu, 27 Aug 2009 10:24:28 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org>
In-Reply-To: <20090827171044.GA5427@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 10:10 AM, Christoph Hellwig wrote:
> The question is how to handle this at the libc level.  Currently glibc
> defines O_DSYNC to be O_SYNC.  We would need to update glibc to pass
> through O_DSYNC for newer kernels and make sure it falls back to O_SYNC
> for olders.  I'm not sure how feasible this is, but maybe Ulrich has
> some better ideas.

The problem with O_* extensions is that the syscall doesn't fail if the 
flag is not handled.  This is a problem in the open implementation which 
can only be fixed with a new syscall.

Why cannot just go on and say we interpret O_SYNC like O_SYNC and 
O_SYNC|O_DSYNC like O_DSYNC.  The POSIX spec explicitly requires that 
the latter handled like O_SYNC.

We could handle it by allocating two bits, only one is handled in the 
kernel.  If the O_DSYNC definition for userlevel would be different from 
the kernel definition then the kernel could interpret O_SYNC|O_DSYNC 
like O_DSYNC.  The libc would then have to translate the userlevel 
O_DSYNC into the kernel O_DSYNC.  If the libc is too old for the kernel 
and the application, the userlevel flag would be passed to the kernel 
and nothing bad happens.

The cleaner alternative is to have a sys_newopen which checks for 
unknown flags and fails in that case.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
