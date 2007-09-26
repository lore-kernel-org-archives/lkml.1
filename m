Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXIZPYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXIZPYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbXIZPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:24:16 -0400
Received: from smtpoutm.mac.com ([17.148.16.73]:60726 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXIZPYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:24:12 -0400
In-Reply-To: <200709261340.l8QDeKie025351@agora.fsl.cs.sunysb.edu>
References: <200709261340.l8QDeKie025351@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <2DDDD55D-4445-4565-9384-4E4BE7B41D7D@mac.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 10/25] Unionfs: add un/likely conditionals on copyup ops
Date: Wed, 26 Sep 2007 11:23:19 -0400
To: Erez Zadok <ezk@cs.sunysb.edu>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 26, 2007, at 09:40:20, Erez Zadok wrote:
> In message <46F9E0EC.3010105@intel.com>, "Kok, Auke" writes:
>> I've been told several times that adding these is almost always  
>> bogus - either it messes up the CPU branch prediction or the  
>> compiler/CPU just does a lot better at finding the right way  
>> without these hints.
>>
>> Adding them as a blanket seems rather strange. Have you got any  
>> numbers that this really improves performance?
>
> Auke, that's a good question, but I found it hard to find any info  
> about it.  There's no discussion on it in Documentation/, and very  
> little I could find elsewhere.  I did see one url explaining what  
> un/likely does precisely, but no guidelines.  My understanding is  
> that it can improve performance, as long as it's used carefully  
> (otherwise it may hurt performance).

Hmm, even still I agree with Auke, you probably use it too much.


> Recently we've done a full audit of the entire code, and added un/ 
> likely where we felt that the chance of succeeding is 95% or better  
> (e.g., error conditions that should rarely happen, and such).

Actually due to the performance penalty on some systems I think you  
only want to use it if the chance of succeeding is 99% or better, as  
the benefit if predicted is a cycle or two and the harm if  
mispredicted can be more than 50 cycles, depending on the CPU.  You  
should also remember than in filesystems many "failures" are  
triggered by things like the ld.so library searches, where it  
literally calls access() 20 different times on various possible paths  
for library files, failing the first 19.  It does this once for each  
necessary library.

Typically you only want to add unlikely() or likely() for about 2  
reasons:
   (A)  It's a hot path and the unlikely case is just going to burn a  
bunch of CPU anyways
   (B)  It really is extremely unlikely that it fails (Think physical  
hardware failure)

Anything else is just bogus.

Cheers,
Kyle Moffett

