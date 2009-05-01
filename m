Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZEANmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZEANmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbZEANmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:42:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42381 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbZEANmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:42:08 -0400
Date: Fri, 1 May 2009 09:32:26 -0400
From: Josef Bacik <josef@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josef Bacik <jbacik@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com, stable@kernel.org
Subject: Re: [PATCH] fiemap: fix problem with setting FIEMAP_EXTENT_LAST
Message-ID: <20090501133226.GE7076@unused.rdu.redhat.com>
References: <1241113491-9031-1-git-send-email-jbacik@redhat.com> <20090430154047.5485759f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430154047.5485759f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:40:47PM -0700, Andrew Morton wrote:
> On Thu, 30 Apr 2009 13:44:51 -0400
> Josef Bacik <jbacik@redhat.com> wrote:
> 
> > This patch fixes a problem where the generic block based fiemap stuff would not
> > properly set FIEMAP_EXTENT_LAST on the last extent.  I've reworked things to
> > keep track if we go past the EOF, and mark the last extent properly.  The
> > problem was reported by and tested by Eric Sandeen.
> > 
> 
> bleeearrggh.  __generic_block_fiemap() needs to be dragged out, shot,
> stabbed and doused in gasoline.
> 
> - uses stupid helper macros (blk_to_logical, logical_to_blk), thus
>   carefully obscuring the types of their incoming args and return value.
>

I did this to make it a bit more cleaner, so I didn't have a bunch of 

(blk << (inode)->i_blkbits)

type statements everywhere.  Do you have a better suggestion?  Would you like an
inline function, or do you want me to pepper the function with this stuff?
 
> - has kerneldoc which documents non-existent arguments and fails to
>   document the actual arguments.
>

Yes thats my fault, sorry.  Things got changed between my original submissions
and I never fixed that, I will take care of that now.
 
> - has a local variable called `tmp'.
>

Sorry, fixing that as well.
 
> - Uses random and seemingly irrational mixture of u64's and `long
>   long's, thus carefully confusing readers who would prefer to see
>   loff_t, sector_t, etc so they have a fighting chance of understanding
>   what the hell the thing does.
>

Hrm well I needed the long long to see if we mapped past where we wanted to, but
I can do that a different way.  I will fix this as well.
 
> - exists as useful counterexample for Documentation/CodingStyle
> 
> - has undocumented locals called "length", "len" and "map_len", to
>   avoid any possibility of confusion.
> 
> - has a local called `start_blk' which has a suspiciously-small
>   32-bit type.  Because of all the above intense obfuscation efforts I
>   just cannot be assed working out whether or not if this is an actual
>   bug.
> 
> 
> Who the heck merged this turkey?
> 
> <checks>
> 
> Oh good, it wasn't me.
> 
> your patch:
> 
> - adds a string of booleans, unhelpfully typed with plain old `int'.
> 
> - seems to think that sentences start with lower-case letters.
> 
>

I will fix all of this as well, sorry.
 
> Sigh.
> 
> Does this bugfix need to be backported into 2.6.29?  Earlier?  If so, why?
>

Yes it does, it will screw anybody up who tries to use fiemap beyond just the
simple cases.  I will send you a updated patch shortly.  Thanks for the review,

Josef 
