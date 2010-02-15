Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0BOPlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:41:19 -0500
Received: from borg.medozas.de ([188.40.89.202]:57474 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab0BOPlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:41:18 -0500
Date: Mon, 15 Feb 2010 16:41:17 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jan Kara <jack@suse.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <20100215144938.GD3434@quack.suse.cz>
Message-ID: <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-02-15 15:49, Jan Kara wrote:
>On Sat 13-02-10 13:58:19, Jan Engelhardt wrote:
>> >> 
>> >> This fixes it by using the passed in page writeback count, instead of
>> >> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
>> >> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
>> >> finish properly even when new pages are being dirted.
>> >
>> >This seems broken.
>> 
>> It seems so. Jens, Jan Kara, your patch does not entirely fix this.
>> While there is no sync/fsync to be seen in these traces, I can
>> tell there's a livelock, without Dirty decreasing at all.
>
>  I don't think this is directly connected with my / Jens' patch.

I start to think so too.

>Similar traces happen even without the patch (see e.g.
>http://bugzilla.kernel.org/show_bug.cgi?id=14830). But maybe the patch
>makes it worse... So are you able to reproduce these warnings and
>without the patch they did not happen?

Your patch speeds up the slow sync; without the patch, there was
no real chance to observ the hard lockup, as the slow sync would
take up all time.

So far, no reproduction. It seems to be just as you say.

>  Where in the code is jbd2_journal_commit_transaction+0x218/0x15e0?

0000000000569554 <jbd2_journal_commit_transaction>:
  56976c:       40 04 ee 62     call  6a50f4 <schedule>

Since there is an obvious schedule() call in jbd2_journal_commit_transaction's
C code, I think that's where it is.
