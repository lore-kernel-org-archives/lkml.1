Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZBPHJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZBPHJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 02:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZBPHJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 02:09:45 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42493 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZBPHJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 02:09:43 -0500
Subject: Re: ext4: call blkdev_issue_flush on fsync
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
In-Reply-To: <20090215224659.GG10706@mini-me.lan>
References: <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
	 <1234435245.15433.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090215224659.GG10706@mini-me.lan>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Mon, 16 Feb 2009 16:09:41 +0900
Message-Id: <1234768181.32677.7.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 17:46 -0500, Theodore Tso wrote:
> On Thu, Feb 12, 2009 at 07:40:45PM +0900, Fernando Luis Vázquez Cao wrote:
> > @@ -76,25 +77,34 @@ int ext4_sync_file(struct file *file, st
> >  	 */
> >  	if (ext4_should_journal_data(inode)) {
> >  		ret = ext4_force_commit(inode->i_sb);
> > +		if (!(journal->j_flags & JBD2_BARRIER))
> > +			goto no_journal_barrier;
> >  		goto out;
> >  	}
> 
> All of these goto statements makes it one gigantic pile of spaghetti.
> The code will be much more understable if you do:
> 
> 		if (!(journal->j_flags & JBD2_BARRIER))
> 			block_flush_device(inode->i_sb);
> 		return ret;	
> 
> >  
> > -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> > -		goto out;
> > +	if (datasync && !(i_state & I_DIRTY_DATASYNC))
> > +		goto flush_blkdev;
> >  
> 
> Maybe instead:
> 	if (datasync && !(i_state & I_DIRTY_DATASYNC)) {
> 		if (i_state & I_DIRTY_PAGES)
> 			block_flush_device(inode->i_sb);
> 		return ret;
> 	}
> 
> 
> > -		if (journal && (journal->j_flags & JBD2_BARRIER))
> > -			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
> > +		if (journal && !(journal->j_flags & JBD2_BARRIER))
> > +			goto no_journal_barrier;
> > +		goto out;
> 
> Maybe instead:
> 		if (journal && !(journal->j_flags & JBD2_BARRIER))
> 			block_flush_device(inode->i_sb);
> 		return ret;
>   	}
> 
> I'm not a fanatic about eliminating all goto's, but "goto out" which
> could be replaced by "return ret;" is just silly.

Yes, you are right. I just wanted to follow the current style of the
code, but I got carried away and took things a bit too far.

I'll be replying to this email with a new iteration of the patch-set
that leaves out the potentially conflictive bits and should be more
readable.

Regards,

Fernando

