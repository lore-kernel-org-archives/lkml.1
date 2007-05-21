Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbXEUJ5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbXEUJ5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXEUJ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:57:00 -0400
Received: from www.osadl.org ([213.239.205.134]:54153 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754545AbXEUJ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:56:59 -0400
Subject: Re: 2.6.22-rc2 built on ppc (2)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Elimar Riesebieter <riesebie@lxtec.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070520143752.2f6be87a.akpm@linux-foundation.org>
References: <20070520110815.GD3253@aragorn.home.lxtec.de>
	 <20070520143752.2f6be87a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 21 May 2007 12:03:37 +0200
Message-Id: <1179741817.6570.44.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 14:37 -0700, Andrew Morton wrote:
> On Sun, 20 May 2007 13:08:15 +0200 Elimar Riesebieter <riesebie@lxtec.de> wrote:
> 
> > FYI, building 2.6.22-rc2 with
> > gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
> > on my powerbook (PPC) gives:
> > 
> > ...
> > kernel/time/ntp.c: In function 'do_adjtimex':
> > kernel/time/ntp.c:307: warning: comparison of distinct pointer types lacks a cast
> > kernel/time/ntp.c:310: warning: comparison of distinct pointer types lacks a cast
> 
> hm, do_div() is defined as operating on a u64, but ntp is passing it an s64
> and the asm-generic implementation of do_div() is warning about that.
> 
> Fixing that would be simple but a bit ugly.

We have the signed do_div() work around and it is used in the ntp code 5
lines further down already.

	tglx

--------------------------------->
Subject: NTP: use the signed divide function instead of do_div()

> > kernel/time/ntp.c:307: warning: comparison of distinct pointer types lacks a cast
> > kernel/time/ntp.c:310: warning: comparison of distinct pointer types lacks a cast
> 
> hm, do_div() is defined as operating on a u64, but ntp is passing it an s64
> and the asm-generic implementation of do_div() is warning about that.

Replace do_div() by div_long_long_rem_signed()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index cb25649..bb1bf86 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -304,10 +304,12 @@ int do_adjtimex(struct timex *txc)
 			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
 			if (time_offset < 0) {
 			    temp64 = -temp64;
-			    do_div(temp64, mtemp);
+			    temp64 = div_long_long_rem_signed(temp64, mtemp,
+							      &rem);
 			    freq_adj -= temp64;
 			} else {
-			    do_div(temp64, mtemp);
+			    temp64 = div_long_long_rem_signed(temp64, mtemp,
+							      &rem);
 			    freq_adj += temp64;
 			}
 		    }




