Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbYKXSPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbYKXSPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYKXSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:15:39 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48301 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbYKXSPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:15:38 -0500
Date: Mon, 24 Nov 2008 19:13:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081124181339.GK26308@kernel.dk>
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <x491vxgkd61.fsf@segfault.boston.devel.redhat.com> <20081112190227.GS26778@kernel.dk> <x49skphdtqm.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49skphdtqm.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24 2008, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > nfsd aside (which does seem to have some different behaviour skewing the
> > results), the original patch came about because dump(8) has a really
> > stupid design that offloads IO to a number of processes. This basically
> > makes fairly sequential IO more random with CFQ, since each process gets
> > its own io context. My feeling is that we should fix dump instead of
> > introducing a fair bit of complexity (and slowdown) in CFQ. I'm not
> > aware of any other good programs out there that would do something
> > similar, so I don't think there's a lot of merrit to spending cycles on
> > detecting cooperating processes.
> >
> > Jeff will take a look at fixing dump instead, and I may have promised
> > him that santa will bring him something nice this year if he does (since
> > I'm sure it'll be painful on the eyes).
> 
> Sorry to drum up this topic once again, but we've recently run into
> another instance where the close cooperator patch helps significantly.
> The case is KVM using the virtio disk driver.  The host-side uses
> posix_aio calls to issue I/O on behalf of the guest.  It's worth noting
> that pthread_create does not pass CLONE_IO (at least that was my reading
> of the code).  It is questionable whether it really should as that will
> change the I/O scheduling dynamics.
> 
> So, Jens, what do you think?  Should we collect some performance numbers
> to make sure that the close cooperator patch doesn't hurt the common
> case?

No, posix aio is a piece of crap on Linux/glibc so we want to be fixing
that instead. A quick fix is again to use CLONE_IO, though posix aio
needs more work than that. I told the qemu guys not to use posix aio a
long time ago since it does stink and doesn't perform well under any
circumstance... So I don't consider that a valid use case, there's a
reason that basically nobody is using posix aio.

-- 
Jens Axboe

