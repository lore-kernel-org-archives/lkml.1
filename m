Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0BEJqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 04:46:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab0BEJqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 04:46:01 -0500
Message-ID: <4B6BE966.8010006@redhat.com>
Date: Fri, 05 Feb 2010 17:48:22 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Xiaotian Feng <xtfeng@gmail.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Patch v2] sysfs: add lockdep class support to s_active
References: <20100205064622.4141.72867.sendpatchset@localhost.localdomain>	<7b6bb4a51002042309v3ca1dd0p60b9dbcacdafaee6@mail.gmail.com> <m1zl3odnt0.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl3odnt0.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Xiaotian Feng <xtfeng@gmail.com> writes:
> 
>> On Fri, Feb 5, 2010 at 2:42 PM, Amerigo Wang <amwang@redhat.com> wrote:
>>> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
>>> As reported by several people, it is something like:
>>>
>>> [ 6967.926563] ACPI: Preparing to enter system sleep state S3
>>> [ 6967.956156] Disabling non-boot CPUs ...
>>> [ 6967.970401]
>>> [ 6967.970408] =============================================
>>> [ 6967.970419] [ INFO: possible recursive locking detected ]
>>> [ 6967.970431] 2.6.33-rc2-git6 #27
>>> [ 6967.970439] ---------------------------------------------
>>> [ 6967.970450] pm-suspend/22147 is trying to acquire lock:
>>> [ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
>>> sysfs_hash_and_remove+0x3d/0x4f
>>> [ 6967.970493]
>>> [ 6967.970497] but task is already holding lock:
>>> [ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
>>> sysfs_get_active_two+0x16/0x36
>>> [...]
>>>
>>> Eric already provides a patch for this[1], but it still can't fix the
>>> problem. Based on his work and Peter's suggestion, I write this patch,
>>> hopefully we can fix the warning completely.
>>>
>>> This patch put sysfs s_active into two classes, one is for PM, the other
>>> is for the rest, so lockdep will distinguish them.
>> I think this patch does not hit the root cause, we have a similiar
>> warning which is not related with PM.
> 
> The root cause is that our locking is crazy complicated.  No lockdep
> changes are going to fix that.
> 
> What we can do and what the patch does is teach lockdep to treat some
> of the sysfs files as a different group (subclass) from other sysfs
> files.  Which keeps us from overgeneralizing too much and having
> a better signal to noise ratio.
> 
> As for the block device problem goes, I can't easily say that
> the block layer is correct.  I expect it is because changing
> the scheduler is unlikely to delete block devices.  If the block layer
> has bugs then adding another subclass as Amerigo suggests should simply
> make lockdep warnings harder to trigger and more accurate so that
> sounds like a path worth walking.
> 
> In general I recommend that pieces of code that need to do a lot of
> work in a sysfs attribute consider using a work queue or a kernel
> thread, as that can be easier to analyze.
> 

Cc'ing Jens Axboe.
