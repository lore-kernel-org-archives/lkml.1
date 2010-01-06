Return-Path: <linux-kernel-owner+w=401wt.eu-S932697Ab0AFUIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab0AFUIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457Ab0AFUIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:08:39 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:37742 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0AFUIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VTw5jMhMyGvtqN66OwBjx2Mo6kbGb/AIY5ye7WI2TMH23Muw0YxDb+bjQXYPhSZ5Du
         JjMJ1eznEob55HIZN7QsV6GeCbI7OVx7FRe9lXJZ1eDn12Wvyh6eSMWxU3CfH3A//ayr
         cYVWhVFEH7so9RMJI+45rQ3jl1beMTMVS4OhA=
MIME-Version: 1.0
In-Reply-To: <4B44E7E3.10305@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-6-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-7-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-8-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-9-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-10-git-send-email-jason.wessel@windriver.com> 
	<8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com> 
	<0F1B54C89D5F954D8535DB252AF412FA0553E3A0@chinexm1.ad.analog.com> 
	<4e5ebad50912301845p35b1ea98l2f91c2a209ee863a@mail.gmail.com> 
	<4B44E7E3.10305@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 6 Jan 2010 15:08:18 -0500
Message-ID: <8bd0f97a1001061208x8876e79y507d98e505071067@mail.gmail.com>
Subject: Re: [Kgdb-bugreport] [PATCH 09/37] kgdb,blackfin: Add in 
	kgdb_arch_set_pc for blackfin
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>, "Zhang, Sonic" <Sonic.Zhang@analog.com>,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 14:43, Jason Wessel wrote:
> I pulled in this patch, and made the changes the Mike talked about with
> respect to cleaning up the arch specific kgdb.c for blackfin.  See the
> attached patch.
>
> Your patch and the one here will go into kgdb-next and onto linux-next.

the Blackfin versions tail into the common probe_kernel_{read,write}
funcs, so your patch causes an infinite recursion in the common case.
as i hinted earlier, i'd like to see mm/access.c to have something
like:
-long probe_kernel_read(void *dst, void *src, size_t size)
+long __probe_kernel_read(void *dst, void *src, size_t size)
...
+long __weak probe_kernel_read(void *dst, void *src, size_t size)
    __attribute__((alias("__probe_kernel_read")));
that way the arch-specific probe_kernel_read can still fall back to
the common __probe_kernel_read function.  same goes for the write
function.

also, i see you added "notrace" to the Blackfin probe_kernel_write ...
was that intentional ?  if so, this should probably go into
include/linux/uaccess.h instead

otherwise, this looks pretty good.  thanks for doing the footwork ! :)
-mike
