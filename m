Return-Path: <linux-kernel-owner+w=401wt.eu-S1764128AbXGXOxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764128AbXGXOxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXGXOww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:52:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49986 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXGXOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:52:52 -0400
Subject: Re: [PATCH] LinuxPPS - definitive version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070724142050.GD4074@enneenne.com>
References: <20070717180550.GA24759@enneenne.com>
	 <1185197716.14697.244.camel@pmac.infradead.org>
	 <20070724080013.GA22171@gundam.enneenne.com>
	 <1185284942.14697.319.camel@pmac.infradead.org>
	 <20070724142050.GD4074@enneenne.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 15:52:49 +0100
Message-Id: <1185288769.14697.339.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 16:20 +0200, Rodolfo Giometti wrote:
> On Tue, Jul 24, 2007 at 02:49:02PM +0100, David Woodhouse wrote:
> 
> > Also 's/unknow /unknown /' (2 instances)
> 
> ?? I didn't find them:
> 
>    $ grep 'unknow ' Documentation/pps/pps.txt

Elsewhere in the patch.

> > In order for your handling of 'pps_source[source].info' to be safe with
> > respect to pps_unregister_source(), you have to guarantee that
> > pps_event() has finished -- and can't be in progress on another CPU --
> > by the time your client's call to pps_unregister_source() completes. At
> > first glance I think your existing clients have that right (you have
> > del_timer_sync() before pps_unregister_source() in ktimer.c, for
> > example). But you should make sure it's clearly documented for new
> > clients.
> 
> This can be done only with locks, but it's not necessary since even if
> a pps_unregister_source() runs while pps_event() executes on another
> CPU the latter will write always on a valid area (even if it could be
> a dummy one) and the data are not corrupted (note also that the data
> will be, in any case, discarted since we are executing a
> pps_unregister_source()).

Read Documentation/memory-barriers.txt

There is a tiny but possibly non-zero chance that one CPU could be in
pps_event() and might not yet have 'seen' the change to the .info field.
Releasing the pps_mutex provides a write-barrier on the CPU which runs
pps_unregister_source(), but there's no corresponding read-barrier on
the CPU running pps_event(). You have to be careful about when
pps_event() is run. It _MUST_ not touch the old info structure after
pps_unregister_source() has completed.

At the moment, I think it's OK because you won't be calling pps_event()
at the wrong times. But you do need to make sure that requirement is
documented. And I think you can remove the whole dummy_info thing
because it's not necessary.

-- 
dwmw2

