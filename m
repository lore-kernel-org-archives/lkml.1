Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZCLALq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZCLALq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZCLALf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:11:35 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:63191 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbZCLALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:11:34 -0400
Message-ID: <49B85335.2010504@lougher.demon.co.uk>
Date: Thu, 12 Mar 2009 00:11:33 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org, s.L-H@gmx.de
Subject: Re: [GIT-PULL] More Squashfs fixes for 2.6.29?
References: <E1LhU3m-0001f1-Cw@dylan.lougher.demon.co.uk> <alpine.LFD.2.00.0903111237410.32478@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903111237410.32478@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 11 Mar 2009, Phillip Lougher wrote:
>> Squashfs: Valid filesystems are flagged as bad by the corrupted fs patch
>>
>> The problem arises due to an unexpected corner-case with zlib which the
>> corrupted filesystems patch didn't address.  Very occasionally zlib
>> exits needing a couple of extra bytes of input (up to 6 seen bytes in the
>> test filesystems), but with avail_out == 0 and no more output buffer
>> space available.  This situation was incorrectly flagged as an output buffer
>> overrun by the corrupted filesystems patch.
> 
> I'm almost certain that this situation is caused by a bug in how you call 
> zlib().
> 
> You've explicitly asked for Z_NO_FLUSH, and I suspect you should be using 
> Z_SYNC_FLUSH (of Z_FINISH if you know you have all the input data). You 
> want as much to be inflated as possible, and you do seem to be expecting 
> it to flush as much as possible. 

Z_NO_FLUSH and Z_SYNC_FLUSH are equivalent in the zlib implementation
according to the documentation...

    "In this implementation, inflate() always flushes as much output as
   possible to the output buffer, and always uses the faster approach on the
   first call. So the only effect of the flush parameter in this implementation
   is on the return value of inflate(), as noted below, or when it returns early
   because Z_BLOCK is used."

Which is why I never bothered to change it.  But, I agree it should be
Z_SYNC_FLUSH for correctness.


> 
> However, I think the more direct cause is your inflate loop. The rules for 
> running inflate() is to call it until it is done, or returns an error:
> 
>     inflate() should normally be called until it returns Z_STREAM_END or an
>   error. However if all decompression is to be performed in a single step
>   (a single call of inflate), the parameter flush should be set to
>   Z_FINISH.
> 
> so you seem to be doing this all wrong. I think you _should_ be doing an 
> inner loop over zlib_inflate() that just does inflates until you get a 
> buffer error, and if you get a buffer error you then go on to the next 
> page if avail_out is zero (all done if it's the last page), or fill the 
> input buffer if it's empty.

I originally implemented an inner loop, something like

do {
	if(avail_out == 0)
		Get next output buffer

	if(avail_in == 0)
		Get next input buffer

	do {
		err = zlib_inflate( xxxx )
	while (err == Z_OK);

} while (err == Z_BUF_ERROR);

But I optimised the inner loop out because of the following logic:

zlib_inflate always tries to make as much progress as possible, therefore
if it returns Z_OK it always either needs more input or more output, in which
case iterating around the outer loop will get the next buffer.  If it returns
any other error code (Z_STREAM_END or Z_DATA_ERROR) we want to terminate
the loop.  The inner loop iterating until Z_BUF_ERROR is received is therefore
unnecessary, it merely iterates twice, first receiving Z_OK, the second time
receiving Z_BUF_ERROR (because no progress can be made),  dropping out to
the outer loop to get the next buffers.

So this should have equivalent behaviour

do {
	if(avail_out == 0)
		Get next output buffer

	if(avail_in == 0)
		Get next input buffer

	err = zlib_inflate( xxxx )

} while (err == Z_OK);


I could put the inner loop back in if you prefer.

Phillip

> 
> So I really think you should fix the zlib_inflate() loop instead.
> 
> I dunno. At least that's what the docs suggest, and it's what we do in 
> git (another heavy user of zlib, althoughb the usage patterns are rather 
> different, and we _tend_ to 
> 
> 			Linus
> 

