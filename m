Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbXFARYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbXFARYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762563AbXFARY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:24:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:1212 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762503AbXFARY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZVrR4ICc5m3R7EFQI58FEELvL5s/K6Bx6crAF62l75V6dB4p8IrTvKiux5UNN493jxS50cfVTR3Eb20y8zWaz1vU77nnhDuYr5qPuCy1p4gMhaXY67wu31klpSahVurX+EdgkBjiPyjWy+mMhmhbI/d+vgz+Agfpr5HyIMbQ6G8=
Message-ID: <a781481a0706011024o4a21712bw9e4342204ebfc490@mail.gmail.com>
Date: Fri, 1 Jun 2007 22:54:26 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Daniel Hazelton" <dhazelton@enter.net>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Cc: "Mark Adler" <madler@alumni.caltech.edu>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       jloup@gzip.org
In-Reply-To: <200705312306.12626.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <a781481a0705300630r51a31f93v1301da92f6a70f01@mail.gmail.com>
	 <1084DBE5-D72F-4403-B231-66DA8FE6AC73@alumni.caltech.edu>
	 <200705312306.12626.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 6/1/07, Daniel Hazelton <dhazelton@enter.net> wrote:
> On Wednesday 30 May 2007 19:02:28 Mark Adler wrote:
> > On May 30, 2007, at 6:30 AM, Satyam Sharma wrote:
> > > [1] For your reference, here is the user code in question:
> >
> > ...
> >
> > >        if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
> > >         ((data_in[0] & 0x0f) == Z_DEFLATED) &&
> > >         !(((data_in[0]<<8) + data_in[1]) % 31)) {
> >
> > The funny thing here is that the author felt compelled to use a
> > #defined constant for the dictionary bit (PRESET_DICT), but had no
> > problem with a numeric constant to isolate the compression method
> > (0x0f), or for that matter extracting the window bits from the
> > header.  The easy way to avoid the use of an internal zlib header
> > file here is to simply replace PRESET_DICT with 0x20.  That constant
> > will never change -- it is part of the definition of the zlib header
> > in RFC 1950.
>
> If there is no objection, I'll put together a patch that changes the use in
> JFFS2 into a "magic number", complete with documentation on it, and also
> moves all of the zlib stuff into a single directory.

Right, s/PRESET_DICT/0x20/ would have the least fall-out / unknown
side-effects.

> > The slightly more involved patch to avoid the problem is to let
> > inflate() do all that work for you, including the integrity check on
> > the zlib header (% 31).  Also this corrects an error in the original
> > code, which is that it continues to try to decompress after finding
> > that a dictionary is needed or that the zlib header is invalid.  In
> > this version, a bad header simply returns an error:
> >
>
> Does anyone know if doing as Mark suggests would negatively impact the
> performance of JFFS2 to such a degree that it could be considered a
> regression? I, unfortunately, don't have the hardware to properly test the
> code. And, at this point in time, I also don't have enough familiarity with
> the JFFS2 code to make such a change myself.

David would have to comment on that, but you could simultaneously
make and submit the patch as suggested by Mark with both your
signed-offs-by. That'll naturally need to go through David's tree, so we'll
know if he likes/accepts the suggested modifications ...
