Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbZCXOtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbZCXOtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZCXOtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:49:08 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:22438 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753971AbZCXOtH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:49:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UM2JkInDHMN73i/thxF5PmpvIj6I5vTe4J0maWKG7Z52t8Q2SCicIjQPv/MGnqUYEfGh1IXHznWMzSO6+xIeAhvfHhUMIrzoRQrJRyAijorE0qVecbEBXFTRSboQvo0UCwIbZSgYNgTBM+muvB6qfpb0vacdOXUVvxJxVi4yShM=  ;
X-YMail-OSG: foM6iscVM1mvFLyz2GzF3w_8RnPBl3xVUOVMx1J1Jjb0kdNlLVq6MpxblNMeP_z57TJ0zNijPZeVql.Eea3puWxMBai6JM3sQNJr7QAr_YohN4_Y.mFuf1g8qvmL8hB0XF1JcrADdkMODloGhznyL0Zddq17mTXEuaEwbmiUeJ7Tb6zH.eogzFMK6SuocgSB9Seyy6usJRGVwoQCziGn1SnJ6yvy
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jos Houtman <jos@hyves.nl>
Subject: Re: Page Cache writeback too slow,   SSD/noop scheduler/ext2
Date: Wed, 25 Mar 2009 01:48:53 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <C5EC2B99.C3B3%jos@hyves.nl>
In-Reply-To: <C5EC2B99.C3B3%jos@hyves.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903250148.53644.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 03:53:29 Jos Houtman wrote:
> On 3/21/09 11:53 AM, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> > On Fri, 20 Mar 2009 19:26:06 +0100 Jos Houtman <jos@hyves.nl> wrote:
> >> Hi,
> >>
> >> We have hit a problem where the page-cache writeback algorithm is not
> >> keeping up.
> >> When memory gets low this will result in very irregular performance
> >> drops.
> >>
> >> Our setup is as follows:
> >> 30 x Quad core machine with 64GB ram.
> >> These are single purpose machines running MySQL.
> >> Kernel version: 2.6.28.7
> >> A dedicated SSD drive for the ext2 database partition
> >> Noop scheduler for the ssd drive.
> >>
> >>
> >> The current hypothesis is as follows:
> >> The wk_update function does not write enough dirty pages, which allows
> >> the number of dirty pages to grow to the dirty_background limit.
> >> When memory is low,  __background_writeout() comes around and
> >> __forcefully__ writes dirty pages to disk.
> >> This forced write fills the disk queue and starves read calls that MySQL
> >> is trying to do: basically killing performance  for a few seconds. This
> >> pattern repeats as soon as the cleared memory is filled again.
> >>
> >> Decreasing the dirty_writeback_centisecs to 100 doesn__t help
> >>
> >> I don__t know why this is, but I did some preliminary tracing using
> >> systemtap and it seems that the majority of times wk_update calls
> >> decides to do nothing.
> >>
> >> Doubling /sys/block/sdb/queue/nr_requests  to 256, seems to help abit: 
> >> the nr_dirty pages is increasing more slowly.
> >> But I am unsure of side-effects and am afraid of increasing the
> >> starvation problem for mysql.
> >>
> >>
> >> I__am very much willing to work on this issue and see it fixed, but
> >> would like to tap into the knowledge of people here.
> >> So:
> >> * Have more people seen this or simular issues?
> >> * Is the hypothesis above a viable one?
> >> * Suggestions/pointers for further research and statistics I should
> >> measure to improve the understanding of this problem.
> >
> > I don't think that noop-iosched tries to do anything to prevent
> > writes-starve-reads.  Do you get better behaviour from any of the other
> > IO schedulers?
>
> I did a quick stress test and cfq does not immediately seem to hurt
> performance, although some of my colleague's have tested this in the past
> with the opposite results (which is why we use noop).
>
> But despite the scheduler, the real problem is in the writeback algorithm
> not keeping up.
> We can grow 600K dirty pages during the day, and only ~300k is flushed to
> disk during the night hours.
>
> While a quick look at the writeback algorithm let me to expect
> __wk_update()__ to flush ~1024 pages every 5 seconds, which is almost 3GB
> per hour.  It obviously does not manage to do this in our setup.
>
> I don¹t believe the speed of the ssd to be the problem, running sync
> manually only takes a few minutes to flush 800K dirty pages to disk.

kupdate surely should just continue to keep trying to write back pages
so long as there are more old pages to clean, and the queue isn't
congested. That seems to be the intention anyway: MAX_WRITEBACK_PAGES
is just the number to write back in a single call, but you see
nr_to_write is set to the number of dirty pages in the system.

On your system, what must be happening is more_io is not being set.
The logic in fs/fs-writeback.c might be busted.

