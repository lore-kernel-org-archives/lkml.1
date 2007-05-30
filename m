Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXE3XCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXE3XCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXE3XC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:02:28 -0400
Received: from quest.jpl.nasa.gov ([137.79.56.36]:51351 "EHLO
	quest.jpl.nasa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXE3XC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:02:27 -0400
In-Reply-To: <a781481a0705300630r51a31f93v1301da92f6a70f01@mail.gmail.com>
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com> <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com> <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk> <200705290943.11176.dhazelton@enter.net> <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com> <172CB60C-2F1F-4CCE-8AB7-C7CFA1161AA0@alumni.caltech.edu> <a781481a0705300630r51a31f93v1301da92f6a70f01@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <1084DBE5-D72F-4403-B231-66DA8FE6AC73@alumni.caltech.edu>
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       jloup@gzip.org
Content-Transfer-Encoding: 7bit
From: Mark Adler <madler@alumni.caltech.edu>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Date: Wed, 30 May 2007 16:02:28 -0700
To: Satyam Sharma <satyam.sharma@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 30, 2007, at 6:30 AM, Satyam Sharma wrote:
> [1] For your reference, here is the user code in question:
...
>        if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
> 	    ((data_in[0] & 0x0f) == Z_DEFLATED) &&
> 	    !(((data_in[0]<<8) + data_in[1]) % 31)) {

The funny thing here is that the author felt compelled to use a  
#defined constant for the dictionary bit (PRESET_DICT), but had no  
problem with a numeric constant to isolate the compression method  
(0x0f), or for that matter extracting the window bits from the  
header.  The easy way to avoid the use of an internal zlib header  
file here is to simply replace PRESET_DICT with 0x20.  That constant  
will never change -- it is part of the definition of the zlib header  
in RFC 1950.

The slightly more involved patch to avoid the problem is to let  
inflate() do all that work for you, including the integrity check on  
the zlib header (% 31).  Also this corrects an error in the original  
code, which is that it continues to try to decompress after finding  
that a dictionary is needed or that the zlib header is invalid.  In  
this version, a bad header simply returns an error:

     /* provide input data and output space */
     inf_strm.next_in = data_in;
     inf_strm.avail_in = srclen;
     inf_strm.next_out = cpage_out;
     inf_strm.avail_out = destlen;

     /* verify and skip zlib header (this updates next_in and  
avail_in) */
     inf_strm.zalloc = Z_NULL;
     inf_strm.zfree = Z_NULL;
     inf_strm.opaque = Z_NULL;
     if (zlib_inflateInit(&inf_strm) != Z_OK) {
         printk(KERN_WARNING "inflateInit failed\n");
         return 1;
     }
     ret = zlib_inflate(&inf_strm, Z_BLOCK);
     if (ret != Z_OK || (inf_strm.data_type & 0x80) == 0) {
         printk(KERN_WARNING "inflate failed on zlib header\n");
         return 1;
     }
     zlib_inflateEnd(&inf_strm);

     /* do raw inflate (no adler32) on deflate data after zlib header */
     inf_strm.zalloc = Z_NULL;
     inf_strm.zfree = Z_NULL;
     inf_strm.opaque = Z_NULL;
     if (zlib_inflateInit2(&inf_strm, -MAX_WBITS) != Z_OK) {
         printk(KERN_WARNING "inflateInit failed\n");
         return 1;
     }
     while ((ret = zlib_inflate ...

Mark

