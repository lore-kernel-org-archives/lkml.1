Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZCEC4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZCEC4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 21:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZCECzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 21:55:54 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:48231 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752254AbZCECzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 21:55:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VfldiinwgvO2/XALGtU2Z2MMa21Ln1WGI/MgCRqUUu9wUKO+Z/TO9QivEYGvaVKc3HVdhX0qcnsCLtqAOOwg/Xb0RUm/AOQsjVh7qq/k2QCW98C7+Px81zUihzjt2vO7GkkXIGp5QyXNWy5Y2FwMidl29gRehnXFZXBwGIdXKQg=  ;
X-YMail-OSG: lRKMl38VM1lB4r2PVGt0x88kL8OqTmNTlT0iGtAt9xxnK2_pzLBgorqnbUpCQUFO_ytP9xVvwVcq4XU8FHvfiFIotO4JJfz2Y0.lL7OJ8LTGT4gW0WjrqIpRSL.FdRoDEwkH45gsF9TEorWiRlFAp7TG14oqdBZrEFeZzKrCHYYvxGwxvSGlCAGq0ZCfhw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: fsx-linux loosing mmap() writes under memory pressure
Date: Thu, 5 Mar 2009 13:55:43 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       linux-ext4@vger.kernel.org
References: <20090304145109.GA7140@duck.suse.cz> <20090304155535.GA23108@duck.suse.cz> <20090304175031.GA24730@duck.suse.cz>
In-Reply-To: <20090304175031.GA24730@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051355.43909.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009 04:50:31 Jan Kara wrote:
> On Wed 04-03-09 16:55:35, Jan Kara wrote:
> > On Wed 04-03-09 15:51:09, Jan Kara wrote:
> > >   first, I'd like to point out that this has happened under UML so it
> > > can be just some obscure bug in that architecture but I belive it's
> > > worth debugging anyway. Now to the problem:
> > >   This has happened with today Linus's git snapshot. The filesystem is
> > > ext3 with *1KB* blocksize. I booted UML with 64MB of memory and run
> > > (these are test's from Andrew Morton's torture tests):
> > >   fsx-linux -l 8000000 /mnt/testfile
> > >   bash-shared-mapping -t 8 /mnt/bashfile 50000000
> > > (the second test just makes the UML under memory pressure and stresses
> > > the filesystem, otherwise it does not interact with fsx-linux in any
> > > way). After some time (like an hour) fsx-linux reported the file is
> > > corrupted. I tried again and it happened again so probably some
> > > debugging should be possible.
> > >   Both times it seems we've simply completely lost a write which
> > > happened through mmap (2 pages in the first case, 3 pages in the second
> > > case). Also I've checked and in the first case no blocks are allocated
> > > for the offsets where the data should be so most probably we've lost
> > > the write before block_write_full_page() called get_block().
> > >   I'll debug this further but I wanted let people know there's some
> > > problem and maybe somebody has some bright idea :).  I'm attaching the
> > > log from fsx if someone is interested.
> >
> >   Testing a bit more, I managed to reproduce the problem on ext2 and
> > what's more strange, now the lost page was written via ordinary write()
> > (fsxlog attached). So I believe this is more likely to be UML specific...
>
>   And to add even more information, this also happens on ext2 with 4KB
> blocksize (although much more rarely it seems). Again the data was written
> by an extending write() but the block for it was not even allocated...

What block device driver are you using?

Can it be reproduced without mapped reads and writes completely? (-W -R)


