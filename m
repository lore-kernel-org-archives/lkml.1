Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbYGYOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbYGYOyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYGYOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:54:11 -0400
Received: from gw.goop.org ([64.81.55.164]:55833 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbYGYOyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:54:10 -0400
Message-ID: <4889E90D.2000807@goop.org>
Date: Fri, 25 Jul 2008 07:54:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Alex Nixon (Intern)" <Alex.Nixon@eu.citrix.com>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Large increase in context switch rate
References: <487E43D9.7080703@goop.org> <87mykgrxtv.fsf@basil.nowhere.org> <0E902970173AF84089673FA54B7FE78A329073@lonpexch01.citrite.net> <200807241126.48364.nickpiggin@yahoo.com.au> <4889B9AE.3050108@citrix.com>
In-Reply-To: <4889B9AE.3050108@citrix.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> The relevant changeset had caused the blocksize to default to 1024 (as opposed
> to 4096) - as a result there was a large increase in the time spent waiting on
> pipes.
>   

Good work!

> Instead of re-adding the line taken out of fs/pipe.c by Theodore I opted instead
> to change the default block size for pseudo-filesystems to PAGE_SIZE, to try
> avoid making pipe.c inconsistent with Theodore's new approach.
>
> The performance penalty from these extra context switches is fairly small, but 
> is magnified when virtualization is involved, hence the desire to keep it lower
> if possible.
>
>
> From 4b568a72fc42b52279507eb4d1339e0637ae719a Mon Sep 17 00:00:00 2001
> From: Alex Nixon <t_alexn@alexn-desktop.(none)>
> Date: Fri, 25 Jul 2008 11:26:44 +0100
> Subject: [PATCH] VFS: increase pseudo-filesystem block size to PAGE_SIZE.
>
> Changeset ba52de123d454b57369f291348266d86f4b35070 caused the block size used
> by pseudo-filesystems to decrease from PAGE_SIZE to 1024 leading to a doubling
> of the number of context switches during a kernbench run.
>   

Probably worth explicitly noting the effect on pipe buffer size.

> Signed-off-by: Alex Nixon <Alex.Nixon@citrix.com>
> ---
>  fs/libfs.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/libfs.c b/fs/libfs.c
> index baeb71e..1add676 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -216,8 +216,8 @@ int get_sb_pseudo(struct file_system_type *fs_type, char *name,
>  
>  	s->s_flags = MS_NOUSER;
>  	s->s_maxbytes = ~0ULL;
> -	s->s_blocksize = 1024;
> -	s->s_blocksize_bits = 10;
> +	s->s_blocksize = PAGE_SIZE;
> +	s->s_blocksize_bits = PAGE_SHIFT;
>  	s->s_magic = magic;
>  	s->s_op = ops ? ops : &simple_super_operations;
>  	s->s_time_gran = 1;
>   

    J
