Return-Path: <linux-kernel-owner+w=401wt.eu-S1030438AbXBOTWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030438AbXBOTWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030741AbXBOTWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:22:49 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:23851 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030438AbXBOTWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:22:48 -0500
In-Reply-To: <20070215184656.GA12897@outpost.ds9a.nl>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215184656.GA12897@outpost.ds9a.nl>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <117BE5D6-146E-407D-887E-067F212BA871@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 05/11] syslets: core code
Date: Thu, 15 Feb 2007 11:16:18 -0800
To: bert hubert <bert.hubert@netherlabs.nl>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 2) 	On the client facing side (port 53), I'd very much hope for a  
> way to
> 	do 'recvv' on datagram sockets, so I can retrieve a whole bunch of
> 	UDP datagrams with only one kernel transition.

I want to highlight this point that Bert is making.

Whenever we talk about AIO and kernel threads some folks are rightly  
concerned that we're talking about a thread *per IO* and fear that  
memory consumption will be fatal.

Take the case of userspace which implements what we'd think of as  
page cache writeback.  (*coughs, points at email address*).  It wants  
to issue thousands of IOs to disjoint regions of a file.  "Thousands  
of kernel threads, oh crap!"

But it only issues each IO with a separate syscall (or io_submit()  
op) because it doesn't have an interface that lets it specify IOs  
that vector user memory addresses *and file position*.

If we had a seemingly obvious interface that let it kick off batched  
IOs to different parts of the file, the looming disaster of a thread  
per IO vanishes in that case.

struct off_vec {
	off_t pos;
	size_t len;
};

long sys_sgwrite(int fd, struct iovec *memvec, size_t mv_count,
	struct off_vec *ovec, size_t ov_count);

It doesn't take long to imagine other uses for this that are less  
exotic.

Take e2fsck and its iterating through indirect blocks or directory  
data blocks.  It has a list of disjoint file regions (blocks) it  
wants to read, but it does them serially to keep the code from  
getting even more confusing.  blktrace a clean e2fsck -f some time..  
it's leaving *HALF* of the disk read bandwith on the table by  
performing serial block-sized reads.  If it could specify batches of  
them the code would still be simple but it could tell the kernel and  
IO scheduler *exactly* what it wants, without having to mess around  
with sys_readahead() or AIO or any of that junk :).

Anyway, that's just something that's been on my mind.  If there are  
obvious clean opportunities to get more done with single syscalls, it  
might not be such a bad thing.

- z
