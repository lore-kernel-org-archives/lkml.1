Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038Ab0ALPfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0ALPfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132Ab0ALPfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:35:04 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37276 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0ALPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:35:03 -0500
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
	<1263241315-19499-3-git-send-email-ebiederm@xmission.com>
	<20100112134134.5f55e95f@gondolin>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 12 Jan 2010 07:34:47 -0800
In-Reply-To: <20100112134134.5f55e95f@gondolin> (Cornelia Huck's message of "Tue\, 12 Jan 2010 13\:41\:34 +0100")
Message-ID: <m1k4vn72w8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> On Mon, 11 Jan 2010 12:21:51 -0800,
> "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
>> From: Eric W. Biederman <ebiederm@aristanetworks.com>
>> 
>> On large directories sysfs_count_nlinks can be a significant
>> bottleneck, so keep a count in sysfs_dirent.  If we exceed
>> the maximum number of directory entries we can store return
>> nlink of 1.  An nlink of 1 matches what reiserfs does in
>> this case, and it let's find and similar utlities know that
>> we have a the directory nlink can not be used for optimization
>> purposes.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> ---
>>  fs/sysfs/dir.c   |   20 ++++++++++++++++++++
>>  fs/sysfs/inode.c |   15 +--------------
>>  fs/sysfs/mount.c |    1 +
>>  fs/sysfs/sysfs.h |    1 +
>>  4 files changed, 23 insertions(+), 14 deletions(-)
>> 
>
>> @@ -420,6 +438,7 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>>  		return -EEXIST;
>> 
>>  	sd->s_parent = sysfs_get(acxt->parent_sd);
>> +	sysfs_dir_inc_nlink(sd->s_parent);
>> 
>>  	sysfs_link_sibling(sd);
>> 
>> @@ -512,6 +531,7 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>> 
>>  	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
>> 
>> +	sysfs_dir_dec_nlink(sd->s_parent);
>>  	sysfs_unlink_sibling(sd);
>> 
>>  	/* Update timestamps on the parent */
>
> Shouldn't s_nlink be adjusted in sysfs_rename for the move case as well?

Yes.  I hereby nominate this as my most buggy patch ever.
Ugh.

I thought I actually cared about nlinks when I bothered to keep a
nlink count, but I am starting to think I really don't.

Eric

