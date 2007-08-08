Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbXHHIbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbXHHIbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbXHHIbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:31:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36129 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXHHIbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:31:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 12/25] sysfs: Introduce sysfs_rename_mutex
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
	<m11wefkq88.fsf_-_@ebiederm.dsl.xmission.com>
	<m1wsw7jbml.fsf_-_@ebiederm.dsl.xmission.com>
	<m1sl6vjbjw.fsf_-_@ebiederm.dsl.xmission.com>
	<m1odhjjbij.fsf_-_@ebiederm.dsl.xmission.com>
	<m1k5s7jbh9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1fy2vjbf9.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqdjjbcf.fsf_-_@ebiederm.dsl.xmission.com>
	<m17io7jba4.fsf_-_@ebiederm.dsl.xmission.com>
	<m13ayvjb82.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7gnhwm4.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzrbhwkc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1zhwhp.fsf_-_@ebiederm.dsl.xmission.com>
	<46B97C94.8090209@gmail.com>
Date: Wed, 08 Aug 2007 02:28:52 -0600
In-Reply-To: <46B97C94.8090209@gmail.com> (Tejun Heo's message of "Wed, 08 Aug
	2007 17:19:32 +0900")
Message-ID: <m13ayufn0b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

> Hello, Eric.
>
> Eric W. Biederman wrote:
>> Looking carefully at the rename code we have a subtle dependency
>> that the structure of sysfs not change while we are performing
>> a rename.  If the parent directory of the object we are renaming
>> changes while the rename is being performed nasty things could
>> happen when we go to release our locks.
>> 
>> So introduce a sysfs_rename_mutex to prevent this highly
>> unlikely theoretical issue.
>
> Yeah, it's a theoretical issue.  Rename/move implementation has always
> depended on the parent structure not changing beneath it, but it's nice
> to tighten up loose ends.
>
>> +DEFINE_MUTEX(sysfs_rename_mutex);
>
> Probably doesn't really matter but wouldn't a rwsem fit better?

Maybe.  I didn't feel any loss in when I was writing the code.
Very few code paths actually seem to care.

>> @@ -774,7 +775,7 @@ static struct dentry *__sysfs_get_dentry(struct
> super_block *sb, struct sysfs_di
>>   *	down from there looking up dentry for each step.
>>   *
>>   *	LOCKING:
>> - *	Kernel thread context (may sleep)
>> + *	mutex_lock(sysfs_rename_mutex)

Well this is weird in that it should be on sysfs_get_dentry
more then __sysfs_get_dentry but otherwise it's ok.

> LOCKING describes what locks should be held when entering the function,
> so proper description would be something like...
>
> 	Kernel thread context, grabs sysfs_rename_mutex

For rename_dir and move_dir yes.  I was updating the rules
for sysfs_get_dentry.  Which really wants it's parents to
hold that lock.

Eric
