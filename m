Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZA2UK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZA2UK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZA2UKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:10:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34305 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZA2UKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:10:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49820CF9.3000706@s5r6.in-berlin.de>
Date: Thu, 29 Jan 2009 21:09:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH RFT 7/7] firewire: sbp2: add workarounds for 2nd and 3rd
 generation iPods
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de> <200901281718.41873.jarod@redhat.com> <tkrat.8899c8be7878fd1f@s5r6.in-berlin.de> <200901282218.42604.jarod@redhat.com>
In-Reply-To: <200901282218.42604.jarod@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Cc: Alan Stern just in case, because he knows much more about
all this)

Jarod Wilson wrote:
> On a related note... The fix capacity workaround... I think I need to
> observe this failure myself... My own 4th-gen ipod, when connected to a
> Mac OS X system, reports the exact capacity I get if the fix capacity
> workaround is disabled. Do they just know not to try to access that
> last block, or is the need for this workaround a myth? :)

Well, before the report [1] from the Ubuntu of a what appeared to be a
regression of Ubuntu 8.10 vs. its parent or grandparent release, we
thought we knew that iPod 2nd + 3rd gen were _not_ affected, because
long ago an owner of these iPods told us so.

Obviously they changed something in Ubuntu 8.10 which suddenly made 3rd
gen iPods vulnerable too.  If the report is accurate, then this is /not/
the READ CAPACITY 10 issue where device's capacity report is off by one.
(The reported capacity without workaround is an even number and thus
possibly correct.)  Rather, this is apparently the kind of the bug where
an access which includes the last sector corrupts some state in the
firmware, causing the firmware to error out on subsequent accesses.  The
actual IO errors in the reporter's log happen at low LBAs, not at LBAs
at the end.

Anyway; to our moderate surprise after years of successful usage of
these devices under Linux, we learn that a current Linux suddenly needs
a quirk fix for them.  IMO they always needed it but they just weren't
exposed to the dangerous access patterns, until userland or the kernel
was changed in an as yet unidentified respect.

Back to the question whether the 4th gen iPod really needs it.  Well,
I'm quite sure that we added it because it was proven to be necessary.
At least that's what I remember about it; if we really wanted to we
could probably find evidence in list archives.  I don't remember which
particular type of last sector bug it was in case of these newer iPod
models.  Coincidentally, those dual interface iPods also need the
workaround when used through usb-storage; see
drivers/usb/storage/unusual_devs.h.

Now, what does OS X do with those iPods?  I don't know.  Maybe they have
quirks lists like we do.  There could be something to be found in the
Darwin sources.  But I consider it more likely that OS X simply does not
do the kind of accesses that Linux does which tend to crash all those
crap firmwares left and right.

Evidently, at least popular Windows incarnations don't do such accesses,
at least not in normal usage.  Otherwise this class of firmware bugs
could simply not exist in mass market devices.

[1] https://bugs.launchpad.net/bugs/294391
-- 
Stefan Richter
-=====-==--= ---= ===-=
http://arcgraph.de/sr/
