Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZCLVGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZCLVGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 17:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZCLVFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 17:05:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4646 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZCLVFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 17:05:50 -0400
Date: Thu, 12 Mar 2009 21:05:46 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: dbrownell@users.sourceforge.net
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
Message-ID: <20090312210545.GJ24376@sirena.org.uk>
References: <200903111743.34708.david-b@pacbell.net> <20090312103744.GA24376@sirena.org.uk> <200903121335.25368.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903121335.25368.david-b@pacbell.net>
X-Cookie: War is an equal opportunity destroyer.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 12:35:24PM -0800, David Brownell wrote:
> On Thursday 12 March 2009, Mark Brown wrote:

> > safely share a regulator without extra work since they have no way of
> > telling why a regulator is in the state that it's in without extra
> > stuff.

> Depends what you mean by "safely".  If they weren't buggy
> already, I don't see how they'd notice any difference.
> Having buggy consumers become non-buggy isn't exactly a
> job for the framework itself.

Previously the per-consumer reference count would've meant that they
couldn't interfere with other consumers - they could set their own
state but not reverse an enable something else had done.  Now there is
only one reference count but there's no way for a consumer to exclude
other consumers and nothing which protects against breakage.

> > We should probably have something along the lines of a 
> > regulator_get_exclusive() for them.  Previously the consumer counting
> > would have stopped them interfering with enables done by other
> > consumers.

> I'd like to see get()/put() match the design pattern used
> elsewhere in the kernel:  those calls signify refcount
> operations.

Aquiring a reference is obviously what we want in the rather common case
where the supply is shared.  We could name an operation that enforces
non shared supplies something else but at the end of the day it's going
to be the same operation.  The major purpose of adding an explicit call
for this is to document the requirement the consumer has for direct
control of what it's doing.

> Agreed that the "consumer" access model probably needs a few
> interface updates.  I'm not sure what they would be though;
> one notion would be to focus on the constraints they apply
> (including "enabled") instead of what they do now.

I'm not at all sure what you mean by this - constraint narrowing by the
consumers is pretty much exactly the model the existing code has.  We
need to do things like re-add the voltage handling that was removed pre
merge but that's already the programming model we have.
