Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZKDVoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZKDVoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932850AbZKDVoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:44:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:58622 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbZKDVoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:44:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C8rTz0Kwugy0GqWlJdfZB9tPXLMsybxzJrpVmTl7uBNq2Adbwq2KANxrfR1PSCBEZt
         vwmf0MwawgJp0X28shaPe9VF49LKmcZEFLMKIvQA085+DvLL1J57HVejKB0C188gFXqo
         2tlLulNDdL0cnt+j2FqYQcs8Tj/BSeLxvf/RU=
Subject: Re: ext4_fiemap gives 0 extents for files smaller than a block
 (patch included)
From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
To: Andreas Dilger <adilger@sun.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
References: <1257360161.22057.16.camel@michlmayr>
	 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 22:44:10 +0100
Message-ID: <1257371050.13852.28.camel@michlmayr>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your reply.

> >
> > @@ -3700,7 +3701,8 @@
> >  		start_blk = start >> inode->i_sb->s_blocksize_bits;
> > -		len_blks = len >> inode->i_sb->s_blocksize_bits;
> > +		end_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
> > +		len_blks = end_blk - start_blk + 1;
> 
> I don't think this is quite correct either.  For example, if blocksize  
> is 1024
> and start is 1023 (start_blk = 0) and len is 2 (end = 1024, end_blk =  
> 1) then
> len_blks = 2 which is too much.

I think that len_blks = 2 is the correct value, because the requested
region extends into 2 blocks (namely 0 and 1). If both blocks are in two
separate extents, then ext4_ext_walk_space should report 2 extents. (If
it's the same extent, only 1 will be reported anyways)

> I think the right calculation here is:
> 
>                    end_blk = (start + len + inode->i_sb->s_blocksize - 1) >>
>                              inode->i_sb->s_blocksize_bits;
>                    len_blks = end_blk - start_blk;
> 

This is exactly the same (provided that len > 0). You can convince
yourself easily that ((blocksize + x) >> blocksize_bits == x >>
blocksize_bits + 1) for any positive x, because the lower bits of
blocksize are all 0. (Your calculation would handle the case len == 0
right, if that was allowed.)

Regards
Leonard


