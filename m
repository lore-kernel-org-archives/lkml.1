Return-Path: <linux-kernel-owner+w=401wt.eu-S933000AbXHWVnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbXHWVnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932818AbXHWVmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:42:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37187 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061AbXHWVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:42:16 -0400
Subject: RE: "double" hpet clocksource && hard freeze [bisected]
From: john stultz <johnstul@us.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bob Picco <bob.picco@hp.com>
In-Reply-To: <1187903135.6024.18.camel@localhost.localdomain>
References: <20070823222115.122a37ca@localhost>
	 <617E1C2C70743745A92448908E030B2A023EB2E1@scsmsx411.amr.corp.intel.com>
	 <1187903135.6024.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 14:41:45 -0700
Message-Id: <1187905306.6024.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 14:05 -0700, john stultz wrote:
> On Thu, 2007-08-23 at 13:41 -0700, Luck, Tony wrote:
> > > I have a double "hpet" entry in "available_clocksource":
> > >	$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > >	tsc hpet hpet acpi_pm jiffies
> > 
> > Oops.  If seems that both drivers/char/hpet.c and arch/x86_64/kernel/hpet.c
> > both register a clocksource named "hpet".  Probably a result of bringing
> > back to life a long lost patch, and having someone else (John Stultz, according
> > to git blame) make a similar change to a different file in the intervening
> > time.
> > 
> > Presumably the thing to do would be merge the x86_64 specific version
> > into the drivers/char/hpet.c version?
> 
> Ugh. Yea. i386 has an hpet clocksource as well. We should kill the
> duplication, but at the moment I'm not comfortable that the
> driver/char/hpet.c is ok to be used for i386/x86_64 (Bob: Do you know
> why the shift value is only 10?).
> 
> 
> I'm a little surprised by this, as the clocksource code use to prevent
> duplicate named clocksources from being registered, so I'm not sure how
> that check got dropped.  Also I'm not quite sure I see where the hard
> freeze is coming from.
> 
> My initial reaction would be to either ifdef ia64 implementation in
> drivers/char/hpet.c or move the code under the ia64 arch dir until it is
> really usable by all arches.

Here is a possible quick fix. I'm open to other approaches, but I also
want to avoid too much churn before 2.6.23 goes out.

Paolo, could you verify this fixes the issue for you?

thanks
-john

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 77bf4aa..c782d8c 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -78,7 +78,17 @@ static struct clocksource clocksource_hpet = {
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
+
+/* XXX - FIXME: i386, x86_64 and ia64 all have separate 
+ * hpet clocksource implementations. They should be merged 
+ * and this would be a good place for it.
+ * Right now this is ia64 only.
+ */
+#ifdef CONFIG_IA64
 static struct clocksource *hpet_clocksource;
+#else /* this isn't generic enough to use for everyone yet */
+static struct clocksource *hpet_clocksource = (struct clocksource*)0xdead;
+#endif
 
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);


