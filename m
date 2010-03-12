Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab0CLVtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:49:55 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:33497 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab0CLVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:49:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Weird wireless/wpa_supplicant screw-up.
In-Reply-To: Your message of "Fri, 12 Mar 2010 03:14:41 PST."
             <1268392481.4828.7.camel@jlt3.sipsolutions.net>
From: Valdis.Kletnieks@vt.edu
References: <7197.1268086939@localhost>
            <1268392481.4828.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268430568_4034P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Mar 2010 16:49:28 -0500
Message-ID: <5220.1268430568@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B9AB6E8.0170,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268430568_4034P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Mar 2010 03:14:41 PST, Johannes Berg said:
> On Mon, 2010-03-08 at 17:22 -0500, Valdis.Kletnieks@vt.edu wrote:
> > (This could be user error/userspace bug, feel free to point me in the right
> > direction if you think so.  Hopefully somebody knows what I've broken this
> > time...)
> > 
> > Fedora Rawhide as of this morning, 2.6.33-mmotm0304 kernel, wpa_supplicant-0.6.8-8.fc13.x86_64
> > wireless-tools-29-5.1.fc12.x86_64.  Dell Latitude E6500, Intel 5100AGN card.
> > 
> > So I finally get a few spare cycles, and re-try getting WPA2 working on our
> > enterprise wireless network, and wpa_supplicant reports it completed
> > successfully and set the keys,
> 
> and does it work? The iwlist stuff could just be a reporting error...

OK, getting closer ;)

in net/wireless/wext-compat.c, we have this in cfg80211_wext_giwencode()
after I add some printk's:

printk(KERN_INFO "In giwencode idx=%d keys=%x cipher=%x\n", idx, wdev->wext.keys, wdev->wext.keys->params[idx].cipher);
        if (!wdev->wext.keys || !wdev->wext.keys->params[idx].cipher) {
printk(KERN_INFO "And we're going home...\n");
                erq->flags |= IW_ENCODE_DISABLED;
                erq->length = 0;
                return 0;
        }

which produces

[  151.401195] In giwencode idx=0 keys=1d023600 cipher=0
[  151.401198] And we're going home...

So the root cause has something to do with params[idx].cipher being unset.

I've become reasonably sure it's not pilot error on my part, as a co-worker's
laptop has the same issue - mine is a Dell Latitude E6500 with an Intel 5000agn
cardrunning Fedora Rawhide and a 2.6.34-rc1-mmotm kernel, and his is a Latitude
D830 with an Intel 3945, Ubuntu with a 2.6.32 kernel.

Looks like time to instrument more of wext-compat.c.  Oh joy.


--==_Exmh_1268430568_4034P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLmrbocC3lWbTT17ARAvmbAKD8Jt01f2gvj6yoyqki+HmfVhIQpACdEUWc
2ZdYZFfTWk4M+xGdUUDoKTo=
=GMD0
-----END PGP SIGNATURE-----

--==_Exmh_1268430568_4034P--

