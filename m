Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXBLLxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXBLLxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 06:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXBLLxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 06:53:45 -0500
Received: from web36712.mail.mud.yahoo.com ([209.191.85.46]:22899 "HELO
	web36712.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964868AbXBLLxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 06:53:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZMHkdXJZaaevlsvxoErt+rronszJ/sazFMihCZvRnYxGoHU6OgfBL3rjFQxB/b93GptaPyVPHQVth4AdOOUeBTcPydGYoGnM2T7mw5vOdquKDruOHUd/UOxZIZkP0X5bnNxULyd0Bwq0J8vD38ZL7RKmN6t91pZMzAD702VmPyo=  ;
Message-ID: <20070212115343.41523.qmail@web36712.mail.mud.yahoo.com>
X-YMail-OSG: ImwDjp0VM1kBd0RkYedBglQdq7DkUNLABOvBY.zHYz92inYem5TkglDKxMX_ZhevmVfk8vqSk_MSj._qr18SUtd.yVaI.w0O_B7F9mvNg9TJiIpJJQCWXdy7GQSDjkkAu0PHs2FmDzYTWk1xZN.eRiteG4ycHAdShrLX2s.GZdhgAjkhl2PTBbLgk509
Date: Mon, 12 Feb 2007 03:53:43 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CF5D37.1000900@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> Alex Dubov wrote:
> > 
> > It just occurred to me that my synopsis of the problem was utterly lame.
> > Here, the correct description:
> > When the card is pulled out, I mark the host as "ejected" (so it fast-fails all the requests),
> > sleep a little for it to relax and then call mmc_remove_host. Otherwise, nasty things happen.
> > Here's the example not involving mmc_block at all (command 3 failed, hardware timeout was
> missed,
> > so software timeout picked it up; the sleep hack is disabled):
> > 
> 
> I believe your problem is line 915 of tifm_sd.c:
> 
> > 	tifm_set_drvdata(sock, NULL);
> 
> You call that before mmc_free_host() (which flushes the work queue), and I
> assume something still needs it. Put in some BUG_ON() here and there and you
> should be able to catch it.
> 
I removed that line altogether (it does not really needed as mmc host will not be accessed
anymore). The problem is more elaborate. Here, the card fails, mmc_host_remove is called without
sleep beforehand, and "after remove" message is printed immediately after it. Only then, mmc_block
remembers to finish its business. If I leave the sleep in place, mmc_block's stuff will get
scheduled before the mmc_remove_host and everything will be all right.
You may also notice that host is already powered off ("Setting ... power 0" message) and still
mmc_block continues to make requests like nothing happened.

Feb 12 22:06:55 mortug tifm_sd tifm_sd0:3: host_status 400, fifo_status 0
Feb 12 22:06:56 mortug tifm_sd: card failed to respond for a long period of time
Feb 12 22:06:56 mortug tifm_7xx1 0000:06:09.3: checking media set 8
Feb 12 22:06:56 mortug tifm_7xx1: demand removing card from socket 0:3
Feb 12 22:06:56 mortug tifm_sd tifm_sd0:3: Setting bus width 0, power 0
Feb 12 22:06:56 mortug tifm_sd tifm_sd0:3: after remove
Feb 12 22:06:56 mortug mmcblk1: error 1 sending read/write command
Feb 12 22:06:56 mortug end_request: I/O error, dev mmcblk1, sector 0
Feb 12 22:06:56 mortug printk: 137 messages suppressed.
Feb 12 22:06:56 mortug Buffer I/O error on device mmcblk1, logical block 0
Feb 12 22:06:56 mortug divide error: 0000 [1] SMP
Feb 12 22:06:56 mortug CPU 0
Feb 12 22:06:56 mortug Modules linked in: ...


 
____________________________________________________________________________________
Expecting? Get great news right away with email Auto-Check. 
Try the Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/newmail_tools.html 
