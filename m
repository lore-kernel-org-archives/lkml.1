Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbYD2U5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbYD2U5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbYD2U46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:56:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:41514 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530AbYD2U45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TJ7aVM3sYnPtpZaGJF9BRYqxHKUc0YF8Hcr2aYYOL307TOP9A2mVFA0r+f/UG5kCk2v/qkBBG629k/ZOJBqyEfpVncslJ1ASyQwFtXTNiCrzc5nosK+7zuY75IDsnO/jmjECQoRHg+MGiaBo2FeGLadfuRgF0n2QKclzBFShHdg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide: fix crash at boot with siimage driver
Date: Tue, 29 Apr 2008 22:53:45 +0200
User-Agent: KMail/1.9.9
Cc: benh@kernel.crashing.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
       list linux-ide <linux-ide@vger.kernel.org>
References: <1209444576.18023.128.camel@pasglop> <4817384C.8020905@ru.mvista.com>
In-Reply-To: <4817384C.8020905@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804292253.45418.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Benjamin Herrenschmidt wrote:
> 
> > Some change to the IDE layer are causing the siimage driver to crash
> > at boot with a NULL dereference. This is due to the sil_dma_ops not
> > containing all the necessary pointers. I suppose it used to just
> > "override" the defaults while now, it needs to contain everything.
> 
>     Both the patch introducing 'struct ide_dma_ops' into drivers and making 
> them 'const' were in the same batch. However, the latter patch (now commit 
> f37afdaca711838b50ecd89b9c15fc745270d77c) erroneously missed siimage.c -- 
> which I didn't notice when reviewing, sigh...
> 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Applied, thanks for fixing it.

> > ---
> 
> > Index: linux-work/drivers/ide/pci/siimage.c
> > ===================================================================
> > --- linux-work.orig/drivers/ide/pci/siimage.c	2008-04-29 14:44:37.000000000 +1000
> > +++ linux-work/drivers/ide/pci/siimage.c	2008-04-29 14:44:44.000000000 +1000
> > @@ -780,7 +780,14 @@ static const struct ide_port_ops sil_sat
> >  };
> >  
> >  static struct ide_dma_ops sil_dma_ops = {
> 
>     Could you please make this 'const' -- the same way as the mentioned commit 
> does in other drivers?

Thanks for noticing, I took care of it while merging the patch.

> > +	.dma_host_set		= ide_dma_host_set,
> > +	.dma_setup		= ide_dma_setup,
> > +	.dma_exec_cmd		= ide_dma_exec_cmd,
> > +	.dma_start		= ide_dma_start,
> > +	.dma_end		= __ide_dma_end,
> >  	.dma_test_irq		= siimage_dma_test_irq,
> > +	.dma_timeout		= ide_dma_timeout,
> > +	.dma_lost_irq		= ide_dma_lost_irq,
> >  };
> >  
> >  #define DECLARE_SII_DEV(name_str, p_ops)		\
