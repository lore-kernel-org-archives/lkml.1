Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667Ab0ALIap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab0ALIap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533Ab0ALIao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:30:44 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:35415 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0ALIan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:30:43 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
	<1263241315-19499-3-git-send-email-ebiederm@xmission.com>
	<20100112055641.GB10756@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 12 Jan 2010 00:30:24 -0800
In-Reply-To: <20100112055641.GB10756@us.ibm.com> (Serge E. Hallyn's message of "Mon\, 11 Jan 2010 23\:56\:41 -0600")
Message-ID: <m1y6k3913z.fsf@fess.ebiederm.org>
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

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
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
>> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
>> index 5c4703d..1c364be 100644
>> --- a/fs/sysfs/dir.c
>> +++ b/fs/sysfs/dir.c
>> @@ -359,6 +359,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
>>  	sd->s_name = name;
>>  	sd->s_mode = mode;
>>  	sd->s_flags = type;
>> +	sd->s_nlink = type == SYSFS_DIR? 2:1;
>> 
>>  	return sd;
>> 
>> @@ -392,6 +393,23 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
>>  	mutex_lock(&sysfs_mutex);
>>  }
>> 
>> +static void sysfs_dir_inc_nlink(struct sysfs_dirent *sd)
>> +{
>> +	/* If we overflow force nlink to be 1 */
>> +	if (sd->s_nlink > 1) {
>> +		sd->s_nlink++;
>> +		if (sd->s_nlink == 0)
>> +			sd->s_nlink = 1;
>> +	}
>> +}
>
> Now, the original code only ups nlink on parent if child is a dir.
> IIUC your code will now inc nlink for files as well.  Is any userspace
> going to be confused by that?

Good point.  nlink should only be upped for directories.

Eric
