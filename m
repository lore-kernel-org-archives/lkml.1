Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZCJKRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZCJKRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZCJKRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:17:08 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:20730 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbZCJKRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:17:06 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2009 06:17:06 EDT
X-IronPort-AV: E=Sophos;i="4.38,335,1233550800"; 
   d="scan'208";a="67625379"
Subject: Re: [PATCH 02/18] Blackfin Serial Driver: use barrier instead of
 cpu_relax for Blackfin SMP like patch
From: gyang <graf.yang@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090306143756.738db0ee.akpm@linux-foundation.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	 <1236321780-28718-3-git-send-email-cooloney@kernel.org>
	 <20090306143756.738db0ee.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 18:07:11 +0800
Message-Id: <1236679631.5183.72.camel@dy>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2009 10:07:23.0523 (UTC) FILETIME=[01C68D30:01C9A168]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 14:37 -0800, Andrew Morton wrote:
> On Fri,  6 Mar 2009 14:42:44 +0800
> Bryan Wu <cooloney@kernel.org> wrote:
> 
> > From: Graf Yang <graf.yang@analog.com>
> > 
> > We are making a SMP like patch to blackfin, cpu_relax() is replaced by a
> > data cache flush function which will count it to a per-cpu counter.
> > If this serial function is called too early, the per-cpu data area have
> > not been initialized, this call will cause crash.
> 
> That's a bug in blackfin architecture support.  The kernel should be
> able to call cpu_relax() at any time, surely.  It's a very low-level
> and simple thing.
> 
> > So we'd like to use barrier() instead of cpu_relax().
> > 
> 
> barrier() is purely a compiler concept.  We might as well just remove
> the cpu_relax() altogether.

Do you mean remove cpu_relax(), and either not add barrier() here?

> 
> 
> >  drivers/serial/bfin_5xx.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> > index 52ccc27..350bfc4 100644
> > --- a/drivers/serial/bfin_5xx.c
> > +++ b/drivers/serial/bfin_5xx.c
> > @@ -1129,7 +1129,8 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
> >  	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
> >  
> >  	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
> > -		cpu_relax();
> > +		barrier();
> > +
> >  	UART_PUT_CHAR(uart, ch);
> >  }
> 
> I grumpily queued this, but it seems all wrong.
