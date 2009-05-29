Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZE2Qwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZE2Qwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZE2Qw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:52:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59267 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZE2QwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:52:25 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	<1243551665-23596-4-git-send-email-ebiederm@xmission.com>
	<4A1FA777.3040200@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 29 May 2009 09:52:16 -0700
In-Reply-To: <4A1FA777.3040200@kernel.org> (Tejun Heo's message of "Fri\, 29 May 2009 18\:14\:31 +0900")
Message-ID: <m1zlcvdf7j.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, greg@kroah.com, kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0447]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> Eric W. Biederman wrote:
>> @@ -732,12 +732,28 @@ const struct inode_operations sysfs_dir_inode_operations = {
>>  	.setattr	= sysfs_setattr,
>>  };
>>  
>> -static void remove_dir(struct sysfs_dirent *sd)
>> +static void remove_dir(struct sysfs_dirent *dir_sd)
>>  {
>>  	struct sysfs_addrm_cxt acxt;
>>  
>> -	sysfs_addrm_start(&acxt, sd->s_parent);
>> -	sysfs_remove_one(&acxt, sd);
>> +	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
>> +
>> +	/* Removing non-empty directories is not valid complain! */
> 						     ^^^
> 						  missing . or ,
>
>> +static struct sysfs_dirent *get_dirent_to_remove(struct sysfs_dirent *dir_sd)
>> +{
>> +	struct sysfs_dirent *sd;
>> +
>> +	mutex_lock(&sysfs_mutex);
>> +	for (sd = dir_sd->s_dir.children; sd; sd = sd->s_sibling) {
>> +		/* Directories might be owned by someone else
>> +		 * making recursive directory removal unsafe.
>> +		 */
>> +		if (sysfs_type(sd) == SYSFS_DIR)
>> +			continue;
>> +		break;
>> +	}
>> +	sysfs_get(sd);
>> +	mutex_unlock(&sysfs_mutex);
>> +
>> +	return sd;
>> +}
>>  
>>  static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
>>  {
>>  	struct sysfs_addrm_cxt acxt;
>> -	struct sysfs_dirent **pos;
>> -
>> -	if (!dir_sd)
>> -		return;
>> -
>> -	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
>> -	sysfs_addrm_start(&acxt, dir_sd);
>> -	pos = &dir_sd->s_dir.children;
>> -	while (*pos) {
>> -		struct sysfs_dirent *sd = *pos;
>> +	struct sysfs_dirent *sd;
>>  
>> -		if (sysfs_type(sd) != SYSFS_DIR)
>> -			sysfs_remove_one(&acxt, sd);
>> -		else
>> -			pos = &(*pos)->s_sibling;
>> +	/* Remove children that we think are safe */
>> +	while ((sd = get_dirent_to_remove(dir_sd))) {
>> +		sysfs_addrm_start(&acxt, sd->s_parent);
>> +		sysfs_remove_one(&acxt, sd);
>> +		sysfs_addrm_finish(&acxt);
>> +		sysfs_put(sd);
>>  	}
>> -	sysfs_addrm_finish(&acxt);
>
> Ummm... Null @dir_sd handling is being removed, which could be fine
> but please do it in a separate patch or at least mention it in the
> patch description.

Agreed.  That should be documented.  I took a look and it appears we
are completely protected by the kobj->state_in_sysfs flag.

  Also, I'm quite uncomfortable with these things
> being done in non-atomic manner.  It can be made to work but things
> like this can lead to subtle race conditions and with the kind of
> layering we put on top of sysfs (kobject, driver model, driver
> midlayers and so on), it isn't all that easy to verify what's going
> on, so NACK for this one.

Total nonsense.

Mucking about with sysfs after we start deleting a directory is a bug.
At worst my change makes a buggy race slightly less deterministic.

I am not ready to consider keeping the current unnecessary atomic
removal step.  That unnecessary atomicity makes the following patches
more difficult, and requires a lot of unnecessary retesting.

What do you think the extra unnecessary atomicity helps protect?

Eric
