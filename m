Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYJ1JZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYJ1JZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYJ1JZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:25:44 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:44752 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYJ1JZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:25:43 -0400
From: James Cloos <cloos@jhcloos.com>
To: benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       "David S. Miller" <davem@davemloft.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: radeonfb lockup in .28-rc (bisected)
In-Reply-To: <1225152347.8004.49.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Tue, 28 Oct 2008 11:05:47 +1100")
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<1225152347.8004.49.camel@pasglop>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2008 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Tue, 28 Oct 2008 05:24:44 -0400
Message-ID: <m3k5bt2hsc.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:081028:benh@kernel.crashing.org::DFYePM5qGPwYdlMM:0000000000000000000000000000000000000XUle
X-Hashcash: 1:23:081028:linux-kernel@vger.kernel.org::VSB6h8aEcNmuR+AB:000000000000000000000000000000001CCZI
X-Hashcash: 1:23:081028:torvalds@linux-foundation.org::fT9GSsvdQiGgpW03:00000000000000000000000000000000ILIH
X-Hashcash: 1:23:081028:akpm@linux-foundation.org::xxnH52sQlAqga7CP:000000000000000000000000000000000000BWUk
X-Hashcash: 1:23:081028:khc@pm.waw.pl::1aB/JRHZSCRwGnTw:00004WYZ
X-Hashcash: 1:23:081028:davem@davemloft.net::Mhlxp0OvdHy0y9Lr:0000000000000000000000000000000000000000019hBy
X-Hashcash: 1:23:081028:linux-fbdev-devel@lists.sourceforge.net::yVUjA3/KCoZn0yBv:0000000000000000000000T5mh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Benjamin" == Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

Benjamin> First, let's see if it's related to the imageblit. Can you
Benjamin> re-apply the reverted patch and apply this little hack on top:

Benjamin> +#if 0
Benjamin>  	/* We only do 1 bpp color expansion for now */
Benjamin>  	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1)
Benjamin>  		goto fallback;
Benjamin> @@ -275,6 +276,7 @@ void radeonfb_imageblit(struct fb_info *
Benjamin>  	return;
 
Benjamin>   fallback:
Benjamin> +#endif

Benjamin> And let me know if that makes it not lockup.

Indeed, if-zero-ing out that block does work.

Since that if essentially removes to call to radeonfb_prim_imageblit(),
I wonder whether:

        /* X here pads width to a multiple of 32 and uses the clipper to
         * adjust the result. Is that really necessary ? Things seem to
         * work ok for me without that and the doco doesn't seem to imply
         * there is such a restriction.
         */

is relevant?

Or whether the card is unhappy with the creg settings.  It does seem,
now that I read the code, that:

void radeon_fifo_update_and_wait(struct radeonfb_info *rinfo, int entries)
{
        int i;

        for (i=0; i<2000000; i++) {
                rinfo->fifo_free = INREG(RBBM_STATUS) & 0x7f;
                if (rinfo->fifo_free >= entries)
                        return;
                udelay(10);
        }
        printk(KERN_ERR "radeonfb: FIFO Timeout !\n");
        /* XXX Todo: attempt to reset the engine */
}

is in play.  It is probably spinning through all of the 2000000 possible
udelay(10) calls.  I don't think I ever gave it twenty seconds before
giving up.  And certainly not forty seconds, if the freeze happens after
setting the DST_Y_X register.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
