Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559Ab0ALBDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0ALBDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443Ab0ALBDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:03:01 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54987 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0ALBDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:03:00 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
	<1263241315-19499-3-git-send-email-ebiederm@xmission.com>
	<4B4BC683.7060508@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 17:02:51 -0800
In-Reply-To: <4B4BC683.7060508@kernel.org> (Tejun Heo's message of "Tue\, 12 Jan 2010 09\:46\:59 +0900")
Message-ID: <m1y6k43zk4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On 01/12/2010 05:21 AM, Eric W. Biederman wrote:
>> On large directories sysfs_count_nlinks can be a significant
>> bottleneck, so keep a count in sysfs_dirent.
>
> I was about to suggest changing s_flags to ushort too.  Hmmm... adding
> a new field to sysfs_dirent somewhat worries me but this doesn't add
> to the size of the structure.  How significant bottlenect are we
> talking about?

It was seen in measurements of sysfs before my last round of changes,
which cause us to refresh the inode, and call sysfs_count_nlink more
often.

I am surprised no one has complained about 2.6.33-rcN yet and reported
a performance regression.

Ultimately not having a cached nlink count transforms what should
be constant time operations to operations that run in time O(N).

>> If we exceed the maximum number of directory entries we can store
>> return nlink of 1.  An nlink of 1 matches what reiserfs does in this
>> case, and it let's find and similar utlities know that we have a the
>> directory nlink can not be used for optimization purposes.
>
> Hmmm... what's the limit on reiserfs?  Is it 64k too?

The resierfs limit is a bit short of a 32bit number.  Ext[234]
all have a 16bit nlink field, and they fail the operation
when you attempt to increment nlink past their limit.

In this case the comparison with reiserfs is to show that at some
point throwing up our hands and not counting and just returning nlink
1 is something userspace can occassionally expect to see.  It is
common enough that find has handled this idiom for years.

Since we can handle this without increasing the size of the sysfs_dirent
I figure we should have a good quality of implementation for the common
case and return something userspace can deal with for the extreme cases.

Eric
