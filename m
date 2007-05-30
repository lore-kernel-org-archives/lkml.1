Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbXE3NaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbXE3NaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbXE3NaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:30:07 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:37800 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbXE3NaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=myfC7XpbO2XbQlkqcFCJoWJKDnc0buZTHY5Xp5JeuxurMXPFEI2FBTaG0scEvqS8fxOIKECUDn674Je1O/xFFScKc0iX4uRS0nd4rpQ37F2dcTAC2lv0VBTBWkITQg7V3klmTDjRuIcXZcH8qUqx/9s96MJNRN2EVpb123Ey8D4=
Message-ID: <a781481a0705300630r51a31f93v1301da92f6a70f01@mail.gmail.com>
Date: Wed, 30 May 2007 19:00:02 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Mark Adler" <madler@alumni.caltech.edu>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       jloup@gzip.org
In-Reply-To: <172CB60C-2F1F-4CCE-8AB7-C7CFA1161AA0@alumni.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>
	 <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>
	 <200705290943.11176.dhazelton@enter.net>
	 <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
	 <172CB60C-2F1F-4CCE-8AB7-C7CFA1161AA0@alumni.caltech.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 5/30/07, Mark Adler <madler@alumni.caltech.edu> wrote:
> On May 29, 2007, at 8:15 AM, Satyam Sharma wrote:
> > skipping some checksum calculation if some
> > flag (PRESET_DICT) is absent from the input stream about to
> > be decompressed ...
>
> You don't need to dissect the header manually to look for that bit.
> If you feed inflate() at least the first two bytes, it will return
> immediately with the Z_NEED_DICT return code if a preset dictionary
> is requested.  You can force inflate() to return immediately after
> decoding the two byte header even if a preset dictionary is not
> requested by using the Z_BLOCK flush code.

Thanks for replying, unfortunately I don't know either zlib or jffs2 code
deeply enough to actually understand what you meant here. Are you
saying that the if-else block in question [1] in
fs/jffs2/compr_zlib.c:jffs2_zlib_decompress() is unnecessary and can
be done away with?

Thanks,
Satyam

[1] For your reference, here is the user code in question:

	inf_strm.next_in = data_in;
	inf_strm.avail_in = srclen;
	inf_strm.total_in = 0;
	inf_strm.next_out = cpage_out;
	inf_strm.avail_out = destlen;
	inf_strm.total_out = 0;

	int wbits = MAX_WBITS;

	/* If it's deflate, and it's got no preset dictionary, then
	   we can tell zlib to skip the adler32 check. */

        if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
	    ((data_in[0] & 0x0f) == Z_DEFLATED) &&
	    !(((data_in[0]<<8) + data_in[1]) % 31)) {
		D2(printk(KERN_DEBUG "inflate skipping adler32\n"));
		wbits = -((data_in[0] >> 4) + 8);
		inf_strm.next_in += 2;
		inf_strm.avail_in -= 2;
	} else {
		/* Let this remain D1 for now -- it should never happen */
		D1(printk(KERN_DEBUG "inflate not skipping adler32\n"));
	}

	if (zlib_inflateInit2(&inf_strm, wbits) != Z_OK) {
		printk(KERN_WARNING "inflateInit failed\n");
		return 1;
	}
	while((ret = zlib_inflate(&inf_strm, Z_FINISH)) == Z_OK)
		;
	if (ret != Z_STREAM_END)
		printk(KERN_NOTICE "inflate returned %d\n", ret);
	zlib_inflateEnd(&inf_strm);
