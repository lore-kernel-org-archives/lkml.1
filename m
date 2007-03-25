Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbXCYWQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbXCYWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 18:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXCYWQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 18:16:56 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:53629 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752017AbXCYWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 18:16:55 -0400
Date: Sun, 25 Mar 2007 13:49:58 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
In-Reply-To: <20070325200826.GA19691@lazybastard.org>
Message-ID: <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz>
References: <20070318191812.GM4892@waste.org>  <20070318203149.GC29295@crusty.rchland.ibm.com>
  <20070319170838.GP4892@waste.org>  <1174328188.30079.46.camel@zod.rchland.ibm.com>
  <20070319195442.GT4892@waste.org>  <1174338329.13341.633.camel@localhost.localdomain>
  <20070319223205.GZ4892@waste.org>  <1174351366.13341.739.camel@localhost.localdomain>
  <20070321110528.GC3785@lazybastard.org>  <1174476334.10840.49.camel@localhost.localdomain>
 <20070325200826.GA19691@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1590919853-1174859398=:13765"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1590919853-1174859398=:13765
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 25 Mar 2007, Jörn Engel wrote:

> On Wed, 21 March 2007 12:25:34 +0100, Thomas Gleixner wrote:
>> On Wed, 2007-03-21 at 12:05 +0100, Jörn Engel wrote:
>>>
>>> Also LogFS currently requires erasesizes of 2^n.
>>
>> Last time I talked to you about that, you said it would be possible and
>> fixable.
>
> Actually, no.  LogFS is not broken, there is nothing to fix.
>
> And there is no fundamental reason why UBI should export blocks with
> non-power-of-two sizes.  UBI currently consists of two parts that are
> intimately intertwined in the current implementation, but have
> relatively little connection otherwise.
>
> 1. Logical volume management.
> 2. Static volumes.
>
> Logical volume management can just as easily move its management
> information into a table, instead of having it spread across all blocks.
> Blocks can keep their original size.  Since you have to scan flash
> anyway, you can also scan for a table, compare a magical number and do
> some extra check to protect yourself against a UBI image inside some
> logical volume.  No big deal.

if you are being paranoid about write cycles putting the write count in the 
block you are writing avoids doing an erase/write elsewhere

although, since you can flip bits to 1 without requireing an erase you could 
sacrafice some space and say that your table has a normal counter for the number 
of times the block has been erased, but a 'tally counter' where you turn one bit 
on each time you erase the block, and when you fill up the tally block you 
re-write the entire table, clearing all the tallys. if you have relativly large 
eraseblocks it seems like you could afford to sacrafice the space in your master 
table to avoid erases of it

IIRC someone said that the count per block was 128 bits? if so you could have a 
master table with a 32 bit integer (4B writes) + 96 bits of tally so that you 
would only have to re-write the table when a block on the flash has been erased 
96 times. with this approach the wear on your table is unlikely to be a factor 
until the point where you are loosing a lot of other eraseblocks due to wear 
(at which point you could shift to a different block for your table, or retire 
the flash)

David Lang
--8323328-1590919853-1174859398=:13765--
