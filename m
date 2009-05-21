Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbZEUIjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbZEUIjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 04:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZEUIiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 04:38:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:56352 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZEUIix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 04:38:53 -0400
Message-ID: <4A1512E2.2040505@kernel.org>
Date: Thu, 21 May 2009 17:37:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/20] sysfs: Handle the general case of removing of directories
 with subdirectories
References: <m1bppofm9k.fsf@fess.ebiederm.org>	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>	<4A14F356.3030501@kernel.org> <m1k54a7w2x.fsf@fess.ebiederm.org>	<4A15046A.10106@kernel.org> <m1octm287f.fsf@fess.ebiederm.org>
In-Reply-To: <m1octm287f.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 08:37:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Eric W. Biederman wrote:
>>> The locking is correct, something that is much more difficult to
>>> tell with your version.
>> Why? :-)
> 
> Because mine is all in a single place and there is no optimization
> to get locks I don't need.
> 
> Unless I have misread your patch you are failing to get the
> i_mutex for child directories, if it possible to get it.
> 
> Something that it is trivial to see that I always do correctly.
> Simply because the distance between the lock and where I depend on
> it is so small.

If this patch series works out, we don't need to grab i_mutexes while
manipulating sd's, right?

>>> I would prefer to only remove empty directories.  But when I
>>> instrumented things up I found cases where that does indeed happen.
>> IIRC, my version did the whole thing while holding sysfs_mutex, so
>> it's safe against such races.  I can't really see why ops like this
>> can't be atomic in sysfs.  I don't really care how things are done but
>> please make it atomic.
> 
> Nope.  Holding the sysfs_mutex does not make you safe from such races.
> It actually makes you more prone to someone adding a directory entry to
> a deleted directory and not having it deleted.  I have a chance of
> deleting the added directory entry.
> 
> The problem is that sysfs_add_one takes to sysfs_dirents.  The look up
> of the directory is done before we take the sysfs_mutex.  So the
> sysfs_dirent could be grabbed at any time.

Well, it can be trivially fixed by checking the removed flag.  The
add/rm thing is designed to help additions and removals of multiple
nodes at one go and I'd really like to see it working that way.  Any
chance you can change code toward that direction?

Thanks.

-- 
tejun
