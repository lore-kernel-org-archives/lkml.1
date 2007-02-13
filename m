Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXBMOkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXBMOkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750696AbXBMOkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:40:55 -0500
Received: from web36715.mail.mud.yahoo.com ([209.191.85.49]:31433 "HELO
	web36715.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1749667AbXBMOky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:40:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=544TlFC21mMRikFPbE9Owk9tqPZOtsraAl2VqgHTbplcO3Xp2TS/HohLm5MrgVHBR65FyInEq9vIpNKpMV6urCJ+/R+ANSAaxDiuAoL3JLc942CSydPsZgQ2srrrqksD1oTaoUOd41OJ0vHdZ/EcUxVS/4WWNNRHqC7rbxAZwf8=;
X-YMail-OSG: ySenk9oVM1lK6ANh_6x8.47OOG.umEiu6lupOFuYBej9sk.wltDfig8zl7kC14Gg4SLGO6X9oWtZxdVXGuF.hjWraLt6JY1e3oL2bublwcI36Hjb15DLyjeO7beIHiUOlnBADIVGLev_MOceE7GQ_41ZeQDaDRfi_l2mmeKBXxlcd5eE195YxWul35Ni
Date: Tue, 13 Feb 2007 06:40:53 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D07075.7090302@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <961103.42832.qm@web36715.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we are already on the topic, I would like to report two additional issues with mmc_block:

1. If, for some reason, device driver cannot return the requested data amount, but does not sets
any error, mmc_block would retry indefinitely. Of course, its always a device driver's fault, but
may be we can set some limit on retry count (this can help a lot with debugging).

And the more serious:
2. There was a write corruption problem with tifm_sd caused by missing wait cycle (card busy/card
not busy) after stop command. It should not had been a problem (the mmc layer was spinning around
with CMD13 untill the card become not-busy), but for some reason it was. We are currently testing
this. The intersting part, however, is behavior of mmc_block given this situation:

It appears that mmc_block's instance manages to get stuck because of this. The symptoms: module
usage count is not decremented when low level driver is unloaded and partition block devices do
not get created afterwards. The fun part: the main block device gets created and deleted on card
insertion/removal and its dump is correct (dd if=/dev/mmcblk0 ...); yet partition detection does
not happens. To fix this, one have to reboot the machine or to wait about 30 minutes for mmc_block
to regain its senses (then it becomes rmmod'able again).

On the other hand, it may be some sort of generic block layer problem.



 
____________________________________________________________________________________
Sucker-punch spam with award-winning protection. 
Try the free Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/features_spam.html
