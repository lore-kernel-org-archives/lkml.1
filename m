Return-Path: <linux-kernel-owner+w=401wt.eu-S1767371AbXECEVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767371AbXECEVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767376AbXECEVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:21:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767371AbXECEVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:21:38 -0400
Date: Wed, 2 May 2007 21:20:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dann frazier <dannf@hp.com>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       support@moxa.com.tw, dilinger@debian.org
Subject: Re: old buffer overflow in moxa driver
Message-Id: <20070502212053.e0ad2dba.akpm@linux-foundation.org>
In-Reply-To: <20070430224829.GI31283@krebs.dannf>
References: <20070430224829.GI31283@krebs.dannf>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 16:48:29 -0600 dann frazier <dannf@hp.com> wrote:

> hey,
>   I noticed that the moxa input checking security bug described by
> CVE-2005-0504 appears to remain unfixed upstream.
>  
> The issue is described here:
>   http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-0504
> 
> Debian has been shipping the following patch from Andres Salomon. I
> tried contacting the listed maintainer a few months ago but received
> no response.
> 
> I've tested that this still applies to and compiles against 2.6.21.
> 
> Signed-off-by: dann frazier <dannf@hp.com>
> 
> diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
> index 7dbaee8..e0d35c2 100644
> --- a/drivers/char/moxa.c
> +++ b/drivers/char/moxa.c
> @@ -1582,7 +1582,7 @@ copy:
>  
>  	if(copy_from_user(&dltmp, argp, sizeof(struct dl_str)))
>  		return -EFAULT;
> -	if(dltmp.cardno < 0 || dltmp.cardno >= MAX_BOARDS)
> +	if(dltmp.cardno < 0 || dltmp.cardno >= MAX_BOARDS || dltmp.len < 0)
>  		return -EINVAL;
>  
>  	switch(cmd)
> @@ -2529,6 +2529,8 @@ static int moxaloadbios(int cardno, unsigned char __user *tmp, int len)
>  	void __iomem *baseAddr;
>  	int i;
>  
> +	if(len < 0 || len > sizeof(moxaBuff))
> +		return -EINVAL;
>  	if(copy_from_user(moxaBuff, tmp, len))
>  		return -EFAULT;
>  	baseAddr = moxa_boards[cardno].basemem;
> @@ -2576,7 +2578,7 @@ static int moxaload320b(int cardno, unsigned char __user *tmp, int len)
>  	void __iomem *baseAddr;
>  	int i;
>  
> -	if(len > sizeof(moxaBuff))
> +	if(len < 0 || len > sizeof(moxaBuff))
>  		return -EINVAL;
>  	if(copy_from_user(moxaBuff, tmp, len))
>  		return -EFAULT;
> @@ -2596,6 +2598,8 @@ static int moxaloadcode(int cardno, unsigned char __user *tmp, int len)
>  	void __iomem *baseAddr, *ofsAddr;
>  	int retval, port, i;
>  
> +	if(len < 0 || len > sizeof(moxaBuff))
> +		return -EINVAL;
>  	if(copy_from_user(moxaBuff, tmp, len))
>  		return -EFAULT;
>  	baseAddr = moxa_boards[cardno].basemem;
> 

I'm seeing copies of this patch floating around the internet from the 2.6.10
timeframe at least.

Could people please be more diligent about getting bugfixes back into
mainline?

