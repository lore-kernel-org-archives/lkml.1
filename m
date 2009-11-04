Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbZKDV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbZKDV7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758197AbZKDV7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:59:43 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53209 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbZKDV7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:59:42 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-12-git-send-email-ebiederm@xmission.com>
	<20091104214938.GA21033@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 13:59:36 -0800
In-Reply-To: <20091104214938.GA21033@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 4 Nov 2009 15\:49\:38 -0600")
Message-ID: <m13a4ux86v.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> By teaching sysfs_revalidate to hide a dentry for
>> a sysfs_dirent if the sysfs_dirent has been renamed,
>> and by teaching sysfs_lookup to return the original
>> dentry if the sysfs dirent has been renamed.  I can
>> show the results of renames correctly without having to
>> update the dcache during the directory rename.
>> 
>> This massively simplifies the rename logic allowing a lot
>> of weird sysfs special cases to be removed along with
>> a lot of now unnecesary helper code.
>> 
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> Patch looks *great*, except:
>
> ...
>
>> @@ -315,6 +274,14 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>>  	if (sd->s_flags & SYSFS_FLAG_REMOVED)
>>  		goto out_bad;
>> 
>> +	/* The sysfs dirent has been moved? */
>> +	if (dentry->d_parent->d_fsdata != sd->s_parent)
>> +		goto out_bad;
>> +
>> +	/* The sysfs dirent has been renamed */
>> +	if (strcmp(dentry->d_name.name, sd->s_name) != 0)
>> +		goto out_bad;
>> +
>>  	mutex_unlock(&sysfs_mutex);
>>  out_valid:
>>  	return 1;
>> @@ -322,6 +289,12 @@ out_bad:
>>  	/* Remove the dentry from the dcache hashes.
>>  	 * If this is a deleted dentry we use d_drop instead of d_delete
>>  	 * so sysfs doesn't need to cope with negative dentries.
>> +	 *
>> +	 * If this is a dentry that has simply been renamed we
>> +	 * use d_drop to remove it from the dcache lookup on its
>> +	 * old parent.  If this dentry persists later when a lookup
>> +	 * is performed at its new name the dentry will be readded
>> +	 * to the dcache hashes.
>>  	 */
>>  	is_dir = (sysfs_type(sd) == SYSFS_DIR);
>>  	mutex_unlock(&sysfs_mutex);
>
> After this, if (is_dir) and (have_submounts(dentry)) then you'll
> still goto out_valid and return 1.  Is that what you want?

It isn't what I want but it is what the VFS requires.  If let the vfs
continue on it's delusional state we will leak the vfs mount and
everything mounted on top of it, with no way to remove the mounts.

Eric
