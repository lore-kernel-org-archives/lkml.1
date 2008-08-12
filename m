Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbYHLFgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbYHLFgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYHLFfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:35:43 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41068 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYHLFfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:35:42 -0400
X-Greylist: delayed 1321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 01:35:42 EDT
Message-Id: <6.0.0.20.2.20080812113004.03c68f48@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 12 Aug 2008 12:57:11 +0900
To: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [patch 12/17] vfs: pagecache usage optimization for
  pagesize!=blocksize
Cc: akpm@linux-foundation.org, jack@ucw.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <200808041719.43293.nickpiggin@yahoo.com.au>
References: <200807282246.m6SMkaHT032267@imap1.linux-foundation.org>
 <20080728230031.GA22218@infradead.org>
 <200808041719.43293.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick.

>
>This patch unfortunately appears like it may introduce an
>uninitialized memory leak due to a data race between one
>thread initializing a buffer then marking it uptodate, and
>the other testing buffer uptodate then reading from the
>buffer (buffer, read as: page memory covered by buffer head).
>
>For reference, this is basically the same class of data race
>that I fixed 0ed361dec36945f3116ee1338638ada9a8920905

I think the same issue that your patch 0ed361dec36945f3116ee
1338638ada9a8920905 "fix PageUptodate data race" pointed out 
is there around buffer_head without my patch "vfs: pagecache usage 
optimization for pagesize!=blocksize".
Because set_buffer_uptodate or buffer_uptodate are used without
distinct locking facility (lock_buffer, or lock_page) in many places,
so it would be needed to deal with memory ordering issue.

Do you add wmb/rmb to BUFFER_FNS macros?


>
>I don't think this patch got quite enough justification to
>warrant just blindly putting barriers in the buffer bitops.
>The best-case numbers for it were reasonable enough when the
>downside was only an extra branch or two in a relatively slow
>path. I don't really know how best to go from here (maybe
>someone can argue it is not a problem or come up with a better
>fix?).
>
>Thanks,
>Nick

