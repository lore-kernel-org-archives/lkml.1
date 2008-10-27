Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYJ0Hmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYJ0Hmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYJ0Hmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:42:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45865 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYJ0Hme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:42:34 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] kill suid bit only for regular files
References: <1224424839-3892-1-git-send-email-dmonakhov@openvz.org>
	<20081026214741.332c7656.akpm@linux-foundation.org>
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Mon, 27 Oct 2008 10:41:52 +0300
In-Reply-To: <20081026214741.332c7656.akpm@linux-foundation.org> (Andrew Morton's message of "Sun\, 26 Oct 2008 21\:47\:41 -0700")
Message-ID: <m363nebi2n.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 19 Oct 2008 18:00:39 +0400 Dmitri Monakhov <dmonakhov@openvz.org> wrote:
>
>> We don't have to do it because it is useless for non regular files.
>
> Are we sure that should_remove_suid() is not and never will used for
> directories?
This bits are meaningless for directory. Posix is quiet about this case.
>
>> In fact block device may trigger this path without dentry->d_inode->i_mutex.
>
> What's wrong with blockdevs triggering this path?
We have following locking rules:notify_changes must be protected 
by d_inode->i_mutex.
BTW: You have add this sanity check to notify_change to -mm tree.
>
> Better changelogs, please.
Ok. Will do. My point is: it is improbable what some body(except me :) )
want to set S_ISUID/S_ISGID bit for non regular files. But it is 
technically possible and result in unexpected consequence.
>
>> Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
>> ---
>>  mm/filemap.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index a2907d5..3d5a2e7 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1767,7 +1767,7 @@ int should_remove_suid(struct dentry *dentry)
>>  	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
>>  		kill |= ATTR_KILL_SGID;
>>  
>> -	if (unlikely(kill && !capable(CAP_FSETID)))
>> +	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
>>  		return kill;
>>  
>>  	return 0;
