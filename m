Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYDUBdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYDUBdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 21:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYDUBdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 21:33:13 -0400
Received: from web36705.mail.mud.yahoo.com ([209.191.85.39]:35431 "HELO
	web36705.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752562AbYDUBdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 21:33:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=YX85jgRyryny4GBL5VhL9awbYhyUGwgsZ6IbJtUW++CQ4H7lrnDte6Hz9rr0SDH3/0x3i5piblE0ZuOK3yN5cyuggp7IxaqelqdgZNw7Aq2GhOxRxYFBDWFpACp/MwONYKHmiURqFuNc5rHwi1NObwEVjn8xFScq0427naydkvY=;
X-YMail-OSG: ciQisTcVM1kpHL4JCTVQDLvqElGueq0VcUk5vcwuTOaCcSFwzcZN2Wzob1jdFhBPJSt_ftp0X..1Tqqm9GJEr1kdfUYK_xk2Enk3HplqSgrHthpZ_ll5ybu.yQ--
Date: Sun, 20 Apr 2008 18:33:11 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
To: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080420160115.GA20694@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <490135.81340.qm@web36705.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I wonder if mtd shouldn't modified to handler more clever controller :
> > I saw some raw nand controller where you can program a batch of 
> > command/read/write/ecc checking (that work on a internal RAM of the 
> > controller (and may be use DMA)) and all you have to do is to wait the 
> > controller do the job.
> > These controllers are very hard to integrate in current nand layer 
> > because it is very low level controller oriented.
> 
> The obvious solution is to have seperate io scheduling from io
> completion.  Requires an asynchronous interface to read/write and some
> sort of request queue.
> 
> Not quite as obvious is the question of whether to add all this to mtd
> or to replace mtd with block devices, which already have it.
> 

I was thinking about it myself and it appears to be the only solution outright.

The interesting, but apparently hard way to do so is to define a couple of
REQ_TYPE_SPECIAL mtd-specific commands and use the existing block device queue
to manipulate them. This can even open the possibility of "static" request
translation: mtd_blkdev can pop the block device request, put it through media
specific translator and then push a necessary set of mtd operations back into
the same queue, delegating the processing to raw mtd device.

The simpler approach I'm following with my xd_card_blk is to define a
simplistic, block device like api. First, the translator is initialized with
the request range (offset + length) and backend is notified to start
processing. The backend then pulls flash requests (READ, WRITE, COPY, ERASE)
from the translator, possibly putting them through additional, protocol/host
specific translation layer.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
