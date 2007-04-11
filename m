Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbXDKSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbXDKSNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXDKSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:13:38 -0400
Received: from mx1.suse.de ([195.135.220.2]:35024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbXDKSNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:13:37 -0400
Message-ID: <461D254C.9020607@suse.com>
Date: Wed, 11 Apr 2007 14:13:32 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] autofs4: fix race in unhashed dentry code
References: <461CF939.9030104@suse.com>	 <1176313777.3377.21.camel@raven.themaw.net>	 <1176314412.3377.29.camel@raven.themaw.net> <1176314894.3377.34.camel@raven.themaw.net>
In-Reply-To: <1176314894.3377.34.camel@raven.themaw.net>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ian Kent wrote:
> On Thu, 2007-04-12 at 02:00 +0800, Ian Kent wrote:
>> On Thu, 2007-04-12 at 01:49 +0800, Ian Kent wrote:
>>> On Wed, 2007-04-11 at 11:05 -0400, Jeff Mahoney wrote:
>>>>  Commit f50b6f8691cae2e0064c499dd3ef3f31142987f0 introduced a
>>>>  race in autofs4 between autofs_lookup_unhashed() and
>>>>  autofs_dentry_release().
>>>>
>>>>  autofs_dentry_release() ends up clearing the ->dentry and ->inode
>>>>  members of autofs_info before removing it from the rehash list. The
>>>>  list is protected by the rehash lock in both functions, but
>>>>  since autofs_dentry_release() starts tearing the autofs_info struct
>>>>  down before removing it from the list, autofs_lookup_unhashed() can
>>>>  get a autofs_info with a NULL dentry.
>>>>
>>>>  This patch moves the clearing of ->dentry and ->inode after the removal
>>>>  from the rehash list.
>>> Oh .. excellent, I had a bug report but I just couldn't see it for
>>> looking.
>> Maybe I've been a bit hasty with the celebration.
>> It looks like I've got a bigger locking problem here.
>> If autofs4_dentry_release waits on the rehash lock and
>> autofs4_lookup_unhashed reclaims it then the info struct and the dentry
>> go away unconditionally as the release is called just prior to freeing
>> the dentry memory, right?.
> 
> No I'm wrong, dentry_iput holds the dcache locks till it sets d_inode to
> NULL, the point of the d_inode check in autofs4_lookup_unhashed.
> 
> My day is still made.
> 

Ok, that was quick. I thought it was ok, but was about to dig back in to
make sure. :)

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGHSVMLPWxlyuTD7IRArOcAKCGwXJaqObc3ee3W810zv5CU2h/MgCfbLUd
4dR++d9OFimkdWGYcmJvWlE=
=+Tlm
-----END PGP SIGNATURE-----
