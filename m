Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYFWITN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYFWITN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYFWISo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:18:44 -0400
Received: from mail.jambit.com ([62.245.207.83]:36571 "EHLO mail.jambit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYFWISn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:18:43 -0400
Message-ID: <485E0007.2020904@gmail.com>
Date: Sun, 22 Jun 2008 09:32:23 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: ADJ_OFFSET_SS_READ bug?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman, John

John, thanks for ADJ_OFFSET_SS_READ, which fixed my bug report
(http://sourceware.org/bugzilla/show_bug?id=2449,
http://bugzilla.kernel.org/show_bug.cgi?id=6761)

Roman, thanks for fixing John's fix ;-)

However, I'm wondering if there is a potential bug in the
implementation of this flag.  Note the following definitions
from include/linux/timex.h:

#define ADJ_OFFSET              0x0001  /* time offset */
[...]
#define ADJ_OFFSET_SINGLESHOT   0x8001  /* old-fashioned adjtime */
#define ADJ_OFFSET_SS_READ      0xa001  /* read-only adjtime */


Using the the above value for ADJ_OFFSET_SS_READ, where the bits match those
in ADJ_OFFSET and ADJ_OFFSET_SINGLESHOT, seems unnecessary as far as I can
see.  Why was that done?

More to the point, it looks like it creates a bug, since the "read-only
adjtime" triggers the code path for ADJ_OFFSET:

         if (txc->modes) {
                 ...
                 if (txc->modes & ADJ_OFFSET) {
                         if (txc->modes == ADJ_OFFSET_SINGLESHOT)
                                 /* adjtime() is independent from ntp_adjtime() */
                                 time_adjust = txc->offset;
                         else
                                 ntp_update_offset(txc->offset); /*XXX*/
                 }
                 if (txc->modes & ADJ_TICK)
                         tick_usec = txc->tick;

                 if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
                         ntp_update_frequency(); /*XXX*/
         }

Unless I misunderstood something, ADJ_OFFSET_SS_READ causes the code marked
XXX to be executed, but I don't think that is what is desired.  Is that true?

Cheers,

Michael

