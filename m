Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZFRIy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZFRIy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZFRIyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:54:51 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:43158 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbZFRIyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:54:50 -0400
Message-ID: <4A3A00D9.8090504@msgid.tls.msk.ru>
Date: Thu, 18 Jun 2009 12:54:49 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: nfsd: page allocation failure - nfsd or kernel problem?
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <4A37FE48.6070306@msgid.tls.msk.ru> <4A38ACC0.3060501@msgid.tls.msk.ru> <alpine.DEB.2.00.0906170542170.3600@p34.internal.lan> <4A38C7CA.7040005@msgid.tls.msk.ru> <20090617185139.GF24040@fieldses.org> <4A395119.5060108@msgid.tls.msk.ru> <alpine.DEB.2.00.0906171335590.4786@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906171335590.4786@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 18 Jun 2009, Michael Tokarev wrote:
> 
>>> 	http://bugzilla.kernel.org/show_bug.cgi?id=13518
>> Does not look similar.
>>
>> I repeated the issue here.  The slab which is growing here is buffer_head.
>> It's growing slowly -- right now, after ~5 minutes of constant writes over
>> nfs, its size is 428423 objects, growing at about 5000 objects/minute rate.
>> When stopping writing, the cache shrinks slowly back to an acceptable
>> size, probably when the data gets actually written to disk.
> 
> Not sure if you're referring to the bugzilla entry or Justin's reported 
> issue.  Justin's issue is actually allocating a skbuff_head_cache slab 
> while the system is oom.

We have the same issue - I replied to Justin's initial email with exactly
the same trace as him.  I didn't see your reply up until today, -- the one
you're referring to below.

As far as I can see, the warning itself, while harmless, indicates some
deeper problem.  Namely, we shouldn't have an OOM condition - the system
is doing nothing but NFS, there's only one NFS client which writes single
large file, the system has 2GB (or 4Gb on another machine) RAM.  It should
not OOM to start with.

>> It looks like we need a bug entry for this :)
>>
>> I'll re-try 2.6.30 hopefully tomorrow.
> 
> You should get the same page allocation failure warning with 2.6.30.  You 
> may want to try my patch in http://lkml.org/lkml/2009/6/17/437 which 
> suppresses the warnings since, as you previously mentioned, there are no 
> side effects and the failure is easily recoverable.

Well, there ARE side-effects actually.  When the issue happens, the I/O
over NFS slows down to almost zero bytes/sec for some while, and resumes
slowly after about half a minute - sometimes faster, sometimes slower.
Again, the warning itself is harmless, but it shows a deeper issue.  I
don't think it's wise to ignore the sympthom -- the actual cause should
be fixed instead.  I think.

/mjt
