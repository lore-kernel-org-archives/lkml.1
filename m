Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZH1ALq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZH1ALq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 20:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZH1ALp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 20:11:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33412 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbZH1ALp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 20:11:45 -0400
Date: Fri, 28 Aug 2009 10:11:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@igel.co.jp>, Paul Mundt <lethal@linux-sh.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: linux-next: manual merge of the v4l-dvb tree with the sh tree
Message-Id: <20090828101141.a41b453e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/media/video/sh_mobile_ceu_camera.c between commit
6d1386c6b8db54ac8d94c01194e0c27cd538532b ("v4l2: Runtime PM for SuperH
Mobile CEU") from the sh tree and commits
96d62ae620121fbf00228c925afc4439782f77e5 ("V4L/DVB (12506): soc-camera:
convert to platform device") and 7d2d23b9101115774c2b6ce5891235a4ba38ed53
("V4L/DVB (12510): soc-camera: (partially) convert to v4l2-(sub)dev API")
from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/video/sh_mobile_ceu_camera.c
index 61c47b8,9cdac58..0000000
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@@ -356,11 -405,7 +404,7 @@@ static int sh_mobile_ceu_add_device(str
  		 "SuperH Mobile CEU driver attached to camera %d\n",
  		 icd->devnum);
  
- 	ret = icd->ops->init(icd);
- 	if (ret)
- 		goto err;
- 
 -	clk_enable(pcdev->clk);
 +	pm_runtime_get_sync(ici->dev);
  
  	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
  	while (ceu_read(pcdev, CSTSR) & 1)
@@@ -394,11 -439,9 +438,9 @@@ static void sh_mobile_ceu_remove_device
  	}
  	spin_unlock_irqrestore(&pcdev->lock, flags);
  
 -	clk_disable(pcdev->clk);
 +	pm_runtime_put_sync(ici->dev);
  
- 	icd->ops->release(icd);
- 
- 	dev_info(&icd->dev,
+ 	dev_info(icd->dev.parent,
  		 "SuperH Mobile CEU driver detached from camera %d\n",
  		 icd->devnum);
  
@@@ -860,12 -1713,16 +1711,12 @@@ static int __devinit sh_mobile_ceu_prob
  		goto exit_release_mem;
  	}
  
 -	snprintf(clk_name, sizeof(clk_name), "ceu%d", pdev->id);
 -	pcdev->clk = clk_get(&pdev->dev, clk_name);
 -	if (IS_ERR(pcdev->clk)) {
 -		dev_err(&pdev->dev, "cannot get clock \"%s\"\n", clk_name);
 -		err = PTR_ERR(pcdev->clk);
 -		goto exit_free_irq;
 -	}
 +	pm_suspend_ignore_children(&pdev->dev, true);
 +	pm_runtime_enable(&pdev->dev);
 +	pm_runtime_resume(&pdev->dev);
  
  	pcdev->ici.priv = pcdev;
- 	pcdev->ici.dev = &pdev->dev;
+ 	pcdev->ici.v4l2_dev.dev = &pdev->dev;
  	pcdev->ici.nr = pdev->id;
  	pcdev->ici.drv_name = dev_name(&pdev->dev);
  	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
@@@ -924,10 -1767,9 +1775,10 @@@ static struct dev_pm_ops sh_mobile_ceu_
  static struct platform_driver sh_mobile_ceu_driver = {
  	.driver 	= {
  		.name	= "sh_mobile_ceu",
 +		.pm	= &sh_mobile_ceu_dev_pm_ops,
  	},
  	.probe		= sh_mobile_ceu_probe,
- 	.remove		= sh_mobile_ceu_remove,
+ 	.remove		= __exit_p(sh_mobile_ceu_remove),
  };
  
  static int __init sh_mobile_ceu_init(void)
