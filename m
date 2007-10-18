Return-Path: <linux-kernel-owner+w=401wt.eu-S1762760AbXJRH1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762760AbXJRH1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbXJRH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:27:31 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:29559 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760038AbXJRH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:27:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=r5bwAZh5c2RlOM0FjHsKeCLDEYQhWf2SR7rKOsZwHjwxur8mY1QyK/yhUPpfupnfWLhUJjpUIZ9+RPg3AofhuJW9zKHmQRHxG0IPYm/MxCQYDsVoo9ELt0zNKBAkvESvrENwB2bpmAuowwA8VB8vhRHYxixWotyQCF1/WKGLX8g=  ;
X-YMail-OSG: VeHLuVsVM1kESOT2BJPb8ip9P4.ywH2uN_wptGCN0x0CO7OyUDZlHWzijmivR6yY4qX2qQhbJJcJyvQyT3CKdWzbLfBvZB52z.2bqnyp0jyEGf3yPbrXf7ZhiY4.dg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Vasily Averin <vvs@sw.ru>
Subject: Re: How Inactive may be much greather than cached?
Date: Thu, 18 Oct 2007 17:27:00 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, devel@openvz.org
References: <4716FC04.6070107@sw.ru> <200710181627.27827.nickpiggin@yahoo.com.au> <471707BD.4000203@sw.ru>
In-Reply-To: <471707BD.4000203@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181727.01128.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 17:14, Vasily Averin wrote:
> Nick Piggin wrote:
> > Hi,
> >
> > On Thursday 18 October 2007 16:24, Vasily Averin wrote:
> >> Hi all,
> >>
> >> could anybody explain how "inactive" may be much greater than "cached"?
> >> stress test (http://weather.ou.edu/~apw/projects/stress/) that writes
> >> into removed files in cycle puts the node to the following state:
> >>
> >> MemTotal: 16401648 kB
> >> MemFree:    636644 kB
> >> Buffers:   1122556 kB
> >> Cached:     362880 kB
> >> SwapCached:    700 kB
> >> Active:    1604180 kB
> >> Inactive: 13609828 kB
> >>
> >> At the first glance memory should be freed on file closing, nobody
> >> refers to file and ext3_delete_inode() truncates inode. We can see that
> >> memory is go away from "cached", however could somebody explain why it
> >> become "invalid" instead be freed? Who holds the references to these
> >> pages?
> >
> > Buffers, swap cache, and anonymous.
>
> But buffers and swap cache are low (1.1 Gb and 700kB in this example) and
> anonymous should go away when process finished.

Ah, I didn't see it was an order of magnitude out.

Some filesystems, including I believe, ext3 with data=ordered,
can leave orphaned pages around after they have been truncated
out of the pagecache. These pages get left on the LRU and vmscan
reclaims them pretty easily.

Try ext3 data=writeback, or even ext2.
