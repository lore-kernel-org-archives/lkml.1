Return-Path: <linux-kernel-owner+w=401wt.eu-S1761214AbXFWRFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214AbXFWRFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 13:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759969AbXFWRFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 13:05:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759151AbXFWRFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 13:05:00 -0400
Date: Sat, 23 Jun 2007 09:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-kernel@vger.kernel.org, kraxel@bytesex.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>, stable@kernel.org
Subject: Re: [PATCH] saa7134: fix thread shutdown handling
Message-Id: <20070623095426.6049f883.akpm@linux-foundation.org>
In-Reply-To: <467AC742.7070007@suse.com>
References: <467AC742.7070007@suse.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 21 Jun 2007 14:45:22 -0400 Jeff Mahoney <jeffm@suse.com> wrote:
>  This patch changes the test for the thread pid from >= 0 to > 0.
> 
>  When the saa8134 driver initialization fails after a certain point,
>  it goes through the complete shutdown process for the driver. Part
>  of shutting it down includes tearing down the thread for tv audio.
> 
>  The test for tearing down the thread tests for >= 0. Since the dev
>  structure is kzalloc'd, the test will always be true if we haven't
>  tried to start the thread yet. We end up waiting on pid 0 to complete,
>  which will never happen, so we lock up.
> 
>  This bug was observed in Novell Bugzilla 284718, when request_irq()
>  failed.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
> ---
> 
>  drivers/media/video/saa7134/saa7134-tvaudio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-06-12 15:45:16.000000000 -0400
> +++ b/drivers/media/video/saa7134/saa7134-tvaudio.c	2007-06-15 14:16:14.000000000 -0400
> @@ -1005,7 +1005,7 @@
>  int saa7134_tvaudio_fini(struct saa7134_dev *dev)
>  {
>  	/* shutdown tvaudio thread */
> -	if (dev->thread.pid >= 0) {
> +	if (dev->thread.pid > 0) {
>  		dev->thread.shutdown = 1;
>  		wake_up_interruptible(&dev->thread.wq);
>  		wait_for_completion(&dev->thread.exit);
> 

This is no longer applicable to the dvb devel tree, because this code has
been converted to the kthread API.

However I guess we do want this in 2.6.22 and in 2.6.21.x.  Mauro, if
that's OK, do you want me to do the merges?

