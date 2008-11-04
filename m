Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYKDGuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYKDGuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKDGt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:49:57 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:56908 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYKDGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:49:56 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: benh@kernel.crashing.org
Cc: James Cloos <cloos@jhcloos.com>, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<1225152347.8004.49.camel@pasglop>
	<m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	<1225662539.8004.237.camel@pasglop>
	<871vxtthr3.fsf@burly.wgtn.ondioline.org>
	<1225697689.8004.245.camel@pasglop>
Date: Tue, 04 Nov 2008 19:49:54 +1300
In-Reply-To: <1225697689.8004.245.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 03 Nov 2008 18:34:49 +1100")
Message-ID: <87wsfkrnn1.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> One thing you may want to try .. it will result in crap results on
> screen but would help telling us if that's the cause, is to hack
> radeonfb to round the image size to a multiple of 32 and see if that
> stops the lockup.

I took a guess at how to do this and ended up with the patch below.

With the patch applied, the screen turns almost completely to gibberish
at console handover and the machine hangs.  At the top I get two lines
of old output from the previous boot.  (I'm pretty sure it's hung
because the optical drive init happens after console handover, and I
don't get the usual chunka-chunka noise.)

The corruption I get is very similar to what I got when I originally
reported the problem when I was using my patched-in 12x24 font.  (I
created the .psf version later and switched back to default 8x16 to
verify my problem was the same as James's.)


diff --git a/drivers/video/aty/radeon_accel.c b/drivers/video/aty/radeon_accel.c
index 8718f73..848e9bc 100644
--- a/drivers/video/aty/radeon_accel.c
+++ b/drivers/video/aty/radeon_accel.c
@@ -208,7 +208,11 @@ static void radeonfb_prim_imageblit(struct radeonfb_info *rinfo,
 	 * work ok for me without that and the doco doesn't seem to imply
 	 * there is such a restriction.
 	 */
-	OUTREG(DST_WIDTH_HEIGHT, (image->width << 16) | image->height);
+	{
+		/* Hack attack. */
+		int width = ((image->width - 1) / 32 + 1) * 32;
+		OUTREG(DST_WIDTH_HEIGHT, (width << 16) | image->height);
+	}
 
 	src_bytes = (((image->width * image->depth) + 7) / 8) * image->height;
 	dwords = (src_bytes + 3) / 4;


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
