Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZKSWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZKSWWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 17:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZKSWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 17:22:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59599 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbZKSWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 17:22:50 -0500
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       john.johansen@canonical.com
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
References: <m1zl6j65by.fsf@fess.ebiederm.org>
	<200911190704.CHI18293.VJOMHFtOLQSOFF@I-love.SAKURA.ne.jp>
	<m1k4xn8nba.fsf@fess.ebiederm.org>
	<200911192333.EHB57391.FSQOHOJtMFFLVO@I-love.SAKURA.ne.jp>
	<m1ocmy4d7b.fsf@fess.ebiederm.org>
	<200911200717.CDF87535.JQMSFFtOFVOHOL@I-love.SAKURA.ne.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Nov 2009 14:22:53 -0800
In-Reply-To: <200911200717.CDF87535.JQMSFFtOFVOHOL@I-love.SAKURA.ne.jp> (Tetsuo Handa's message of "Fri\, 20 Nov 2009 07\:17\:53 +0900")
Message-ID: <m1lji2upc2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Hello.
>
> Eric W. Biederman wrote:
>> > Indeed. TOMOYO and AppArmor need a hint for prepending "/proc" prefix.
>> > A simple implementation which adds one bit to task_struct is shown below.
>> > In this way, not only the file permission checks inside dentry_open()
>> > but also the directory permission checks inside vfs_path_lookup() can be
>> > prepended "/proc" prefix. AppArmor might want to prepend "/proc" inside
>> > vfs_path_lookup().
>> 
>> There don't appear to be any security hooks in vfs_path_lookup().
>>
> OK. Then, AppArmor won't be confused.
>
>> Instead of current->in_sysctl we can just look at the path and see if
>> it is the root of the mount chain and if the fs is proc.
>> 
>> Something like:
>> 
>> diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
>> index 5f2e332..0b55faa 100644
>> --- a/security/tomoyo/realpath.c
>> +++ b/security/tomoyo/realpath.c
>> @@ -108,6 +108,15 @@ int tomoyo_realpath_from_path2(struct path *path, char *newname,
>>  		spin_unlock(&dcache_lock);
>>  		path_put(&root);
>>  		path_put(&ns_root);
>> +		/* Prepend "/proc" prefix if using internal proc vfs mount. */
>> +		if (!IS_ERR(sp) && (path->mnt->mnt_parent == path->mnt) &&
>> +		    (strcmp(path->mnt->mnt_sb->s_type->name, "proc") == 0)) {
>> +			sp -= 5;
>> +			if (sp >= newname)
>> +				memcpy(sp, "/proc", 5);
>> +			else
>> +				sp = ERR_PTR(-ENOMEM);
>> +		}
>>  	}
>>  	if (IS_ERR(sp))
>>  		error = PTR_ERR(sp);
>
> Above patch works. Please proceed. Thank you.
>
> Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> Why not to use path->mnt->mnt_sb->s_magic == PROC_SUPER_MAGIC rather than
> strcmp(path->mnt->mnt_sb->s_type->name, "proc") == 0 ?

Brain short circuit.

Eric

