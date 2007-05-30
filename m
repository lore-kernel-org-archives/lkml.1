Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbXE3X0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbXE3X0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXE3X0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:26:37 -0400
Received: from keil-draco.com ([216.193.185.50]:50693 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085AbXE3X0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:26:36 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Mark Adler <madler@alumni.caltech.edu>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Date: Wed, 30 May 2007 19:26:25 -0400
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       jloup@gzip.org
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <a781481a0705300630r51a31f93v1301da92f6a70f01@mail.gmail.com> <1084DBE5-D72F-4403-B231-66DA8FE6AC73@alumni.caltech.edu>
In-Reply-To: <1084DBE5-D72F-4403-B231-66DA8FE6AC73@alumni.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705301926.25546.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007 19:02:28 Mark Adler wrote:
> On May 30, 2007, at 6:30 AM, Satyam Sharma wrote:
> > [1] For your reference, here is the user code in question:
>
> ...
>
> >        if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
> > 	    ((data_in[0] & 0x0f) == Z_DEFLATED) &&
> > 	    !(((data_in[0]<<8) + data_in[1]) % 31)) {
>
> The funny thing here is that the author felt compelled to use a
> #defined constant for the dictionary bit (PRESET_DICT), but had no
> problem with a numeric constant to isolate the compression method
> (0x0f), or for that matter extracting the window bits from the
> header.  The easy way to avoid the use of an internal zlib header
> file here is to simply replace PRESET_DICT with 0x20.  That constant
> will never change -- it is part of the definition of the zlib header
> in RFC 1950.

That was one of my original suggestions, though I personally downchecked it 
(and believe I also did so in the mail with the suggestions) because of the 
dislike of "Magic Numbers" in the kernel. However, I had only looked at a 
small part of the JFFS2 code to see what it used zutil.h for - if it is using 
said 'Magic Numbers' in the rest of the code, the consistent way to fix this 
would be to replace the PRESET_DICT macro with the constant it stands for.

I've gotten a bit caught-up in extending the test-bed code I used to benchmark 
Nitin's 'tinyLZO' implementation, but I will see about getting a patch 
together to change JFFS2 in the manner Mark suggests. (Unless, of course, 
someone gets to it before I do).

DRH

>
> The slightly more involved patch to avoid the problem is to let
> inflate() do all that work for you, including the integrity check on
> the zlib header (% 31).  Also this corrects an error in the original
> code, which is that it continues to try to decompress after finding
> that a dictionary is needed or that the zlib header is invalid.  In
> this version, a bad header simply returns an error:
>
>      /* provide input data and output space */
>      inf_strm.next_in = data_in;
>      inf_strm.avail_in = srclen;
>      inf_strm.next_out = cpage_out;
>      inf_strm.avail_out = destlen;
>
>      /* verify and skip zlib header (this updates next_in and
> avail_in) */
>      inf_strm.zalloc = Z_NULL;
>      inf_strm.zfree = Z_NULL;
>      inf_strm.opaque = Z_NULL;
>      if (zlib_inflateInit(&inf_strm) != Z_OK) {
>          printk(KERN_WARNING "inflateInit failed\n");
>          return 1;
>      }
>      ret = zlib_inflate(&inf_strm, Z_BLOCK);
>      if (ret != Z_OK || (inf_strm.data_type & 0x80) == 0) {
>          printk(KERN_WARNING "inflate failed on zlib header\n");
>          return 1;
>      }
>      zlib_inflateEnd(&inf_strm);
>
>      /* do raw inflate (no adler32) on deflate data after zlib header */
>      inf_strm.zalloc = Z_NULL;
>      inf_strm.zfree = Z_NULL;
>      inf_strm.opaque = Z_NULL;
>      if (zlib_inflateInit2(&inf_strm, -MAX_WBITS) != Z_OK) {
>          printk(KERN_WARNING "inflateInit failed\n");
>          return 1;
>      }
>      while ((ret = zlib_inflate ...
>
> Mark


