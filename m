Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbYGMRQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbYGMRQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYGMRP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:15:59 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:13105 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYGMRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:15:58 -0400
Message-ID: <487A383F.50600@hp.com>
Date: Sun, 13 Jul 2008 13:15:43 -0400
From: jim owens <jowens@hp.com>
User-Agent: Mozilla/5.0 (X11; U; OSF1 alpha; en-US; rv:1.7.13) Gecko/20060421
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       t-sato@yk.jp.nec.com, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       mtk.manpages@googlemail.com
Subject: Re: [PATCH 3/3] Add timeout feature
References: <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed> <4874C3E8.20804@hp.com> <20080713120602.GC7517@elf.ucw.cz>
In-Reply-To: <20080713120602.GC7517@elf.ucw.cz>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>>This means ONLY SOME metadata (or no metadata) is flushed and
>>then all metadata updates are stopped.  User/kernel writes
>>to already allocated file pages WILL go to a frozen disk.
> 
> That's the difference here. They do write file data, and thus avoid
> mmap()-writes problem.
> 
> ...and they _still_ provide auto-thaw.
> 								Pavel

One of the hardest things to make people understand is that
stopping file data writes in the filesystem during a freeze
is not just dangerous, it is also __worthless__ unless you
have a complete "user environment freeze" mechanism.

In a real 24/7 environment, the DB and application stack
may be poorly glued together stuff from multiple vendors.

And unless each independent component has a freeze and they
can all be coordinated, the data in the pipeline is never
stable enough to say "if you stop all writes to disk and
take a snapshot, this is the same as an orderly shutdown,
backup, restore, and startup".

If you need to stop applications before a freeze, there
is no reason to implement "stop writing file data to disk".

The only real way to make it work (and what the smart apps
do) is to have application "checkpoint" commands so they
can roll-back to a stable point from the snapshot while
allowing new user activity to proceed.

People who don't have checkpoints or some other way to
make their environment stable with a transitioning snapshot
must stop all user activity before snapshotting and have
maintenance windows defined to do that.

jim
