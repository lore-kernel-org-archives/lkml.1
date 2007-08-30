Return-Path: <linux-kernel-owner+w=401wt.eu-S1761913AbXH3OqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761913AbXH3OqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbXH3Opx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:45:53 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:11408 "EHLO
	outbound5-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761042AbXH3Opv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:45:51 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Thu, 30 Aug 2007 08:44:54 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andres Salomon" <dilinger@queued.net>
cc: jayakumar.alsa@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: Re: ALSA: cs5535audio: update PCI device handling in
 suspend/resume
Message-ID: <20070830144454.GJ5851@cosmic.amd.com>
References: <20070829233014.6c885eb0.dilinger@queued.net>
MIME-Version: 1.0
In-Reply-To: <20070829233014.6c885eb0.dilinger@queued.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 30 Aug 2007 14:43:46.0977 (UTC)
 FILETIME=[2BC85110:01C7EB14]
X-WSS-ID: 6AC80838CG8894917-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/07 23:30 -0400, Andres Salomon wrote:
> 
> Save the PCI state before disabling the device, and add some error checking.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
> ---
> 
>  sound/pci/cs5535audio/cs5535audio_pm.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/pci/cs5535audio/cs5535audio_pm.c b/sound/pci/cs5535audio/cs5535audio_pm.c
> index 9a4e84a..838708f 100644
> --- a/sound/pci/cs5535audio/cs5535audio_pm.c
> +++ b/sound/pci/cs5535audio/cs5535audio_pm.c
> @@ -74,8 +74,11 @@ int snd_cs5535audio_suspend(struct pci_dev *pci, pm_message_t state)
>  	/* save important regs, then disable aclink in hw */
>  	snd_cs5535audio_stop_hardware(cs5535au);
>  
> +	if (pci_save_state(pci)) {
> +		printk(KERN_ERR "cs5535audio: pci_save_state failed!\n");
> +		return -EIO;
> +	}
>  	pci_disable_device(pci);
> -	pci_save_state(pci);
>  	pci_set_power_state(pci, pci_choose_state(pci, state));
>  	return 0;
>  }
> @@ -89,7 +92,12 @@ int snd_cs5535audio_resume(struct pci_dev *pci)
>  	int i;
>  
>  	pci_set_power_state(pci, PCI_D0);
> -	pci_restore_state(pci);
> +	if (pci_restore_state(pci) < 0) {
> +		printk(KERN_ERR "cs5535audio: pci_restore_state failed, "
> +		       "disabling device\n");
> +		snd_card_disconnect(card);
> +		return -EIO;
> +	}
>  	if (pci_enable_device(pci) < 0) {
>  		printk(KERN_ERR "cs5535audio: pci_enable_device failed, "
>  		       "disabling device\n");
> 
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


