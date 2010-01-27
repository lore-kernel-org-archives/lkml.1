Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492Ab0A0EUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0A0EUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 23:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106Ab0A0EUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 23:20:25 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:32910 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab0A0EUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 23:20:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gVJrBHXr64CqtFxHzv+8pm3bxDnv2ZpVvsZgXr3Bct9ZdHGRpWm9RA4PrNU8xKZmeU
         i7RPicCsn6BwOjpa1htOxidDQRoI8sHIjoNdyVxIDsjyZug9pVGacXzyJiQUpsDN6zII
         GdSMuIRZINdRLeIIt16FLp48Wb0fKCyDs8kLY=
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jeff Angielski <jeff@theptrgroup.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       linux-mtd@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B5FADE8.30803@theptrgroup.com>
References: <4B591573.60602@theptrgroup.com>
	 <1264480808.2401.78.camel@localhost.localdomain>
	 <1264484928.3536.1017.camel@calx> <1264500214.3867.21.camel@localhost>
	 <4B5F9A78.7080000@theptrgroup.com> <1264558433.3536.1543.camel@calx>
	 <4B5FADE8.30803@theptrgroup.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 06:20:10 +0200
Message-Id: <1264566010.2401.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 22:07 -0500, Jeff Angielski wrote:
> Matt Mackall wrote:
> > On Tue, 2010-01-26 at 20:44 -0500, Jeff Angielski wrote:
> >> Artem Bityutskiy wrote:
> >>> On Mon, 2010-01-25 at 23:48 -0600, Matt Mackall wrote:
> >>>> Hmm. I'd just as soon drop it entirely. Here's a patch. Herbert, you
> >>>> want to send this through your crypto tree?
> >>>>
> >>>>
> >>>> random: drop weird m_time/a_time manipulation
> >>>>
> >>>> No other driver does anything remotely like this that I know of except
> >>>> for the tty drivers, and I can't see any reason for random/urandom to do
> >>>> it. In fact, it's a (trivial, harmless) timing information leak. And
> >>>> obviously, it generates power- and flash-cycle wasting I/O, especially
> >>>> if combined with something like hwrngd. Also, it breaks ubifs's
> >>>> expectations.
> >>>>
> >>>> Signed-off-by: Matt Mackall <mpm@selenic.com>
> >>>>
> >>>> diff -r 29db0c391ce8 drivers/char/random.c
> >>>> --- a/drivers/char/random.c	Sun Jan 17 11:01:16 2010 -0800
> >>>> +++ b/drivers/char/random.c	Mon Jan 25 23:32:00 2010 -0600
> >>>> @@ -1051,12 +1051,6 @@
> >>>>  				/* like a named pipe */
> >>>>  	}
> >>>>  
> >>>> -	/*
> >>>> -	 * If we gave the user some bytes, update the access time.
> >>>> -	 */
> >>>> -	if (count)
> >>>> -		file_accessed(file);
> >>>> -
> >>>>  	return (count ? count : retval);
> >>>>  }
> >>>>  
> >>>> @@ -1116,8 +1110,6 @@
> >>>>  	if (ret)
> >>>>  		return ret;
> >>>>  
> >>>> -	inode->i_mtime = current_fs_time(inode->i_sb);
> >>>> -	mark_inode_dirty(inode);
> >>>>  	return (ssize_t)count;
> >>>>  }
> >>> It may brake other FSes expectations, theoretically, as well.
> >>>
> >>> Anyway, I'm perfectly fine if this is removed.
> >>>
> >>> Jeff, could you please try Matt's patch and report back if you still
> >>> have issues or not. If no, you can use this as a temporary work-around
> >>> until a proper fix hits upstream or ubifs-2.6.git.
> >> Matt's patch did not compile as written.  I tried to implement what I 
> >> think he was trying to do and created this patch (it seems to match the 
> >> guts of what inode_setattr() was looking for):
> >>
> >>
> >> diff --git a/drivers/char/random.c b/drivers/char/random.c
> >> index 8258982..70f16c7 100644
> >> --- a/drivers/char/random.c
> >> +++ b/drivers/char/random.c
> >> @@ -1108,6 +1108,7 @@ static ssize_t random_write(struct file *file, 
> >> const char __user *buffer,
> >>   {
> >>   	size_t ret;
> >>   	struct inode *inode = file->f_path.dentry->d_inode;
> >> +	struct iattr attr;
> >>
> >>   	ret = write_pool(&blocking_pool, buffer, count);
> >>   	if (ret)
> >> @@ -1116,8 +1117,12 @@ static ssize_t random_write(struct file *file, 
> >> const char __user *buffer,
> >>   	if (ret)
> >>   		return ret;
> >>
> >> -	inode->i_mtime = current_fs_time(inode->i_sb);
> >> -	mark_inode_dirty(inode);
> >> +	attr.ia_mtime = current_fs_time(inode->i_sb);
> >> +	attr.ia_valid = ATTR_MTIME;
> >> +	ret = inode_setattr(inode, &attr);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >>   	return (ssize_t)count;
> >>   }
> >>
> >> However, this patch does not fix the problem.  I still see the same 
> >> errors.  Matt, is this what you were trying to do?
> > 
> > That doesn't look anything like my patch? And mine was test compiled.
> 
> Ahh, you would be right.  I mixed up authors.  My bad.  ;)
> 
> Matt's patch that removes the offending code works fine.
> 
> Artem's patch that tries to fix the offending code (and does not compile 
> as posted) does not work.

Thanks for testing. So, who would bring Matt's patch upstream then, hmm?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

