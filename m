Return-Path: <linux-kernel-owner+w=401wt.eu-S1032284AbXEHVQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032284AbXEHVQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032279AbXEHVQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:16:53 -0400
Received: from 1wt.eu ([62.212.114.60]:2535 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032270AbXEHVQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:16:51 -0400
Date: Tue, 8 May 2007 23:16:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: Zbigniew Baniewski <zb@ispid.com.pl>
Cc: linux-kernel@vger.kernel.org, hancockr@shaw.ca
Subject: Re: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
Message-ID: <20070508211646.GA3129@1wt.eu>
References: <20070505194922.GA13176@localhost.localdomain> <20070506043645.GF943@1wt.eu> <20070508202334.GA16185@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508202334.GA16185@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zbigniew,

[first, please always keep people in CC when posting on LKML]

On Tue, May 08, 2007 at 10:23:34PM +0200, Zbigniew Baniewski wrote:
> On Sun, May 06, 2007 at 06:36:45AM +0200, Willy Tarreau wrote:
> 
> > Could you please be a bit more precise :
> >   - config
> 
> Below.

Thanks, I could reproduce.

> >   - what are the unresolved symbols ?
> 
> I don't know. When trying to install "generated" kernel-and-so-on.deb file,
> there is an error message:
> 
> depmod: *** Unresolved symbols in /lib/modules/2.4.34/kernel/drivers/ide/ide-core.o

Here is the complete error :

depmod: *** Unresolved symbols in /lib/modules/2.4.34/kernel/drivers/ide/ide-core.o
depmod:         init_cmd640_vlb

> See also other similar reports, f.e.:
> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-05/msg07966.html
> http://www.unixadmintalk.com/f59/kernel-compile-problem-afs-122462/
> http://www.captain.at/programming/rtai/kernel-2.4.php

OK I've checked them now. The right solution is the one suggested in the last
link above, which is also what Robert Hancock said too : not use CONFIG_IDE=m.

The reason is very simple : the IDE code may call several other drivers, some
of which are modules, some of which are hard-linked into the kernel. It has
no reliable way of knowing which ones will be available. In fact, the build
system inside drivers/ide is not perfect as it's not an easy part.

The other solution in your particular situation is to replace in your .config:
CONFIG_BLK_DEV_CMD640=y

with :
CONFIG_BLK_DEV_CMD640=m

because only cmd640 causes trouble. I've tested right here and it fixes the
problem as expected. After all, nearly all your other IDE drivers are modules.

> >   - link to the patch you are talking about ?
> 
> It's the patch made by Arkadiusz Miskiewicz:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0311.2/1136.html

OK thanks. It was merged, but it _seems_ to require that you link ide-core
with the kernel and only use ide-probe-mini to probe/unprobe devices. Never
tried this way though.

Regards,
Willy

