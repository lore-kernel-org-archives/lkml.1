Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZCWURV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZCWURV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbZCWURM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:17:12 -0400
Received: from n23.bullet.mail.mud.yahoo.com ([68.142.206.162]:36523 "HELO
	n23.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754411AbZCWURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:17:11 -0400
X-Yahoo-Newman-Id: 961197.11954.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XspmYcbpL31LMIPz/uxOQgdlwmok6V5YF2ZWpYVuf65nh1e05f/qG8mQtosejgD2jEX0FHWgcBSQLNGAHpbTUI/V+sei2wXwqoqL3AjI8D9mvW/HYVLmBtBLUzVmAl5Gonjdmrv7ecc8x6qGbM8m+jxqlLpsiYZbSe9eeqVits0=  ;
X-YMail-OSG: 4K5JcEkVM1kigPyMN1KIDk7CFzDI8bA5bdksSwJYc1eIp2BZl6BpFkWvMlFXS.EAZRunDP6VbR4yW8gXIYxcI_ikawjnCoxUFCA.0N6B7jODKTNxAXW3V9F3_69D8uH95UyRXjc6MuuMHOsFbdzbG9vAPURWSoDQzHcfS6JK.8IqhKEQlGbq_1FpQFnJl2z8Zg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Purushotam Kumar <purushotam@ti.com>
Subject: Re: [PATCH 1/1] DaVinci: MMC: Updated MMC/SD controller driver for DaVinci family.
Date: Mon, 23 Mar 2009 13:17:07 -0700
User-Agent: KMail/1.9.10
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
References: <1237378885-5918-1-git-send-email-purushotam@ti.com>
In-Reply-To: <1237378885-5918-1-git-send-email-purushotam@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231317.07231.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, Purushotam Kumar wrote:
> From: Purshotam Kumar <purushotam@ti.com>
> 
> This patch adds support for MMC/SD controller driver for DaVinci family SoC.
> This patch will work for SoC like DM6446 and DM355. SoC like DM365 and
> DA830 also has same controller with small variations and could supported/added 
> easily by using this version of patch. It means that this version of patch 
> could be used for all SoC which has been derived from DaVinci family.
>  
> This patch has been generated against latest 2.6.29 mainline kernel. This patch
> will not compile currently because it depends notably on the EDMA utilities and
> chip/board setup, that will come at some point through the ARM tree. Please use
> currently DaVinci GIT tree for EDMA utilities and chip/board setup etc.
> 
> Many thanks to David Brownell (david-b@pacbell.net) for his all support.
> 
> 
> Signed-off-by: Purshotam Kumar <purushotam@ti.com>

Sanity-tested against mainline with simple patches to add
EDMA and chip/board setup ... root-on-MMC works, just like
root-on-IDE.

Once you fix the build bug noted below:

 Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Though the PIO bits still bother me ... I'd use *only* the
io{read,write}8_rep() calls to load/unload the FIFO.  While
those calls haven't broken yet, it's rude to (a) open-code
io{read,write}32_rep() like that, and (b) assume all buffers
coming in to that function are 32-bit aligned.  PIO is hardly
ever used, given EDMA.  Maybe just one or two calls when
enumerating.  (SDIO might use it more often.)  That can be
fixed a bit later.

Also, it'd be good to submit a patch to the DaVinci tree
to make it match whatever Pierre eventually merges.  (Less
the clock name change, of course, which is only needed to
cope with the elderly clock logic now in mainline.)


> ---
>  arch/arm/mach-davinci/include/mach/mmc.h |   25 +
>  drivers/mmc/host/Kconfig                 |    8 +
>  drivers/mmc/host/Makefile                |    1 +
>  drivers/mmc/host/davinci_mmc.c           | 1257 ++++++++++++++++++++++++++++++
>  4 files changed, 1291 insertions(+), 0 deletions(-)


Build bug in probe():

> +	host->clk = clk_get(&pdev->dev, MMCSDCLK);

Put quotes around "MMCSDCLK".

