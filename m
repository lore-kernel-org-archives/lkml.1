Return-Path: <linux-kernel-owner+w=401wt.eu-S1764211AbXHDALY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764211AbXHDALY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 20:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761649AbXHDALQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 20:11:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:57813 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbXHDALP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 20:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=o+VdDIVvVnusZBEw5bRaQB7UFAlZCivw6an+sC1bL0OtZcuTxtPqlA+gJP5UepKPBxXZOpftu7tJjQejyQK8Nq2Ar9chxx4JBmMgi5hPXJUmk0DRwwyT5Flx5JwnI2VDAY2OP5lUtcnqIdRZfxMQVfcxPX/w/H/vAdh2WlEOPbc=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] au88x0: mem leak fix in snd_vortex_create()
Date: Sat, 4 Aug 2007 02:09:25 +0200
User-Agent: KMail/1.9.7
Cc: Manuel Jander <mjander@embedded.cl>, Jesper Juhl <jesper.juhl@gmail.com>,
       alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708040209.25589.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In sound/pci/au88x0/au88x0.c::snd_vortex_create() : 
The Coverity checker found that if we allocate storage for 'chip' 
but then leave via the  regions_out:  label, then we end up leaking 
the storage allocated for 'chip'.
I believe simply freeing 'chip' before the "return err;" line is 
all we need to fix this, but please double-check me :)


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
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
 


