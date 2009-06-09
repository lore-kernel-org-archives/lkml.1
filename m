Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZFIHZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZFIHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZFIHZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:25:46 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24068 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZFIHZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:25:46 -0400
Message-ID: <4A2E0E40.5070505@gmail.com>
Date: Tue, 09 Jun 2009 10:24:48 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
       Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Jeff Layton <jlayton@redhat.com>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
Subject: Re: [PATCH] writeback: skip new or to-be-freed inodes
References: <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603141021.GB5738@localhost> <20090603141636.GC5650@duck.suse.cz> <20090603144711.GC5738@localhost> <20090606030725.GA12852@localhost> <4A2CB7AE.6080909@gmail.com> <20090608092930.GA13846@localhost> <20090608104544.GA2428@infradead.org>
In-Reply-To: <20090608104544.GA2428@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jun 2009 07:24:49.0855 (UTC) FILETIME=[5FBA2CF0:01C9E8D3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCed Adiran Hunter]

Christoph Hellwig wrote:
> On Mon, Jun 08, 2009 at 05:29:30PM +0800, Wu Fengguang wrote:
>> Thank you. Basically I'm not sure if UBIFS guarantees it won't be
>> unmounted (hence the MS_ACTIVE bit is on) when calling
>> generic_sync_sb_inodes() in shrink_liability() and ubifs_sync_fs().
> 
> Btw, the call in ubifs_sync_fs should be superflous in the
> vfs-2.6#for-next tree.  We now do make sure that all inodes are flushed
> before calling ->sync_fs with the wait parameter.

OK, thanks for letting know. Once this is merged upstream,
I'll amend UBIFS.

> shrink_liability is a more interesting case, I don't understand enough
> of ubifs to comment on it.

Well... I'm not sure if I can tell why we need this in few
words. But I'll try.

UBIFS supports on-the-flight compression. This, and other factors
lead to a situation when UBIFS does not know how much the dirty
data in the page/inode caches will take on the flash. Indeed,
how do we know how well the data will be compressed?

UBIFS has so called "budgeting" subsystem. This subsystem is
responsible for accounting flash space. If user writes a new
data page, which goes to the page cache and sits there, the
budgeting sub-system decrements the free space counters by
4KiB. And so on.

At some point the free space counters in the budgeting subsystem
reache zero, which means we do not have more space. However,
in 99% of the cases this is not true, because the budgeting
subsystem's calculations are _very_ pessimistic, they always
assume the worst case scenario like the data are uncompressible.

So consider a situation when user writes a new data page. First
of all, the ->write_begin function will call a budgeting
sub-system function in order to reserve flash space for this
new data page.

The budgeting subsystem will see that space counters are zero.
And what it will do it will call the 'shrink_liability()'
function, which, among other things, may call the
'generic_sync_sb_inodes()' function, which will force write-back,
and this will give us some space. Indeed, when we actually
write the data back, we'll see how much flash space they
really take. And in 99% of cases they will take less than
we budgeted for, usually much less.

This is the rough idea. In practice things are more complex,
and there are factors like inability to know how much of dirty
space may be reclaimed, what will be the index size after
commit, etc. This all makes the budgeting subsystem complex
and difficult to understand. Moreover, we still consider it
as a work in progress, because we use too rough calculations,
and there are too many heuristics.

Here you may read some more information about UBIFS flash
accounting issues:
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_spaceacc

You may also find a lot of info here:
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_documentation

Especially in this document:
http://www.linux-mtd.infradead.org/doc/ubifs_whitepaper.pdf
but it is not easy reading. You may search for "budget"
in the doc.

HTH.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
