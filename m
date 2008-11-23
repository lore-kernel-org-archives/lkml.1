Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbYKWUXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbYKWUXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYKWUXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:23:44 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:2733 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYKWUXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:23:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UYOKv0b/wh6UJqqEwl+yLuIYWNraQiAR4D1sicr6l57umMN5gzwvReRQwBQNc2szdE
         2BFeXpYS4WIJRC4bABGxr4MRq0h6vsamjDiswI+wk01R8aFY0cu//77RuKvvsCHZDDv+
         yuWU5oIu5LPm7RNtV6VLA20t4k4UR8Bungxzw=
Message-ID: <b637ec0b0811231223r2032f221geeb19ea5804d3b91@mail.gmail.com>
Date: Sun, 23 Nov 2008 21:23:42 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b637ec0b0811231024t73d1b8b3x9e23e24dda94c6b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <200811231914.09982.rjw@sisk.pl>
	 <b637ec0b0811231024t73d1b8b3x9e23e24dda94c6b8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, Nov 23, 2008 at 7:24 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi
>
> Yes. I started another bisection session between 2.6.27.4 and 2.6.27.5.
>

Ok, this time things went much better. The bisection pointed to:

------------------------------------------------------------------------------------------------------------------------------------------------
fcomolli@hawking:~/software/GIT-TREES/linux-2.6.27.y> git bisect good
ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b is first bad commit
commit ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b
Author: Jay Fenlason <fenlason@redhat.com>
Date:   Mon Oct 27 23:28:14 2008 +0100

    firewire: fix struct fw_node memory leak

    commit 77e557191701afa55ae7320d42ad6458a2ad292e upstream

    With the bus_resets patch applied, it is easy to see this memory leak
    by repeatedly resetting the firewire bus while running slabtop in
    another window.  Just watch kmalloc-32 grow and grow...

    Signed-off-by: Jay Fenlason <fenlason@redhat.com>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

:040000 040000 01cadbd5f5fb81ce4f5e2023573204c4fbec3a28
809a53f4be87bd8be133ebd7564e1139a0cfa45b M      drivers
------------------------------------------------------------------------------------------------------------------------------------------------

And this is the log:

------------------------------------------------------------------------------------------------------------------------------------------------
fcomolli@hawking:~/software/GIT-TREES/linux-2.6.27.y> git bisect log
git-bisect start
# good: [056c71459d3acf9fefcb2dc67abeef10e649d508] Linux 2.6.27.4
git-bisect good 056c71459d3acf9fefcb2dc67abeef10e649d508
# bad: [788a5f3f70e2a9c46020bdd3a195f2a866441c5d] Linux 2.6.27.5
git-bisect bad 788a5f3f70e2a9c46020bdd3a195f2a866441c5d
# bad: [7bdb542c453c14e54af9ebe5c4a827e4a678c47d] powerpc/numa: Make
memory reserve code more robust
git-bisect bad 7bdb542c453c14e54af9ebe5c4a827e4a678c47d
# good: [f29062d0ec12ee3a58c67228dc829574b4ced378] syncookies: fix
inclusion of tcp options in syn-ack
git-bisect good f29062d0ec12ee3a58c67228dc829574b4ced378
# good: [882491755d4c819de5bb593f04d06692185760aa] firewire: fix
ioctl() return code
git-bisect good 882491755d4c819de5bb593f04d06692185760aa
# bad: [baae4f5fd7a75bdfa70d374b738963053df2bcaa] firewire: fw-sbp2: fix races
git-bisect bad baae4f5fd7a75bdfa70d374b738963053df2bcaa
# bad: [ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b] firewire: fix struct
fw_node memory leak
git-bisect bad ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b
# good: [b6021579f54e5b6b31f03fe24de1208a2feb4aec] firewire: Survive
more than 256 bus resets
git-bisect good b6021579f54e5b6b31f03fe24de1208a2feb4aec
------------------------------------------------------------------------------------------------------------------------------------------------

The commit reverted cleanly and now I'm running 2.6.27.7 with that
commit reverted. I'll post my results.

Hoper this helps. Regards,
Fabio

>> Rafael
>
> Regards,
> Fabio
>
