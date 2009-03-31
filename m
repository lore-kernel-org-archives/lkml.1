Return-Path: <linux-kernel-owner+w=401wt.eu-S1763156AbZCaR7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763156AbZCaR7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762261AbZCaR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:59:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41572 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZCaR7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=n3fbSKQCVyjPwgDNfDA9vYLmwyfGvstsGdkWXqGunM/9lKOIDgyeTiwod2rJAD9w6a
         7VvgTD0ffZEywoheFf+WzQUenp3EFTxEkj27tGjYzH8ZWZbTdeYW4hzvgWiH7tvoAuAx
         yV/9kkvtFWCLmGR4kpj1qVQtPMpVukI6GdZyE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable workaround
Date: Tue, 31 Mar 2009 20:01:45 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Michael Roth <mroth@nessie.de>, linux-kernel@vger.kernel.org
References: <49CFCB2A.4020505@nessie.de> <200903302228.54601.bzolnier@gmail.com> <20090331074508.GA16403@liondog.tnic>
In-Reply-To: <20090331074508.GA16403@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903312001.45960.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Borislav Petkov wrote:
> Hi,
> 
> > > @Bart: can you take at look at this. Somehow, if the device is behind a
> > > PCI IDE controller, the order of issuing the command and enabling DMA is
> > > important. Seen something like that before?
> > 
> > Spec is unclear on the ordering but empirically it seems that some hosts
> > may need packet command to start DMA.  I think that we should proceed with
> > your patch (please repost with patch description) and also apply the same
> > change to the rest of ATAPI devices in a subsequent patch.
> 
> Why two patches, do we really need to differentiate between ide-cd and
> other ATAPI devices? Besides the patch is so simple: 4 lines moved up.

Good engineering practice -- we've changed only ide-cd in 2.6.29 so we
should start with reverting the change and backporting it to -stable.

Fixing other ATAPI devices can be handled later and preferrably after
testing them first -- who knows if there are no devices which depend on
the reverse order of doing things or that it won't uncover/trigger some
other problem.  Feel free to call me (over-)paranoid... :)

However based on later comments from Alan and the current libata code
I feel that we should be pretty safe in this particular case so we may
as well fix everything in one go.

> Anyway, I lightly tested it with ide-cd and ide-floppy and both seem to
> take it ok. Also, if I remember correctly, the original ide-cd behavior
> was to issue the command and _then_ start DMA so we're back to that. I
> guess now we should be concerned whether the other ATAPI devices can
> handle the reverse situation where you first issue a command and _then_
> start DMA.. Hmm...
> 
> --
> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Tue, 31 Mar 2009 09:36:44 +0200
> Subject: [PATCH] ide-atapi: start DMA after issuing a packet command
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
> 
> Apparently¹, some ATAPI devices want to see the packet command first
> before enabling DMA otherwise they simply hang indefinitely. Reorder the
> two steps and start DMA only after having issued the command first.
> 
> [1] http://marc.info/?l=linux-kernel&m=123835520317235&w=2

I added "Reported-by:" here

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
