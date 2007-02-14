Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXBNAO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXBNAO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087AbXBNAO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:14:27 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:2553 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbXBNAO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:14:26 -0500
Date: Tue, 13 Feb 2007 18:07:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata FUA revisited
In-reply-to: <45D1D72D.9020509@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net
Message-id: <45D252CD.5010303@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no>
 <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca>
 <45D1D72D.9020509@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
>> On the NCQ side, I think it's pretty safe to assume that all 
>> controllers will handle it. Obviously I've verified it with sata_nv 
>> (at least that it doesn't blow up obviously), and the other two NCQ 
>> drivers we have, ahci and sata_sil24 just feed raw FIS data into the 
>> controller so there should be no issue with not supporting it.
> 
> FWIW, ICH6/7/8 ahci's clear PMP field when transmitting FIS.  The reason 
> why I'm hesitant is because there is no way to tell whether the FUA bit 
> got honored or ignored.  With extra opcode, it's okay because barrier 
> explicitly fails but if NCQ FUA is not supported, it will succeed 
> silently as normal write.  Everything will be okay generally but the 
> barrier is done incorrectly and on a really bad day it will lead to 
> journal corruption.

Well, we should be able to determine that experimentally (at least on 
specific controllers) with a little test program that just writes little 
bits of data and fsyncs repeatedly (assuming that does in fact trigger 
FUAs currently..) If it runs faster than the drive could possibly be 
rewriting the physical disk then obviously the FUA bit is not getting 
through and/or not respected and we can blacklist FUA on that controller.

Also, the FUA bit in the NCQ commands is in the device register, so it's 
not like the PMP fields where it's not used for anything else and so the 
controller messing with it wouldn't be otherwise noticed..

> 
> So, actually, I was thinking about *always* using the non-NCQ FUA 
> opcode.  As currently implemented, FUA request is always issued by 
> itself, so NCQ doesn't make any difference there.  So, I think it would 
> be better to turn on FUA on driver-by-driver basis whether the 
> controller supports NCQ or not.

Unfortunately not all drives that support NCQ support the non-NCQ FUA 
commands (my Seagates are like this).

There's definitely a potential advantage to FUA with NCQ - if you have 
non-synchronous accesses going on concurrently with synchronous ones, if 
you have to use non-NCQ FUA or flush cache commands, you have to wait 
for all the IOs of both types to drain out before you can issue the 
flush (since those can't be overlapped with the NCQ read/writes). And if 
you can only use flush cache, then you're forcing all the writes to be 
flushed including the non-synchronous ones you didn't care about. 
Whether or not the block layer currently exploits this I don't know, but 
it definitely could.

> Well, I might be being too paranoid but silent FUA failure would be 
> really hard to diagnose if that ever happens (and I'm fairly certain 
> that it will on some firmwares).

Well, there are also probably drives that ignore flush cache commands or 
  fail to do other things that they should. There's only so far we can 
go in coping if the firmware authors are being retarded. If any drive is 
broken like that we should likely just blacklist NCQ on it entirely as 
obviously little thought or testing went into the implementation..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


