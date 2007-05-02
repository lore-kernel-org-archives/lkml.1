Return-Path: <linux-kernel-owner+w=401wt.eu-S1766637AbXEBWJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766637AbXEBWJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993189AbXEBWJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:09:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61504 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993188AbXEBWJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:09:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
Date: Thu, 3 May 2007 00:09:11 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1178137281.10111.8.camel@amdx2.microgate.com>
In-Reply-To: <1178137281.10111.8.camel@amdx2.microgate.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030009.11502.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+VyH/HJj9HLDEVfWrOxXwIxbPCTyCgmrnLToq
 Ed/vC+MIMrUIcBGXrGp6PujDRsCrMp8oBrLvHHFMjEIXIQ490Q
 9pPF9pV3bb7PZV9mG0LLw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 May 2007, Paul Fulghum wrote:
> +	switch (cmd) {
> +
> +	case MGSL_IOCSPARAMS32:
> +		rc = set_params32(info, (struct MGSL_PARAMS32 __user *)compat_ptr(arg));
> +		break;
> +
> +	case MGSL_IOCGPARAMS32:
> +		rc = get_params32(info, (struct MGSL_PARAMS32 __user *)compat_ptr(arg));
> +		break;

No need for the cast here.

> +
> +	spin_lock_irqsave(&info->lock, flags);

no need for _irqsave, just use spin_{,un}lock_irq() when you know that
interrupts are enabled.

> --- a/include/linux/synclink.h	2007-04-25 22:08:32.000000000 -0500
> +++ b/include/linux/synclink.h	2007-05-02 14:59:17.000000000 -0500
> @@ -167,6 +167,24 @@ typedef struct _MGSL_PARAMS
>  
>  } MGSL_PARAMS, *PMGSL_PARAMS;
>  
> +/* provide 32 bit ioctl compatibility on 64 bit systems */
> +struct MGSL_PARAMS32
> +{
> +	unsigned int	mode;
> +	unsigned char	loopback;
> +	unsigned short	flags;
> +	unsigned char	encoding;
> +	unsigned int	clock_speed;
> +	unsigned char	addr_filter;
> +	unsigned short	crc_type;
> +	unsigned char	preamble_length;
> +	unsigned char	preamble;
> +	unsigned int	data_rate;
> +	unsigned char	data_bits;
> +	unsigned char	stop_bits;
> +	unsigned char	parity;
> +};

The definition is correct, but by convention it would be better to use
compat_ulong_t instead of unsigned int for those fields that are an
unsigned long in native mode.

	Arnd <><
