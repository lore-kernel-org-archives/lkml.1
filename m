Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620Ab0ALBG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0ALBG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462Ab0ALBG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:06:58 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43138 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab0ALBG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:06:57 -0500
To: Benjamin LaHaise <bcrl@lhnet.ca>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
	<1263241315-19499-3-git-send-email-ebiederm@xmission.com>
	<4B4BC683.7060508@kernel.org> <20100112005308.GL5524@kvack.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 17:06:53 -0800
In-Reply-To: <20100112005308.GL5524@kvack.org> (Benjamin LaHaise's message of "Mon\, 11 Jan 2010 19\:53\:08 -0500")
Message-ID: <m1vdf82ksy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@lhnet.ca> writes:

> On Tue, Jan 12, 2010 at 09:46:59AM +0900, Tejun Heo wrote:
>> Hello,
>> 
>> On 01/12/2010 05:21 AM, Eric W. Biederman wrote:
>> > On large directories sysfs_count_nlinks can be a significant
>> > bottleneck, so keep a count in sysfs_dirent.
>> 
>> I was about to suggest changing s_flags to ushort too.  Hmmm... adding
>> a new field to sysfs_dirent somewhat worries me but this doesn't add
>> to the size of the structure.  How significant bottlenect are we
>> talking about?
>
> 100,000 entries in a sysfs directory is a requirement for network devices.

I haven't limited that.

>> > If we exceed the maximum number of directory entries we can store
>> > return nlink of 1.  An nlink of 1 matches what reiserfs does in this
>> > case, and it let's find and similar utlities know that we have a the
>> > directory nlink can not be used for optimization purposes.
>> 
>> Hmmm... what's the limit on reiserfs?  Is it 64k too?
>
> 64k is too small.  10 gig interfaces can currently service 50-100k users, 
> each of which requires their own network device.

64k is the point at which I stop returning a userful nlink number to
userspace, sysfs directories can still scale to any size.

I could legitimately always return nlink == 1, and all userspace
utilities that I know of would be fine, but I am trying to be a bit
more polite than that.

I don't see the link count as interesting enough to store more than
16bits for it.  Even with 32bits of storage for nlink sysfs would have
to have to handle the rollover case as I am doing now.  So I don't
see any advantage to storing more bits.

Eric
