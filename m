Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYGAKx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYGAKx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYGAKxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:53:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbYGAKxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:53:04 -0400
Date: Tue, 1 Jul 2008 11:52:51 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
       mtk.manpages@googlemail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>, viro@ZenIV.linux.org.uk,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       akpm@linux-foundation.org,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080701105251.GC22522@agk.fab.redhat.com>
Mail-Followup-To: Takashi Sato <t-sato@yk.jp.nec.com>,
	Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
	mtk.manpages@googlemail.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	viro@ZenIV.linux.org.uk,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	akpm@linux-foundation.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701081026.GB16691@infradead.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 04:10:26AM -0400, Christoph Hellwig wrote:
> I still disagree with this whole patch.  

Same here - if you want a timeout, what stops you from implementing it in a
userspace process?  If your concern is that the process might die without
thawing the filesystem, take a look at the userspace LVM/multipath code for
ideas - lock into memory, disable OOM killer, run from ramdisk etc.
In practice, those techniques seem to be good enough.

> call can hang and this would be theoretically useful is when the
> filesystem is already frozen by someone else, but this should be fixed
> by refusing to do the second freeze, as suggested in my comment to patch
> 1.

Similarly if a device-mapper device is involved, how should the following
sequence behave - A, B or C?

1. dmsetup suspend (freezes)
2. FIFREEZE
3. FITHAW
4. dmsetup resume (thaws)

A:
  1 succeeds, freezes
  2 succeeds, remains frozen
  3 succeeds, remains frozen
  4 succeeds, thaws

B:
  1 succeeds, freezes
  2 fails, remains frozen
  3 shouldn't be called because 2 failed but if it is: succeeds, thaws
  4 succeeds (already thawed, but still does the device-mapper parts)

C:
  1 succeeds, freezes
  2 fails, remains frozen
  3 fails (because device-mapper owns the freeze/thaw), remains frozen 
  4 succeeds, thaws

Alasdair
-- 
agk@redhat.com
