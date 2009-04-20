Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZDTMik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZDTMik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZDTMi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:38:29 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51702 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZDTMi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:38:28 -0400
Message-ID: <49EC6CB3.8080800@suse.de>
Date: Mon, 20 Apr 2009 18:08:11 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Masahiro Tamori <masahiro.tamori@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-nfs@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       LKML <linux-kernel@vger.kernel.org>, linux-embedded@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [ltt-dev] [PATCH] nfs: add support for splice writes
References: <49D45974.2060202@suse.de> <20090402063235.GB24846@Krystal>	 <49D45E42.3050502@suse.de>	 <91e0b5050904020542l6b38d7a6hab6d7ef8b4593425@mail.gmail.com>	 <49EC0A83.8060802@suse.de> <1240230224.8073.6.camel@heimdal.trondhjem.org>
In-Reply-To: <1240230224.8073.6.camel@heimdal.trondhjem.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Mon, 2009-04-20 at 11:09 +0530, Suresh Jayaraman wrote:
>> Hi Trond,
>>
>> Do you think this patch is OK? Can this be considered for merging?
>>
>> Thanks,
>>
>>>>>> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
>>>>>> index 90f292b..13d6a00 100644
>>>>>> --- a/fs/nfs/file.c
>>>>>> +++ b/fs/nfs/file.c
>>>>>> @@ -47,6 +47,9 @@ static ssize_t nfs_file_splice_read(struct file *filp, loff_t *ppos,
>>>>>>                   size_t count, unsigned int flags);
>>>>>> static ssize_t nfs_file_read(struct kiocb *, const struct iovec *iov,
>>>>>>               unsigned long nr_segs, loff_t pos);
>>>>>> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
>>>>>> +                  struct file *filp, loff_t *ppos,
>>>>>> +                  size_t count, unsigned int flags);
>>>>>> static ssize_t nfs_file_write(struct kiocb *, const struct iovec *iov,
>>>>>>               unsigned long nr_segs, loff_t pos);
>>>>>> static int nfs_file_flush(struct file *, fl_owner_t id);
>>>>>> @@ -76,6 +79,7 @@ const struct file_operations nfs_file_operations = {
>>>>>>   .lock      = nfs_lock,
>>>>>>   .flock     = nfs_flock,
>>>>>>   .splice_read  = nfs_file_splice_read,
>>>>>> +  .splice_write  = nfs_file_splice_write,
>>>>>>   .check_flags  = nfs_check_flags,
>>>>>>   .setlease    = nfs_setlease,
>>>>>> };
>>>>>> @@ -550,6 +554,26 @@ out_swapfile:
>>>>>>   goto out;
>>>>>> }
>>>>>>
>>>>>> +static ssize_t nfs_file_splice_write(struct pipe_inode_info *pipe,
>>>>>> +                 struct file *filp, loff_t *ppos,
>>>>>> +                 size_t count, unsigned int flags)
>>>>>> +{
>>>>>> +  struct dentry *dentry = filp->f_path.dentry;
>>>>>> +  struct inode *inode = dentry->d_inode;
>>>>>> +
>>>>>> +  dprintk("NFS splice_write(%s/%s, %lu@%Lu)\n",
>>>>>> +      dentry->d_parent->d_name.name, dentry->d_name.name,
>>>>>> +      (unsigned long) count, (unsigned long long) *ppos);
>>>>>> +
>>>>>> +  if (IS_SWAPFILE(inode)) {
>>>>>> +      printk(KERN_INFO "NFS: attempt to write to active swap"
>>>>>> +          "file!\n");
>>>>>> +      return -EBUSY;
>>>>>> +  }
> 
> I don't know that we really need this. We should sweep through the NFS
> code and kill all those IS_SWAPFILE() thingys. Or at least #define
> IS_SWAPFILE(a) (0)
> ...

Hmm.. I'm not sure whether we should kill them now. I think originally,
these were added keeping in mind the future NFS swap support. Given that
the recent work from Peterz Zilstra on "Swap over NFS" and multiple
iterations/review on the same, I think those patches will eventually get
merged sooner or later. Perhaps, it's a good idea to #define
IS_SWAPFILE(a) 0 than killing them entirely..?


Thanks,

>>>>>> +
>>>>>> +  return generic_file_splice_write(pipe, filp, ppos, count, flags);
>>>>>> +}
>>>>>> +
>>>>>> static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
>>>>>> {
>>>>>>   struct inode *inode = filp->f_mapping->host;
>>>>>>
> 
> Otherwise it looks fine...
> 
> 
> 

-- 
Suresh Jayaraman
