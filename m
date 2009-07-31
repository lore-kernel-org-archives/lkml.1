Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZGaR3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZGaR3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZGaR3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:29:01 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44573 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZGaR3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:29:00 -0400
Subject: Re: [PATCH] clocksource: save mult_orig in clocksource_disable()
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, tglx@linutronix.de, akpm@linux-foundation.org
In-Reply-To: <20090731121811.GA3989@elte.hu>
References: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
	 <1245352632.7508.1.camel@localhost.localdomain>
	 <aec7e5c30906252230s62196e1fr5671aa591f1869a3@mail.gmail.com>
	 <20090731121811.GA3989@elte.hu>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 10:28:58 -0700
Message-Id: <1249061338.3392.6.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-31 at 14:18 +0200, Ingo Molnar wrote:
> * Magnus Damm <magnus.damm@gmail.com> wrote:
> 
> > On Fri, Jun 19, 2009 at 4:17 AM, john stultz<johnstul@us.ibm.com> wrote:
> > > On Fri, 2009-06-19 at 00:24 +0900, Magnus Damm wrote:
> > >> From: Magnus Damm <damm@igel.co.jp>
> > >>
> > >> Save clocksource mult_orig in clocksource_disable().
> > >>
> > >> To fix the common case where ->enable() does not setup
> > >> mult, make sure mult_orig is saved in mult on disable.
> > >>
> > >> Also add comments to explain why we do this.
> > >>
> > >> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > >
> > > Acked-by: John Stultz <johnstul@us.ibm.com>
> > >
> > > Thomas, Andrew, please push this for 2.6.31.
> > 
> > This one is slowly making it's way in I suppose?
> 
> Btw., what specific issue does this fix? The commit description is 
> generic, there's no bugzilla link and no other information either 
> that could give me an idea about precisely what incarnation of the 
> bug you have hit.

Magnus' earlier change to mult_orig makes it so mult_orig is written on
enable, instead of when we register the clocksource. This causes
problems as enable() might be called multiple times while a system is
running, where as the register would only happen once.

If a user switches away from a clocksource and back to a clocksource,
the mult_orig will no longer be the original mult, as we will over write
it with an NTP adjusted mult.

Its a minor detail, but it causes problems when I do NTP testing across
different clocksources, as the ppm drift factor does not stay constant
per clocksource.

This fix makes sure we store mult_orig over mult on disable() so we
restore the correct value on the next enable().

thanks
-john


