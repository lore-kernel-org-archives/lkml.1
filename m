Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZGAXQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZGAXQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZGAXQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:16:13 -0400
Received: from [199.45.143.218] ([199.45.143.218]:34681 "EHLO zlynx.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750949AbZGAXQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:16:12 -0400
Message-ID: <4A4BEE1A.8090204@acm.org>
Date: Wed, 01 Jul 2009 17:15:38 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Attila Kinali <attila@kinali.ch>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Long lasting MM bug when swap is smaller than RAM
References: <20090630115819.38b40ba4.attila@kinali.ch>	<4A4ABD8F.40907@gmail.com>	<20090701100432.2d328e46.attila@kinali.ch> <20090701100834.1f740ad5.attila@kinali.ch>
In-Reply-To: <20090701100834.1f740ad5.attila@kinali.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090701/1MM91f-0004Gc-Ld-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attila Kinali wrote:
> On Wed, 1 Jul 2009 10:04:32 +0200
> Attila Kinali <attila@kinali.ch> wrote:
> 
>>> But 
>>> swapping does not only occur if memory is running low. If disk usage is 
>>> high then non-recently used data may be swapped out to make more room 
>>> for disk caching.
>> Hmm..I didn't know this.. thanks!
> 
> This was the cause of the problem!
> 
> I just restarted svnserv, clamav and bind (the three applications
> using most memory) and suddenly swap cleared up.
> 
> Now the question is, why did they accumulate so much used swap
> space, while before the RAM upgrade, we hardly used the swap space at all?

I do not know about the others, but ClamAV suffers from pretty serious 
memory fragmentation.  What it does is load the updated signatures into 
a new memory allocation, verify them, then free the old signature 
allocation.  This results in a large hole in glibc's malloc structures 
and because of ClamAV's allocation pattern, this hole is difficult to 
reclaim.  This ClamAV memory fragmentation will continue to grow worse 
until the daemon is completely restarted.

Under memory pressure the kernel pushes least used pages out to swap, 
and these unused but still allocated pages of ClamAV are never again 
used, so out to swap they go.

I know this because the company I work for tried to fix the memory 
allocation fragmentation of ClamAV, but they did not like our patch and 
preferred to continue allowing the memory allocator to fragment in 
exchange for simpler code.

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
