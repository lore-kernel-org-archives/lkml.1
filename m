Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZDTChj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZDTChj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 22:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZDTChZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 22:37:25 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:33488
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbZDTChY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 22:37:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AogBAOd860l8qNY8/2dsb2JhbAAIzA+DfQY
X-IronPort-AV: E=Sophos;i="4.40,214,1238947200"; 
   d="scan'208";a="422362264"
Subject: [PATCH] favr32: improve touchscreen response
From: Ben Nizette <ben@niasdigital.com>
To: "haavard.skinnemoen" <haavard.skinnemoen@atmel.com>
Cc: kernel <kernel@avr32linux.org>,
       "Egtvedt, Hans-Christian" <Hans-Christian.Egtvedt@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 12:36:53 +1000
Message-Id: <1240195013.24329.38.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ezLCD+101 board (to which an favr-32 is fitted) has a long,
unshielded, nasty lead between the touch panel and the ads7843 touch
controller.  In order to get satisfactory response then, we need to
employ every noise-reduction trick in the driver's arsenal.  After
extensive fiddling I've found some good settings:

1) We keep vref on all the time to dramatically reduce settling times
(at the cost of a tiny increase in power consumption).

2) Despite 1 the settling time is still non-zero.  500uS is plenty of
time for the signals to settle

3) Despite 1 and 2 there's still a little bit of noise around.  By
setting a pen recheck delay we make the panel feel less touchy and
twitchy.

Someone with more time and patience myself might be able to tune this
numbers further but these settings are now perfectly acceptable for
normal use.

Tested on ezLCD+101 though should only improve response on other ezLCD+/
favr-32 boards too.

Signed-off-by: Ben Nizette <bn@niasdigital.com>

---
 arch/avr32/boards/favr-32/setup.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
index 58203d1..f1152fa 100644
--- a/arch/avr32/boards/favr-32/setup.c
+++ b/arch/avr32/boards/favr-32/setup.c
@@ -72,6 +72,10 @@ static struct ads7846_platform_data ads7843_data = {
 	.debounce_max		= 20,
 	.debounce_rep		= 4,
 	.debounce_tol		= 5,
+	
+	.keep_vref_on		= true,
+	.settle_delay_usecs	= 500,
+	.penirq_recheck_delay_usecs = 100,
 
 	/* The ads7843 pendown irq is just connected to regular
 	 * gpio and therefore can only trigger interrupts on
-- 
1.6.0.2


