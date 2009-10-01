Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZJAIsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZJAIsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZJAIsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbZJAIsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:48:52 -0400
Date: Thu, 1 Oct 2009 14:17:37 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20091001084737.GA8385@amit-x200.redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291531.23389.borntraeger@de.ibm.com> <20090930171321.GA17200@amit-x200.redhat.com> <200910011017.29502.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910011017.29502.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Oct 01 2009 [10:17:29], Christian Borntraeger wrote:
> Am Mittwoch 30 September 2009 19:13:21 schrieb Amit Shah:
> > On (Tue) Sep 29 2009 [15:31:23], Christian Borntraeger wrote:
> > > Am Dienstag 29 September 2009 15:09:50 schrieb Amit Shah:
> > > > Great, thanks. However I was thinking of moving this init to the
> > > > probe() routine instead of in the init_conosle routine just because
> > > > multiple consoles can be added and we don't want to init this each
> > > > time.. just once in probe is fine.
> > >
> > > If you have new patch CC me and I can give it a spin.
> > 
> > Hey Christian,
> > 
> > I have a new patch that changes a few things:
> > - moves the put_char fix to probe instead of doing it in
> >   init_port_console(), which gets called on each console port found.
> > - uses port->id instead of a static hvc_vtermno to pass on a value to
> >   hvc_alloc(). Motivation explained within comments in the code.
> > - A few other changes that introduce and make use of port->vcon instead
> >   of accessing the static virtconsole directly -- aimed at easing future
> >   fix to have multiple virtio-console devices.
> > 
> > It would be great if you could test this.
> 
> The basic stuff seems to work, but when I did a console resize I get:

...

> One of the config->get() related changes is probably wrong.

I see it. The following should fix it.

		Amit

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 30361c1..b2de2df 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -822,9 +822,10 @@ static void tx_intr(struct virtqueue *vq)
 
 static void config_intr(struct virtio_device *vdev)
 {
-	/* Handle port hot-add */
-	schedule_work(&virtconsole.config_work);
-
+	if (use_multiport()) {
+		/* Handle port hot-add */
+		schedule_work(&virtconsole.config_work);
+	}
 	/* Handle console size changes */
 	virtcons_apply_config(vdev);
 }

