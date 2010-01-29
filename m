Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108Ab0A2PWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0A2PWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 10:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701Ab0A2PWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 10:22:35 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48256 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0A2PWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 10:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LdATFOn9Oh7iAPVgIzg/Xumg/Ec0CkOyVTtxTwhfZZazoA0ku9d0dmWjrThty5WyMG
         gNVx0oPOb8spChjRbT3L+2vPeYx50XQLbhQzj2Rix9PcLIgEWCIs5coju1fn2rmZjkK3
         hKbghSUB3hlaCgA98obr0hwMYGRsPlRm6pb7I=
Subject: Re: [2.6.33-rc5] kernel BUG at include/net/netns/generic.h:41!
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <b6fcc0a1001290217l4edb0a0btbafa0c26b6f14ad5@mail.gmail.com>
References: <20100129094822.GA8294@nb-core2.darkstar.lan>
	 <b6fcc0a1001290217l4edb0a0btbafa0c26b6f14ad5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 16:22:29 +0100
Message-ID: <1264778549.3184.28.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 janvier 2010 à 12:17 +0200, Alexey Dobriyan a écrit :
> On Fri, Jan 29, 2010 at 11:48 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> > with recent kernels I'm seeing this BUG - triggered by racoon - at boot:
> >
> > NET: Registered protocol family 15
> > ------------[ cut here ]------------
> > kernel BUG at /home/kronos/src/linux-2.6.git/include/net/netns/generic.h:43!
> > invalid opcode: 0000 [#1] PREEMPT SMP
> > last sysfs file: /sys/kernel/uevent_seqnum
> > CPU 1
> > Pid: 1941, comm: racoon Not tainted 2.6.33-rc5-00271-gbe8cde8-dirty #238 F3Sa      /F3Sa
> > RIP: 0010:[<ffffffffa03035be>]  [<ffffffffa03035be>] pfkey_create+0x36/0x18b [af_key]
> 
> Does it triggers after succesfull boot if you do
> 
>     rmmod af_key; modprobe af_key
> 
> a couple of times?
> 
> Post .config, just in case.

I am looking at ipsec_pfkey_init()

We call sock_register(&pfkey_family_ops) before pfkey_net_id being
initialized (by the call to register_pernet_subsys(&pfkey_net_ops);

As soon as sock_register(&pfkey_family_ops) is done, another thread can
open a socket and call pfkey_create()  -> crash

We should change order of initializations somehow



