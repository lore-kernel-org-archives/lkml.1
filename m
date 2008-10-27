Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbYJ0FsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbYJ0FsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYJ0FsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:48:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081AbYJ0FsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:48:10 -0400
Date: Sun, 26 Oct 2008 22:46:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>, jakub@redhat.com, arjan@infradead.org,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: [PATCH v5] ELF: implement AT_RANDOM for glibc PRNG seeding
Message-Id: <20081026224659.af213906.akpm@linux-foundation.org>
In-Reply-To: <48FE39FA.9030601@redhat.com>
References: <20081001222706.68E7E1544B4@magilla.localdomain>
	<20081003001616.GN10632@outflux.net>
	<20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
	<20081003052938.GS10632@outflux.net>
	<20081002225718.6a0d803a@infradead.org>
	<48E5BAC6.9070007@redhat.com>
	<20081003145054.GU10632@outflux.net>
	<20081003145754.GH32682@tyan-ft48-01.lab.bos.redhat.com>
	<20081003173313.GW10632@outflux.net>
	<48E65964.5020809@redhat.com>
	<20081003175917.GX10632@outflux.net>
	<20081021130111.b8d73625.akpm@linux-foundation.org>
	<48FE39FA.9030601@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 13:22:18 -0700 Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Andrew Morton wrote:
> > I read the above changeloglet and read the above-linked page and it's
> > still 87% unclear to me what this feature does.  Something to do with
> > stack randomisation, apparently.  I suppose I could go do further
> > hunting, but from the quality-of-changelog POV I don't think I should
> > need to do so.
> 
> Not stack randomization.  glibc needs right after startup a bit of
> random data for internal protections (stack canary etc).  What is now in
> upstream glibc is that we always unconditionally open /dev/urandom, read
> some data, and use it.  For every process startup.  That's slow.
> 
> In addition Andi mentioned that this use of /dev/urandom might be
> problematic.  I let him explain this.
> 
> The solution is to provide a limited amount of random data to the
> starting process in the aux vector.  I suggested 16 bytes and this is
> what the patch implements.  If we need only 16 bytes or less we use the
> data directly.  If we need more we'll use the 16 bytes to see a PRNG.
> This avoids the costly /dev/urandom use and it allows the kernel to use
> the most adequate source of random data for this purpose.  It might not
> be the same pool as that for /dev/urandom.
> 

Thanks.

> > It's unclear to me that the random-number issue got sorted out?
> 
> I think the last patch used the normal function to get 16 random bytes,
> equivalent to the data used for stack randomization etc.
> 
> If Andi has concrete proposals for a revamp of the use of entropy in the
> kernel this can be easily done as an add-on.  This patch doesn't make
> the situation worse, it doesn't deplete entropy more than it happens now.
> 

True.

As long as glibc doesn't do the /dev/urandom read when the kenrel has
already done that.  I assume that it will do so, until AT_RANDOM-aware
glibc has propagated out?

