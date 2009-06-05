Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbZFETeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbZFETeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZFETeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:34:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46276 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZFETeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:34:02 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 03/23] vfs: Generalize the file_list
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-3-git-send-email-ebiederm@xmission.com>
	<20090602070642.GD31556@wotan.suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Jun 2009 12:33:59 -0700
In-Reply-To: <20090602070642.GD31556@wotan.suse.de> (Nick Piggin's message of "Tue\, 2 Jun 2009 09\:06\:42 +0200")
Message-ID: <m1ab4m5vbs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: npiggin@suse.de, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

>> fs_may_remount_ro and mark_files_ro have been modified to walk the
>> inode list to find all of the inodes and then to walk the file list
>> on those inodes.  It can be a slightly longer walk as we frequently
>> cache inodes that we do not have open but the overall complexity
>> should be about the same,
>
> Well not really. I have a couple of orders of magnitude more cached
> inodes than open files here.

Good point.

>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -699,6 +699,11 @@ static inline int mapping_writably_mapped(struct address_space *mapping)
>>  	return mapping->i_mmap_writable != 0;
>>  }
>>  
>> +struct file_list {
>> +	spinlock_t		lock;
>> +	struct list_head	list;
>> +};
>> +
>>  /*
>>   * Use sequence counter to get consistent i_size on 32-bit processors.
>>   */
>> @@ -764,6 +769,7 @@ struct inode {
>>  	struct list_head	inotify_watches; /* watches on this inode */
>>  	struct mutex		inotify_mutex;	/* protects the watches list */
>>  #endif
>> +	struct file_list	i_files;
>>  
>>  	unsigned long		i_state;
>>  	unsigned long		dirtied_when;	/* jiffies of first dirtying */
>> @@ -934,9 +940,15 @@ struct file {
>>  	unsigned long f_mnt_write_state;
>>  #endif
>>  };
>> -extern spinlock_t files_lock;
>> -#define file_list_lock() spin_lock(&files_lock);
>> -#define file_list_unlock() spin_unlock(&files_lock);
>> +
>> +static inline void file_list_lock(struct file_list *files)
>> +{
>> +	spin_lock(&files->lock);
>> +}
>> +static inline void file_list_unlock(struct file_list *files)
>> +{
>> +	spin_unlock(&files->lock);
>> +}
>
> I don't really like this. It's just a list head. Get rid of
> all these wrappers and crap I'd say. In fact, starting with my
> patch to unexport files_lock and remove these wrappers would
> be reasonable, wouldn't it?

I don't really mind killing the wrappers.

I do mind your patch because it makes the list going through
the tty's something very different.  In my view of the world
that is the only use case is what I'm working to move up more
into the vfs layer.  So orphaning it seems wrong.

> Increasing the size of the struct inode by 24 bytes hurts.
> Even when you decrapify it and can reuse i_lock or something,
> then it is still 16 bytes on 64-bit.

We can get it even smaller if we make it an hlist.  A hlist_head is
only a single pointer.  This size growth appears to be one of the
biggest weakness of the code.

> I haven't looked through all the patches... but this is to
> speed up a slowpath operation, isn't it? Or does revoke
> need to be especially performant?

This was more about simplicity rather than performance.  The
performance gain is using a per inode lock instead of a global lock.
Which keeps cache lines from bouncing.

> So this patch is purely a perofrmance improvement? Then I think
> it needs to be justified with numbers and the downsides (bloating
> struct inode in particulra) to be changelogged.

Certainly the cost.

One of the things I have discovered since I wrote this patch is the
i_devices list.  Which means we don't necessarily need to have heads
in places other than struct inode.  A character device driver (aka the
tty code) can walk it's inode list and from each inode walk the file
list.  I need to check the locking on that one.

If that simplification works we can move all maintenance of the file
list into the vfs and not need a separate file list concept.  I will
take a look.

Eric
