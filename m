Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYGCOrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYGCOrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbYGCOqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:46:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbYGCOqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:46:42 -0400
Message-ID: <486CE61C.50706@redhat.com>
Date: Thu, 03 Jul 2008 09:45:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Takashi Sato <t-sato@yk.jp.nec.com>
CC: Christoph Hellwig <hch@infradead.org>, Alasdair G Kergon <agk@redhat.com>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       dm-devel@redhat.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       mtk.manpages@googlemail.com, axboe@kernel.dk
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080701105251.GC22522@agk.fab.redhat.com> <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
In-Reply-To: <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Sato wrote:
> Hi Christoph and Alasdair,
> 
>> On Tue, Jul 01, 2008 at 04:10:26AM -0400, Christoph Hellwig wrote:
>>> I still disagree with this whole patch.
>> Same here - if you want a timeout, what stops you from implementing it in a
>> userspace process?  If your concern is that the process might die without
>> thawing the filesystem, take a look at the userspace LVM/multipath code for
>> ideas - lock into memory, disable OOM killer, run from ramdisk etc.
>> In practice, those techniques seem to be good enough.
> 
> If the freezer accesses the frozen filesystem and causes a deadlock,
> the above ideas can't solve it.  The timeout is useful to solve such a deadlock.
> If you don't need the timeout, you can disable it by specifying "0" as the
> timeout period.
> 
>> Similarly if a device-mapper device is involved, how should the following
>> sequence behave - A, B or C?
>>
>> 1. dmsetup suspend (freezes)
>> 2. FIFREEZE
>> 3. FITHAW
>> 4. dmsetup resume (thaws)
> [...]
>> C:
>>  1 succeeds, freezes
>>  2 fails, remains frozen
>>  3 fails (because device-mapper owns the freeze/thaw), remains frozen
>>  4 succeeds, thaws
> 
> I think C is appropriate and the following change makes it possible.
> How do you think?
> 
> 1. Add the new bit flag(BD_FREEZE_DM) in block_device.bd_state.
>    It means that the volume is frozen by the device-mapper.

Will we add a new bit/flag for every possible subysstem that may call
freeze/thaw?  This seems odd to me.

They are different paths to the same underlying mechanism; it should not
matter if it is an existing freeze from DM or via FIFREEZE or via the
xfs ioctl, or any other mechanism should it?  I don't think this generic
interface should use any flag named *_DM, personally.

It seems that nested freeze requests must be handled in a generic way
regardless of what initiates any of the requests?

Refcounting freezes as Alasdair suggests seems to make sense to me, i.e.
freeze, freeze, thaw, thaw leads to:

>> > > 1 (freeze) succeeds, freezes (frozen++)
>> > > 2 (freeze) succeeds, remains frozen (frozen++)
>> > > 3 (thaw) succeeds, remains frozen (frozen--)
>> > > 4 (thaw) succeeds, thaws (frozen--)

that way each caller of freeze is guaranteed that the fs is frozen at
least until they call thaw?

Thanks,
-Eric
