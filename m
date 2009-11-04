Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZKDM5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZKDM5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZKDM47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:56:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45071 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbZKDM46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:56:58 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 06/13] sysfs: Fix locking and factor out sysfs_sd_setattr
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-6-git-send-email-ebiederm@xmission.com>
	<20091104031632.GC27639@us.ibm.com> <m1fx8vdk4a.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 04:56:56 -0800
In-Reply-To: <m1fx8vdk4a.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 03 Nov 2009 19\:49\:57 -0800")
Message-ID: <m1ws26zbvr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> "Serge E. Hallyn" <serue@us.ibm.com> writes:
>
>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>> From: Eric W. Biederman <ebiederm@xmission.com>
>>> 
>>> Cleanly separate the work that is specific to setting the
>>> attributes of a sysfs_dirent from what is needed to update
>>> the attributes of a vfs inode.
>>> 
>>> Additionally grab the sysfs_mutex to keep any nasties from
>>> surprising us when updating the sysfs_dirent.
>>> 
>>> Acked-by: Tejun Heo <tj@kernel.org>
>>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>>> ---
>>>  fs/sysfs/inode.c |   52 ++++++++++++++++++++++++++++++++--------------------
>>>  fs/sysfs/sysfs.h |    1 +
>>>  2 files changed, 33 insertions(+), 20 deletions(-)
>>> 
>>> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
>>> index fed7a74..fccfb55 100644
>>> --- a/fs/sysfs/inode.c
>>> +++ b/fs/sysfs/inode.c
>>> @@ -64,30 +64,15 @@ struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
>>> 
>>>  	return attrs;
>>>  }
>>> -int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>>> +
>>> +int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
>>>  {
>>> -	struct inode * inode = dentry->d_inode;
>>> -	struct sysfs_dirent * sd = dentry->d_fsdata;
>>>  	struct sysfs_inode_attrs *sd_attrs;
>>>  	struct iattr *iattrs;
>>>  	unsigned int ia_valid = iattr->ia_valid;
>>> -	int error;
>>> -
>>> -	if (!sd)
>>> -		return -EINVAL;
>>> 
>>>  	sd_attrs = sd->s_iattr;
>>> 
>>> -	error = inode_change_ok(inode, iattr);
>>> -	if (error)
>>> -		return error;
>>> -
>>> -	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
>>> -
>>> -	error = inode_setattr(inode, iattr);
>>> -	if (error)
>>> -		return error;
>>> -
>>>  	if (!sd_attrs) {
>>>  		/* setting attributes for the first time, allocate now */
>>>  		sd_attrs = sysfs_init_inode_attrs(sd);
>>> @@ -110,12 +95,39 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>>>  			iattrs->ia_ctime = iattr->ia_ctime;
>>>  		if (ia_valid & ATTR_MODE) {
>>>  			umode_t mode = iattr->ia_mode;
>>> -
>>> -			if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
>>> -				mode &= ~S_ISGID;
>>>  			iattrs->ia_mode = sd->s_mode = mode;
>>>  		}
>>>  	}
>>> +	return 0;
>>> +}
>>> +
>>> +int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>>> +{
>>> +	struct inode * inode = dentry->d_inode;
>>> +	struct sysfs_dirent * sd = dentry->d_fsdata;
>>> +	int error;
>>> +
>>> +	if (!sd)
>>> +		return -EINVAL;
>>> +
>>> +	error = inode_change_ok(inode, iattr);
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
>>> +	if (iattr->ia_valid & ATTR_MODE) {
>>> +		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
>>> +			iattr->ia_mode &= ~S_ISGID;
>>> +	}
>>
>> Was it a bug that before this patch this wasn't cleared before the
>> actual inode_setattr()?
>
> Not strictly as inode_setattr performs the exact same check.
>
>> Since the S_ISGID will be set for the *new* gid, that is,
>> iattr->ia_gid, shouldn't the user be required to be
>> in_group_p(iattr->i_gid)?  Note you haven't done the
>> inode_setattr() yet.
>
> Interesting point, yes I am potentially testing the wrong gid
> there.  The dangers of moving code around.
>
> Thank you for catching that.  !#@#!#

Turns out it wasn't as bad as it looks because inode_change_ok already
does what I am trying to do properly.

Although come to think of it, SGID on a sysfs file is completely bogus.
We don't exec files and we don't allow users to create anything.

I have already sent the follow up patch to remove those few lines of code.

Eric
