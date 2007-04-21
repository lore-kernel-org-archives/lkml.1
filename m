Return-Path: <linux-kernel-owner+w=401wt.eu-S1031260AbXDUOex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031260AbXDUOex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031267AbXDUOex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:34:53 -0400
Received: from mx1.suse.de ([195.135.220.2]:39576 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031260AbXDUOex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:34:53 -0400
Message-ID: <462A2107.6060902@suse.de>
Date: Sat, 21 Apr 2007 10:34:47 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
Cc: a.righi@cineca.it, Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>, linux-kernel@vger.kernel.org,
       reiserfs-dev@namesys.com, Edward Shishkin <edward@namesys.com>,
       zam@clusterfs.com, ak@suse.de
Subject: Re: Fwd: Fw: [2.6.20.4] BUG: dentry xattrs still in use in shrink_dcache_for_umount()
 with reiserfs
References: <20070413095219.02075323.akpm@linux-foundation.org>	<462536B2.5060308@users.sourceforge.net>	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>	<200704181816.21166.vs@namesys.com>	<46263270.9010108@suse.com> <20070420170738.e269fcae.akpm@linux-foundation.org> <46296CB8.3090100@suse.com> <462A0F06.9020602@cineca.it> <462A2055.1040509@suse.com>
In-Reply-To: <462A2055.1040509@suse.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeff Mahoney wrote:
> Andrea Righi wrote:
>> Jeff Mahoney wrote:
>>> I have the patchset that I mentioned, but I'm not proposing it for 2.6.21.
>>> It's much too invasive to be introduced in an -rc7, but it does include
>>> locking changes that I believe avoid this bug.
>>>
>>> Vladimir was right in his analysis that sometimes get_xa_root() takes the
>>> reference once and other times twice, but not for the right reasons.  I save
>>> a reference to the xattr dir to avoid a lookup later, but when there are multiple
>>> getxattrs or listxattrs as the first xattr operation on the file system, we can end
>>> up taking a second reference when we shouldn't. This is because those operations
>>> are protected by read locks and the ->xattr_root pointer isn't protected by anything
>>> else. A quick fix would be to just extend the protection of the priv root's i_mutex
>>> around the assignment, and test first. The right fix involves a complete rework of
>>> the locking, and I have code to do that, it's just too late to include it in 2.6.21.
>>>
>>> I'd love to know what Andrea (and now Andi Kleen) are doing to hit this now. There
>>> haven't been any changes in this code in a while, and the shrink_dcache_for_umount()
>>> has been around since October. I'm unable to reproduce locally so far, so if Andrea
>>> or Andi could see if this fixes it for them, I'd appreciate it.
>> Jeff, your patch doesn't resolve, but you hit the problem. Actually, I
>> think the xattr_root pointer must be protected also in get_xa_root()
>> using the same private root i_mutex.
>>
>> I've tested the following patch and it resolves in my case. What do you
>> think about it? could it be a reasonable fix?
> 
> Your patch fixes the problem. That'll teach me to spin a patch up while I'm headed
> out the door. I think a cleaner solution for now is just to refactor get_xa_root,
> __get_xa_root, and create_xa_root into one function to simplify the lookup and the
> locking. I think I'll add another step to my patch set that removes the caching of
> xattr_root entirely or creates in on mount, as the priv root is created. The privroot
> must be cached to avoid a deadlock on the fs-root directory's i_mutex, but xattr_root
> was cached as an optimzation. If we need to take privroot->i_mutex every time, there's
> no point in caching it since it will probably be in the dcache anyway.
> 
> -Jeff
> 

Ignore this patch. I missed a spot.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGKiEHLPWxlyuTD7IRApRTAJ0WeJzkH7julSus9iqx+LYoAAlFOwCfahu0
4qN7BR/monh7ZcQWZ7Vmz3Y=
=UNNw
-----END PGP SIGNATURE-----
