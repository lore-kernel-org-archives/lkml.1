Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXEAEfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXEAEfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423720AbXEAEfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:35:38 -0400
Received: from mail.queued.net ([207.210.101.209]:1079 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030825AbXEAEey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:34:54 -0400
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 00:34:54 EDT
Message-ID: <4636BCA7.2090301@debian.org>
Date: Tue, 01 May 2007 00:05:59 -0400
From: Andres Salomon <dilinger@debian.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: dann frazier <dannf@hp.com>
CC: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       support@moxa.com.tw
Subject: Re: old buffer overflow in moxa driver
References: <20070430224829.GI31283@krebs.dannf>
In-Reply-To: <20070430224829.GI31283@krebs.dannf>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wow, I'd forgotten all about this one.

Signed-off-by: Andres Salomon <dilinger@debian.org>

dann frazier wrote:
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

