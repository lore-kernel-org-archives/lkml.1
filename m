Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXHIR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXHIR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXHIRz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:55:59 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:60164 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbXHIRz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:55:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=umduQlXvF4BWAHSBDIikEwyjpEtotPz+pWa9s8a7iEL4EjM5JmPYajwcBOxCchhpZ1i2YVDDlKvAEQRJ11IqurkoOK/tVO39nAf08mJ4AP1U/enCVpPBCes+TIrReGdnKh4bEwfirz3xRVdBXbPMzGpmsINxTSjGEgIQcz18Fr0=
Message-ID: <a52a95e30708091055t584cb46ga5147d2c12e4bf9c@mail.gmail.com>
Date: Thu, 9 Aug 2007 10:55:56 -0700
From: "Tom Mortensen" <tmmlkml@gmail.com>
To: "Jeff Mahoney" <jeffm@suse.com>
Subject: Re: reiserfs fs/reiserfs/bitmap.c:1287
Cc: tony@tvortex.net, linux-kernel@vger.kernel.org,
       "ReiserFS Mailing List" <reiserfs-devel@vger.kernel.org>
In-Reply-To: <46BA57AC.2040306@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15366.199.125.14.2.1184261266.squirrel@localmail-dr.mcsimons.com>
	 <46967D7D.5090204@suse.com>
	 <a52a95e30708081529i7cee02ddq61471378c2a12ffa@mail.gmail.com>
	 <46BA57AC.2040306@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hard drive is only 80GB and the ReiserFS file system is on
paritition 1 which spans the entire hard drive.

I recently upgraded to kernel 2.6.22.1.  Previously was running 2.4.31
and never encountered this error before.

I'm presently trying to make it fail again to see if I can gather more
information.  I can also revert to a previous kernel release (either
2.4.x or 2.6.x), any suggestion?


On 8/8/07, Jeff Mahoney <jeffm@suse.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Tom Mortensen wrote:
> > I'm wondering if any resolution to this particular bug?  I see this
> > exact kernel bug in copying large data sets (40GB+), and can reproduce
> > fairly well.  Running reiserfsck produces this message:
> >
> > "Zero bit found in on-disk bitmap after the last valid bit."
>
> BTW, this error describes the following condition:
>
> With a 4KiB blocksize (assumed), each bitmap describes 128MiB chunks. If
> your file system is of such a size that it's not an even multiple of
> 128MiB, the final bitmap will describe blocks that aren't part of the
> file system. The easiest way to represent them is to mark them used so
> that they won't end up getting allocated, ever.
>
> The message quoted above means that some of the bits that describe the
> blocks beyond the end of the file system have been zeroed, indicating
> that the space is available. If you were actually hit by this condition
> at runtime, you'd get "attempt to access beyond end of device" or
> something like that in your log.
>
> In any event, something is corrupting your bitmaps and that needs to get
> tracked down. The size of the file system is important. I've been seeing
> reports of users hitting similar problems with file systems larger than
> 8 TiB. The cause is that the s_bmap_nr field in the superblock is 16
> bit, and the file system assumes it's correct. mkreiserfs < 3.6.20 will
> happily create those file systems with a value that has wrapped, while
> mkreiserfs >= 3.6.20 will zero the value out, causing a mount failure
> unless the kernel has been patched to support the full size and to
> interpret s_bmap_nr == 0 as "value has overflowed."
>
> I've posted some lightly tested versions of patches to handle > 8TiB
> file systems on the reiserfs-devel mailing list and hope to finalize
> them this week. If your file system isn't larger than 8 TiB, then we'll
> have to do a bit more hunting.
>
> - -Jeff
>
> - --
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.4-svn0 (GNU/Linux)
> Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org
>
> iD8DBQFGulesLPWxlyuTD7IRAsK2AJ9hHXP/u/U39ilYbJzuJZH1Ak7n3ACfb/Oo
> 2GIGKznayXqevH6lVGh8vew=
> =q4Ca
> -----END PGP SIGNATURE-----
>
