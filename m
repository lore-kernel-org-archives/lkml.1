Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbZEUHyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbZEUHyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZEUHyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:54:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58939 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZEUHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:54:22 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-5-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-6-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-7-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-8-git-send-email-ebiederm@xmission.com>
	<4A1502C6.5020103@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 00:54:18 -0700
In-Reply-To: <4A1502C6.5020103@kernel.org> (Tejun Heo's message of "Thu\, 21 May 2009 16\:29\:10 +0900")
Message-ID: <m1skiy3n85.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4647]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 08/20] sysfs: Optimize just changing the sysfs file mode.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Don't allocate a struct iattr for the sysfs dentry if just
>> the mode changes because we have a field for that on the
>> sysfs_dirent, and we can trigger that case with sysfs_chmod_file.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> ---
>>  fs/sysfs/inode.c |   22 ++++++++++++++--------
>>  1 files changed, 14 insertions(+), 8 deletions(-)
>> 
>> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
>> index 555f0ff..70ff2a2 100644
>> --- a/fs/sysfs/inode.c
>> +++ b/fs/sysfs/inode.c
>> @@ -60,12 +60,16 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>>  		return error;
>>  
>>  	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
>> +	if (iattr->ia_valid & ATTR_MODE) {
>> +		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
>> +			iattr->ia_mode &= ~S_ISGID;
>> +	}
>>  
>>  	error = inode_setattr(inode, iattr);
>>  	if (error)
>>  		return error;
>>  
>> -	if (!sd_iattr) {
>> +	if (!sd_iattr && (ia_valid & ~ATTR_MODE)) {
>>  		/* setting attributes for the first time, allocate now */
>>  		sd_iattr = kzalloc(sizeof(struct iattr), GFP_KERNEL);
>>  		if (!sd_iattr)
>> @@ -78,6 +82,13 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>>  		sd->s_iattr = sd_iattr;
>>  	}
>>  
>> +	if (ia_valid & ATTR_MODE)
>> +		sd->s_mode = iattr->ia_mode;
>> +
>> +	/* If we don't need the extra attributes leave */
>> +	if (!sd_iattr)
>> +		return 0;
>
> One visible difference is lack of timestamp update.  Is there any use
> case where sysfs file mode changing needs to be fast?\

Not really.  If the time changes we set something besides ATTR_MODE
like ATTR_MTIME or ATTR_CTIME.  If we come in through any of the
user space entry points ATTR_CTIME appears to be set so this optimization
will not trigger.

I think there are cases where we only opportunistically track time
changes, when the structure is allocated that this changes but it
is a very small percentage of the time.

The practical effect of my changes should be that we only track timestamps
when user space actually performs an explicit change to the file.

If someone was depending on some weird indirect side effect like that
on one of the 5-6 files that calls sysfs_chmod let's make it explicit.

For me this isn't about making this go faster.  This is about keeping
the sysfs data structures small when we can.

It doesn't really complicate the code and we wind up doing the obvious thing.

Eric
