Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZKDO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZKDO0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZKDO0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:26:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47982 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbZKDO0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:26:20 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] sysfs: Don't leak secdata when a sysfs_dirent is freed.
References: <m1zl7236ox.fsf@fess.ebiederm.org>
	<20091104140913.GA4355@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 06:26:19 -0800
In-Reply-To: <20091104140913.GA4355@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 4 Nov 2009 08\:09\:13 -0600")
Message-ID: <m1fx8uz7qs.fsf@fess.ebiederm.org>
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

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> While refreshing my sysfs patches I noticed a leak in the secdata
>> implementation.  We don't free the secdata when we free the
>> sysfs dirent. 
>> 
>> This is a bug in 2.6.32-rc5 that we really should close.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> I'm surprised no kmemleak or anything has found this - but I guess
> not many sites hand-set custom selinux contexts on sysfs?

I don't expect so since you couldn't customize it in 2.6.31.
This is brand new code, and this corner case was just overlooked
in the review.

Eric


> Acked-by: Serge Hallyn <serue@us.ibm.com>
>
>> ---
>> 
>>  fs/sysfs/dir.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>> 
>> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
>> index 5fad489..e020183 100644
>> --- a/fs/sysfs/dir.c
>> +++ b/fs/sysfs/dir.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/completion.h>
>>  #include <linux/mutex.h>
>>  #include <linux/slab.h>
>> +#include <linux/security.h>
>>  #include "sysfs.h"
>> 
>>  DEFINE_MUTEX(sysfs_mutex);
>> @@ -285,6 +286,9 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
>>  		sysfs_put(sd->s_symlink.target_sd);
>>  	if (sysfs_type(sd) & SYSFS_COPY_NAME)
>>  		kfree(sd->s_name);
>> +	if (sd->s_iattr && sd->s_iattr->ia_secdata)
>> +		security_release_secctx(sd->s_iattr->ia_secdata,
>> +					sd->s_iattr->ia_secdata_len);
>>  	kfree(sd->s_iattr);
>>  	sysfs_free_ino(sd->s_ino);
>>  	kmem_cache_free(sysfs_dir_cachep, sd);
>> -- 
>> 1.6.5.2.143.g8cc62
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
