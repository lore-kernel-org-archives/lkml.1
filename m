Return-Path: <linux-kernel-owner+w=401wt.eu-S935152AbXEWPTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbXEWPTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934638AbXEWPSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:18:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:49595 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934513AbXEWPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kA9iQo5JJyV1ZQwBlPEb7vbhWTYmt1q4lGNiAxswH5xAcxd+wwAzvWxqzczOsCTiaYuPMKInAbcqmXJYFD2KpoGmTf21ROK0CVJS6WQsQ+GA7z0lIJ3mKXnFzxtfhroZCX++cBRq3rk1GGpm/eueRtZyGrkOmmHHbRDhgQUiUMg=
Date: Wed, 23 May 2007 18:17:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] UDF: possible usage of uninitialized variables
Message-ID: <20070523141750.GA8330@cvg>
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

Sorry, that's my fault :(

		Cyrill

