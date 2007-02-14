Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbXBNAvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbXBNAvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXBNAvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:51:14 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:55437 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXBNAvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:51:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KntK/UL1ILmhg81gFFticewgag1fZucm+pjkeUqpwXGrmF0MEVsCIdXX5d8xNvYojmpiZFHhtiYZIs3QLi1iAAFYZT3k++0NfsqCK/kk2Ta2p2GA0nkBWx93JhTGiEVZpqTGeA0pmU033phOG4NbjtrPcIlz4QbgU8s2R/c+Z7A=
Message-ID: <45D25CF2.5030508@gmail.com>
Date: Tue, 13 Feb 2007 16:50:58 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: libata FUA revisited
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca> <45D1D72D.9020509@gmail.com> <45D252CD.5010303@shaw.ca>
In-Reply-To: <45D252CD.5010303@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Jeff, Alan, Mark and Jens.  Hi!]

Hello, Robert.

Robert Hancock wrote:
> Well, we should be able to determine that experimentally (at least on 
> specific controllers) with a little test program that just writes little 
> bits of data and fsyncs repeatedly (assuming that does in fact trigger 
> FUAs currently..) If it runs faster than the drive could possibly be 
> rewriting the physical disk then obviously the FUA bit is not getting 
> through and/or not respected and we can blacklist FUA on that controller.

That's right.

> Also, the FUA bit in the NCQ commands is in the device register, so it's 
> not like the PMP fields where it's not used for anything else and so the 
> controller messing with it wouldn't be otherwise noticed..

Yeap, I just wanted to point out (so the FWIW) that seemingly innocent 
ahci does mangle with some part of the FIS given in the memory.  I agree 
that this is much unlikely with the FUA bit.

>> So, actually, I was thinking about *always* using the non-NCQ FUA 
>> opcode.  As currently implemented, FUA request is always issued by 
>> itself, so NCQ doesn't make any difference there.  So, I think it 
>> would be better to turn on FUA on driver-by-driver basis whether the 
>> controller supports NCQ or not.
> 
> Unfortunately not all drives that support NCQ support the non-NCQ FUA 
> commands (my Seagates are like this).

And I'm a bit scared to set FUA bit on such drives and trust that it 
will actually do FUA, so our opinions aren't too far away from each 
other.  :-)

> There's definitely a potential advantage to FUA with NCQ - if you have 
> non-synchronous accesses going on concurrently with synchronous ones, if 
> you have to use non-NCQ FUA or flush cache commands, you have to wait 
> for all the IOs of both types to drain out before you can issue the 
> flush (since those can't be overlapped with the NCQ read/writes). And if 
> you can only use flush cache, then you're forcing all the writes to be 
> flushed including the non-synchronous ones you didn't care about. 
> Whether or not the block layer currently exploits this I don't know, but 
> it definitely could.

The current barrier implementation uses the following sequences for 
no-FUA and FUA cases.

1. w/o FUA

normal operation -> barrier issued -> drain IO -> flush -> barrier 
written -> flush -> normal operation resumes

2. w/ FUA

normal operation -> barrier issued -> drain IO -> flush -> barrier 
written / FUA -> normal operation resumes

So, the FUA write is issued by itself.  This isn't really efficient and 
frequent barriers impact the performance badly.  If we can change that 
NCQ FUA will be certainly beneficial.

>> Well, I might be being too paranoid but silent FUA failure would be 
>> really hard to diagnose if that ever happens (and I'm fairly certain 
>> that it will on some firmwares).
> 
> Well, there are also probably drives that ignore flush cache commands or 
>  fail to do other things that they should. There's only so far we can go 
> in coping if the firmware authors are being retarded. If any drive is 
> broken like that we should likely just blacklist NCQ on it entirely as 
> obviously little thought or testing went into the implementation..

FLUSH has been around quite long time now and most drives don't have 
problem with that.  FUA on ATA is still quite new and libata will be the 
first major user of it if we enable it by default.  It just seems too 
easy to ignore that bit and successfully complete the write - there 
isn't any safety net as opposed to using a separate opcode.  So, I'm a 
bit nervous.

Any comments, people?

Thanks.

-- 
tejun
