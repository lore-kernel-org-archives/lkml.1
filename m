Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZEDFBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZEDFBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 01:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZEDFBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 01:01:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:55747 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZEDFBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 01:01:41 -0400
Message-ID: <49FE769D.2000402@suse.com>
Date: Mon, 04 May 2009 01:01:17 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       David <david@unsolicited.net>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
References: <49FB1F20.8040400@suse.com> <20090503085236.GT8633@ZenIV.linux.org.uk>
In-Reply-To: <20090503085236.GT8633@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> On Fri, May 01, 2009 at 12:11:12PM -0400, Jeff Mahoney wrote:
>>  2.6.30-rc3 introduced some sanity checks in the VFS code to avoid NFS
>>  bugs by ensuring that lookup_one_len is always called under i_mutex.
>>
>>  This patch expands the i_mutex locking to enclose lookup_one_len. This was
>>  always required, but not not enforced in the reiserfs code since it
>>  does locking around the xattr interactions with the xattr_sem.
>>
>>  This is obvious enough, but it survived an overnight 50 thread ACL test.
> 
> It's not enough, unfortunately ;-/  It deals with the warning, but it
> leaves an actual hole in there.
> 
> Look: what happens if we mount it r/o without that directory and then
> remount r/w?  We get dentry for privroot, hash it (negative at that point),
> then do actual mkdir, unlock root and modify the ->d_compare() of root
> to reject lookups on that sucker.  Too late - in the meanwhile lookups
> might very well come and find privroot in dcache.
> 
> BTW, the way ->d_compare() is done in there is rather dumb -
> 	if (q1 == &priv_root->d_name)
> 		return -ENOENT;
> 	...
> would do just as well.  Why don't we do that lookup *once* (on ->get_sb(),
> before anything can come and race with us), and then just keep negative
> dentry if the directory hadn't been around?  And set d_compare() for root
> immediately after that lookup...
> 
> I've applied your patch as-is, and unless you have objections to the
> variant above I'll do that as incremental.  Comments?

Of course you're right about the lookup hole.

The lookup during remount is from when the code didn't enable xattrs
unconditionally for security and trusted attributes. The privroot would
only be created when mounted read-write with -oacl and/or -ouser_xattr.
Now xattrs are enabled uncondtionally, so any read-write mount will
create that if xattrs are enabled in the kernel. It used to avoid
caching a negative lookup that would never get used.

I don't have any objections to any of your suggestions.

Thanks!

- -Jeff
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkn+dp0ACgkQLPWxlyuTD7KuwQCgmrYQhuDy+HylXPL46Yb2R9Y+
Fr0AoIKRyL4mX1wCR+R9WN74zULTrbXT
=LSDi
-----END PGP SIGNATURE-----
