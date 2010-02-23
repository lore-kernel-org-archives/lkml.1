Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab0BWB4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:56:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43210 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0BWB4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:56:19 -0500
Message-ID: <4B8335B7.6010807@canonical.com>
Date: Mon, 22 Feb 2010 17:56:07 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com> <20100222161714.de1a7fca.akpm@linux-foundation.org>
In-Reply-To: <20100222161714.de1a7fca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 20 Feb 2010 04:27:38 -0800 john.johansen@canonical.com wrote:
> 
>> From: John Johansen <john.johansen@canonical.com>
>>
>> When __d_path() hits a lazily unmounted mount point, it tries to prepend
>> the name of the lazily unmounted dentry to the path name.  It gets this wrong,
>> and also overwrites the slash that separates the name from the following
>> pathname component. This patch fixes that; if a process was in directory
>> /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
>> missing slash), while the new result with this patch is ``/foo/bar''.
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
>> ---
>>  fs/dcache.c |   27 +++++++++++++++++++++++----
>>  1 files changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index 953173a..df49666 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -1922,11 +1922,9 @@ char *__d_path(const struct path *path, struct path *root,
>>  	retval = end-1;
>>  	*retval = '/';
>>  
>> -	for (;;) {
>> +	while(dentry != root->dentry || vfsmnt != root->mnt) {
> 
thanks, forgot to refresh after checkpatch

> Please put a space between the `while' and the `('.
> 
>>  		struct dentry * parent;
>>  
>> -		if (dentry == root->dentry && vfsmnt == root->mnt)
>> -			break;
>>  		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
>>  			/* Global root? */
>>  			if (vfsmnt->mnt_parent == vfsmnt) {
>> @@ -1950,9 +1948,30 @@ out:
>>  	return retval;
>>  
>>  global_root:
>> -	retval += 1;	/* hit the slash */
>> +	/*
>> +	 * We went past the (vfsmount, dentry) we were looking for and have
>> +	 * either hit a root dentry, a lazily unmounted dentry, an
>> +	 * unconnected dentry, or the file is on a pseudo filesystem.
>> +	 */
>> +	if ((dentry->d_sb->s_flags & MS_NOUSER) ||
>> +	    (dentry->d_name.len = 1 && *dentry->d_name.name == '/')) {
> 
> Did you really mean to assign 1 to dentry->d_name.len here?  Was `=='
> intended?  I hope so, because modifying the dentry in d_path() would be odd.
> 
> If this was a mistake then why did the patch pass testing?
> 
Nope, definite bug, missed that case in testing.  In this case every test that
had a leading '/' had a d_name.len == 1 as well.

I haven't seen the case of where a root dentry has a leading / and doesn't have
a d_name.len == 1 and if that case never happens the test wouldn't be needed.

I will respin the patch, and include testing this time

thanks
john
