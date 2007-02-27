Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbXB0Buu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbXB0Buu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 20:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXB0Buu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 20:50:50 -0500
Received: from smtpout.mac.com ([17.250.248.171]:49274 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbXB0But (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 20:50:49 -0500
In-Reply-To: <45E376E8.8020901@zytor.com>
References: <20060724085701.B2083275@wobbly.melbourne.sgi.com> <200607242031.11815.a.gruenbacher@computer.org> <45E36D39.2030605@zytor.com> <20070226.154308.112620497.davem@davemloft.net> <45E372CA.9020709@zytor.com> <20070227000318.GA3448@infradead.org> <45E376E8.8020901@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3E0E2D98-5FEC-403E-831F-2B5BE6A3281A@mac.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>,
       a.gruenbacher@computer.org, bunk@stusta.de,
       linux-kernel@vger.kernel.org, jmorris@redhat.com, dwmw2@infradead.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: include/linux/xattr.h: how much userpace visible?
Date: Mon, 26 Feb 2007 20:49:00 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 26, 2007, at 19:10:16, H. Peter Anvin wrote:
> Christoph Hellwig wrote:
>> What's the problem of exposing all these APIs unconditionally?   
>> glibcs should either use all information from the linux/ headers  
>> or nothing at all, but not depend on hiding some bits.
>
> It's not always that simple.  In particular, in some files there  
> might be typedefs or structure tags that step on libc's namespace  
> (but are useful to other libcs), but ABI constants that are  
> universally useful.
>
> One way to deal with the particular issue of structure tags which  
> is probably even more useful is:
>
> #if defined(__KERNEL__) || defined(__KERNEL_EXPORT_STRUCTURES)
> # define __kstruct_stat stat
> #endif
>
> struct __kstruct_stat {
> 	/* ...foo... */
> };
>
> ... which lets the libc export it into whatever namespace it wants  
> by #defining __kstruct macros accordingly.

Not a bad idea, but it could use some extra error checking to make  
sure that somebody remembers to "#define __kstruct_foo" before  
"#include <linux/foo.h>" (perhaps indirectly through linux/bar.h).   
Maybe something like this (plays nice with the very-basic unifdef  
parsing too):

#ifdef __KERNEL__
# define __kstruct_stat stat
# define __kstruct_foo foo
# define __kstruct_bar bar
#endif

#ifdef __LINUX_KERNEL_EXPORT
# define __kstruct_stat stat
# define __kstruct_foo foo
# define __kstruct_bar bar
#endif

#ifndef __kstruct_stat
# error "Missing definition of __kstruct_stat, please insert:"
# error "  #define __kstruct_stat <name-for-stat-struct>"
# error "into your C file before '#include <linux/foo.h>'"
#endif
struct __kstruct_stat {
}

Someone who wanted to keep the name __kstruct_stat could of course  
"#define __kstruct_stat __kstruct_stat" easily.

Cheers,
Kyle Moffett

