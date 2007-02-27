Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXB0XHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXB0XHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXB0XHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:07:05 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:38736 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXB0XHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:07:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=PSANbW+y26nhlSk/88spWu4uRp7wtE6AgywgXW223AAYUseqyY7QvYqLPKQBwwvXvyc26Hj4lggwEb59ojeThV8eBNA8B8hAuAWLjw7w/EB3DaEKfM4CWB8yJjppXb9d16wWPFW6OQqlUFbQ4k2gq3ey6tioaAc6TY1VpAh+2q4=
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: DervishD <lkml@dervishd.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <20070226203223.GA161@DervishD>
References: <20070226144744.GA3615@DervishD>
	 <1172503471.20842.14.camel@daplas> <20070226171334.GB13496@DervishD>
	 <1172510654.7101.11.camel@daplas>  <20070226203223.GA161@DervishD>
Content-Type: multipart/mixed; boundary="=-7bvyZxsUGVkF1nVmq7lq"
Date: Wed, 28 Feb 2007 07:09:15 +0800
Message-Id: <1172617755.13422.0.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7bvyZxsUGVkF1nVmq7lq
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-02-26 at 21:32 +0100, DervishD wrote:
>     Hi Antonino :)
> 
>  * Antonino A. Daplas <adaplas@gmail.com> dixit:
> > On Mon, 2007-02-26 at 18:13 +0100, DervishD wrote:
> > That's why tdfxb limits the vyres to a maximum of 4096. As to why the
> > problem disappeared just by changing this parameter, that I too don't
> > know.
> 
>     Probably setting it back to 4096 will make the problem reappear.
> Right now I cannot test, but I'll make some experiments.
> 

Can you try this patch?  It might help with the screen corruption.

Tony


--=-7bvyZxsUGVkF1nVmq7lq
Content-Disposition: attachment; filename=tdfxfb_delay.diff
Content-Type: text/x-patch; name=tdfxfb_delay.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index 689ce02..bb3ca71 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -284,7 +284,8 @@ static inline void banshee_make_room(str
 {
 	/* Note: The Voodoo3's onboard FIFO has 32 slots. This loop
 	 * won't quit if you ask for more. */
-	while((tdfx_inl(par, STATUS) & 0x1f) < size-1);
+	while((tdfx_inl(par, STATUS) & 0x1f) < size-1)
+		mdelay(5);
 }
  
 static int banshee_wait_idle(struct fb_info *info)
@@ -297,7 +298,9 @@ static int banshee_wait_idle(struct fb_i
 
 	while(1) {
 		i = (tdfx_inl(par, STATUS) & STATUS_BUSY) ? 0 : i + 1;
-		if(i == 3) break;
+		if(i == 3)
+			break;
+		mdelay(5);
 	}
 	return 0;
 }

--=-7bvyZxsUGVkF1nVmq7lq--

