Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYIOO6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYIOO6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 10:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYIOO6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 10:58:09 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:60089 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYIOO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 10:58:08 -0400
Date: Mon, 15 Sep 2008 16:53:42 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] device model: Do a quickcheck for driver binding before
 doing an expensive check
Message-ID: <20080915165342.00d7d10c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080915070644.5503c613@infradead.org>
References: <20080914083206.0f42b2a7@infradead.org>
	<20080915133226.7e433379@gondolin.boeblingen.de.ibm.com>
	<20080915070644.5503c613@infradead.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 07:06:44 -0700,
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 15 Sep 2008 13:32:26 +0200
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > On Sun, 14 Sep 2008 08:32:06 -0700,
> > Arjan van de Ven <arjan@infradead.org> wrote:
> > 
> > > This patch adds a quick check for the driver<->device match before
> > > taking the locks and doin gthe expensive checks. Taking the lock
> > > hurts in asynchronous boot context where the device lock gets hit;
> > > one of the init functions takes the lock and goes to do an
> > > expensive hardware init; the other init functions walk the same PCI
> > > list and get stuck on the lock as a result.
> > 
> > Hm, you call bus->match twice now; once without dev->sem held and once
> > with it. For the busses I'm familiar with that shouldn't be a problem,
> > but are you sure there aren't busses which want dev->sem held?
> > (Although I think not relying on dev->sem would be the sane thing...)
> 
> As far as I can see it's ok, but if not I obviously like to hear about
> it SOON :)

I don't see any problem on the s390 busses, and pci and usb look OK as
well at a glance.

> 
> 
> > > 
> > > For the common case, we can know there's no chance whatsoever of a
> > > match if the device isn't in the drivers ID table... so this patch
> > > does that check as a best-effort-avoid-the-lock approach.
> > 
> > I've always thought of ->match being a quick check which just looks at
> > the IDs with ->probe doing the heavier stuff, so this should be
> > reasonable (if all busses play nicely). But driver_probe_device()
> > still calls ->match a second time, and device_attach() will thus
> > always call ->match under the lock. Should it be moved out of the
> > lock there as well?
> 
> having a second check is actually not a bad thing per se; in terms of
> programming pattern, doing the quick checks before the lock, but doing
> the final check inside the lock makes sense to me. If there's real
> objections to doing the match the second time (it's cheap!) I'll remove
> it, but this way, you can call the "heavy" function always and from
> anywhere, and it'll just do the right thing no matter what. I kinda like
> that as concept ;)

OK, you have a point. I just find it a bit ugly; especially as the
->probe function will check if the device matches as well (by poking at
the device).

But I'd be fine with either way :)

