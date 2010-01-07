Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758Ab0AGEH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0AGEH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 23:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642Ab0AGEH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 23:07:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52608 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab0AGEH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 23:07:26 -0500
Date: Thu, 7 Jan 2010 15:07:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the suspend tree with the input tree
Message-Id: <20100107150723.b07d521b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Today's linux-next merge of the suspend tree got a conflict in
drivers/input/serio/serio.c between commits
386d8772980be01b94bd463ea1e745732d7eb502 ("Input: serio - use device core
to create 'id' attribute group") and
ddf1ffbd40c92ff1e58c45fa96d309788f7beb60 ("Input: serio - let device core
tell us if device was registered") from the input tree and commit
f543d6795ccfbd443a042e012a6aea15e4f4c87a ("PM: Allow serio input devices
to suspend/resume asynchronously") from the suspend tree.

I fixed it up (see below) but am not sure it this is the correct fix.  I
can carry this fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/serio/serio.c
index c3b626e,42970e4..0000000
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@@ -547,15 -555,22 +547,17 @@@ static void serio_add_port(struct seri
  	}
  
  	list_add_tail(&serio->node, &serio_list);
 +
  	if (serio->start)
  		serio->start(serio);
 +
  	error = device_add(&serio->dev);
  	if (error)
 -		printk(KERN_ERR
 -			"serio: device_add() failed for %s (%s), error: %d\n",
 +		dev_err(&serio->dev,
 +			"device_add() failed for %s (%s), error: %d\n",
  			serio->phys, serio->name, error);
 -	else {
 -		serio->registered = true;
 -		error = sysfs_create_group(&serio->dev.kobj, &serio_id_attr_group);
 -		if (error)
 -			printk(KERN_ERR
 -				"serio: sysfs_create_group() failed for %s (%s), error: %d\n",
 -				serio->phys, serio->name, error);
++	else
+ 		device_enable_async_suspend(&serio->dev, true);
 -	}
  }
  
  /*
