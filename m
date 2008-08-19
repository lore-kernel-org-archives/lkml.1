Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYHSENr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYHSENr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbYHSENi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:13:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbYHSENi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:13:38 -0400
Date: Mon, 18 Aug 2008 21:12:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] saa7134-core.c: fix warning
Message-Id: <20080818211207.8da0945f.akpm@linux-foundation.org>
In-Reply-To: <20080805213111.GA17627@orion>
References: <20080805213111.GA17627@orion>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 01:31:11 +0400 Alexander Beregalov <a.beregalov@gmail.com> wrote:

> From: Alexander Beregalov <a.beregalov@gmail.com>
> 
> saa7134-core.c: fix warning
> 
> drivers/media/video/saa7134/saa7134-core.c:366: warning:
> 'saa7134_buffer_requeue' defined but not used
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
> 
>  drivers/media/video/saa7134/saa7134-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
> index 75d6184..0473a79 100644
> --- a/drivers/media/video/saa7134/saa7134-core.c
> +++ b/drivers/media/video/saa7134/saa7134-core.c
> @@ -360,7 +360,7 @@ void saa7134_buffer_timeout(unsigned long data)
>  }
>  
>  /* resends a current buffer in queue after resume */
> -
> +#ifdef CONFIG_PM
>  static int saa7134_buffer_requeue(struct saa7134_dev *dev,
>  				  struct saa7134_dmaqueue *q)
>  {
> @@ -384,7 +384,7 @@ static int saa7134_buffer_requeue(struct saa7134_dev *dev,
>  
>  	return 0;
>  }
> -
> +#endif

I changed it as below - we might as well save an ifdef block.

--- a/drivers/media/video/saa7134/saa7134-core.c~saa7134-corec-fix-warning
+++ a/drivers/media/video/saa7134/saa7134-core.c
@@ -359,32 +359,6 @@ void saa7134_buffer_timeout(unsigned lon
 	spin_unlock_irqrestore(&dev->slock,flags);
 }
 
-/* resends a current buffer in queue after resume */
-
-static int saa7134_buffer_requeue(struct saa7134_dev *dev,
-				  struct saa7134_dmaqueue *q)
-{
-	struct saa7134_buf *buf, *next;
-
-	assert_spin_locked(&dev->slock);
-
-	buf  = q->curr;
-	next = buf;
-	dprintk("buffer_requeue\n");
-
-	if (!buf)
-		return 0;
-
-	dprintk("buffer_requeue : resending active buffers \n");
-
-	if (!list_empty(&q->queue))
-		next = list_entry(q->queue.next, struct saa7134_buf,
-					  vb.queue);
-	buf->activate(dev, buf, next);
-
-	return 0;
-}
-
 /* ------------------------------------------------------------------ */
 
 int saa7134_set_dmabits(struct saa7134_dev *dev)
@@ -1139,6 +1113,32 @@ static void __devexit saa7134_finidev(st
 }
 
 #ifdef CONFIG_PM
+
+/* resends a current buffer in queue after resume */
+static int saa7134_buffer_requeue(struct saa7134_dev *dev,
+				  struct saa7134_dmaqueue *q)
+{
+	struct saa7134_buf *buf, *next;
+
+	assert_spin_locked(&dev->slock);
+
+	buf  = q->curr;
+	next = buf;
+	dprintk("buffer_requeue\n");
+
+	if (!buf)
+		return 0;
+
+	dprintk("buffer_requeue : resending active buffers \n");
+
+	if (!list_empty(&q->queue))
+		next = list_entry(q->queue.next, struct saa7134_buf,
+					  vb.queue);
+	buf->activate(dev, buf, next);
+
+	return 0;
+}
+
 static int saa7134_suspend(struct pci_dev *pci_dev , pm_message_t state)
 {
 
_

