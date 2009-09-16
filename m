Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZIPLS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZIPLS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZIPLSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:18:24 -0400
Received: from tichy.grunau.be ([85.131.189.73]:52355 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZIPLSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:18:23 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 07:18:23 EDT
Date: Wed, 16 Sep 2009 13:13:26 +0200
From: Janne Grunau <j@jannau.net>
To: Julia Lawall <julia@diku.dk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/8] drivers/media/video/hdpvr: introduce missing kfree
Message-ID: <20090916111325.GA14900@aniel.lan>
References: <Pine.LNX.4.64.0909111821180.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909111821180.10552@pc-004.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 06:21:35PM +0200, Julia Lawall wrote:
> 
> Error handling code following a kzalloc should free the allocated data.

Thanks for the report. I'll commit a different patch which adds the buffer
to the buffer list as soon it is allocated. The hdpvr_free_buffers() in the
error handling code will clean it up then. See below:

diff --git a/linux/drivers/media/video/hdpvr/hdpvr-video.c b/linux/drivers/media/video/hdpvr/hdpvr-video.c
--- a/linux/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/linux/drivers/media/video/hdpvr/hdpvr-video.c
@@ -134,6 +134,8 @@
                        v4l2_err(&dev->v4l2_dev, "cannot allocate buffer\n");
                        goto exit;
                }
+               list_add_tail(&buf->buff_list, &dev->free_buff_list);
+
                buf->dev = dev;

                urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -158,7 +160,6 @@
                                  hdpvr_read_bulk_callback, buf);

                buf->status = BUFSTAT_AVAILABLE;
-               list_add_tail(&buf->buff_list, &dev->free_buff_list);
        }
        return 0;
 exit:
