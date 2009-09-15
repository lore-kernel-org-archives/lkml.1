Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZIOQe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZIOQe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZIOQeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:34:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:48805 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZIOQeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I/aSbE0YhGwPbplhzJ9zzy/pP6KC3jr4HgNoxFa/f/39xZLSxTrsaGBmLa9m6lyqLz
         WL55i9UyoOGG4dqd3DCfGJkESOqspQCRWECRS1DuesJhLNnYDl9WHt3Z6uHzjLsjaYwJ
         ymcaDI4yh5yd3+KtURdBH1qlAC4+Si72lPOZ0=
MIME-Version: 1.0
In-Reply-To: <4AAE84EA.8010109@cmu.edu>
References: <20090904045231.GW4973@obsidianresearch.com>
	 <adaab1bnvz3.fsf@cisco.com>
	 <20090904140325.c592289a.akpm@linux-foundation.org>
	 <20090904212316.GZ406@obsidianresearch.com>
	 <17754_1252731784_n8C533ou010944_20090911162837.GC17677@kroah.com>
	 <4AAE84EA.8010109@cmu.edu>
Date: Tue, 15 Sep 2009 09:34:28 -0700
Message-ID: <da7b3ce30909150934q4d84252exd8fa264ffd8e6420@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Fixup pubek sysfs file
From: Hal Finney <hal.finney@gmail.com>
To: "Jonathan M. McCune" <jonmccune@cmu.edu>
Cc: Greg KH <greg@kroah.com>, m.selhorst@sirrix.com,
       linux-kernel@vger.kernel.org, jbeulich@novell.com, jmorris@namei.org,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       tpmdd-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One file-based aspect of the TPM driver interface is the securityfs
file system, typically mounted at /sys/kernel/security/tpm0. This
includes the IMA and/or BIOS event measurements. Trousers does read
these files optionally, however it has to be configured in tcsd.conf.
But the file formats are shared between the kernel driver and the
Trousers parsing code. This functionality is necessary for Trousers to
report pre-boot and post-boot measurement events to user code, which
in turn is necessary for meaningful Quote operations in some contexts.

Hal Finney

On Mon, Sep 14, 2009 at 11:01 AM, Jonathan M. McCune <jonmccune@cmu.edu> wrote:
> Hello everybody,
>
> I have decided to chime in as a frequent (and I'm going to claim
> "experienced") user of the linux kernel TPM driver.
>
> To the best of my knowledge there is very little code in the wild that
> depends on the current structure of these sysfs entries.  Probably the
> most used set of libraries and programs -- "TrouSerS" and "TPM Tools"
> (trousers.sourceforge.net) -- interact directly with the TPM via
> /dev/tpm*.  I'm fairly confident that "tboot" (tboot.sourceforge.net)
> and "jTPM Tools" (trustedjava.sourceforge.net) don't use the sysfs
> entries either.
>
> Thus, fixing the one-item-per-file issues seems reasonable to me. For
> example, changing /sys/devices/platform/tpm_tis/pcrs from a single
> multi-entry file to a directory containing files named 0-15 or 0-23 that
> each then contain only the relevant 20-byte value seems quite
> reasonable. (Today's TPMs contain either 16 or 24 PCRs but future ones
> could contain many more.)
>
> I believe the pubek entry has gone broken for so long because once a TPM
> has been "owned" (and "taking ownership" is almost certainly the first
> thing one does when using the TPM for something), accessing the pubek
> needs to be authorized and so the sysfs entry shouldn't return anything
> anyways ("Authorization required."?). But it should definitely be fixed
> or removed.
>
> Likewise "caps" could be made into a directory containing files for the
> relevant data (Manufacturer, TCG version, Firmware version, ...).
>
> What I _disagree_ with is that these values should be moved debugfs.
> They are characteristics of a particular hardware device's current state
> and I believe fit the definition of what belongs in sysfs reasonably
> well.  Their current implementation simply needs help.
>
> The changes I've mentioned are larger and don't seem appropriate for
> 2.6.31, but perhaps a plan to have them implemented for an upcoming
> version is reasonable?  Is anybody willing to help put together such a
> patch?  Discuss whether it's reasonable / acceptable to do so?
>
> Thanks,
> -Jon
