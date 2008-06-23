Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbYFWUZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbYFWUZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYFWUZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:25:10 -0400
Received: from n77.bullet.mail.sp1.yahoo.com ([98.136.44.45]:32963 "HELO
	n77.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756182AbYFWUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:25:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 669573.32803.bm@omp401.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=6J0loAx5aXvtWnph1kHWQrLC/8+iWY4UJ0ydTQm5/ttZ9cmv3ihL6ASncHPA6S1xIZoq+WDYaNhsxhpAKJpfNSLaCPF/AA7gE/PJn1e6bUt6Ox46+yvuQEw8qa5i3fnjpZtOiWXvshddgi+v+aqSJ8AS3ymfYrZSdwZyS+6NNHs=;
X-Mailer: YahooMailWebService/0.7.199
Date: Mon, 23 Jun 2008 13:25:06 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: Panic in obsolete softmac wireless net 2.6.24 code
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <139401.73967.qm@web46107.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin moin,

This is to report that I've often had a panic in the softmac code
(which has since been ripped out from the latest kernels) that I've
been able to avoid, albeit not correctly, and thereby had relatively
stable operation from a 2.6.24-ish kernel (oooh, 38 days since last
panic/reboot, I'd have guessed maybe a week).

Unfortunately, while attempting to add debugging to a 2.6.25-flavour
kernel shows my machine freezes solid-ish in the wireless code at
various and different points, such that so far, my attempts to use
anything later have been mostly unsuccessful; yet when it does work,
it works, partly, though here too I have some issues with how it
works or doesn't, which I may address later.  Or not.  Jeez, and to
think I'm claiming english as my mother tongue

Then again, those 38 days of uptime tell me that while I've been
meaning to (honest) try later code, because there are in fact a
couple annoying bugs in 2.6.24-era code I need to fix, there's been
a lot happening since then to make my observations increasingly
irrelevant.


The particular case where I'm able to trip over the panic-inducing
BUG code seems to be when I'm using a somewhat-weak-in-strength WLAN
access-point.  In using a local strong network, I've never run across
the panic code.  That is, usually I can use the distant network with
success, but at times, the signal strength drops below the point where
automatic authentication/authorization succeeds.

As this code no longer exists, the only real point for me to report
this is in case anyone else might be using softmac in up-to-2.6.24
kernels and wants to avoid this type of panic.  So far, I haven't
had success with later kernels on my hardware, but that's a different
kettle of worms that I'll eat when I cross it, or something.


The code I've added to the OBSOLETE 2.6.24 kernel code that avoids
the panic looks sort of like this (line numbers will be slightly off
due to debuggery elsewhere I'm not including)...

--- /mnt/usr/local/src/linux-2.6.24/net/ieee80211/softmac/ieee80211softmac_auth.c-DIST  2008-01-30 10:59:39.000000000 +0100
+++ /mnt/usr/local/src/linux-2.6.24/net/ieee80211/softmac/ieee80211softmac_auth.c       2008-03-03 23:06:37.000000000 +0100
@@ -97,6 +99,18 @@ ieee80211softmac_auth_queue(struct work_
                }
                net->authenticated = 0;
                /* add a timeout call so we eventually give up waiting for an auth reply */
+               /* XXX HACK it's probably here... */
+                       dprintk(KERN_NOTICE PFX "   before queue_delayed_work in softmac_auth_queue....\n");
+                       if (&auth->work == NULL) dprintk(KERN_NOTICE PFX "   NULL auth->work in softmac_auth_queue!!!!\n");
+                       if (timer_pending(&auth->work.timer)) {
+                               dprintk(KERN_NOTICE PFX "   TIMER_PENDING -- we
probably do not want to panic!\n");
+                               /* XXX what to do?  definitely not continue,
+                                * but how to handle this properly?  */
+
+                               spin_unlock_irqrestore(&mac->lock, flags);
+                               return;
+
+                       }
                queue_delayed_work(mac->wq, &auth->work, IEEE80211SOFTMAC_AUTH_TIMEOUT);
                auth->retry--;
                spin_unlock_irqrestore(&mac->lock, flags);


I obviously don't understand this a bit, but the panics are induced by
the timer_pending() check in queue_delayed_work() (not shown), and
somehow, occasionally, in my situation, this check will be met.  By
using the above code, I can safely see when this happens, and manually
choose to trigger the above snippet of code (by manually issuing the
commands to attempt to associate/authenticate); it may take several
times and/or a wait, but, signal-strength-permitting, eventually I've
been able to reassociate successfully and continue work without ever
tripping the panic code.

With the debuggery I've added (not shown here), I've seen that the
expected sequence of events with authentication/authorization does not
always proceed by itself with my weak-signal-strength situation.
Whether this relates to the panics, I cannot say; nor can I say if
the hack above to avoid the panic is causing problems -- only that
I've not experienced any, and avoiding the panic necessitating a reboot
has been a definite win.


Once again, to repeat myself, the above code is OBSOLETE since the
2.6.24 kernel, and is nowhere to be found in up-to-date source.  This
hack is only useful for people such as myself who continue to use the
obsolete code.


thanks,
barry bouwsma


      

