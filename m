Return-Path: <linux-kernel-owner+w=401wt.eu-S1030780AbXEDPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbXEDPtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030882AbXEDPtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:49:18 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23012 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030780AbXEDPtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:49:17 -0400
Message-ID: <463B55F9.4070606@msgid.tls.msk.ru>
Date: Fri, 04 May 2007 19:49:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
References: <E1HjjyF-00022D-00@calista.eckenfels.net> <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk> <20070504094610.GA31607@infradead.org>
In-Reply-To: <20070504094610.GA31607@infradead.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, May 04, 2007 at 09:12:31AM +0100, Anton Altaparmakov wrote:
>> Nothing to do with win32 functions.  Windows does NOT create sparse  
>> files therefore it never can have an issue like ext3 does in this  
>> scenario.  Windows will cause nice allocations to happen because of  
>> this and the 1-byte writes are perfectly sensible in this regard.   
>> (Although a little odd as Windows has a proper API for doing  
>> preallocation so I don't get why it is not using that instead...)
> 
> Which means the right place to fix this is samba.  Samba just need
> to intersept lseek and pread/pwrite to never allocate sparse files
> but do the right thing instead.  Now what the right thing would probably
> be a preallocate instead of writing zeroes, and we need to provide the
> infrastructure for them to do it, which is in progress currently.
> (And in fact samba already does the right thing for XFS if you use
> the prealloc samba vfs module, which AFAIK is not the default)

Hmm.

How about providing a way to stop kernel (or filesystem) to make gaps
in files instead?  Like some ioctl(fd, FS_NOGAPS, 1) -- pretty much
like 'doze has, just the opposite (on windows, this flag is "on" by
default).

Fixing this issue in samba means that samba has to keep/track more state
data than it currently does.  Detecting such seek+write has some costs.

It's even worse: imagine samba transforms this into write(zeros) (as
preallocate isn't available yet), and at the same time, another process
is writing there... Which will be perfectly valid in current case, but
will go wrong way (overwriting just-written data with zeros) in this
new scenario.

But the main point is that samba has to keep track of things which it
doesn't do now, and those things becomes.. interesting (difficult if
at all possible to track) in multi-user/concurrent-writes environment.

/mjt
