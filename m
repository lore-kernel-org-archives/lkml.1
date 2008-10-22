Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYJVJMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYJVJMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYJVJMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:12:24 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36752 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYJVJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lcGGHkXc+zYH/telubf3FmlYORJEXNslgtfcalerOLiVt2lD5+F9qBUJgXJ7g9tOLZ
         xFurc6F3AbbUh/gNR1+SPKbl+ouM2fi5VUNAkTkDuNjztHpRibLrJQVucoqF7379ZFud
         N5rgJU9jZtsBmq0b3+LjrwT3uOqAzQHP2tMc8=
Message-ID: <a4423d670810220212g64711390x1963da748f6084c2@mail.gmail.com>
Date: Wed, 22 Oct 2008 13:12:22 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Dave Chinner" <david@fromorbit.com>, lachlan@sgi.com,
       "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
In-Reply-To: <20081022082550.GM18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081017165738.GA20818@infradead.org>
	 <20081017203710.GA27187@infradead.org>
	 <20081017135510.7127c4e7@infradead.org>
	 <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
	 <20081020163327.GA15651@infradead.org>
	 <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
	 <20081020223549.GA21152@disturbed>
	 <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com>
	 <20081022075838.GK18495@disturbed> <20081022082550.GM18495@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/22 Dave Chinner <david@fromorbit.com>:
> On Wed, Oct 22, 2008 at 06:58:38PM +1100, Dave Chinner wrote:
>> On Tue, Oct 21, 2008 at 03:42:16PM +0400, Alexander Beregalov wrote:
>> > Bisected to:
>> > dd509097cb0b76d3836385f80d6b2d6fd3b97757 is first bad commit
>> > commit dd509097cb0b76d3836385f80d6b2d6fd3b97757
>> > Author: Lachlan McIlroy <lachlan@sgi.com>
>> > Date:   Mon Sep 29 14:56:40 2008 +1000
>> >
>> >     [XFS] Unlock inode before calling xfs_idestroy()
>> >
>> >     Lock debugging reported the ilock was being destroyed without being
>> >     unlocked. We don't need to lock the inode until we are going to insert it
>> >     into the radix tree.
>>
>> Ah, OK, I see the problem, though I don't understand why I'm not
>> seeing the might_sleep() triggering all the time given that I always
>> build with:
>>
>> $ grep SLEEP .config
>> CONFIG_DEBUG_SPINLOCK_SLEEP=y
>>
>> Basically the above commit moved xfs_ilock() inside
>> radix_tree_preload()/radix_tree_preload_end(), which means we are
>> taking a rwsem() while we have an elevated preempt count. I'll
>> get a patch out to fix it.
>
> Patch below (against the xfs master/linux-next branch) should fix the
> regression. I've just started QA on it. Can you please check that
> it works for you, Alexander?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> XFS: Can't lock inodes in radix tree preload region
>
> When we are inside a radix tree preload region, we cannot
> sleep. Recently we moved the inode locking inside the
> preload region for the inode radix tree. Fix that,
> and fix a missed unlock in another error path in the
> same code at the same time.
>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>

Yes, it fixes the issue. Thanks
