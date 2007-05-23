Return-Path: <linux-kernel-owner+w=401wt.eu-S934459AbXEWQYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbXEWQYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXEWQYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:24:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:9500 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXEWQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SK6+L/iuQFd1q6MHTH7lnaDy2bz/5QwB0DST78I84ie1rVbzVdwzyd36uRvK60ZU+fzfy0FrKDodOLDoJl894DvXFmTzjGwZUIAYhGr1N6GXcK0EcMZ/NK6bh3mze4LLt4tMhVviU4se+5IQ/1dfuuKiEiYwI+czaaTz1qDEs+o=
Date: Wed, 23 May 2007 20:05:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF: possible usage of uninitialized variables
Message-ID: <20070523160533.GA12216@cvg>
References: <20070522175223.GA8259@cvg> <20070522202938.GA30666@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522202938.GA30666@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Kara - Tue, May 22, 2007 at 10:29:38PM +0200]
| > A few variables could be used without being explicitly initialized.
| > Fixed.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > 
| > 
| >  balloc.c |    6 +++++-
| >  super.c  |    5 ++++-
| >  2 files changed, 9 insertions(+), 2 deletions(-)
| > 
| > 
| > diff --git a/balloc.c b/balloc.c
| > index 4cec910..be37393 100644
| > --- a/balloc.c
| > +++ b/balloc.c
| > @@ -744,7 +744,11 @@ static int udf_table_new_block(struct super_block * sb,
| >  	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
| >  	uint32_t newblock = 0, adsize;
| >  	uint32_t elen, goal_elen = 0;
| > -	kernel_lb_addr eloc, goal_eloc;
| > +	kernel_lb_addr eloc;
| > +	kernel_lb_addr goal_eloc = {
| > +		.logicalBlockNum = 0,
| > +		.partitionReferenceNum = 0,
| > +	};
| >  	struct extent_position epos, goal_epos;
| >  	int8_t etype;
|   As I read the code, I don't think it can happen goal_eloc is used
| unitialized. Also please diff the tree completely, not just the udf
| directory..
| 
| > diff --git a/super.c b/super.c
| > index 9b8644a..068a99c 100644
| > --- a/super.c
| > +++ b/super.c
| > @@ -1358,7 +1358,10 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
| >  			case UDF_VIRTUAL_MAP15:
| >  			case UDF_VIRTUAL_MAP20:
| >  			{
| > -				kernel_lb_addr ino;
| > +				kernel_lb_addr ino = {
| > +					.logicalBlockNum = 0,
| > +					.partitionReferenceNum = 0,
| > +				};
| >  
| >  				if (!UDF_SB_LASTBLOCK(sb))
| >  				{
|   This one seems correct. Thanks for fixing this.
| 
| 								Honza
| -- 
| Jan Kara <jack@suse.cz>
| SuSE CR Labs
| 

Jan, you know I've been messed up. The variables I've touched in my patch
became initialized in any case.

Andrew, just drop my patch (you're right and I was wrong ;).

Thanks you both for comments.

		Cyrill

