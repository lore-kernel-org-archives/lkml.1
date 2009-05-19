Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZESVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZESVMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 17:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZESVMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 17:12:43 -0400
Received: from mailout04.t-online.de ([194.25.134.18]:41567 "EHLO
	mailout04.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZESVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 17:12:43 -0400
Date: Tue, 19 May 2009 23:12:21 +0200
From: Martin Lottermoser <Martin.Lottermoser@t-online.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090519211221.GA6977@wanza.invalid>
References: <20090517091224.GA8280@wanza.invalid> <200905191719.35543.bzolnier@gmail.com> <20090519182928.GA8172@wanza.invalid> <200905192131.00168.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905192131.00168.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ID: rxSdMiZVYhRAPa+5p9MZE-OwLFRR9mrxeA7XMGZmFq-bXyYyATMlQKSrpiXv7Pggx0
X-TOI-MSGID: 6fa9016e-776e-481f-a8dc-a23efced9cd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 19, 2009 at 09:30:59PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Incremental patch fixing it:
> 
> diff -u b/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> --- b/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -255,7 +255,7 @@
>  	if (ivb) {
>  		const char *model = (char *)&id[ATA_ID_PROD];
>  
> -		if (strcmp("TSSTcorp CDDVDW SH-S202", model) == 0) {
> +		if (strstr("TSSTcorp CDDVDW SH-S202", model)) {
>  			/*
>  			 * These ATAPI devices always report 80c cable
>  			 * so we have to depend on the host in this case.
> 

I applied that, recompiled, installed, rebooted, and checked the syslog.
The message was still

  hdc: UDMA/66 mode selected

and hdparm also showed "udma4" as being selected. I therefore didn't test
with a DVD.

However, after twice reading the POSIX definition of strstr() I reversed
the order of the arguments to

                if (strstr(model, "TSSTcorp CDDVDW SH-S202")) {

and that did it. Syslog now contained:

  hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33
  hdc: UDMA/33 mode selected

hdparm showed "udma2", and playing movie DVDs worked without DMA being
disabled. :-)

That seems to be it, then. Many thanks for your help, and in particular for
the explanations.

Regards,
Martin Lottermoser
-- 
Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
Greifswaldstrasse 28
38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
Germany
