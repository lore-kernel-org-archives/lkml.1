Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbZATNff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbZATNff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZATNf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:35:26 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:51185 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280AbZATNfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:35:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhICAJhhdUl5LBURgWdsb2JhbACUBQEBFiK2SIVz
X-IronPort-AV: E=Sophos;i="4.37,295,1231075800"; 
   d="scan'208";a="288511976"
Date: Wed, 21 Jan 2009 00:35:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120133521.GD10158@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	LKML <linux-kernel@vger.kernel.org>,
	xfs mailing list <xfs@oss.sgi.com>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120114906.GA12526@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 06:49:06AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 20, 2009 at 12:47:16PM +0100, Jacek Luczak wrote:
> > Christoph Hellwig pisze:
> > > I'm doing about half of my testing on 32 bit x86, and I couldn't
> > > reproduce the detailed receipe  in the kernel.org bugzilla yet.
> > > 
> > > Just curious:  do you have CONFIG_LBD set?
> > 
> > the answer is:
> > $ grep LBD .config
> > # CONFIG_LBD is not set
> 
> Ok, let me reproduce it without that set..

Good call, Christoph. I have a reproduce on ia32, CONFIG_LBD=n,
1k block size, 16 AGs in 4GB. Filesystem pre-prepared by
copying a build kernel onto it then 'make mrproper' to put
holes in it. Then, on boot:

dave@xfs-32:/mnt$ sudo mount /dev/sdb /mnt; cd /mnt
dave@xfs-32:/mnt$ cp /home/dave/linux-2.6.tar.gz . ; sync
dave@xfs-32:/mnt$ sudo xfs_bmap -v linux-2.6.tar.gz
linux-2.6.tar.gz:
 EXT: FILE-OFFSET       BLOCK-RANGE      AG AG-OFFSET         TOTAL
   0: [0..150271]:      92112..242383     0 (92112..242383)  150272
   1: [150272..346879]: 256188..452795    0 (256188..452795) 196608
   2: [346880..445183]: 906390..1004693   1 (382102..480405)  98304
   3: [445184..494335]: 770022..819173    1 (245734..294885)  49152
   4: [494336..543487]: 720870..770021    1 (196582..245733)  49152
   5: [543488..592639]: 671718..720869    1 (147430..196581)  49152
   6: [592640..641791]: 622566..671717    1 (98278..147429)   49152
   7: [641792..737023]: 1398498..1493729  2 (349922..445153)  95232
   8: [737024..781055]: 1353872..1397903  2 (305296..349327)  44032
   9: [781056..830207]: 1304720..1353871  2 (256144..305295)  49152
  10: [830208..879359]: 1255566..1304717  2 (206990..256141)  49152
  11: [879360..925367]: 1209558..1255565  2 (160982..206989)  46008
dave@xfs-32:/mnt$ > linux-2.6.tar.gz
Connection to xfs-32 closed.

I'll see if this is reproducable, and if it is I'll start
instrumenting in the morning during the LCA keynote. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
