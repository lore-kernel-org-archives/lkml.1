Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbYAVBBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbYAVBBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbYAVBBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:01:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:26218 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbYAVBBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ShRo97AYuooQDJp1+8bPQbq27stez0QgcenDAgHfjgyB7EiSUHtlFk3VeKLUk8s+/N/ydNEEcVdyljTqUXjC0jPnndboD5guIqwMjoBReY4L+edKFrndcENO23SMHQFe67rqPD8LkjHkDvp5ywsQ5UMmJmquzXhyEX80zrgGrUQ=
Message-ID: <47954047.90609@gmail.com>
Date: Tue, 22 Jan 2008 10:00:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
References: <1200445210549-git-send-email-htejun@gmail.com>	 <1200681668.25782.9.camel@cinder.waste.org>  <47912F02.6070801@gmail.com> <1200951757.3860.24.camel@cinder.waste.org>
In-Reply-To: <1200951757.3860.24.camel@cinder.waste.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> I suppose. I still find this approach less than ideal, especially
> putting something potentially large on the stack. The dangers are
> perhaps worse than a malloc, really. 

I pondered on this a bit but the thing is we already use several
hundreds bytes in a function which builds complex messages.  The
original ata_eh_report() implementation allocates 424 bytes on stack for
temp buffers and local variables.  In addition to that, it calls printk
with upto 30 arguments (~240 bytes).  While the new implementation
allocates 232 bytes sans the buffer and the maximum number of arguments
is about sixteen (~128 bytes).  ata_eh_report() uses a fixed buffer but
320byte buffer should be sufficient.

In total, it's 664 vs 680 and that's for a really big message.  mprintk
also allows fixed or malloc'd buffers so if you wanna go bigger,
malloc'd buffer should do the job.

> I also don't like your interface much. Consider this alternative:
> 
> struct mprintk *mp = mprintk_begin(KERN_INFO "ata%u.%2u: ", 1, 0);
> mprintk(mp, "ATA %d", 7);
> mprintk(mp, ", %u sectors\n", 1024);
> mprintk(mp, "everything seems dandy\n");
> mprintk_end(mp);
> 
> That keeps all the "normal" printks short and makes the flush more
> explict.

I like that the more used function is shorter.  Hmmm... The reason why I
first used mprintk_push() is to make it clear that the function
accumulates messages unlike mprintk() which flushes what's accumulated
and prints its own message.

> Now we make mprintk_begin attempt to do a kmalloc of a moderate size
> (512 bytes?) and failing that, return null. Then mprintk can fall
> through to printk in the NULL case.

If you wanna do that implicitly, you need GFP_ flag in mprintk_begin()
and atomic allocation should be used from interrupt handlers and friends
and they fail easily under the right (or wrong) conditions.  Forcing
kmalloc isn't a good idea.  Having multiple initializers is one way to
do it.  Any suggestions?

Thanks.

-- 
tejun
