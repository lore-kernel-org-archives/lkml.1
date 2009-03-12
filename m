Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZCLAlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZCLAlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZCLAlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:41:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbZCLAlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:41:12 -0400
Date: Wed, 11 Mar 2009 17:39:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, Geert.Uytterhoeven@sonycom.com,
       linux-kernel@vger.kernel.org, s.L-H@gmx.de
Subject: Re: [GIT-PULL] More Squashfs fixes for 2.6.29?
In-Reply-To: <49B85335.2010504@lougher.demon.co.uk>
Message-ID: <alpine.LFD.2.00.0903111715340.32478@localhost.localdomain>
References: <E1LhU3m-0001f1-Cw@dylan.lougher.demon.co.uk> <alpine.LFD.2.00.0903111237410.32478@localhost.localdomain> <49B85335.2010504@lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Mar 2009, Phillip Lougher wrote:
> 
> But I optimised the inner loop out because of the following logic:
> 
> zlib_inflate always tries to make as much progress as possible

Is this strictly true? Your own bug report seems to say that it isn't.

Hmm. [ Goes back and looks. ] The zlib source code is a total piece of 
mess, but it does seem like it only does "goto inf_leave" when it needs 
more data (unless you ask for the "stop at block boundary", of course). Or 
in the Z_STREAM_END case, or errors. 

But your bug report sounds very much like you got all the data already 
(nothing available for output any more), but then didn't do the last CHECK 
stage (== no output, but the input contains the 32-bit adler checksum and 
the CHECK command). That would explain exactly the case of "a few extra 
bytes at the input, despite not having any output left".

And if you don't do the CHECK stage, then you're missing a large part of 
the corruption checking that zlib does.

So you should never exit based on whether you still need output. So that

	if (msblk->stream.avail_out == 0) {
		..
		else if (msblk->stream.avail_in > 0
			BUG

really looks _wrong_. It's not a buggy situation at all to have no output 
left to process, but still input in the input buffers. It may well just 
mean that you ended up having the CHECK part of the zlib buffer in a new 
input buffer.

		Linus
