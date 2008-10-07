Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbYJGA6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbYJGA6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYJGAp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:29 -0400
Received: from ns.suse.de ([195.135.220.2]:47056 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbYJGAp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:26 -0400
Date: Mon, 6 Oct 2008 17:39:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [patch 50/71] pcmcia: Fix broken abuse of dev->driver_data
Message-ID: <20081007003936.GY3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pcmcia-fix-broken-abuse-of-dev-driver_data.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alan Cox <alan@redhat.com>

[ Upstream commit: cec5eb7be3a104fffd27ca967ee8e15a123050e2 ]

PCMCIA abuses dev->private_data in the probe methods. Unfortunately it
continues to abuse it after calling drv->probe() which leads to crashes and
other nasties (such as bogus probes of multifunction devices) giving errors like

pcmcia: registering new device pcmcia0.1
kernel: 0.1: GetNextTuple: No more items

Extract the passed data before calling the driver probe function that way
we don't blow up when the driver reuses dev->private_data as its right.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/ds.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -428,6 +428,18 @@ static int pcmcia_device_probe(struct de
 	p_drv = to_pcmcia_drv(dev->driver);
 	s = p_dev->socket;
 
+	/* The PCMCIA code passes the match data in via dev->driver_data
+	 * which is an ugly hack. Once the driver probe is called it may
+	 * and often will overwrite the match data so we must save it first
+	 *
+	 * handle pseudo multifunction devices:
+	 * there are at most two pseudo multifunction devices.
+	 * if we're matching against the first, schedule a
+	 * call which will then check whether there are two
+	 * pseudo devices, and if not, add the second one.
+	 */
+	did = p_dev->dev.driver_data;
+
 	ds_dbg(1, "trying to bind %s to %s\n", p_dev->dev.bus_id,
 	       p_drv->drv.name);
 
@@ -456,21 +468,14 @@ static int pcmcia_device_probe(struct de
 		goto put_module;
 	}
 
-	/* handle pseudo multifunction devices:
-	 * there are at most two pseudo multifunction devices.
-	 * if we're matching against the first, schedule a
-	 * call which will then check whether there are two
-	 * pseudo devices, and if not, add the second one.
-	 */
-	did = p_dev->dev.driver_data;
 	if (did && (did->match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO) &&
 	    (p_dev->socket->device_count == 1) && (p_dev->device_no == 0))
 		pcmcia_add_device_later(p_dev->socket, 0);
 
- put_module:
+put_module:
 	if (ret)
 		module_put(p_drv->owner);
- put_dev:
+put_dev:
 	if (ret)
 		put_device(dev);
 	return (ret);

-- 
