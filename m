Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZI3XAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZI3XAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZI3XAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:00:48 -0400
Received: from claw.goop.org ([74.207.240.146]:35924 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZI3XAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:00:47 -0400
Message-ID: <4AC3E1EB.4020903@goop.org>
Date: Wed, 30 Sep 2009 15:55:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: dri-devel <dri-devel@lists.sourceforge.net>,
       Jan Beulich <JBeulich@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm: make sure page protections are updated after changing
 vm_flags.
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures compute ->vm_page_prot depending on ->vm_flags, so
we need to update the protections after adjusting the flags.

Reported-by: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 8104eca..9d3e39f 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -537,7 +537,7 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_ops = obj->dev->driver->gem_vm_ops;
 	vma->vm_private_data = map->handle;
 	/* FIXME: use pgprot_writecombine when available */
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
 
 	/* Take a ref for this mapping of the object, so that the fault
 	 * handler can dereference the mmap offset's pointer to the object.


