Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZCEKTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZCEKTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZCEKTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:19:06 -0500
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:33114 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751641AbZCEKTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:19:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MJo3iO8mild3PC8Al3hugdjL3gXQzAohsIm93wim9Ddd2NUUCvgYH+vC5Z3HMHCQ9Ve+Uk/oNo7S8MEFE2hMevOLivP+04VUENw8dFJveyBOnjmXkewCpMGx+3l8Bt3rhPj8nAwBsXmnIAKF0Jo/ukVQ8DumU0HlhN55w/qPOKQ=  ;
X-YMail-OSG: 4EY8qGYVM1nB2gw_21qB1Di53ypUtm.df8.4m01SzuyNMbYS5RSfY92iUdc2blcBK7dYYz1BYs5uQGAY4h.1ATNhpDF561OVTw_hJQbnppdRNzC_W4jcHKPOYGkjs0xqbQFqw3OAWlATAa4rdNvITtmXUWjNZDBLLzmTIshaLkIDULmHL5eGqzQDJgj0ew--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>
Subject: Re: fsx-linux loosing mmap() writes under memory pressure
Date: Thu, 5 Mar 2009 21:18:54 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
References: <20090304145109.GA7140@duck.suse.cz> <200903051355.43909.nickpiggin@yahoo.com.au> <20090305100516.GB29177@duck.suse.cz>
In-Reply-To: <20090305100516.GB29177@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903052118.55380.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 March 2009 21:05:16 Jan Kara wrote:
> On Thu 05-03-09 13:55:43, Nick Piggin wrote:
> > On Thursday 05 March 2009 04:50:31 Jan Kara wrote:
> > > On Wed 04-03-09 16:55:35, Jan Kara wrote:
> > > > On Wed 04-03-09 15:51:09, Jan Kara wrote:
> > > > >   first, I'd like to point out that this has happened under UML so
> > > > > it can be just some obscure bug in that architecture but I belive
> > > > > it's worth debugging anyway. Now to the problem:
> > > > >   This has happened with today Linus's git snapshot. The filesystem
> > > > > is ext3 with *1KB* blocksize. I booted UML with 64MB of memory and
> > > > > run (these are test's from Andrew Morton's torture tests):
> > > > >   fsx-linux -l 8000000 /mnt/testfile
> > > > >   bash-shared-mapping -t 8 /mnt/bashfile 50000000
> > > > > (the second test just makes the UML under memory pressure and
> > > > > stresses the filesystem, otherwise it does not interact with
> > > > > fsx-linux in any way). After some time (like an hour) fsx-linux
> > > > > reported the file is corrupted. I tried again and it happened again
> > > > > so probably some debugging should be possible.
> > > > >   Both times it seems we've simply completely lost a write which
> > > > > happened through mmap (2 pages in the first case, 3 pages in the
> > > > > second case). Also I've checked and in the first case no blocks are
> > > > > allocated for the offsets where the data should be so most probably
> > > > > we've lost the write before block_write_full_page() called
> > > > > get_block(). I'll debug this further but I wanted let people know
> > > > > there's some problem and maybe somebody has some bright idea :). 
> > > > > I'm attaching the log from fsx if someone is interested.
> > > >
> > > >   Testing a bit more, I managed to reproduce the problem on ext2 and
> > > > what's more strange, now the lost page was written via ordinary
> > > > write() (fsxlog attached). So I believe this is more likely to be UML
> > > > specific...
> > >
> > >   And to add even more information, this also happens on ext2 with 4KB
> > > blocksize (although much more rarely it seems). Again the data was
> > > written by an extending write() but the block for it was not even
> > > allocated...
> >
> > What block device driver are you using?
>
>   UML was just using image file to back the filesystem I was testing on.
> But I don't think that plays a big role because the blocks were not even
> allocated in the fs-image so we must have lost them quite early.

So you're using ubd driver? OK, I just have a report of a problem
with brd driver...


