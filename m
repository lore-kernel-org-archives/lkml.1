Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbZJNUop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbZJNUop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbZJNUop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:44:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55470 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbZJNUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:44:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Oct 2009 22:43:54 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/8] firewire: cdev: reduce stack usage by ioctl_dispatch
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.af1058f9e26f4dba@s5r6.in-berlin.de>
Message-ID: <tkrat.ec38f27900b7af20@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
 <tkrat.af1058f9e26f4dba@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> --- linux-2.6.31.orig/drivers/firewire/core-cdev.c
> +++ linux-2.6.31/drivers/firewire/core-cdev.c
> @@ -1299,28 +1299,47 @@ static int (* const ioctl_handlers[])(st
>  static int dispatch_ioctl(struct client *client,
>  			  unsigned int cmd, void __user *arg)
>  {
> -	char buffer[256];
> +	char buffer[40];
>  	int ret;
>  
> +#define check_ioctl_size(x) BUILD_BUG_ON(_IOC_SIZE(x) > sizeof(buffer))
> +
> +	check_ioctl_size(FW_CDEV_IOC_GET_INFO);
> +	check_ioctl_size(FW_CDEV_IOC_SEND_REQUEST);
[...]

With linux 2.6.32-rc1's version of BUILD_BUG_ON, this adds sparse
warnings (seen with sparse 0.4.2):

drivers/firewire/core-cdev.c:1308:9: error: bad integer constant expression
drivers/firewire/core-cdev.c:1309:9: error: bad integer constant expression
[...]

Back to the drawing board.
-- 
Stefan Richter
-=====-==--= =-=- -===-
http://arcgraph.de/sr/

