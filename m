Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZCFDyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZCFDyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZCFDyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:54:09 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34918 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZCFDyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:54:08 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesper Krogh <jesper@krogh.cc>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <1236309216.7766.248.camel@localhost.localdomain>
References: <1236029277.7756.0.camel@localhost.localdomain>
	 <49ACC853.8070205@krogh.cc> <1236110026.6068.18.camel@localhost>
	 <49AD90E2.7050209@krogh.cc> <1236118969.6068.87.camel@localhost>
	 <49AE9EA4.2080500@krogh.cc> <49AECA3B.5030503@krogh.cc>
	 <1236193075.3793.63.camel@jstultz-laptop>
	 <1236220759.6863.7.camel@localhost.localdomain>
	 <1236221530.6863.9.camel@localhost.localdomain>
	 <20090305084338.GA16026@elte.hu>
	 <1236309216.7766.248.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 19:54:01 -0800
Message-Id: <1236311641.7766.260.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 19:13 -0800, john stultz wrote:
> On Thu, 2009-03-05 at 09:43 +0100, Ingo Molnar wrote:
> > * john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > > Ingo, Thomas: On the hardware I'm testing the fast-pit 
> > > > calibration only triggers probably 80-90% of the time. About 
> > > > 10-20% of the time, the initial check to 
> > > > pit_expect_msb(0xff) fails (count=0), so we may need to look 
> > > > more at this approach.
> > 
> > We definitely need to improve calibration quality.
> > 
> > The question is - why does fast-calibration fail 10-20% of the 
> > time on your test-system? Also, why exactly do we miscalibrate? 
> > Could you please have a look at that?
> 
> Working on it, I just wanted to let you know I was seeing some different
> odd behavior then Jesper.
> 
> > One theory would be that the PIT readout is unreliable. Windows 
> > does not make use of it, so it's not the most tested aspect of 
> > the PIT. Is that what happens on your box?
> 
> Still looking into it, but from my initial debugging it seems that by
> reading the PIT very quickly after setting it, we may be getting junk
> values. If I re-read the PIT again, I see the expected 0xff value. 
> 
> Its been somewhat of a heisenbug, as if I add any printk's or even just
> a mb() after the outb it seems to make the problem go away (or just rare
> enough I don't have the patience to reproduce it :)
> 
> So I don't know if a small delay is appropriate here (seems counter
> productive to the whole fast-pit calibration ;) or if we should just try
> to catch these bad reads and try again before failing?

Maybe something like the following? (Not tested heavily yet!)

Again, just for clarity, as we've mixed a few issues here, this patch is
for a side issue and not related to the original regression reported by
Jesper. I'm still waiting on debug output from Jesper to further
diagnose whats going wrong with his TSC calibration.

thanks
-john


Apparently some hardware may occasionally return junk values if you try
to read the pit immediately after setting it. This causes the
pit_expect_msb() to occasionally fail (~10% of the time).

This patch tries to work around this issue by not failing if the first
read right after setting the PIT is not what we expect.

NOT FOR INCLUSION (yet!)

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 599e581..2ca5ba4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -280,8 +280,17 @@ static inline int pit_expect_msb(unsigned char val)
 	for (count = 0; count < 50000; count++) {
 		/* Ignore LSB */
 		inb(0x42);
-		if (inb(0x42) != val)
+		if (inb(0x42) != val) {
+			/*
+			 * If we're too fast, we may read
+			 * junk values right after we set
+			 * the PIT. So if this is the first
+			 * read, try again
+			 */
+			if (val == 0xff && count == 0)
+				continue;
 			break;
+		}
 	}
 	return count > 50;
 }


