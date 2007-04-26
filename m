Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbXDZQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbXDZQ7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXDZQ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:58:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34981 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbXDZQ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:58:17 -0400
Date: Thu, 26 Apr 2007 09:55:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>
Subject: [patch 03/33] HID: zeroing of bytes in output fields is bogus
Message-ID: <20070426165506.GD1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hid-zeroing-of-bytes-in-output-fields-is-bogus.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jiri Kosina <jkosina@suse.cz>

HID: zeroing of bytes in output fields is bogus

This patch removes bogus zeroing of unused bits in output reports,
introduced in Simon's patch in commit d4ae650a.
According to the specification, any sane device should not care
about values of unused bits.

What is worse, the zeroing is done in a way which is broken and
might clear certain bits in output reports which are actually
_used_ - a device that has multiple fields with one value of
the size 1 bit each might serve as an example of why this is
bogus - the second call of hid_output_report() would clear the
first bit of report, which has already been set up previously.

This patch will break LEDs on SpaceNavigator, because this device
is broken and takes into account the bits which it shouldn't touch.
The quirk for this particular device will be provided in a separate
patch.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -876,10 +876,6 @@ static void hid_output_field(struct hid_
 	unsigned size = field->report_size;
 	unsigned n;
 
-	/* make sure the unused bits in the last byte are zeros */
-	if (count > 0 && size > 0)
-		data[(count*size-1)/8] = 0;
-
 	for (n = 0; n < count; n++) {
 		if (field->logical_minimum < 0)	/* signed values */
 			implement(data, offset + n * size, size, s32ton(field->value[n], size));

-- 
