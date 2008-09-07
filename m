Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYIGJWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYIGJWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYIGJWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:22:04 -0400
Received: from h155.mvista.com ([63.81.120.155]:14374 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752814AbYIGJWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:22:03 -0400
Message-ID: <48C39D2F.4010701@ru.mvista.com>
Date: Sun, 07 Sep 2008 13:21:51 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Masoud Sharbiani <masouds@google.com>
Cc: bzolnier@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Fix pointer arithmetic in hpt3xx driver code (3rd try)
References: <20080906171850.GF26371@google.com>
In-Reply-To: <20080906171850.GF26371@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Masoud Sharbiani wrote:

> git commit 74811f355f4f69a187fa74892dcf2a684b84ce99 causes crash at
> module load (or boot) time on my machine with a hpt374 controller.
> The reason for this is that for initializing second controller which sets
> (hwif->dev == host->dev[1]) to true (1), adds 1 to a void ptr, which
> advances it by one byte instead of advancing it by sizeof(hpt_info) bytes.
> Because of this, all initialization functions get corrupted data in info
> variable which causes a crash at boot time.
>
> This patch fixes that and makes my machine boot again.
>   

   This description is better, thanks. You could also mention that 
you're factoring out the code to get to the 'struct hpt_info' into a 
separate function...

> Signed-Off-By: Masoud Sharbiani <masouds@google.com>
>
> diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
> index eb107ee..4eae284 100644
> --- a/drivers/ide/pci/hpt366.c
> +++ b/drivers/ide/pci/hpt366.c
> @@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t *drive, const char **list)
>  	return 0;
>  }
>  
> +static struct hpt_info *hpt3xx_get_info(struct device *dev)
> +{
> +	struct ide_host *host	= pci_get_drvdata(to_pci_dev(pci_dev));
>   

   Oops, this just won't compile. :-/
   And please re-consider passing 'struct pci_dev *' to this function 
since it's pre-calculated by the callers and is used by them otherwise 
in 5 (not even 4) cases out of 7.

> +	struct hpt_info *info	= (struct hpt_info *)host->host_priv;
> +
> +	return dev == host->dev[1] ? info + 1 : info;
>   

    The 'dev' here would turn into '&dev->dev' if the parameter type 
would be changed.

MBR, Sergei


