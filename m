Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0BVVOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:14:07 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:37619 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab0BVVOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:14:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix use-after-free of vfsmount by mnt_drop_write()
References: <874ol9cfm7.fsf@devron.myhome.or.jp> <20100222205429.GH972@shell>
Date: Tue, 23 Feb 2010 06:13:59 +0900
In-Reply-To: <20100222205429.GH972@shell> (Valerie Aurora's message of "Mon,
	22 Feb 2010 15:54:29 -0500")
Message-ID: <87pr3x6kiw.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valerie Aurora <vaurora@redhat.com> writes:

>> Those might be assuming that the nd->path.mnt refcnt is keeped by
>> filp after nameidata_to_filp().
>> 
>> It's wrong if nameidata_to_filp() returned the error.  (nd->path and
>> filp are invalid)
>> 
>> Instead to use deep knowledge of nameidata_to_filp() internal, this
>> thinks the nd->path is invalid after nameidata_to_filp(). So, this
>> just take refcnt for mnt_want/drop_write().
>
> You might take a look at the patch I just posted:
>
> Subject: [RFC PATCH] VFS: Simplify truncate logic in do_filp_open()
>
> If that patch is correct, it will considerably simplify the second
> part of your patch.

[...]
>>  	/*
>> -	 * It is now safe to drop the mnt write
>> -	 * because the filp has had a write taken
>> -	 * on its behalf.
>> +	 * It is now safe to drop the mnt write because the filp has
>> +	 * had a write taken on its behalf. (NOTE: since O_TRUNC can
>> +	 * be used with O_RDONLY, this needs to cover truncate path)
>>  	 */
>> -	if (will_truncate)
>> -		mnt_drop_write(nd.path.mnt);
>> +	if (will_truncate) {
>> +		mnt_drop_write(mnt_writer);
>> +		mntput(mnt_writer);
>> +	}

Unfortunately, no. I already noted that we can't it simply. ;)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
