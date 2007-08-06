Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbXHFCMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbXHFCMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXHFCMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:12:13 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:35910 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752710AbXHFCMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:12:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=nQKW0YIHauvEI00eGpnzFeuxm4Je9rQgYKRIR9wdS/eYe8Ay0jIsNCiYv14MSQKqUEMQWpNtRpANBUwFPMlDFKGNOnYAH/z1pUxGBLOaXZBacY7fqDG/z5OMbjOdvCyQeD5ynPvwfXCdOw/x0XZmJ9DGQBqIxmb4a7QyVqegkCk=  ;
X-YMail-OSG: oGgKWLYVM1lL5K2SW_YuZ60tLqexJpTtRV6VBq62mnQigdC72KsBhgcp5x7qaI7F9RphG9ND6g--
Message-ID: <46B68369.1090802@yahoo.com.au>
Date: Mon, 06 Aug 2007 12:11:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matthew Hawkins <darthmdh@gmail.com>
CC: Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	 <200707102015.44004.kernel@kolivas.org>	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>	 <46A57068.3070701@yahoo.com.au>	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>	 <46A58B49.3050508@yahoo.com.au>	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>	 <46A6CC56.6040307@yahoo.com.au> <b21f8390707310937i5f90fa2rae650221b3ff4880@mail.gmail.com>
In-Reply-To: <b21f8390707310937i5f90fa2rae650221b3ff4880@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Hawkins wrote:
> On 7/25/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>>I guess /proc/meminfo, /proc/zoneinfo, /proc/vmstat, /proc/slabinfo
>>before and after the updatedb run with the latest kernel would be a
>>first step. top and vmstat output during the run wouldn't hurt either.
> 
> 
> Hi Nick,
> 
> I've attached two files with this kind of info.  Being up at the cron
> hours of the morning meant I got a better picture of what my system is
> doing.  Here's a short summary of what I saw in top:
> 
> beagleindexer used gobs of ram.  600M or so (I have 1G)

Hmm OK, beagleindexer. I thought beagle didn't need frequent reindexing
because of inotify? Oh well...


> updatedb didn't use much ram, but while it was running kswapd kept on
> frequenting the top 10 cpu hogs - it would stick around for 5 seconds
> or so then disappear for no more than 10 seconds, then come back
> again.  This behaviour persisted during the run.  updatedb ran third
> (beagleindexer was first, then update-dlocatedb)

Kswapd will use CPU when memory is low, even if there is no swapping.

Your "buffers" grew by 600% (from 50MB to 350MB), and slab also grew
by a few thousand entries. This is not just a problem when it pushes
out swap, it will also harm filebacked working set.

This (which Ray's traces also show) is a bit of a problem. As Andrew
noticed, use-once isn't working well for buffer cache, and it doesn't
really for dentry and inode cache either (although those don't seem
to be as much of a problem on your workload).

Andrew has done a little test patch for this in -mm, but it probably
wants more work and testing. If you can test the -mm kernel and see
if things are improved, that would help.

-- 
SUSE Labs, Novell Inc.
