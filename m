Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZKIWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZKIWex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 17:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZKIWew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 17:34:52 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46033 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbZKIWew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 17:34:52 -0500
MIME-Version: 1.0
In-Reply-To: <20091109141439.GA10927@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	 <1257249429-12384-12-git-send-email-ebiederm@xmission.com>
	 <20091104214938.GA21033@us.ibm.com> <m13a4ux86v.fsf@fess.ebiederm.org>
	 <4AF4D76C.6090008@kernel.org> <20091109141439.GA10927@us.ibm.com>
Date: Mon, 9 Nov 2009 14:34:57 -0800
Message-ID: <aca0ce8b0911091434k17b3add2rbff3792375ab2165@mail.gmail.com>
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
From: Eric Biederman <ebiederm@aristanetworks.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 6:14 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Tejun Heo (tj@kernel.org):
>> Hello,
>>
>> Eric W. Biederman wrote:
>> > It isn't what I want but it is what the VFS requires.  If let the vfs
>> > continue on it's delusional state we will leak the vfs mount and
>> > everything mounted on top of it, with no way to remove the mounts.
>>
>> This is caused by not having any way to prevent deletion on
>> directories with submounts, right?  How does other distributed
>> filesystems deal with directories with submounts going away underneath
>> it?
>
> Ooooh.  I see, I was thinking only about the rename case, and forgot
> this was the path for deleted files, too.  For the rename case it
> should be ok to let the dentry be put since the submounts will be
> accessible at the new location, right?  Should that be handled
> separately?

No in the rename case it isn't ok to let the dentry be discarded put as mounts
are implemented using a hash of the struct dentry's address, and if you aren't
the mount point you are referenced as d_parent.

For rename I am slightly better than NFS.  sysfs does not support hard
links so if I am looking up the new name I can look for a preexisting
dentry for my
inode and if I find one I call d_move on it to lazily perform the rename.

Eric
