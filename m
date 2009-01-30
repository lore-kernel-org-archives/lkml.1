Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZA3Jzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZA3Jzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZA3Jzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:55:42 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:63682 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZA3Jzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:55:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WZnUEJvRsnBzyQXat6w9aDUBIlRto2A/tRnjDmOAEyRKTOb/e3YfuTBB9i4aP0r0vS
         nW3jmAQSFL/+jGDyzEelUAfJQCV6GusblFAjEApdpsTLsz0T3lwAwC1ZTkh7LVstq5sn
         bCTB0Eg6cWo8lhq3GcGd4rYaoH4b7Uk4RTMV4=
MIME-Version: 1.0
In-Reply-To: <793692118a2f4bdd17326e8bed6c9792.squirrel@newgolddream.dyndns.info>
References: <1233186456.6734.16.camel@localhost.localdomain>
	 <1233187069.6734.21.camel@localhost.localdomain>
	 <20090129031341.GD31096@linux-sh.org>
	 <3ca9ec7a13c1a13ea7be6c37bbdfdb0c.squirrel@newgolddream.dyndns.info>
	 <793692118a2f4bdd17326e8bed6c9792.squirrel@newgolddream.dyndns.info>
Date: Fri, 30 Jan 2009 09:55:38 +0000
Message-ID: <8b67d60901300155n66f86d4ch875d01cd1620409e@mail.gmail.com>
Subject: Re: [PATCH RFC] sh: maple: Add support for SEGA Dreamcast VMU and 
	clean up maple bus driver (1/3)
From: Adrian McMenamin <lkmladrian@gmail.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/29 Adrian McMenamin <adrian@newgolddream.dyndns.info>:
> On Thu, January 29, 2009 4:43 pm, Adrian McMenamin wrote:
>> On Thu, January 29, 2009 3:13 am, Paul Mundt wrote:

>>>>
>>> Please do not abuse P2SEGADDR in this fashion. No new code should be
>>> using P2SEGADDR anyways. maple is particularly abusive in this case
>>> since
>>> it bounces back and forth between P2SEGADDR and PHYSADDR to try and
>>> ignore the fact cache flushing has to be handled.
>>>
>>> You may also wish to consider ioremap/ioremap_nocache().
>>>
>>
>> Can I just use dma_cache_sync before each dma run and then use the P1
>> address space?
>>
>
> After the dma run I mean - the cache is flushed before the run - but not
> after.
>


So I have done this:

Removing P2SEGADDR call and flushing caches
---

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 4d9b8b3..5dca308 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -186,7 +186,7 @@ static struct mapleq *maple_allocq(struct
maple_device *mdev)
 	mq->recvbuf = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
 	if (!mq->recvbuf)
 		goto failed_p2;
-	mq->recvbuf->buf = (void *)P2SEGADDR(&((mq->recvbuf->bufx)[0]));
+	mq->recvbuf->buf = &((mq->recvbuf->bufx)[0]);

 	return mq;

@@ -639,9 +639,11 @@ static void maple_dma_handler(struct work_struct *work)
 	ctrl_outl(0, MAPLE_ENABLE);
 	if (!list_empty(&maple_sentq)) {
 		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
+			mdev = mq->dev;
 			recvbuf = mq->recvbuf->buf;
+			dma_cache_sync(&mdev->dev, recvbuf, 0x400,
+				DMA_FROM_DEVICE);
 			code = recvbuf[0];
-			mdev = mq->dev;
 			kfree(mq->sendbuf);
 			list_del_init(&mq->list);
 			switch (code) {


Seems to work...
