Return-Path: <linux-kernel-owner+w=401wt.eu-S1765106AbXHLB6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765106AbXHLB6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 21:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbXHLB6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 21:58:01 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:42255 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbXHLB6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 21:58:00 -0400
Message-ID: <46BE6854.90502@gmail.com>
Date: Sun, 12 Aug 2007 03:54:28 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: Re: [PATCH] Re: cciss: warning: right shift count >= width of type
References: <200708120228.26234.jesper.juhl@gmail.com> <9a8748490708111756o63ddaeedja091fb2f0b4dbc40@mail.gmail.com> <46BE617D.6010505@gmail.com>
In-Reply-To: <46BE617D.6010505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2007 03:25 AM, Rene Herman wrote:

> On 08/12/2007 02:56 AM, Jesper Juhl wrote:
> 
>> (whoops, forgot to add maintainer to Cc - now added)
> 
> Ehm... too late...

Useless followup though -- hp.com rejects me as it feels the SPF neutral 
results gmail sends due to me not using the gmail SMTP server and/or web 
interface is something it wants to listen to.

I see you are @gmail as well, which depending on how you use it might mean 
your are also not able to reach @hp. If anyone can get HP to fix their mail 
setup, that'd be useful.

Rene.


> 
>> On 12/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
>>> Hi,
>>>
>>> I've been building some randconfig kernels lately and I've noticed
>>> this in a few builds :
>>>
>>> drivers/block/cciss.c:2614: warning: right shift count >= width of type
>>> drivers/block/cciss.c:2615: warning: right shift count >= width of type
>>> drivers/block/cciss.c:2616: warning: right shift count >= width of type
>>>
>>> The code in question is this :
>>>
>>> static void do_cciss_request(struct request_queue *q)
>>> {
>>> ...
>>>         sector_t start_blk;
>>> ...
>>>                         c->Request.CDB[2]= (start_blk >> 56) & 
>>> 0xff;    //MSB
>>>                         c->Request.CDB[3]= (start_blk >> 48) & 0xff;
>>>                         c->Request.CDB[4]= (start_blk >> 40) & 0xff;
>>> ...
>>> }
>>>
>>>
>>> The problem stems from these lines in include/linux/types.h :
>>> ...
>>> #ifdef CONFIG_LBD
>>> typedef u64 sector_t;
>>> #else
>>> typedef unsigned long sector_t;
>>> #endif
>>> ...
>>>
>>> So on a 32bit arch without CONFIG_LBD, sector_t is going to be 32 
>>> bits wide.
>>> Thus it seems gcc is absolutely right in complaining about those
>>> 56, 48 & 40 bit shifts, since they are indeed wider than the type
>>> in the "!CONFIG_LBD on a 32bit arch" case.
>>>
>>>
>>> I must admit that I have no idear what the proper way to deal with
>>> that is, so I'll just report it so hopefully someone else can fix it.
>>>
>>> By the way; I'm building current Linus git tree, head at commit
>>> ac07860264bd2b18834d3fa3be47032115524cea
> 
> Well, given that it's explicitly treating start_blk as a 64-bit value, 
> the proper fix is probably to cast start_blk to an actual (guaranteed) 
> 64-bit value. Untested, uncompiled, and someone else may disagree:
> 
> Rene.
> 

