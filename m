Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZBPC5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZBPC5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZBPC4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:56:41 -0500
Received: from thunk.org ([69.25.196.29]:37210 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871AbZBPC4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:56:40 -0500
Date: Sun, 15 Feb 2009 17:46:59 -0500
From: Theodore Tso <tytso@mit.edu>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Jan Kara <jack@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
Subject: Re: ext4: call blkdev_issue_flush on fsync
Message-ID: <20090215224659.GG10706@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Jan Kara <jack@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
	fernando@kic.ac.jp
References: <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp> <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp> <20090116163039.GE10617@duck.suse.cz> <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp> <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234435245.15433.19.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1234435245.15433.19.camel@sebastian.kern.oss.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 07:40:45PM +0900, Fernando Luis Vázquez Cao wrote:
> @@ -76,25 +77,34 @@ int ext4_sync_file(struct file *file, st
>  	 */
>  	if (ext4_should_journal_data(inode)) {
>  		ret = ext4_force_commit(inode->i_sb);
> +		if (!(journal->j_flags & JBD2_BARRIER))
> +			goto no_journal_barrier;
>  		goto out;
>  	}

All of these goto statements makes it one gigantic pile of spaghetti.
The code will be much more understable if you do:

		if (!(journal->j_flags & JBD2_BARRIER))
			block_flush_device(inode->i_sb);
		return ret;	

>  
> -	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
> -		goto out;
> +	if (datasync && !(i_state & I_DIRTY_DATASYNC))
> +		goto flush_blkdev;
>  

Maybe instead:
	if (datasync && !(i_state & I_DIRTY_DATASYNC)) {
		if (i_state & I_DIRTY_PAGES)
			block_flush_device(inode->i_sb);
		return ret;
	}


> -		if (journal && (journal->j_flags & JBD2_BARRIER))
> -			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
> +		if (journal && !(journal->j_flags & JBD2_BARRIER))
> +			goto no_journal_barrier;
> +		goto out;

Maybe instead:
		if (journal && !(journal->j_flags & JBD2_BARRIER))
			block_flush_device(inode->i_sb);
		return ret;
  	}

I'm not a fanatic about eliminating all goto's, but "goto out" which
could be replaced by "return ret;" is just silly.

      	 	     	     	      - Ted
