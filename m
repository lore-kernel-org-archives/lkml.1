Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZEUHhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZEUHhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbZEUHhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:37:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56016 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZEUHhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:37:32 -0400
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
	<4A14F781.6010103@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 00:37:30 -0700
In-Reply-To: <4A14F781.6010103@kernel.org> (Tejun Heo's message of "Thu\, 21 May 2009 15\:41\:05 +0900")
Message-ID: <m1k54a6h51.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0236]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 06/20] sysfs: Use dentry_ops instead of directly playing with the dcache
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

>> +static int sysfs_dentry_revalidate(struct dentry *dentry, struct nameidata *nd)
>> +{
>> +	struct sysfs_dirent *sd = dentry->d_fsdata;
>> +	int is_dir;
>> +
>> +	mutex_lock(&sysfs_mutex);
>> +
>> +	/* The sysfs dirent has been deleted */
>> +	if (sd->s_flags & SYSFS_FLAG_REMOVED)
>> +		goto out_bad;
>> +
>> +	mutex_unlock(&sysfs_mutex);
>> +out_valid:
>> +	return 1;
>> +out_bad:
>> +	/* Remove the dentry from the dcache hashes.
>> +	 * If this is a deleted dentry we use d_drop instead of d_delete
>> +	 * so sysfs doesn't need to cope with negative dentries.
>> +	 */
>> +	is_dir = (sysfs_type(sd) == SYSFS_DIR);
>> +	mutex_unlock(&sysfs_mutex);
>> +	if (is_dir) {
>> +		/* If we have submounts we must allow the vfs caches
>> +		 * to lie about the state of the filesystem to prevent
>> +		 * leaks and other nasty things.
>> +		 */
>> +		if (have_submounts(dentry))
>> +			goto out_valid;
>> +		shrink_dcache_parent(dentry);
>> +	}
>> +	d_drop(dentry);
>> +	return 0;
>> +}
>
> Ummm... what happens if sysfs recreates those identical nodes again
> while the old dentries are lingering?  The dead ones will linger till
> the submounts are gone and then look ups after that will show the new
> ones, right?

Yep.  On the vfs level.  The sysfs dirent tree will reflect what is
going on with the hardware.

This is a vfs misfeature, that I hope someday we will get fixed.
But for now it is better not to leak mount points.  Especially
since no one actually mounts things on sysfs.

Eric
