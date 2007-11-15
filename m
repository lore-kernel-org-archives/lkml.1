Return-Path: <linux-kernel-owner+w=401wt.eu-S1763772AbXKOT5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763772AbXKOT5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbXKOT5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:57:21 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38511 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554AbXKOT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:57:20 -0500
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1195155759.22457.29.camel@lappy> (message from Peter Zijlstra on
	Thu, 15 Nov 2007 20:42:38 +0100)
Subject: Re: [RFC] fuse writable mmap design
References: <E1IshIR-0000fE-00@dorka.pomaz.szeredi.hu>
	 <1195154530.22457.16.camel@lappy>
	 <E1IskWl-0000oJ-00@dorka.pomaz.szeredi.hu> <1195155759.22457.29.camel@lappy>
Message-Id: <E1Iskpw-0000qY-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 Nov 2007 20:57:16 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The next point then, I'd expect your fuse_page_mkwrite() to push
> writeout of your 32-odd mmap pages instead of poll.

You're talking about this:

+	wait_event(fc->writeback_waitq,
+		   fc->numwrite < FUSE_WRITEBACK_THRESHOLD);

right?  It's one of the things I need to clean out, there's no point
in fc->numwrite, which is essentially the same as the BDI_WRITEBACK
counter.

OTOH, I'm thinking about adding a per-fs limit (adjustable for
privileged mounts) of dirty+writeback.

I'm not sure how hard would it be to add support for this into
balance_dirty_pages().  So I'm thinking of a parameter in struct
backing_dev_info that is used to clip the calculated per-bdi threshold
below this maximum.

How would that affect the proportions algorithm?  What would happen to
the unused portion?  Would it adapt to the slowed writeback and
allocate it to some other writer?

Miklos
