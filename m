Return-Path: <linux-kernel-owner+w=401wt.eu-S937046AbXGTVmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937046AbXGTVmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762316AbXGTVmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:42:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:40640 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759719AbXGTVmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:42:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rpkTxt+Z7fln2bJc2tk+CNbDdPPBdtgbH5E9/niB9BVx9VUgauqcVQkl9T0DtKPayJmYk8oFCgLBJnxKY6b0qvy5DFltsfFVkptvj09RtNNT2hA7TC23vRWRpthTf7jpgG4vpB4at/9ndEb5ZL0RDbPq4mFgolD8q+Ci1B6aqBY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][pnp] Avoid a small unlikely memory leak in proc_read_escd()
Date: Fri, 20 Jul 2007 23:41:06 +0200
User-Agent: KMail/1.9.7
Cc: Thomas Hood <dthood@mail.com>, David Hinds <dahinds@users.sourceforge.net>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202341.06710.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a small and unlikely memory leak in 
drivers/pnp/pnpbios/proc.c::proc_read_escd(). It's inside a sanity 
check, so it probably won't trigger often (if at all), however it 
*is* a potential leak and it's easy to avoid, so let's just fix it :)

While I was in there I also broke a oneline 'if' statement into two 
lines - seemed too trivial a changee to warrent a seperate patch.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/pnp/pnpbios/proc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pnp/pnpbios/proc.c b/drivers/pnp/pnpbios/proc.c
index 8027073..f77b8c4 100644
--- a/drivers/pnp/pnpbios/proc.c
+++ b/drivers/pnp/pnpbios/proc.c
@@ -88,7 +88,8 @@ static int proc_read_escd(char *buf, char **start, off_t pos,
 	}
 
 	tmpbuf = kzalloc(escd.escd_size, GFP_KERNEL);
-	if (!tmpbuf) return -ENOMEM;
+	if (!tmpbuf)
+		return -ENOMEM;
 
 	if (pnp_bios_read_escd(tmpbuf, escd.nv_storage_base)) {
 		kfree(tmpbuf);
@@ -100,6 +101,7 @@ static int proc_read_escd(char *buf, char **start, off_t pos,
 	/* sanity check */
 	if (escd_size > MAX_SANE_ESCD_SIZE) {
 		printk(KERN_ERR "PnPBIOS: proc_read_escd: ESCD size reported by BIOS read_escd call is too great\n");
+		kfree(tmpbuf);
 		return -EFBIG;
 	}
 


