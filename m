Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbXIBWSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbXIBWSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbXIBWSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:18:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:38176 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbXIBWSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VwjJRy+8qMftloWwPCxWiejpe+9rFSlT7kBw1V1VA/tb2iPu0jp+OHJo7J6DyPVUgjvN9EktzIU3hVR0GIKF7cbn73eqVN73k/gXQX9VTbAu4wUZUgRHBzlOGBYfw2mT7BVSpUyWauy6DwFUiEZe4KdlR/YM4WLelb4ZjVIaiC0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Richard Mittendorfer <delist@gmx.net>
Subject: Re: Hang in 2.6.23-rc5
Date: Mon, 3 Sep 2007 00:14:53 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com> <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com> <20070903000515.45dacb3f.delist@gmx.net>
In-Reply-To: <20070903000515.45dacb3f.delist@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709030014.53225.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 00:05:15 Richard Mittendorfer wrote:
> Also sprach "Alessandro Suardi" <alessandro.suardi@gmail.com> (Sun, 2 Sep 2007 22:38:28 +0200):
> > On 9/2/07, charles gagalac <charles.gagalac@gmail.com> wrote:
> > > On 9/2/07, daryll q wrote:
> > > > Upgraded my kernel from 2.6.23-rc2 to 2.6.23-rc5.
> > > >
> > > >  System hangs (caps lock and scroll lock leds are both flashing).
> [...]
> > > i experienced hangs, with the flashing caps and scroll locks as you've
> > > described, in a few of my later pulls prior to rc5.  i couldn't
> > > reproduce the hangs and my logs didn't show evidence of a problem.  my
> > > system under rc5, so far, hasn't hung on me.
> [...]
> > Oh, I thought I was the only one. I also had a single hang+flashing
> >  Caps & Scroll Lock with -rc5, but haven't had one since.
> [...]
> 
> Hmm, just occured here, no chance to capture anything. Happend under
> some system and network load (distcc/nfs) (latest atheros/madwifi
> tainted however, but never had troubles). Not had much uptime with pre-5
> -rc's.
> 
> Anything I can help to debug this?
> 

First of all, try this patch : 

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -560,7 +560,7 @@ static u32 tcp_rto_min(struct sock *sk)
        struct dst_entry *dst = __sk_dst_get(sk);
        u32 rto_min = TCP_RTO_MIN;
 
-       if (dst_metric_locked(dst, RTAX_RTO_MIN))
+       if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
                rto_min = dst->metrics[RTAX_RTO_MIN-1];
        return rto_min;
 }

If that doesn't help, then setup netconsole or serial console and 
try to capture some output from the hang.
(details on how to setup net & serial consoles can be found in 
 Documentation/networking/netconsole.txt
  and
 Documentation/serial-console.txt
)
Make sure you've set your console loglevel high enough to log 
everything.

Also try enabling sysrq in your kernel and, if possible, capture a 
sysrq+t dump when the crash happens and send in the dmesg output 
after sysrq+t - details in Documentation/sysrq.txt - there's also 
info on console log level in there.

You can also try building a kernel with most (or all) of the debug 
options found in the 'Kernel hacking' menu enabled. That can often 
help by producing extra valuable debug output (you need to be able 
to capture it though, so getting net/serial console setup as well 
is usually a good idea if the box hangs completely and you can't 
just get info by running dmesg).


Kind regards,
  Jesper Juhl


