Return-Path: <linux-kernel-owner+w=401wt.eu-S932520AbXHDSd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520AbXHDSd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765119AbXHDScb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:32:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:44971 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765558AbXHDSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:user-agent:cc:mime-version:content-disposition:date:content-type:content-transfer-encoding:message-id;
        b=jBksPX7A6wWZvrHHnccFgwD1J73sadIJYrsSdi3STwe1AXGAuEYwoAphhuQNqQAqUYrZ8VyDFJsveXDpfK8SOyQLlMvKIj5mYACGb559h6RN/wUJWg/+IyV6/A0mUoDPvv5uwAoLLm1dMCrV4SamfGbXgl5WqPsVbIcXiwEisNo=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][RESEND] au88x0: mem leak fix in snd_vortex_create()
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Manuel Jander <mjander@embedded.cl>,
       Jesper Juhl <jesper.juhl@gmail.com>, alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 4 Aug 2007 20:30:34 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042030.34804.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resend of patch previously submitted on 04-Aug-2007 02:09)


Hi,

In sound/pci/au88x0/au88x0.c::snd_vortex_create() : 
The Coverity checker found that if we allocate storage for 'chip' 
but then leave via the  regions_out:  label, then we end up leaking 
the storage allocated for 'chip'.
I believe simply freeing 'chip' before the "return err;" line is 
all we need to fix this, but please double-check me :)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
---

diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index 5ec1b6f..f70286a 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -232,6 +232,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
 	pci_disable_device(chip->pci_dev);
 	//FIXME: this not the right place to unregister the gameport
 	vortex_gameport_unregister(chip);
+	kfree(chip);
 	return err;
 }
 


