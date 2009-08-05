Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZHEVxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZHEVxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZHEVx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:53:29 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:40756 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZHEVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EyEU+S3xBnrEWK5LfxxUmjrkAkWPABdHOdw/ZDQY9BvTsUilQaiFhmeptSU5VHBfTZ
         3BZ6A7b/QW/R8xSnzg4RQFlaRCb44vpfe97w0LJXfmBnVHdmsAGh7iYnG74tLaOnP+dB
         kFn4IaFtsJd+SvWPkJtV4wOF/d1gL0wGm4gdU=
Message-ID: <4A79FF57.50902@gmail.com>
Date: Wed, 05 Aug 2009 23:53:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Martyn Welch <martyn.welch@gefanuc.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] Staging: Correct tsi-148 VME interrupt free routine
References: <20090805163219.4903.43629.stgit@ES-J7S4D2J.amer.consind.ge.com> <20090805163802.28044.91999.stgit@ES-J7S4D2J.amer.consind.ge.com>
In-Reply-To: <20090805163802.28044.91999.stgit@ES-J7S4D2J.amer.consind.ge.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2009 06:38 PM, Martyn Welch wrote:
>  	if (tsi148_bridge->irq[level - 1].count == 0) {
> -		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
> -		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
> -		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);
> -
>  		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEN);
>  		tmp &= ~TSI148_LCSR_INTEN_IRQEN[level - 1];
>  		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEN);
> +
> +		tmp = ioread32be(tsi148_bridge->base + TSI148_LCSR_INTEO);
> +		tmp &= ~TSI148_LCSR_INTEO_IRQEO[level - 1];
> +		iowrite32be(tmp, tsi148_bridge->base + TSI148_LCSR_INTEO);

I have no idea what the registers do and I suppose it's behind some PCI
bridge anywhere. If it is not true, ignore the further.

Is it OK that the second write to INTEO doesn't reach the device before
you set func to NULL? I mean, is it enough to prevent the interrupt
raising only by twiddling INTEN? Otherwise you need to put some read
right here to push non-completed writes on bridges (flush posted
writes). (I mentioned this in the former mail too.)

Otherwise looks good.

>  	}
>  
> +	tsi148_bridge->irq[level - 1].callback[statid].func = NULL;
> +	tsi148_bridge->irq[level - 1].callback[statid].priv_data = NULL;
> +
>  	/* Release semaphore */
>  	up(&(vme_irq));
>  }

