Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbYIJSH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbYIJSH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYIJSHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:07:13 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:46830 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbYIJSHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:07:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] Document use of RTC in pm_trace
Date: Wed, 10 Sep 2008 20:07:08 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <200809101658.06935.elendil@planet.nl> <200809101856.24997.elendil@planet.nl> <alpine.LFD.1.10.0809101001360.3384@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809101001360.3384@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809102007.09670.elendil@planet.nl>
X-OriginalArrivalTime: 10 Sep 2008 18:07:10.0406 (UTC) FILETIME=[0B538E60:01C91370]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008, Linus Torvalds wrote:
> On Wed, 10 Sep 2008, Frans Pop wrote:
> > But I would not expect the RTC to get changed when the resume is
> > successful. Or does it just get updated with every resume step
> > without a reset to the pre-trace value on completion?
>
> Indeed. We don't know where the bug happens when tracing, so each
> trace-point just writes its hash value into it. And nothing restores
> it, since nothing knows that the resume is "done" (a lot of problems
> happen due to X interactions much later than the 'core' resume thing).

Right. How about this patch then?

---
From: Frans Pop <elendil@planet.nl>

As pm_trace uses the system's hardware clock to save its magic
value, users of that option should be warned that using this debug
option will result in an incorrect system time after resume.
    
Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.txt
index b05f512..2ebdc60 100644
--- a/Documentation/power/s2ram.txt
+++ b/Documentation/power/s2ram.txt
@@ -54,3 +54,21 @@ used to run with "radeonfb" (it's an ATI Radeon mobility). It turns out
 that "radeonfb" simply cannot resume that device - it tries to set the
 PLL's, and it just _hangs_. Using the regular VGA console and letting X
 resume it instead works fine.
+
+NOTE
+====
+pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
+Reason for this is that the RTC is the only reliably available piece of
+hardware during resume operations where a value can be set that will
+survive a reboot.
+
+Consequence is that after a resume (even if it is successful) your system
+clock will have a value corresponding to the magic mumber instead of the
+correct date/time! It is therefore advisable to use a program like ntp-date
+or rdate to reset the correct date/time from an external time source when
+using this trace option.
+
+As the clock keeps ticking it is also essential that the reboot is done
+quickly after the resume failure. The trace option does not use the seconds
+or the low order bits of the minutes of the RTC, but a too long delay will
+corrupt the magic value.
