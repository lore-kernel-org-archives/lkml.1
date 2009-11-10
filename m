Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZKJOmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZKJOmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbZKJOmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:42:50 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61782 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbZKJOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:42:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wU99Eo3dROJlmWa9esv3c1wzAgUzOpjUdpqHJr8XPh0vNLSfzI833leO4d1L/WbeZl
         ScoST7z9SkaKdSZeNxadaPBFqMzLTkIyWyUn8q2QvqI8glbIBKpOdMGvMJisNJoLR/cN
         XPnE4bbaZwY1pGRlavIZbmCiXyhrdw248ep90=
MIME-Version: 1.0
In-Reply-To: <20091106135722.5abfdd03@jbarnes-piketon>
References: <cb0375e10910030939v8d03df7m861a2f05219f173c@mail.gmail.com>
	 <cb0375e10910291022l5650994dyc4a36d55f1e5bbc4@mail.gmail.com>
	 <cb0375e10910291040i31a7b9aatb6da5c20778d9791@mail.gmail.com>
	 <cb0375e10910292325l659034c4u36cf263cda8e90c8@mail.gmail.com>
	 <20091030083742.48f5d4f3@jbarnes-g45>
	 <cb0375e10910301155s5e2b2e79t562bfa798ba75e23@mail.gmail.com>
	 <cb0375e10911042000h3cf215a1o44add74510c15a1c@mail.gmail.com>
	 <20091105082829.2d59dcae@jbarnes-piketon>
	 <cb0375e10911061225y1bc29807y5abd67e748ef4164@mail.gmail.com>
	 <20091106135722.5abfdd03@jbarnes-piketon>
Date: Tue, 10 Nov 2009 09:42:52 -0500
X-Google-Sender-Auth: 2e96bf69357d2123
Message-ID: <cb0375e10911100642p348cc701la840e0b39aa8615f@mail.gmail.com>
Subject: Re: [resend] i915: high power consumption after suspend/resume
From: Andrew Lutomirski <luto@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to confuse matters further, the following patch does *not* help.
Even with this patch applied, power consumption often goes high when
resuming, and writing 1 to i915_wedged after fully resuming fixes it.

I now officially have no clue what's going on.  Maybe there's
something wrong with the i915 resume code that increases power
consumption.

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 7f436ec..71472a9 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -99,11 +99,28 @@ static int i915_resume(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret = 0;
+	u8 gdrst;
+	unsigned long timeout;
+

 	if (pci_enable_device(dev->pdev))
 		return -1;
 	pci_set_master(dev->pdev);

+	pci_read_config_byte(dev->pdev, GDRST, &gdrst);
+	pci_write_config_byte(dev->pdev, GDRST, gdrst | GDRST_RENDER);
+	udelay(50);
+	//pci_write_config_byte(dev->pdev, GDRST, gdrst & 0xfe);
+	
+	/* ...we don't want to loop forever though, 500ms should be plenty */
+	timeout = jiffies + msecs_to_jiffies(500);
+	do {
+		udelay(100);
+		pci_read_config_byte(dev->pdev, GDRST, &gdrst);
+	} while ((gdrst & 0x1) && time_after(timeout, jiffies));
+	printk(KERN_INFO "i915: Reset on resume took %d ms\n",
+	       jiffies_to_msecs(jiffies - timeout + msecs_to_jiffies(500)));
+
 	i915_restore_state(dev);

 	intel_opregion_init(dev, 1);

--Andy
