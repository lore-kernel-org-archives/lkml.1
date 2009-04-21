Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbZDURfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbZDURfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZDURfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:35:17 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:39686 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbZDURfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:35:15 -0400
Subject: Re: [ltt-dev] [PATCH] nfs: add support for splice writes
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Masahiro Tamori <masahiro.tamori@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-nfs@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       LKML <linux-kernel@vger.kernel.org>, linux-embedded@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090421144810.GA7036@infradead.org>
References: <49D45974.2060202@suse.de> <20090402063235.GB24846@Krystal>
	 <49D45E42.3050502@suse.de>
	 <91e0b5050904020542l6b38d7a6hab6d7ef8b4593425@mail.gmail.com>
	 <49EC0A83.8060802@suse.de> <1240230224.8073.6.camel@heimdal.trondhjem.org>
	 <49EC6CB3.8080800@suse.de> <1240237274.13636.9.camel@heimdal.trondhjem.org>
	 <49EC990B.1030007@suse.de>  <20090421144810.GA7036@infradead.org>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 13:35:02 -0400
Message-Id: <1240335302.5390.20.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: 003BFCB1DF26067082AC12444A4C5E3F310DF61D
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 180 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 10:48 -0400, Christoph Hellwig wrote:
> On Mon, Apr 20, 2009 at 09:17:23PM +0530, Suresh Jayaraman wrote:
> > +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
> > +				     struct file *filp, loff_t *ppos,
> > +				     size_t count, unsigned int flags)
> > +{
> > +	struct dentry *dentry = filp->f_path.dentry;
> > +
> > +	dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
> > +		dentry->d_parent->d_name.name, dentry->d_name.name,
> > +		(unsigned long) count, (unsigned long long) *ppos);
> > +
> > +	return generic_file_splice_write(pipe, filp, ppos, count, flags);
> > +}
> > +
> 
> You need all calls from nfs_file_write, too:
> 
>  - most importantly the nfs_revalidate_file_size for O_APPEND

Isn't O_APPEND illegal for splice_write()? It looks like it is from a
quick perusal of do_splice_from().

>  - the nfs_do_fsync for sync writes

generic_file_splice_write() calls generic_osync_inode(), which should
ensure sync writes even with NFS.
The one thing it won't do is propagate NFS write errors back to the
caller. If we do care about this, then we should certainly test for
nfs_need_sync_write() and then call nfs_do_fsync() (see
nfs_file_write()).

>  - probably the stats increment

We should talk to Chuck about this.

Cheers
  Trond

