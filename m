Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXEYAkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXEYAkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXEYAki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:40:38 -0400
Received: from mail.ottensheim.at ([193.170.194.20]:60218 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbXEYAkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:40:37 -0400
Message-ID: <4656307F.6010204@oberhumer.com>
Date: Fri, 25 May 2007 02:40:31 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Richard Purdie <richard@openedhand.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Michael-Luke Jones <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nitin Gupta <nitingupta910@gmail.com>
Subject: Re: [RFC] [-mm] Remove 'unsafe' LZO decompressor
References: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>	 <20070524115055.6be93924.akpm@linux-foundation.org> <1180045572.12821.35.camel@localhost.localdomain>
In-Reply-To: <1180045572.12821.35.camel@localhost.localdomain>
X-no-Archive: yes
X-Oberhumer-Conspiracy: There is no conspiracy. Trust us.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> On Thu, 2007-05-24 at 11:50 -0700, Andrew Morton wrote:
>> On Thu, 24 May 2007 18:15:17 +0100
>> Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
>> 		
>>> Attached is a patch which may be desirable for -mm. It applies  
>>> directly to 2.6.22-rc2-mm1.
>>>
>>> The patch removes the 'unsafe' LZO decompression function, lowering  
>>> the size of the minilzo.c file by nearly 500 out of an original 1727  
>>> lines. It also removes references to the 'unsafe' decompression  
>>> function in the public LZO header and the EXPORT_SYMBOL_GPL declaration.
> [...]
>>> Comments / disagreement all welcome :)
>> This is obviously a highly desirable thing to do for a number of reasons. 
>> But have we quantified the performance difference?
> 
> Ok, I've done some tests: 
> 
> 1. Comparing the safe and unsafe functions
> 
> For my minilzo kernel patch, the safe version showed a 7.2% performance
> hit. For Nitin's patch, it showed a 3.2% performance hit (but see
> below).
> 
> Could be a lot worse and I don't object to the removal of the unsafe
> version.
> 
> 2. Comparing Nitin's code with my minilzo based kernel patch.
> 
> My kernel patch is about 2.25 times faster at decompression (16725Kb/ms
> vs 7399Kb/ms) and fractionally faster at compression (1434kb/ms vs
> 1490kb/ms). As things stand the performance of Nitin's patch is
> therefore unacceptable as that is a significant decompression
> performance loss.

Please do _not_ rewrite the LZO implementation just for coding style principles.

The current miniLZO implementation is _extrememly_ well tested, pretty 
optimized and quite portable.

I agree that the implementation may look confusing, but you should be able to 
make it look much better by removing all the unused #defines and #ifdef code 
paths - LZO supports exotic things like 16-bit DOS and CRAY PVP memory models 
which obviously are not needed in the kernel and account for quite a number of 
abstractions (which are implemented through the preprocessor).

Finally the current version has been tested with a lot of compilers and 
contains accumulated knowledge about some hairy things - see 
http://gcc.gnu.org/PR25196 for an example, as well as some not-yet identified 
aliasing issue.

~Markus


> These tests are on 32 bit Intel and in userspace but I've found them to
> be a pretty good indicator of what happens in the real world and on
> other architectures. 
> For simplicity I made these tests with some existing code I had around
> but its licence is such I can't share it, much to my frustration.
> 
> Cheers,
> 
> Richard
> 


-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
