Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbZFIKUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbZFIKUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbZFIKSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:15 -0400
Received: from kroah.org ([198.145.64.141]:54496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760437AbZFIKSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:14 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:56 2009
Message-Id: <20090609094056.465155618@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:07 -0700
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
       alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 19/87] Fix oops on close of hot-unplugged FTDI serial converter
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=fix-oops-on-close-of-hot-unplugged-ftdi-serial-converter.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit 80193195f87ebca6d7417516d6edeb3969631c15 upstream.

Commit c45d6320 ("fix reference counting of ftdi_private") stopped
ftdi_sio_port_remove() from directly freeing the port-private data, with
the intention if the port was still open, it would be freed when
ftdi_close() is eventually called and releases the last refcount on the
structure.

That's all very well, but ftdi_sio_port_remove() still contains a call
to usb_set_serial_port_data(port, NULL) -- so by the time we get to
ftdi_close() for the port which was unplugged, it _still_ oopses on
dereferencing that NULL pointer, as it did before (and does in 2.6.29).

The fix is just not to clear the private data in ftdi_sio_port_remove().
Then the refcount is properly reduced to zero when the final kref_put()
happens in ftdi_close().

Remove a bogus comment too, while we're at it. And stop doing things
inside "if (priv)" -- it must _always_ be there.

Based loosely on an earlier patch by Daniel Mack, and suggestions by
Alan Stern.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1485,14 +1485,7 @@ static int ftdi_sio_port_remove(struct u
 
 	remove_sysfs_attrs(port);
 
-	/* all open ports are closed at this point
-	 *    (by usbserial.c:__serial_close, which calls ftdi_close)
-	 */
-
-	if (priv) {
-		usb_set_serial_port_data(port, NULL);
-		kref_put(&priv->kref, ftdi_sio_priv_release);
-	}
+	kref_put(&priv->kref, ftdi_sio_priv_release);
 
 	return 0;
 }


