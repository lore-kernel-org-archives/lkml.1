Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYJVPf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYJVPf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYJVPfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:35:20 -0400
Received: from saeurebad.de ([85.214.36.134]:41854 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYJVPfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:35:19 -0400
X-Greylist: delayed 1745 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 11:35:18 EDT
From: Johannes Weiner <hannes@saeurebad.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: lachlan@sgi.com, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS?
References: <20081017165738.GA20818@infradead.org>
	<a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
	<20081017203710.GA27187@infradead.org>
	<20081017135510.7127c4e7@infradead.org>
	<a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com>
	<20081020163327.GA15651@infradead.org>
	<a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com>
	<20081020223549.GA21152@disturbed>
	<a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com>
	<20081022075838.GK18495@disturbed> <20081022082550.GM18495@disturbed>
Date: Wed, 22 Oct 2008 17:06:02 +0200
In-Reply-To: <20081022082550.GM18495@disturbed> (Dave Chinner's message of
	"Wed, 22 Oct 2008 19:25:50 +1100")
Message-ID: <87y70gk6ud.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

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

Ran into the same problem, the fix worked for me.

Thank you.

	Hannes
