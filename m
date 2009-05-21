Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZEUH3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZEUH3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZEUH3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:29:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49689 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbZEUH3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:29:31 -0400
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
	<4A14F356.3030501@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 00:29:26 -0700
In-Reply-To: <4A14F356.3030501@kernel.org> (Tejun Heo's message of "Thu\, 21 May 2009 15\:23\:18 +0900")
Message-ID: <m1k54a7w2x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of directories with subdirectories
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Modify sysfs to properly remove directories containing attributes and
>> subdirectories.  The code is relatively simple and means we don't have
>> to worry about what might use this logic.
>> 
>> In a quick survey I have only found /sys/dev/char and /sys/dev/block that are
>> removing non-enmpty directories today (and they are exclusively filled with symlinks).
>> So only removing empty directories does not appear to be an option.
>> 
>> I don't hold sysfs_mutex across the entire operation as that is unneeded
>> for coherence at the sysfs level and some level of coordination is expected
>> at the upper layers.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ...
>> -void sysfs_remove_subdir(struct sysfs_dirent *sd)
>> -{
>> -	remove_dir(sd);
>> +	struct sysfs_dirent *sd = dir_sd;
>> +	mutex_lock(&sysfs_mutex);
>> +	while ((sysfs_type(sd) == SYSFS_DIR) && sd->s_dir.children)
>> +		sd = sd->s_dir.children;
>> +	if (sd != dir_sd)
>> +		sysfs_get(sd);
>> +	else
>> +		sd = NULL;
>> +	mutex_unlock(&sysfs_mutex);
>> +	return sd;
>>  }
>
> Some blank lines wouldn't hurt, especially after local variable
> declaration.
>
>> -static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
>> +static void remove_dir(struct sysfs_dirent *dir_sd)
>>  {
>>  	struct sysfs_addrm_cxt acxt;
>> -	struct sysfs_dirent **pos;
>> -
>> -	if (!dir_sd)
>> -		return;
>> +	struct sysfs_dirent *sd;
>>  
>>  	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
>> -	sysfs_addrm_start(&acxt, dir_sd);
>> -	pos = &dir_sd->s_dir.children;
>> -	while (*pos) {
>> -		struct sysfs_dirent *sd = *pos;
>>  
>> -		if (sysfs_type(sd) != SYSFS_DIR)
>> -			sysfs_remove_one(&acxt, sd);
>> -		else
>> -			pos = &(*pos)->s_sibling;
>> +	while ((sd = sysfs_get_one(dir_sd))) {
>> +		sysfs_addrm_start(&acxt, sd->s_parent);
>> +		sysfs_remove_one(&acxt, sd);
>> +		sysfs_addrm_finish(&acxt);
>> +		sysfs_put(sd);
>>  	}
>> +	sysfs_addrm_start(&acxt, dir_sd->s_parent);
>> +	sysfs_remove_one(&acxt, dir_sd);
>>  	sysfs_addrm_finish(&acxt);
>> +}
>
> I agree we should be heading this way but what happens to attributes
> or directories living below the subdirectories?  If it's gonna handle
> recursive case, I think it better do it properly.  I had patches of
> similar effect.

I do handle it properly.  sysfs_get_one finds the deepest child of the
first directory entry.  Then I remove it.  And I repeat until done.

The locking is correct, something that is much more difficult to
tell with your version.

By grabbing and dropping the sysfs_mutex things are simpler, and they
get even simpler in future patches.



Now looking at that code in detail there is a question of what happens if
we add a directory entry while we are recursively deleting a directory.
Neither your patch, my patch, nor the existing code handle that case
(assuming the sysfs_dirent) was looked up before it is removed from it's
parent directory.  I expect another patch is called for to plug that
theoretical gap.  

I expect the way to close that hole is to have an extra flag that says
we are removing a directory entry and refuse to add if that flag is
set.

I would prefer to only remove empty directories.  But when I
instrumented things up I found cases where that does indeed happen.

Eric
