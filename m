Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab0BEKBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 05:01:03 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:55803 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828Ab0BEKBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 05:01:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PXuNzv7ZvVD7xgNg/BQ/gd/SIv3BSPYrZRH2jzFeMxYL5UyLMaMUyUZ5ennG0oW4Mt
         WVtQBbOLCHXSYwSmsjyVbbXO55aS+KiROBcuXG6+kp1V1eM91xB+sgrxbyUy8lG/r+2i
         ZXb6gG1o2hZJei7pZ0wV97+82p7Ck/ATpYiTM=
MIME-Version: 1.0
In-Reply-To: <m1zl3odnt0.fsf@fess.ebiederm.org>
References: <20100205064622.4141.72867.sendpatchset@localhost.localdomain>
	 <7b6bb4a51002042309v3ca1dd0p60b9dbcacdafaee6@mail.gmail.com>
	 <m1zl3odnt0.fsf@fess.ebiederm.org>
Date: Fri, 5 Feb 2010 18:00:59 +0800
Message-ID: <7b6bb4a51002050200m669ac1dv8b525cc843e10d60@mail.gmail.com>
Subject: Re: [Patch v2] sysfs: add lockdep class support to s_active
From: Xiaotian Feng <xtfeng@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 5, 2010 at 5:39 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
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
>>> [ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
>>> sysfs_hash_and_remove+0x3d/0x4f
>>> [ 6967.970493]
>>> [ 6967.970497] but task is already holding lock:
>>> [ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
>>> sysfs_get_active_two+0x16/0x36
>>> [...]
>>>
>>> Eric already provides a patch for this[1], but it still can't fix the
>>> problem. Based on his work and Peter's suggestion, I write this patch,
>>> hopefully we can fix the warning completely.
>>>
>>> This patch put sysfs s_active into two classes, one is for PM, the other
>>> is for the rest, so lockdep will distinguish them.
>>
>> I think this patch does not hit the root cause, we have a similiar
>> warning which is not related with PM.
>
> The root cause is that our locking is crazy complicated.  No lockdep
> changes are going to fix that.
>
> What we can do and what the patch does is teach lockdep to treat some
> of the sysfs files as a different group (subclass) from other sysfs
> files.  Which keeps us from overgeneralizing too much and having
> a better signal to noise ratio.
>
> As for the block device problem goes, I can't easily say that
> the block layer is correct.  I expect it is because changing
> the scheduler is unlikely to delete block devices.  If the block layer
> has bugs then adding another subclass as Amerigo suggests should simply
> make lockdep warnings harder to trigger and more accurate so that
> sounds like a path worth walking.
>
> In general I recommend that pieces of code that need to do a lot of
> work in a sysfs attribute consider using a work queue or a kernel
> thread, as that can be easier to analyze.

PM case
store /sys/devices/system/cpu1/online
remove /sys/devices/system/cpu1/cache/

iosched case
store /sys/block/sdx/queue/scheduler
remove /sys/block/sdx/queue/iosched/

So it looks like this is from sysfs layer ....

>
> Eric
>
