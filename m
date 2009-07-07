Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZGGNUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZGGNUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbZGGNUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:20:42 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60221 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbZGGNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:20:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MDfn1zRF8QGGPq0GgacAmKtXxzRUgdsEd4MgOchs4MRDVansVNHp+mmrKVnfq/vJCu
         N//iZzswhLpBi+gKG9yZ0sfltEOuAUuIvhXYkXeHEaZSVilhOfRntFcbL1aGFS6kVW8m
         IQFrlSogz7mF52/Ea+5JuA2GT4T0NTryFlKBc=
Date: Tue, 7 Jul 2009 15:20:25 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Joao Correia <joaomiguelcorreia@gmail.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andres Freund <andres@anarazel.de>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090707132025.GB6520@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <20090706163106.GA4559@ami.dom.local> <a5d9929e0907061023g4306d80ewfc8907653b949005@mail.gmail.com> <200907061926.43625.andres@anarazel.de> <20090707065014.GA3296@ami.dom.local> <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5d9929e0907070340y63280508t92e6c7e4ce464994@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, here is this tiny patch!

On Tue, Jul 07, 2009 at 11:40:16AM +0100, Joao Correia wrote:
> I am now running 2.6.31-rc2 for a couple of hours, no freeze.
> 
> Let me know what/if i can help with tracking down the original source
> of the problem.

OK, so we know it's only about timers. Here is another tiny patch
(the previous one should be removed), which could tell (with oops) if
there's something while migrating. Anyway, the bug should be back :-(

Thanks,
Jarek P.
---

 kernel/timer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 0b36b9e..61ba855 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -658,6 +658,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 			spin_unlock(&base->lock);
 			base = new_base;
 			spin_lock(&base->lock);
+			BUG_ON(tbase_get_base(timer->base));
 			timer_set_base(timer, base);
 		}
 	}
