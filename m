Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbZHLJBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbZHLJBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZHLJBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:01:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZHLJBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:01:50 -0400
Message-ID: <4A828550.5030008@redhat.com>
Date: Wed, 12 Aug 2009 17:03:12 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, esandeen@redhat.com, eteo@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and write
 permissions set
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>	<1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>	<87prb7v0dr.fsf@devron.myhome.or.jp>	<1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>	<1249904964.2422.21.camel@moss-pluto.epoch.ncsc.mil>	<87r5vj2617.fsf@devron.myhome.or.jp>	<1249909031.2422.37.camel@moss-pluto.epoch.ncsc.mil> <87my6724rz.fsf@devron.myhome.or.jp>
In-Reply-To: <87my6724rz.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Stephen Smalley <sds@tycho.nsa.gov> writes:
>
>   
>>>> SELinux shouldn't apply a permission check for the clearing of the suid
>>>> bit on write or truncate.  It should only apply a permission check for
>>>> the actual truncate or write operation, and then the clearing of the
>>>> suid bit should always be forced if that check passed.
>>>>         
>>> Ok. Yes. So, to do it efficiently without problem, I'm suggesting the
>>> following or something (I don't know whether LSM should do this or not).
>>>
>>> selinux_inode_setattr(),
>>>
>>> 	ia_valid = iattr->ia_valid;
>>> 	if (!(ia_valid & ATTR_FORCE) && (ia_valid & ATTR_FORCE_MASK)) {
>>> 		err = dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
>>> 		if (err)
>>>                 	return err;
>>> 		ia_valid &= ~ATTR_FORCE_MASK;
>>> 	}
>>> 	if (ia_valid & ATTR_NOT_FORCE_MASK)
>>> 	 	err = dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
>>> 	return err;
>>>
>>> I guess ATTR_FORCE_MASK would be (ATTR_MODE | ATTR_UID | ATTR_GID |
>>> 			ATTR_ATIME_SET | ATTR_MTIME_SET) or something,
>>> and ATTR_NOT_FORCE_MASK would be ATTR_SIZE or something.
>>>
>>> I'm not sure this is the right code what selinux want to do though, but,
>>> I hope it is clear what I want to say. (I'm assuming FILE__WRITE is for
>>> check of ATTR_SIZE)
>>>       
>> The logic is supposed to map certain attribute changes (mode, owner,
>> group, explicit setting of atime or mtime to a specific value rather
>> than the current time) to the SELinux setattr permission, while mapping
>> other attribute changes that occur naturally on a write (size, setting
>> of mtime to current time) to the SELinux write permission.  That doesn't
>> seem clear from using ATTR_FORCE_MASK vs ATTR_NOT_FORCE_MASK above - I'd
>> use different naming conventions for clarity.
>>     
>
> I see. Yes, the naming of this code doesn't matter at all. The code was
> just intended to explain what I'm suggesting.
>
>   
>>> With this change, the caller can pass "(ATTR_SIZE | ATTR_MODE)" or
>>> "(ATTR_SIZE | ATTR_MODE | ATTR_FORCE)" etc. for truncate().
>>>
>>> [btw, "(ATTR_SIZE | ATTR_MODE)" is what do_truncate() does currently].
>>>       
>> That was a change in do_truncate(), commit
>> 7b82dc0e64e93f430182f36b46b79fcee87d3532.
>>
>> It makes sense, but no one ever updated selinux_inode_setattr() to match
>> that change.
>>     
>
> I see. Yes, exactly. And for the user of non file owner case, I'm
> thinking we would like to pass ATTR_FORCE too.
>
>   
Ok, I know what you are talking about now...

Maybe I should make another patch to fix this... :-/ I need some time to 
understand SELinux, before I finish it, keeping this patch is fine.

Thanks!

