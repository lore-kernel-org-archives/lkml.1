Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYBSSmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYBSSmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYBSSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:41:54 -0500
Received: from rtr.ca ([76.10.145.34]:4372 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbYBSSlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:41:53 -0500
Message-ID: <47BB22F0.8080404@rtr.ca>
Date: Tue, 19 Feb 2008 13:41:52 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: very poor ext3 write performance on big filesystems?
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47BB2008.6070202@rtr.ca>
In-Reply-To: <47BB2008.6070202@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Theodore Tso wrote:
> ..
>> The following ld_preload can help in some cases.  Mutt has this hack
>> encoded in for maildir directories, which helps.
> ..
> 
> Oddly enough, that same spd_readdir() preload craps out here too
> when used with "rm -r" on largish directories.
> 
> I added a bit more debugging to it, and it always craps out like this:
>         opendir dir=0x805ad10((nil))
>     Readdir64 dir=0x805ad10 pos=0/289/290
>     Readdir64 dir=0x805ad10 pos=1/289/290
>     Readdir64 dir=0x805ad10 pos=2/289/290
>     Readdir64 dir=0x805ad10 pos=3/289/290
>     Readdir64 dir=0x805ad10 pos=4/289/290
>     ...
>     Readdir64 dir=0x805ad10 pos=287/289/290
>     Readdir64 dir=0x805ad10 pos=288/289/290
>     Readdir64 dir=0x805ad10 pos=289/289/290
>     Readdir64 dir=0x805ad10 pos=0/289/290
>     Readdir64: dirstruct->dp=(nil)
>     Readdir64: ds=(nil)
>     Segmentation fault (core dumped)
>    
> Always.  The "rm -r" loops over the directory, as show above,
> and then tries to re-access entry 0 somehow, at which point
> it discovers that it's been NULLed out.
> 
> Which is weird, because the local seekdir() was never called,
> and the code never zeroed/freed that memory itself
> (I've got printfs in there..).
> 
> Nulling out the qsort has no effect, and smaller/larger
> ALLOC_STEPSIZE values don't seem to matter.
> 
> But.. when the entire tree is in RAM (freshly unpacked .tar),
> it seems to have no problems with it.  As opposed to an uncached tree.
..

I take back that last point -- it also fails even when the tree *is* cached.
