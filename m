Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbZLGSEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbZLGSEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964862AbZLGSEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:04:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38227 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858AbZLGSEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A9uB3z5zKDVHP7L7LtEqib8dIlRmzxIx12nwtzKzR/gioGMkZHoJ0g6u2cKlwU0p7H
         cQzm9yDGOcCpzflq+PqvvINIcREXlinmdTijBxs2boACABgsbVM8nsspPxuaM62A58ee
         h2Hgcw/y2nhKThKMs9MEyfbZLWqTUSMt6vGlg=
Date: Mon, 7 Dec 2009 21:04:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix bogus warning in
	apic_noop.apic_write()
Message-ID: <20091207180436.GC5489@lenovo>
References: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain> <tip-a946d8f11f0da9cfc714248036fcfd3a794d1e27@git.kernel.org> <20091207150425.GA5489@lenovo> <alpine.LFD.2.00.0912071629350.3089@localhost.localdomain> <20091207163057.GB5489@lenovo> <alpine.LFD.2.00.0912071755130.3089@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912071755130.3089@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 05:55:37PM +0100, Thomas Gleixner wrote:
...
> > And, btw if some code is trying to write to apic when
> > it's disabled via boot option -- it means the code is
> > buggy and this is not a false positive but rather proper
> > warning.
> > 
> > Thomas, if you've changed this code I suppose you saw some
> > warning triggered, right? Could you pointed me on it?
> 
> http://www.kerneloops.org/searchweek.php?search=native_apic_write_dummy
> 

Doh!

The most cases show inapropriate usage of apic->write() operation.
set_perf_event_pending() already fixed by
7d42896628202a551ad1107697cd215dc5fca099,
intel_init_thermal() fixed as well with
5ce4243dcefbbc43791ffc36e1be55067ceec916

(all was in -tip).

Though throttling code is just buggy and intel_init_thermal() should
check if cpu_has_apic. So the former code does exactly what
it should -- it catches inapropriate writes.

Thomas, I just don't know -- from my pov, write() is really different
from read(), since it implies that APIC changes it behaviour, it could
be timer setup, vector setup operation or whatever. I even doubt if
enabling IPI in apic-noop is a good idea (since perf code already
implemented to check apic presence by Peter and IPI is not called).

Though I'm not insisting, I simply don't have spare time at moment
to check all apic_writes() again :(

	-- Cyrill
