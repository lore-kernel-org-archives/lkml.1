Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbXFTVZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbXFTVZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXFTVZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:25:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:65076 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbXFTVZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dwzOTkYN2xr+ZqZlqlOP2bGI7aYAiisSsHQp3ufgs6wa1sRY8g92BxyhLGoH9tJ6+5k3DFZTej7Nwhv5fWMZtID58Z/4bFaz1+VFYidqkj2nG9BtIOLzeDdQSZadXbfcF7o8TCFBpn5o1p6XtB+kEX3AgVnGcQCAHElTQt/t/D4=
Message-ID: <a781481a0706201425j2c0e1fa9i147cc6ae17b74fd@mail.gmail.com>
Date: Thu, 21 Jun 2007 02:55:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH 11/12] pcmcia/net_pcmcia: all net_pcmcia modules depend on PCMCIA
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
In-Reply-To: <20070620134435.21410ceb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070619225203.GM5193@alberich.amd.com>
	 <20070620134435.21410ceb.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 6/21/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 20 Jun 2007 00:52:03 +0200 Andreas Herrmann wrote:
>
> > Fix several build errors with PCMCIA=m && NET_PCMCIA=y:
> >
> >    LD      .tmp_vmlinux1
> >    drivers/built-in.o: In function `nmclan_release':
> >    nmclan_cs.c:(.text+0x14026c): undefined reference to `pcmcia_disable_device'
> >    ...
> >    drivers/built-in.o: In function `exit_xirc2ps_cs':
> >    xirc2ps_cs.c:(.exit.text+0x1055): undefined reference to `pcmcia_unregister_driver'
> >    make: *** [.tmp_vmlinux1] Error 1
>
> This is interesting.  This is a result of the menuconfig changes,
> which made NET_PCMCIA a boolean, and then some tristates depend
> on NET_PCMCIA and the boolean -> tristate dependencies aren't
> specific enough.
>
> Your fix is one way to do it.  I'd prefer to make
> NET_PCMCIA a tristate instead, then let its value trickle down
> to the subordinate config symbols.

This is interesting indeed. But would it make much sense to
mark a menuconfig item as tristate? I suspect the problem here
was simply that these PCMCIA drivers did not explicitly depend
on CONFIG_PCMCIA (which they should be, considering they
pull in code from that particular subsystem), which Andreas'
patch resolves ...

[ Also, when we make NET_PCMCIA tristate here, I suspect it
would still be possible to select these drivers as built-in (even
though PCMCIA can be modular) which would still give the
above errors? I didn't test, so please correct me if I'm wrong. ]

> This probably means that some of the other menuconfig changes
> need to be audited for this "feature."

Right. [ I didn't check git history, but it is also possible that
these drivers not depend on PCMCIA like they should have
before Jan did the menuconfig conversions too. ] But IMHO,
the general lesson from this case is that if some driver depends
on some other symbol, then we still need to honour that
dependency explicitly instead of simply putting the driver inside
a "#if <menuconfig_symbol>" and only making the
<menuconfig_item> itself depend on the said dependency;
otherwise the boolean / tristate problems you mentioned will bite,
so an audit would clearly be in order.

Satyam
