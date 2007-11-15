Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXKOFZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXKOFZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 00:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXKOFZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 00:25:43 -0500
Received: from paragon.brong.net ([74.52.187.94]:51520 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbXKOFZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 00:25:42 -0500
Date: Thu, 15 Nov 2007 16:25:38 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Christian Kujau <lists@nerdbynature.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071115052538.GA21522@brong.net>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de> <20071115040708.GB15302@brong.net> <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 08:24:53PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 15 Nov 2007, Bron Gondwana wrote:
> > 
> > And congratulations to him for that.  We almost entirely dropped 2.6.16,
> > but there's a regression some time since then that makes large MMAPed
> > files a major pain (specifically the dcc database clean takes about 5
> > minutes on 2.6.16 and about 12 hours on 2.6.20 or 2.6.23 series kernels)
> > 
> > But we keep putting off writing a small testcase that can repeat the
> > issue so we can bisect it - because it's working fine with 2.6.16 on
> > that machine.
> 
> Heh. I suspect you don't even need to bisect it.
> 
> The big difference with large mmap'ed files is that later kernels will 
> actually track dirty ratios for dirty mmap'ed pages. Earlier kernels never 
> did.
> 
> So in older kernels, you can dirty as much memory as you want, and the 
> kernel will never try to write it back (well - "never" here means one of 
> either (a) you ask it to with msync or (b) you run out of memory, when the 
> kernel then totally falls down and the machine is essentially unusuable).
> 
> So *if* the symptom seems to be that the later kernels do a lot more IO, 
> then try to change 
> 
> 	/proc/sys/vm/dirty_[background_]ratio
> 
> which is just a percentage of memory (defaults to 5% for background and 
> 10% for foreground dirtying). Turn them both up a lot (say to 50 and 80 
> percent respectively) and see if that makes a difference.

>From our sysctl.conf:
# This should help reduce flushing on Cache::FastMmap files
vm.dirty_background_ratio = 50
vm.dirty_expire_centisecs = 9000
vm.dirty_ratio = 80
vm.dirty_writeback_centisecs = 3000

So we've already been running those settings for a while.  They didn't
help.

We also gave this thing its very own dedicated ServeRAID card and
associated RAID1 set of high speed SCSI drives (mainly because they
were just sitting there already attached to the machine and unused,
we don't love DCC that much) and it didn't help.  Helped the rest of
the machine now that the system drive wasn't being pegged 100% for
12 hours a day, but it didn't speed things up any.

It was making some pretty random little scattered changes all through
that file.  Hmm.. here's what the developers said about it:


  First dbclean creates a new dcc_db file by copying from the old file.
  As it copies, it decides whether each record is worth keeping.
  That involves looking up the checksums in the old hash table.  This
  is as almost afast a simple /bin/cp if the old dcc_db and dcc_db.hash
  files fit in RAM.

  The dbclean creates a new dcc_db.hash file.  This starts with
  creating an empty new dcc_db.hash file.  Then the new dcc_db and
  dcc_db.hash files are mapped into memory, and dbclean creates pointers
  to each checksum in the dcc_db file in the dcc_db.hash file.

  While dbclean is running, dccd unmaps everything and tries to stay out
  of the way.

 
> If so, you'll be the first one to officially even notice this change, I 
> think.

Yay for us.  Thankfully it doesn't affect Cyrus's MMAP usage (read only
with direct seek and write calls to change anything, then remap) or we
would have suffered pretty badly!

Guess we'd better get on to figuring building a simple test app.  The
mmap file that DCC uses is about 2Gb if that makes any difference:

-rw-r--r-- 1 dcc  dcc  2035138560 Nov 15 00:15 dcc_db
-rw-r--r-- 1 dcc  dcc   516612096 Nov 14 06:27 dcc_db.hash

The machine has 6Gb of memory and should be able to fit these
files fine:

[root@out1 hm]$ free
             total       used       free     shared    buffers     cached
Mem:       6232364    5758112     474252          0      41756    3002528
-/+ buffers/cache:    2713828    3518536
Swap:      2048248      74944    1973304


And here's what top says about the process:
      15   0 1914m  57m  41m D    5  1.0 346:07.79 dccd

This is on: 2.6.16.55-reiserfix-fai 
  (one small patch to reiserfs, and built with netboot support for FAI)


So yeah - we'll try to get a clearer idea of what it's doing, but the
knob twiddle didn't work for us.

Bron.
