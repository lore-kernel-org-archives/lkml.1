Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXLLEyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXLLEyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 23:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXLLEyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 23:54:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbXLLEyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 23:54:11 -0500
Date: Tue, 11 Dec 2007 20:53:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH -mm] media: video: usbvision: add mutex_unlock() to
 error paths
Message-Id: <20071211205312.923551ef.akpm@linux-foundation.org>
In-Reply-To: <20071212015650.481405953@mvista.com>
References: <20071212015650.481405953@mvista.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 17:56:50 -0800 Daniel Walker <dwalker@mvista.com> wrote:

> There are a few error paths which don't unlock the usbvision->lock.
> 
> So I've added mutex_unlock() calls to fix those paths.
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  drivers/media/video/usbvision/usbvision-video.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/media/video/usbvision/usbvision-video.c
> +++ linux-2.6.23/drivers/media/video/usbvision/usbvision-video.c
> @@ -1290,6 +1290,7 @@ static int usbvision_radio_open(struct i
>  		errCode = usbvision_set_alternate(usbvision);
>  		if (errCode < 0) {
>  			usbvision->last_error = errCode;
> +			mutex_unlock(&usbvision->lock);
>  			return -EBUSY;
>  		}
>  
> @@ -1806,6 +1807,7 @@ static int __devinit usbvision_probe(str
>  					      usbvision->num_alt,GFP_KERNEL);
>  	if (usbvision->alt_max_pkt_size == NULL) {
>  		err("usbvision: out of memory!\n");
> +		mutex_unlock(&usbvision->lock);
>  		return -ENOMEM;
>  	}
>  

Well yes.  But the bug which you've found is a *direct* consequence of a
coding mistake in those functions: they have multiple deeply-nested `return'
statements.  This is a common cause of locking errors and resource leaks and
is why we prefer the `goto place-which-unwinds' approach.

We can easily fix that in one case, at least.

One does wonder whether usbvision_radio_open() should be returning the
usbvision_set_alternate() result to the caller here, rather than
overwriting it with -EBUSY.


--- a/drivers/media/video/usbvision/usbvision-video.c~media-video-usbvision-add-mutex_unlock-to-error-paths-fix
+++ a/drivers/media/video/usbvision/usbvision-video.c
@@ -1290,8 +1290,8 @@ static int usbvision_radio_open(struct i
 		errCode = usbvision_set_alternate(usbvision);
 		if (errCode < 0) {
 			usbvision->last_error = errCode;
-			mutex_unlock(&usbvision->lock);
-			return -EBUSY;
+			errCode = -EBUSY;
+			goto out;
 		}
 
 		// If so far no errors then we shall start the radio
@@ -1308,6 +1308,7 @@ static int usbvision_radio_open(struct i
 			usbvision->initialized = 0;
 		}
 	}
+out:
 	mutex_unlock(&usbvision->lock);
 	return errCode;
 }
_

