Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXE2PP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXE2PP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 11:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbXE2PPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 11:15:49 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:44948 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXE2PPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 11:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eO9+QuEa6s7sxSkdEFqwlhIFD/MCcN5QNwPCestb4YvRIlpyDYtvEGV/bk/Ff9LRoRGD3tElTOSOhKZ6Zr90YN0JxnN2cel+dzTiQWQLFWN9jq/t521pzJG3DYd5voafqHQhSLRqnTt6sIkKVLU6suew2k0gYkMGlfglt6B4atM=
Message-ID: <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
Date: Tue, 29 May 2007 20:45:41 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Cc: "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       madler@alumni.caltech.edu, jloup@gzip.org
In-Reply-To: <200705290943.11176.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>
	 <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>
	 <200705290943.11176.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Trimmed Cc list; added original zlib authors. ]

> On Tuesday 29 May 2007 09:33:51 Michael-Luke Jones wrote:
> > On 29 May 2007, at 12:27, Satyam Sharma wrote:
> > > Right, actually, zlib could be switched over to [using a common
> > > directory].
> > > Because zlib_deflate/ and zlib_inflate/ too share a private header
> > > zutil.h which has unfortunately been stuck into include/linux/ with
> > > a big
> > > /* WARNING: this file should *not* be used by applications. */
> > > comment ...
> >
> > Well, unfortunately zutil.h is currently being used in-kernel by fs/
> > jffs2/compr_zlib.c despite the "WARNING: this file should *not* be
> > used by applications" notice.

Hmmm, either jffs2 thinks the zlib interfaces exposed through
include/linux/zlib.h are insufficient, or it isn't using zlib properly
(or at least the way it was supposed to be used :-)

Looking at fs/jffs2/compr_zlib.c, however, it just seems to be
an optimization -- skipping some checksum calculation if some
flag (PRESET_DICT) is absent from the input stream about to
be decompressed ...

This /looks/ like an optimization that might make sense for other
users of zlib too, in which case that entire check and
skip-the-checksum thing could actually be put into zlib proper. (?)

> > So moving this header to a truly private location isn't possible
> > right now, unfortunately,
> >
> > Michael-Luke Jones
> > [added David Whitehouse to cc]

On 5/29/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> I've looked at that code and it seems to need that file for one constant.
> Perhaps it'd be better for jffs2/compr_zlib.c to define that constant itself
> (or use it as a "Magic Number") rather than include the zlib private header.
> Another possibility would be to move that constant out of zutil.h and into
> zconf.h or zlih.b - doing any of those would allow the zlib private header to
> be moved such that zlib could be changed to use a common directory *and* have
> said private header in that directory.

Moving PRESET_DICT to zlib.h robs lib/zlib_deflate/deflate.c from
being able to resolve that macro. FWIW, a dirty hack could be to
simply duplicate it in zlib.h. But then, implementation and interface
are decoupled for good reasons ...

Satyam
