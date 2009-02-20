Return-Path: <linux-kernel-owner+w=401wt.eu-S1759080AbZBTBeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbZBTBeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbZBTBeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:34:00 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:56942 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZBTBd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:33:59 -0500
MIME-Version: 1.0
In-Reply-To: <200902201128.55959.rusty@rustcorp.com.au>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <ac3eb2510902191248w26f1d1c0o95d68aaa3be097a1@mail.gmail.com>
	 <ac3eb2510902191359o3e32c424h830e78cd0ace446a@mail.gmail.com>
	 <200902201128.55959.rusty@rustcorp.com.au>
Date: Fri, 20 Feb 2009 02:33:57 +0100
Message-ID: <ac3eb2510902191733s700cbdd5k55f8593e2151d306@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 01:58, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Friday 20 February 2009 08:29:48 Kay Sievers wrote:
>> Further testing revealed, if I only comment out the stop_machine()
>> preparation, which is used in an error case, I get almost the same
>> improvement, even with the original mutex in place. Without the mutex
>> it's still a bit better, maybe it would be much better if we have more
>> CPUs, but all the long delays are gone only with removing the
>> stop_machine() preparation.
>
> Hmm, interesting.  The reason that reducing the lock coverage had this effect
> is because stop_machine_create() just bumps a refcount if someone is already
> between ...create() and ...destroy().
>
> So, now we've found the problem, let's fix it, then re-visit mutex reduction.
>
> module: don't use stop_machine on module load
>
> Kay Sievers <kay.sievers@vrfy.org> discovered that boot times are slowed
> by about half a second because all the stop_machine_create() calls,
> and he only probes about 40 modules (I have 125 loaded on this laptop).
>
> We only do stop_machine_create() so we can unlink the module if
> something goes wrong, but it's overkill (and buggy anyway: if
> stop_machine_create() fails we still call stop_machine_destroy()).

Sounds good. With that, no module takes more than 40 millisecs to link
now, most of them are between 3 and 8 millisecs.

Coldplug loads 39 modules, I end up having 50 loaded, but they are
after the udev coldplug settle time. The  39 modules get linked into
the kernel in 281 millisecs, which sounds pretty good.

That looks very different to the numbers without this patch and the
otherwise same setup, where we get heavy noise in the traces and many
delays of up to 200 millisecs until linking, most of them taking 30+
millisecs.

Thanks,
Kay
