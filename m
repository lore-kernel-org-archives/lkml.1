Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbZE1PXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbZE1PXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbZE1PXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:23:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34697 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZE1PXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:23:38 -0400
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr,
       Alex Chiang <achiang@hp.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
	<20090527144754.GD10842@mit.edu> <20090527175353.GE10842@mit.edu>
	<20090527175830.GF10842@mit.edu> <20090527181402.GP11363@kernel.dk>
	<20090527191524.GS11363@kernel.dk> <20090527194543.GT11363@kernel.dk>
	<20090528004959.GH26625@mit.edu> <20090528092803.GE29199@duck.suse.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 28 May 2009 08:23:28 -0700
In-Reply-To: <20090528092803.GE29199@duck.suse.cz> (Jan Kara's message of "Thu\, 28 May 2009 11\:28\:04 +0200")
Message-ID: <m1octdw8sv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jack@suse.cz, ebiederm@aristanetworks.com, achiang@hp.com, damien.wyart@free.fr, richard@rsk.demon.co.uk, yanmin_zhang@linux.intel.com, akpm@linux-foundation.org, hch@infradead.org, david@fromorbit.com, chris.mason@oracle.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, tytso@mit.edu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Kara <jack@suse.cz>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Wed 27-05-09 20:49:59, Theodore Tso wrote:
>> On Wed, May 27, 2009 at 09:45:43PM +0200, Jens Axboe wrote:
>> > 
>> > This one has been tested good, where good means that it boots and
>> > functions normally at least. Whether it fixes your issue, that would be
>> > interesting to know :-)
>> > 
>> 
>> Unfortunately, it doesn't seem to have.  Here's a dmesg with the
>> softlockup report and the sysrq-t output.  Unfortunately the dmesg
>> file is too big for LKML, so I've compressed it so you can get the
>> whole thing.
>   Everybody waits for sys_sync() to complete and they never seem to be
> woken up. Jens, wb_work_complete() seems a bit fishy - who does
> wb_clear_work() in sync_mode == WB_SYNC_ALL which is on stack?
>
>> There's also a lockdep warning which fsx triggered.
>   The lockdep warning is definitely unrelated. It's really a possible
> deadlock, although not quite probable. IMHO the problem is that
> sysfs_mutex gets above mmap_sem due to code in sysfs_readdir which calls
> filldir() which may cause page fault. At the same time it gets quite low
> on the lock stack because filesystems call sysfs functions from their
> internal functions (in this case ext4_put_super) holding quite some locks.
> Adding a few CC's for this.

Interesting.

I thought the network stack was the only piece of code silly enough
to hold locks while deleting sysfs files.

Holding any lock while deleting a objects from sysfs, sysctl or proc,
is asking for serious mischief, and unfixable from the fs side.

The usual problem is that lockdep doesn't yet understand
sysfs_deactivate which waits for any running sysfs operations to
complete before it deletes the sysfs files.

Which means any lock you hold in a show or store method is can deadlock
with any lock you hold while deleting from sysfs.

ext4 appears lock loose and fancy free in it's show and store methods
so it might be ok except for this issue of mmap_sem vs sysfs_mutex.
But apparently even that isn't enough to git rid of the requirement
to not hold locks when deleting objects.

Eric
