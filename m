Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZDTOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZDTOVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 10:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZDTOVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 10:21:25 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:44134 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbZDTOVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:21:24 -0400
Subject: Re: [ltt-dev] [PATCH] nfs: add support for splice writes
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Masahiro Tamori <masahiro.tamori@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-nfs@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       LKML <linux-kernel@vger.kernel.org>, linux-embedded@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <49EC6CB3.8080800@suse.de>
References: <49D45974.2060202@suse.de> <20090402063235.GB24846@Krystal>
	 <49D45E42.3050502@suse.de>
	 <91e0b5050904020542l6b38d7a6hab6d7ef8b4593425@mail.gmail.com>
	 <49EC0A83.8060802@suse.de> <1240230224.8073.6.camel@heimdal.trondhjem.org>
	 <49EC6CB3.8080800@suse.de>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 10:21:14 -0400
Message-Id: <1240237274.13636.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: B11FDBBD0675E210FF29FA49E5A2A6483148D312
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 179 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 18:08 +0530, Suresh Jayaraman wrote:
> Trond Myklebust wrote:
> > On Mon, 2009-04-20 at 11:09 +0530, Suresh Jayaraman wrote:
> >> Hi Trond,
> >>
> >> Do you think this patch is OK? Can this be considered for merging?
> >>
> >> Thanks,
> >>
> >>>>>> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> >>>>>> index 90f292b..13d6a00 100644
> >>>>>> --- a/fs/nfs/file.c
> >>>>>> +++ b/fs/nfs/file.c
> >>>>>> @@ -47,6 +47,9 @@ static ssize_t nfs_file_splice_read(struct file *filp, loff_t *ppos,
> >>>>>>                   size_t count, unsigned int flags);
> >>>>>> static ssize_t nfs_file_read(struct kiocb *, const struct iovec *iov,
> >>>>>>               unsigned long nr_segs, loff_t pos);
> >>>>>> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
> >>>>>> +                  struct file *filp, loff_t *ppos,
> >>>>>> +                  size_t count, unsigned int flags);
> >>>>>> static ssize_t nfs_file_write(struct kiocb *, const struct iovec *iov,
> >>>>>>               unsigned long nr_segs, loff_t pos);
> >>>>>> static int nfs_file_flush(struct file *, fl_owner_t id);
> >>>>>> @@ -76,6 +79,7 @@ const struct file_operations nfs_file_operations = {
> >>>>>>   .lock      = nfs_lock,
> >>>>>>   .flock     = nfs_flock,
> >>>>>>   .splice_read  = nfs_file_splice_read,
> >>>>>> +  .splice_write  = nfs_file_splice_write,
> >>>>>>   .check_flags  = nfs_check_flags,
> >>>>>>   .setlease    = nfs_setlease,
> >>>>>> };
> >>>>>> @@ -550,6 +554,26 @@ out_swapfile:
> >>>>>>   goto out;
> >>>>>> }
> >>>>>>
> >>>>>> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
> >>>>>> +                 struct file *filp, loff_t *ppos,
> >>>>>> +                 size_t count, unsigned int flags)
> >>>>>> +{
> >>>>>> +  struct dentry *dentry = filp->f_path.dentry;
> >>>>>> +  struct inode *inode = dentry->d_inode;
> >>>>>> +
> >>>>>> +  dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
> >>>>>> +      dentry->d_parent->d_name.name, dentry->d_name.name,
> >>>>>> +      (unsigned long) count, (unsigned long long) *ppos);
> >>>>>> +
> >>>>>> +  if (IS_SWAPFILE(inode)) {
> >>>>>> +      printk(KERN_INFO "NFS: attempt to write to active swap"
> >>>>>> +          "file!\n");
> >>>>>> +      return -EBUSY;
> >>>>>> +  }
> > 
> > I don't know that we really need this. We should sweep through the NFS
> > code and kill all those IS_SWAPFILE() thingys. Or at least #define
> > IS_SWAPFILE(a) (0)
> > ...
> 
> Hmm.. I'm not sure whether we should kill them now. I think originally,
> these were added keeping in mind the future NFS swap support. Given that
> the recent work from Peterz Zilstra on "Swap over NFS" and multiple
> iterations/review on the same, I think those patches will eventually get
> merged sooner or later. Perhaps, it's a good idea to #define
> IS_SWAPFILE(a) 0 than killing them entirely..?

Why are they needed at all? AFAICS, other filesystems check IS_SWAPFILE
when truncating a file, but don't litter their code with all these weird
checks for writing, reading, etc.
It's not as if these checks can stop a determined privileged person from
writing to the swapfile anyway. All they have to do is go to another
client or write directly to the file on the server...

Trond

