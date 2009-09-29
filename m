Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZI2MDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZI2MDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI2MDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:03:08 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:53869 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZI2MDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:03:07 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 29 Sep 2009 14:03:08 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <20090922154549.GA11379@amit-x200.redhat.com> <20090929092431.GA3368@amit-x200.redhat.com>
In-Reply-To: <20090929092431.GA3368@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291403.08547.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 11:24:31 schrieb Amit Shah:
> -static void hvc_handle_input(struct virtqueue *vq)
> +/* The operations for our console. */
> +static struct hv_ops virtio_cons = {
> +	.get_chars = cons_get_chars,
> +	.put_chars = cons_put_chars,
> +	.notifier_add = cons_notifier_add_vio,
> +	.notifier_del = cons_notifier_del_vio,
> +	.notifier_hangup = cons_notifier_del_vio,
> +};
[...]
> +int __init virtio_cons_early_init(int (*put_chars)(u32, const char *, int)) 
> +{
> +	virtio_cons.put_chars = put_chars;
> +	return hvc_instantiate(0, 0, &virtio_cons);
> +}
[...]
> +static int __devinit virtcons_probe(struct virtio_device *vdev)
[...]
> -	/* Start using the new console output. */
> -	virtio_cons.get_chars = get_chars;
> -	virtio_cons.put_chars = put_chars;

Ok, that wont work for systems that use virtio_cons_early_init. The early
put_chars method was replaced by the final one, but these hunks changed that
behaviour. Something like the following restores the old behaviour: (only 
tested on s390)

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
If you agree, you can merge this snipped into your big patch.

---
 drivers/char/virtio_console.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/char/virtio_console.c
===================================================================
--- linux-2.6.orig/drivers/char/virtio_console.c
+++ linux-2.6/drivers/char/virtio_console.c
@@ -590,6 +590,9 @@ int init_port_console(struct virtio_cons
 		pr_err("%s: Could not alloc hvc for virtio console port, ret = %d\n",
 		       __func__, ret);
 		port->hvc = NULL;
+	} else {
+		/* get rid of early put char variants */
+		virtio_cons.put_chars = cons_put_chars;
 	}
 	return ret;
 }
