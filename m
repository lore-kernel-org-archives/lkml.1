Return-Path: <linux-kernel-owner+w=401wt.eu-S1765804AbXHDShd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765804AbXHDShd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932784AbXHDSeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:34:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:45415 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010AbXHDSeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:subject:user-agent:cc:mime-version:content-disposition:date:to:content-type:content-transfer-encoding:message-id;
        b=A8qMLntFo6fqBY7ZO0ttsjOtZHMyN/9x81Qam1afInVG6SZi83eqYzhGW8jbmF1pv6NvbJHKgEAqkqrSl+b+u1WxhxgxFyhtXy6IB/SMfA6xtcAivDxSQ0p7aw7lZH1WH4kJeRIpZWUPmMLfMBYP5BFI0B+XdTEk6nm9kIBoN2Q=
From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][RESEND][pnp] Avoid a small unlikely memory leak in proc_read_escd()
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Hood <dthood@mail.com>,
       David Hinds <dahinds@users.sourceforge.net>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 4 Aug 2007 20:32:04 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042032.05139.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending patch originally submitted on 20/7-2007 23:41)


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
 


