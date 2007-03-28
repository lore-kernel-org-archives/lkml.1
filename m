Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXC1V7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXC1V7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbXC1V7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:59:13 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:18563 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbXC1V7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:59:12 -0400
Date: Wed, 28 Mar 2007 23:59:07 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jikos@jikos.cz>, Lee Revell <rlrevell@joe-job.com>,
       Toralf F?rster <toralf.foerster@gmx.de>, andrea@suse.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
Message-ID: <20070328215907.GA28682@localdomain>
References: <200703281847.05356.toralf.foerster@gmx.de> <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com> <Pine.LNX.4.64.0703281909240.29565@twin.jikos.cz> <20070328131454.cdb06bc3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328131454.cdb06bc3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 01:14:54PM -0700, Andrew Morton wrote:
> On Wed, 28 Mar 2007 19:23:32 +0200 (CEST)
> Jiri Kosina <jikos@jikos.cz> wrote:
> 
> > blockdev: bd_claim_by_kobject() could check value of unititalized pointer
[..]
> > @@ -950,7 +950,7 @@ static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
> >  				struct kobject *kobj)
> >  {
> >  	int res;
> > -	struct bd_holder *bo, *found;
> > +	struct bd_holder *bo, *found = NULL;
> 
> that generates extra code and people get upset.

I, for one, not upset. On the contrary.

IMHO gcc should be smart enough to optimize that code properly with that 
"= NULL" added. 

BTW with gcc 4.1.2 on x86_64 that warning doesn't get emitted, and it 
generates the same exact code with or without " = NULL". One could aruge,
if people are upset about more code being generated because they use an 
older stable branch of gcc, it's _their_ problem.

> 	struct bd_holder *found;
> 
> 	squash_bogus_uninit_warning(found);	/* useful comment goes here */
> 
> which is also unpleasant, but not as unpleasant as a screenful of warnings
> which hide real problems, IMO.

If there was such 'squash_bogus_uninit_warning' macro exist and in use,
then this could have been a possible scenario:

  A) There's some 200-lines long function.
  B) It has a squash_bogus_uninit_warning() somewhere in the beginning.
  C) Someone commits a patch that uses an uninitialized variable on _some_
     cases and it doesn't generate a warning.
  D) You get an 'heisenbug', since that pointer might point to something
     that is dereferencable without a fault, etc.

I think that warnings of these kind (assuming that they are not generated
as a result of deficiencies in the latest stable version of gcc) exist
for a damn good reason - the code should be fixed and that warning 
shouldn't be bypassed in semi-nasty ways.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
