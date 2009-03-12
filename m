Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZCLA7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZCLA7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZCLA7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:59:05 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:43772 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391AbZCLA7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:59:03 -0400
Message-ID: <49B85E55.6060804@lougher.demon.co.uk>
Date: Thu, 12 Mar 2009 00:59:01 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org, s.L-H@gmx.de
Subject: Re: [GIT-PULL] More Squashfs fixes for 2.6.29?
References: <E1LhU3m-0001f1-Cw@dylan.lougher.demon.co.uk> <alpine.LFD.2.00.0903111237410.32478@localhost.localdomain> <49B85335.2010504@lougher.demon.co.uk> <alpine.LFD.2.00.0903111715340.32478@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903111715340.32478@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 12 Mar 2009, Phillip Lougher wrote:
>> But I optimised the inner loop out because of the following logic:
>>
>> zlib_inflate always tries to make as much progress as possible
> 
> Is this strictly true? Your own bug report seems to say that it isn't.
> 
> Hmm. [ Goes back and looks. ] The zlib source code is a total piece of 
> mess, but it does seem like it only does "goto inf_leave" when it needs 
> more data (unless you ask for the "stop at block boundary", of course). Or 
> in the Z_STREAM_END case, or errors. 
> 
> But your bug report sounds very much like you got all the data already 
> (nothing available for output any more), but then didn't do the last CHECK 
> stage (== no output, but the input contains the 32-bit adler checksum and 
> the CHECK command). That would explain exactly the case of "a few extra 
> bytes at the input, despite not having any output left".

Yes, this is exactly what's happening.  Sorry if the bug report didn't
make it clear.

> 
> And if you don't do the CHECK stage, then you're missing a large part of 
> the corruption checking that zlib does.
> 
> So you should never exit based on whether you still need output. So that
> 
> 	if (msblk->stream.avail_out == 0) {
> 		..
> 		else if (msblk->stream.avail_in > 0
> 			BUG
> 
> really looks _wrong_. It's not a buggy situation at all to have no output 
> left to process, but still input in the input buffers. It may well just 
> mean that you ended up having the CHECK part of the zlib buffer in a new 
> input buffer.

Yes the check is pretty bogus.  I'm about to send an improved patch
that gets rid of this check (just relying on zlib to error if we've
got no more output buffers, and it wants to output).

I'll also put some more info into the commit indicating the problem
it's fixing.

Thanks

Phillip

> 
> 		Linus
> 


