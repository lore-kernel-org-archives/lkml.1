Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZBJMSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZBJMSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 07:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZBJMS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 07:18:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZBJMS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 07:18:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: JosephChan@via.com.tw
Subject: Re: [Patch 1/1 v2] via-sdmmc: VIA MSP card reader driver support
Date: Tue, 10 Feb 2009 13:18:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8089A3E0C@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8089A3E0C@exchtp03.taipei.via.com.tw>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101318.08517.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+fuHaoMjdIpVz3wHOyulqQ37xRw72B/bJsLIF
 ci4FpjrIalsASW23l/VJpIm11gGn6EtbR5/xxsbjiuKPWMm8P/
 0TzGQbDA0yFm/oGHHVKUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009, JosephChan@via.com.tw wrote:
> The following patches provides VIA MSP SD/MMC card reader driver support.
> And these patches are based on kernel 2.6.29-rc4.
> Also, thanks for Arnd's previous suggestions.

Looks mostly good, just two more comments:

> --- a/drivers/mmc/host/via-sdmmc.h	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/mmc/host/via-sdmmc.h	2009-02-10 21:34:18.000000000 +0800

The header file is used in only one place, which means that you could
move everything from there into via-sdmmc.c. This would make reading the
code easier later on.

> +
> +	if (data->flags & MMC_DATA_WRITE) {
> +		for (i = 0; i < len; i++) {
> +			tmpbuf = kmap_atomic(sg_page(&sg[i]), KM_BIO_SRC_IRQ);
> +			tmpbuf += sg[i].offset;
> +			memcpy(host->ddmabuf + offset, tmpbuf, sg[i].length);
> +			offset += sg[i].length;
> +			kunmap_atomic(tmpbuf, KM_BIO_SRC_IRQ);
> +		}
> +	}

This loop is broken for sg chaining. You should use for_each_sg() or
sg_next() instead of sg[i] indexing.

> +	if (data->flags & MMC_DATA_READ) {
> +		struct scatterlist *sg = data->sg;
> +		unsigned char *sgbuf;
> +		int i;
> +
> +		for (i = 0; i < data->sg_len; i++) {
> +			sgbuf = kmap_atomic(sg_page(&sg[i]), KM_BIO_SRC_IRQ);
> +			memcpy(sgbuf + sg[i].offset, host->ddmabuf + offset,
> +			       sg[i].length);
> +			offset += sg[i].length;
> +			kunmap_atomic(sgbuf, KM_BIO_SRC_IRQ);
> +		}
> +	}
> +

same here.

	Arnd <><
