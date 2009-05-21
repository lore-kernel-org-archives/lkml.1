Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZEUHgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZEUHgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 03:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZEUHgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 03:36:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:46883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZEUHgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 03:36:33 -0400
Message-ID: <4A15046A.10106@kernel.org>
Date: Thu, 21 May 2009 16:36:10 +0900
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
References: <m1bppofm9k.fsf@fess.ebiederm.org>	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>	<1242865694-2100-4-git-send-email-ebiederm@xmission.com>	<4A14F356.3030501@kernel.org> <m1k54a7w2x.fsf@fess.ebiederm.org>
In-Reply-To: <m1k54a7w2x.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 07:36:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> I agree we should be heading this way but what happens to attributes
>> or directories living below the subdirectories?  If it's gonna handle
>> recursive case, I think it better do it properly.  I had patches of
>> similar effect.
> 
> I do handle it properly.  sysfs_get_one finds the deepest child of the
> first directory entry.  Then I remove it.  And I repeat until done.
> 
> The locking is correct, something that is much more difficult to
> tell with your version.

Why? :-)

> By grabbing and dropping the sysfs_mutex things are simpler, and they
> get even simpler in future patches.
> 
> Now looking at that code in detail there is a question of what happens if
> we add a directory entry while we are recursively deleting a directory.
> Neither your patch, my patch, nor the existing code handle that case
> (assuming the sysfs_dirent) was looked up before it is removed from it's
> parent directory.  I expect another patch is called for to plug that
> theoretical gap.  
> 
> I expect the way to close that hole is to have an extra flag that says
> we are removing a directory entry and refuse to add if that flag is
> set.
> 
> I would prefer to only remove empty directories.  But when I
> instrumented things up I found cases where that does indeed happen.

IIRC, my version did the whole thing while holding sysfs_mutex, so
it's safe against such races.  I can't really see why ops like this
can't be atomic in sysfs.  I don't really care how things are done but
please make it atomic.

Thanks.

-- 
tejun
