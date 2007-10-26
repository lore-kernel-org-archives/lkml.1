Return-Path: <linux-kernel-owner+w=401wt.eu-S1760469AbXJZWlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469AbXJZWlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbXJZWln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:41:43 -0400
Received: from mail2.opus-i.net ([209.10.181.134]:38726 "EHLO
	FPNYEXCFE01.opus-i.corp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750719AbXJZWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:41:43 -0400
Message-ID: <47226D24.30802@datallegro.com>
Date: Fri, 26 Oct 2007 18:41:40 -0400
From: Karl Schendel <kschendel@datallegro.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
References: <47225835.4050309@datallegro.com> <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org> <47226A75.1020008@oracle.com>
In-Reply-To: <47226A75.1020008@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2007 22:41:41.0943 (UTC) FILETIME=[60F0A470:01C81821]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
> Linus Torvalds wrote:
>> Hmm. If I read this right, this bug seems to have been introduced by 
>> commit 65b8291c4000e5f38fc94fb2ca0cb7e8683c8a1b ("dio: invalidate clean 
>> pages before dio write") back in March.
> 
> Agreed.  And it's a really dumb bug.  ->direct_io will almost always
> return -EIOCBQUEUED for aio dio so it won't be invalidating for aio dio
> writes.  (Notice that the testing in that commit mentions two racing
> processes, I bet U$1M that I only tested sync dio :/)

Well, actually, in this case both processes are doing sync IO.
It's just that the writer is direct and the reader isn't, with
the reader usually behind the writer but close enough that
readahead crosses the writer reasonably often.  With the
if (retval) test, we only invalidate if nothing got written
at all!

I hadn't even thought of aio directio.  Yeah, the invalidate
should happen for -EIOCBQUEUED as well, I guess.

The disparity in direct-io-ness on the part of the reader
vs writer is a userland dum-dum, no question.  (That's
getting fixed, too.)

Karl

