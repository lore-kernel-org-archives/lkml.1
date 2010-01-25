Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749Ab0AYTEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0AYTEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633Ab0AYTEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:04:30 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:3404 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0AYTE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KNV1vXIyeV5vKgqQDrGI9I7LwnToJ7j+Uipi0bNrOCLtMV8iTGEUcbKSQlc9t4Tqgs
         oXkqGh8wbWS2pWt1YOqAGxMinGa7rvYtHyy60rPu3SME4eW0LuRaUfiNxW3MtAP6tqK2
         yQkYATlS18fV5Uqu/S7xRZ+dt02k7E4fOH1Ro=
Subject: Re: ext4_fiemap gives 0 extents for files smaller than a block
 (patch included)
From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
To: Andreas Dilger <adilger@sun.com>
Cc: 474597@bugs.launchpad.net, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
References: <1257360161.22057.16.camel@michlmayr>
	 <372739E0-41AD-4DEC-9187-1396BE5894BD@sun.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 20:04:24 +0100
Message-ID: <1264446264.27189.3.camel@michlmayr>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you have any news on this bug?

Will you apply the patch? Do you not plan to apply the patch?
Do you need an update of the patch?

Regards
Leonard

Am Mittwoch, den 04.11.2009, 12:44 -0700 schrieb Andreas Dilger:
> On 2009-11-04, at 11:42, Leonard Michlmayr wrote:
> > Fiemap (ioctl) does not return any extents for small files on ext4.
> > (fm_start=0, fm_length=filesize)
> >
> > File affected: fs/ext4/extents.c
> >
> > I found the reason of the bug: wrong rounding. It will not only affect
> > small files, but any request that overlaps an extent boundary by less
> > that blocksize.
> 
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
> 
> I think the right calculation here is:
> 
>                    end_blk = (start + len + inode->i_sb->s_blocksize -  
> 1) >>
>                              inode->i_sb->s_blocksize_bits;
>                    len_blks = end_blk - start_blk;
> 
> I'm also wondering (unrelated to this bug) why inode->i_sb- 
>  >s_blocksize_bits
> is used instead of inode->i_blkbits?  That is probably worth a  
> separate cleanup
> patch.
...

