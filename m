Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZDZGMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZDZGMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 02:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZDZGMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 02:12:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:42594 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZDZGM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 02:12:29 -0400
Date: Sun, 26 Apr 2009 08:12:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 01/27] fs: cleanup files_lock
Message-ID: <20090426061227.GA28555@wotan.suse.de>
References: <20090425012020.457460929@suse.de> <20090425012209.061706790@suse.de> <m163gtz46p.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163gtz46p.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 10:35:10PM -0700, Eric W. Biederman wrote:
> npiggin@suse.de writes:
> 
> > Lock tty_files with tty_mutex, provide helpers to manipulate the per-sb
> > files list, and unexport the files_lock spinlock.
> 
> This conflicts a bit with some of my ongoing work, which is generalizing
> the file list to make it more useful and makes the tty case much less
> of a special case.

OK. My first patch should be fine, though.

 
> Do you know if the performance improvement would be anywhere near as good if
> file_list and file_list_lock becoming per inode?

Interesting (I didn't look closely at your patches yet). Probably that
would be quite reasonable.

 
> Do you have any idea what the performance improvement with changing the file_list_lock
> is?

Several of these locks hit in the same workloads so they mask each
other. I only just got the patchset to the stage where I can really
benchmark it. I could try your alternative as well.


 
> > Index: linux-2.6/fs/open.c
> > ===================================================================
> > --- linux-2.6.orig/fs/open.c
> > +++ linux-2.6/fs/open.c
> > @@ -828,7 +828,7 @@ static struct file *__dentry_open(struct
> >  	f->f_path.mnt = mnt;
> >  	f->f_pos = 0;
> >  	f->f_op = fops_get(inode->i_fop);
> > -	file_move(f, &inode->i_sb->s_files);
> > +	file_sb_list_add(f, inode->i_sb);
> 
> You can make this just:
> 	 if (!special_file(inode->i_mode))
> 		file_add(f, &inode->i_files);
> 
> And save yourself a lot of complexity.

Probably right, but I'll leave that for someone else to do.

