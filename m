Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZDXJbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZDXJbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 05:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZDXJbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 05:31:16 -0400
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:42024 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750895AbZDXJbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 05:31:15 -0400
X-Yahoo-Newman-Id: 2865.81361.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aXCKyX6IcW7ap1ZCEZMxoFRPDCKMKd7B3n9c+5sitwF0QDBwpUKcm/uCARPgq/90iHmDbvCxdP9+JOmDdRou7+ZGJ5jzVoXVX7qvIQaAhe35ztgV8jFNDF27k/+0LBpQ3BrCUlEytH6OVt+Wm2WRYreKVALotMeOQQzfr1Ynt/E=  ;
X-YMail-OSG: _Zqp00MVM1krRzaeR2iN_WMmcKvTgJhuNhTB85TRY2ox4CbPJNWUiisPHFbG5NnQdTDzneVlgh_PD7FB1IjZcSED655OVap_.7WYEmcKkQjgw2t_SH6STN0..Hgghgzwv0Wy.W1s7ny3l2w42klLrwwLuxPTsMtR.je70qs5opG9cvr2hOQdWEBWXv7QN0BZeR.6ryrI9RieZNNbqhSZkGO6BsjcludHGhif76Q6706NKhSNcqb0bzIC7iY1YKUHK1DcDGSPijX4P4pIcPkqG1s2bCYny25NXbwB5P2OWp1rkm2vEfsv
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Date: Fri, 24 Apr 2009 02:31:12 -0700
User-Agent: KMail/1.9.10
Cc: rtc-linux@googlegroups.com, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it> <200904231245.33435.david-b@pacbell.net> <20090423215538.256fb5ff@i1501.lan.towertech.it>
In-Reply-To: <20090423215538.256fb5ff@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904240231.12906.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Alessandro Zummo wrote:
> > If the spinlock is *ever* acquired with IRQs disabled,
> > it must *always* be acquired that way.
> > 
> > The typical use is ... from IRQ context, which will in
> > some cases mean IRQs disabled.  QED.
> 
>  the spinlock could be acquired with IRQs disabled,
>  with spin_lock_irq, in the alarm setup functions

I don't want to make time for a re-audit of this
spinlock's usage just now.


>  and 
>  acquired with the standard spinlock calls in the irq
>  handler.

Which "standard" call?  "spin_lock", "spin_lock_irqsave",
and "spin_lock_irq" are all standard calls.

Recall that it's not the IRQ handler that's directly
grabbing the lock; it's code called by that handler.


>  would it work?

The patch I saw -- switching rtc_update_irq() to use
spin_lock_irqsave() -- would work, but it's incomplete.
It left the doc broken, and didn't clean up the drivers
which did the real work to obey the current call spec.

It'd be much nicer if lockdep would just do the right
thing and report when IRQ handlers do stupid things,
instead of covering up that class of bugs.  But I'm told
it will not get fixed; sigh.


