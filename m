Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZCKR7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZCKR7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZCKR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:59:42 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:64578 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751290AbZCKR7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:59:41 -0400
Date: Wed, 11 Mar 2009 18:59:38 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] squashfs: Make SquashFS 4 use the new pcomp crypto
 interface
In-Reply-To: <49B36A18.5030506@lougher.demon.co.uk>
Message-ID: <alpine.LRH.2.00.0903111830540.1040@vixen.sonytel.be>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1235569394-15217-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090307104637.GB8731@gondor.apana.org.au>
 <49B36A18.5030506@lougher.demon.co.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Phillip,

On Sun, 8 Mar 2009, Phillip Lougher wrote:
> Herbert Xu wrote:
> > On Wed, Feb 25, 2009 at 02:43:14PM +0100, Geert Uytterhoeven wrote:
> > > Modify SquashFS 4 to use the new "pcomp" crypto interface for
> > > decompression,
> > > instead of calling the underlying zlib library directly. This simplifies
> > > e.g.
> > > the addition of support for hardware decompression and different
> > > decompression
> > > algorithms.
> > >
> > > Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > > Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
> > 
> > I've applied patches 1-5.  I'd like to see an ack on this before
> > applying it.
> 
> I've not acked it because I've not yet made any decisions as to whether I want
> it in Squashfs.  Also as Squashfs maintainer I maintain my own tree of patches
> to Squashfs, and so I'll prefer to add it to my tree for subsequent feeding
> into 2.6.30 once the merge window opens.

OK.

> I'm fairly agnostic about what decompression library Squashfs uses.  The only
> thing I care about is cleanliness and usability of the API and performance.
> If the crypto API is cleaner or the cryto zlib implementation is faster than
> the current zlib implementation then I see no reason not to move over to it.
> But, I've seen no performance figures and the API seems clumsier.

I did not see any noticeable performance impact due to my changes.

> Two API issues of concern (one major, one minor).  Both of these relate to the
> way Squashfs drives the decompression code, where it repeatedly calls it
> supplying additional input/output buffers, rather than using a "single-shot"
> approach where it calls the decompression code once supplying all the
> necessary input and output buffer space.
> 
> 1. Minor issue -the lack of a stream.total_out field.  The current
> zlib_inflate code collects the total number of bytes decompressed over the
> multiple calls into the stream.total_out field.
> 
>    There is clearly no such field available in the cryto API, leading to the
> somewhat clumsy need to track it, i.e. it leads to the following additional
> code.

If people feel the need for a total_out field, I can add it to struct
comp_request.

BTW, what about total_in, which is also provided by plain zlib's z_stream?
Do people see a need for a similar field?

> 2. Major issue - working out loop termination.
> 
> It transpires when decompressing from multiple input buffers into multiple
> output buffers, determining when the decompressor has consumed all input
> buffers and has flushed all output to the output buffers is difficult.

    [...]

> With zlib_inflate this is irrelevant because it supplies a suitable exit code
> indicating whether it needs to be called again (Z_OK) or whether decompression
> has finished (Z_STREAM_END).  This makes loop termination easy.

Zlib indeed provides such a flag. Other decompression algorithms may not
provide this, and keep on `decompressing' as long as you feed them data.

So while I could add an output flag indicating decompression has finished, it
cannot be more than a mere hint when considering support for multiple
(de)compression algorithms.

> My biggest criticism against the cryto changes to Squashfs is
> crypto_decompress_update doesn't seem to give this information, leaving to the
> clumsy introduction of a check to see if crypto_decompress_update produced any
> output data, i.e.:
> 
> -		} while (zlib_err == Z_OK);
> > -
> 
> is replaced by:
> 
> > +		} while (bytes || produced);
> > +
> 
> This is clearly suboptimal, and always leads to an additional iteration around
> the loop.  Only once we've iterated over the loop one last time doing nothing
> do we decide the decompression has completed.

Given the difficulty in determining the finishing of decompression in a generic
way, I don't see a better solution. If no data has been consumed nor produced,
and no -EAGAIN is returned, decompression is finished.

BTW, this is also very similar to reading from a file: read() returns a
non-zero count until the end of the file is reached.

The additional loop also doesn't seem to have any noticeable impact on
performance, though.

> Not only this, but the loop termination also suffers from a major
> unanticipated bug:
> 
> The loop termination forces an additional iteration around the loop even
> though we've run out of output buffer space.
> 
> Consider the usual scenario where we're decompressing a buffer into two 4K
> pages (pages = 2), and the buffer decompresses to 8K.  The final "real"
> iteration will have produced != 0 and req.avail_out == 0 (we've consumed all
> the output bytes in the last output buffer).
> 
> Because produced != 0 we will iterate over the loop again.  But because
> req.avail_out == 0 we will load req.next_out with a non-existent buffer (we
> will fall off the end of the buffer array), i.e.
> 
> +			if (req.avail_out == 0) {
> > +				req.next_out = buffer[page++];
> > +				req.avail_out = PAGE_CACHE_SIZE;
> >     }
> >
> 
> If for any reason crypto_decompress_update produces unexpected output (perhaps
> because of corrupted data), we will trigger a kernel oops.
> 
> Obviously in the majority of cases (which is why the code works), the "false"
> additional iteration doesn't produce any output.  But it is distinctly bad
> practice to have code in the kernel that in normal operation passes a bad
> pointer to crypto_decompress_output, and relies on its behaviour not to use
> that bad pointer.

You are right.  Hence this needs a check for page < pages, cfr. your recent fix
to survive corrupted file system images. I'll take care of that.

Thanks for your comments!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
