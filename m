Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYAUSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYAUSxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYAUSxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:53:14 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50435 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYAUSxN (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:53:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Gerd Knorr <kraxel@bytesex.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH} 2.6.24-rc8-mm1 - x86_64 PAT issues with vesafb and NVidia cards
In-Reply-To: Your message of "Thu, 17 Jan 2008 02:35:14 PST."
             <20080117023514.9df393cf.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200941586_2778P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 21 Jan 2008 13:53:06 -0500
Message-ID: <7567.1200941586@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200941586_2778P
Content-Type: text/plain; charset=us-ascii

(Gerd Knorr cc'ed because 'git blame' says he last touched the line of code
I ended up touching - if this needs other cc:'s, will somebody who knows who
should review please add them?)

On Thu, 17 Jan 2008 02:35:14 PST, Andrew Morton said: 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/

This gave the NVidia binary driver indigestion:

X:2772 conflicting cache attribute d0000000-d0006000 uncached<->default

While researching this one and adding some debugging printk's and dump_stack()s,
I found that this was caused by:

[    0.444051] reserve_mattr swapper:1  setting d0000000-d0500000 to default
[    0.444055] Pid: 1, comm: swapper Not tainted 2.6.24-rc8-mm1 #4
[    0.444057]
[    0.444057] Call Trace:
[    0.444065]  [<ffffffff8034dfe7>] ? ioremap_page_range+0x17b/0x244
[    0.444069]  [<ffffffff802259ba>] reserve_mattr+0x91/0x27d
[    0.444072]  [<ffffffff80224c24>] __ioremap+0xe6/0x146
[    0.444077]  [<ffffffff806f7297>] vesafb_probe+0x196/0x6b2
...

So the vesafb driver had decided to tag an even *larger* space as 'default'..
I'm *guessing* that in fact, this area should have been non-caching (since
it's the video memory for the card), but nothing cared/flagged before.

Pigheaded-and-probably-wrong brute-force fix that works on my laptop, but
somebody who actually understands the vesafb code should check that in fact
the space *should* be non-caching.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6.24-rc8-mm1/drivers/video/vesafb.c.dist	2007-10-09 16:31:38.000000000 -0400
+++ linux-2.6.24-rc8-mm1/drivers/video/vesafb.c	2008-01-20 11:11:57.000000000 -0500
@@ -286,7 +286,7 @@ static int __init vesafb_probe(struct pl
 	info->pseudo_palette = info->par;
 	info->par = NULL;
 
-	info->screen_base = ioremap(vesafb_fix.smem_start, vesafb_fix.smem_len);
+	info->screen_base = ioremap_nocache(vesafb_fix.smem_start, vesafb_fix.smem_len);
 	if (!info->screen_base) {
 		printk(KERN_ERR
 		       "vesafb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",



--==_Exmh_1200941586_2778P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHlOoScC3lWbTT17ARAiAEAJ9/opI7TbY1UIAmgoiz8vqRX7BJPgCglZKU
t2Okx/0yDLL+vwaeoOqDlVI=
=/LyW
-----END PGP SIGNATURE-----

--==_Exmh_1200941586_2778P--
