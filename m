Return-Path: <linux-kernel-owner+w=401wt.eu-S967683AbXFHDrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967683AbXFHDrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967126AbXFHDrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:47:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52238 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966465AbXFHDq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:46:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Albert Cahalan <acahalan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pbadari@us.ibm.com, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	<20070606204432.b670a7b1.akpm@linux-foundation.org>
	<787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
	<20070607162004.GA27802@vino.hallyn.com>
Date: Thu, 07 Jun 2007 21:45:37 -0600
In-Reply-To: <20070607162004.GA27802@vino.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 7 Jun 2007 11:20:04 -0500")
Message-ID: <m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Ok, so IIUC the problem was that inode->i_ino was being set to the id,
> and the id can be the same for different things in two namespaces.

There is nothing preventing inode number collisions in this code even
without multiple namespaces, and even when it was functioning
correctly.  However as it does not seem possible to find these files
through normal filesystem operations that does not seem to be a problem.

> So aside from not using the id as inode->i_ino, an alternative is to use
> a separate superblock, spearate mqeueue fs, for each ipc ns.
>
> I haven't looked at that enough to see whether it's feasible, i.e. I 
> don't know what else mqueue fs is used for.  Eric, does that sound
> reasonable to you?

At this point given that we actually have a small user space dependency
and the fact that after I have reviewed the code it looks harmless to
change the inode number of those inodes, in both cases they are just
anonymous inodes generated with new_inode, and anything that we wrap
is likely to be equally so.

So it looks to me like we need to do three things:
- Fix the inode number
- Fix the name on the hugetlbfs dentry to hold the key
- Add a big fat comment that user space programs depend on this
  behavior of both the dentry name and the inode number.

So Badari it looks like your original patch plus a little bit is
what we need.

Eric
