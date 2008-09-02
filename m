Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYIBDPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYIBDPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 23:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYIBDO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 23:14:58 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:30268 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYIBDO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 23:14:57 -0400
X-IronPort-AV: E=Sophos;i="4.32,312,1217822400"; 
   d="scan'208";a="74419875"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/4] ALSA: add dummy function to support shared mmap in nommu Blackfin arch
Date: Tue, 2 Sep 2008 11:16:37 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA029D5EC2@chinexm1.ad.analog.com>
In-Reply-To: <s5h4p559umn.wl%tiwai@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/4] ALSA: add dummy function to support shared mmap in nommu Blackfin arch
Thread-Index: AckJC9PmbT7IQvtbQceqcoLGZyQQuwDmdaUg
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org><1219829968-6431-5-git-send-email-cooloney@kernel.org> <s5h4p559umn.wl%tiwai@suse.de>
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Takashi Iwai" <tiwai@suse.de>, "Bryan Wu" <cooloney@kernel.org>
Cc: <perex@perex.cz>, <liam.girdwood@wolfsonmicro.com>,
       <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Sep 2008 03:14:55.0434 (UTC) FILETIME=[12B11AA0:01C90CAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Thursday, August 28, 2008 8:45 PM
To: Bryan Wu
Cc: perex@perex.cz; liam.girdwood@wolfsonmicro.com;
broonie@opensource.wolfsonmicro.com; alsa-devel@alsa-project.org;
linux-kernel@vger.kernel.org; Cliff Cai
Subject: Re: [PATCH 4/4] ALSA: add dummy function to support shared mmap
in nommu Blackfin arch

At Wed, 27 Aug 2008 17:39:28 +0800,
Bryan Wu wrote:
> 
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  sound/core/pcm_native.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c index 
> c49b9d9..cb202a1 100644
> --- a/sound/core/pcm_native.c
> +++ b/sound/core/pcm_native.c
> @@ -3391,6 +3391,12 @@ out:
>  }
>  #endif /* CONFIG_SND_SUPPORT_OLD_API */
>  
> +unsigned long dummy_get_unmapped_area(struct file *file, unsigned
long addr,
> +				      unsigned long len, unsigned long
pgoff, unsigned long 
> +flags) {
> +	return 0;
> +}

>Always zero is confirmed to work for other architectures, too?
I'm not sure about this but for non-mmu arch it's enough and harmless.


>  /*
>   *  Register section
>   */
> @@ -3407,6 +3413,7 @@ const struct file_operations snd_pcm_f_ops[2] =
{
>  		.compat_ioctl = 	snd_pcm_ioctl_compat,
>  		.mmap =			snd_pcm_mmap,
>  		.fasync =		snd_pcm_fasync,
> +		.get_unmapped_area =	dummy_get_unmapped_area,
>  	},
>  	{
>  		.owner =		THIS_MODULE,
> @@ -3419,5 +3426,6 @@ const struct file_operations snd_pcm_f_ops[2] =
{
>  		.compat_ioctl = 	snd_pcm_ioctl_compat,
>  		.mmap =			snd_pcm_mmap,
>  		.fasync =		snd_pcm_fasync,
> +		.get_unmapped_area =	dummy_get_unmapped_area,
>  	}
>  };

>I don't think adding this dummy get_unmapped_area unconditionally for
every driver is good.  This overrides the default
>mm->get_unmaped_area.
But without this dummy function,shared mmap on nommu arch would
fail,refer to validate_mmap_request() in mm/nommu.c.
May be we can add a kernel config item to include or not include this
function depending on non-mmu or mmu arch.  

Cliff
