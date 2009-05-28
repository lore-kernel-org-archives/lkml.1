Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbZE1FvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbZE1FvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZE1FvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:51:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbZE1FvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:51:16 -0400
Date: Wed, 27 May 2009 22:51:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2] serial: 8250_gsc: fix printk format warning
Message-Id: <20090527225106.10fc9cc6.akpm@linux-foundation.org>
In-Reply-To: <1242652291-1868-1-git-send-email-a.beregalov@gmail.com>
References: <1242652291-1868-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 17:11:31 +0400 Alexander Beregalov <a.beregalov@gmail.com> wrote:

> Fix this build warning:
> drivers/serial/8250_gsc.c:44: warning: format '%lx' expects type
> 'long unsigned int', but argument 2 has type 'resource_size_t'
> 

The patch does more than fix a "warning".  It fixes an actual error. 
The caller will prepare a 64-bit argument and the callee will print
only 32 bits of it.

> ---
>  drivers/serial/8250_gsc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/8250_gsc.c b/drivers/serial/8250_gsc.c
> index 418b4fe..a7b02a5 100644
> --- a/drivers/serial/8250_gsc.c
> +++ b/drivers/serial/8250_gsc.c
> @@ -41,7 +41,7 @@ static int __init serial_init_chip(struct parisc_device *dev)
>  			printk(KERN_INFO
>  				"Serial: device 0x%lx not configured.\n"
>  				"Enable support for Wax, Lasi, Asp or Dino.\n",
> -				dev->hpa.start);
> +				(unsigned long)dev->hpa.start);

Nope.  hpa.start can be u32 or u64.  We need to cast that to the wider
type so that it will correctly print in all circumstances.

So I changed both patches to print with %ll and to cast to
unsigned long long.
