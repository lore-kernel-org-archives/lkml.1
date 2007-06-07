Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbXFGGt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbXFGGt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXFGGtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:49:21 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:49203 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXFGGtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oy0MKmiXIaaqujm1+awiO4x+JRtbF+f0Zzg6y3pkPCti1/qDpkcm8LDLNXlyZ7WwCQ0r+nknRvpsBKtJDMSsKjeR5qHRfGrzOM+xUCVrhSJwidE1nvS5PRt7KB1kPphmtL4MGf1g8HRcQsPsoIEQdGk2Rxtw7PZn0zvdWdllBe8=
Message-ID: <4cefeab80706062349s264648fbr25ccbc9884be2057@mail.gmail.com>
Date: Thu, 7 Jun 2007 12:19:19 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Nitin Gupta" <nitingupta910@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO de/compression support - take 7
In-Reply-To: <4cefeab80706060705o210f6a71od074d6cc60e113a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80706060534h2461ddffu35f463d7728519a0@mail.gmail.com>
	 <20070606125130.GA13419@infradead.org>
	 <4cefeab80706060705o210f6a71od074d6cc60e113a9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Nitin Gupta <nitingupta910@gmail.com> wrote:
> On 6/6/07, Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Jun 06, 2007 at 06:04:17PM +0530, Nitin Gupta wrote:
> > > Hi,
> > >
> > > This is kernel port of LZO1X-1 compressor and LZO1X decompressor (safe
> > > version only).
> > >
> > > * Changes since 'take 6' (Full Changelog after this):
> > > 1) Fixed unaligned memory access problems as pointed out by author --
> > > LZO_UNALIGNED_OK_{2,4} collapsed to UNALIGNED_OK which is #defined for
> > > archs that allow unaligned access (see lib/lzo1x/Makefile). For other
> > > archs, we fall down to byte-by-byte access avoiding any unaligned
> > > access. In original code, LZO_UNALIGNED_OK_{2,4} resp. describe if we
> > > can do unaligned access for ushort and uint32.
> >
> > Please use get_unaligned() for any unaligned access in kernel space.
> >
> >
>
> Done.
>

Just as a side note: I think retaining code to do byte-by-byte access
also is worth it, such as:
+ #ifdef UNALIGNED_OK
+		if (get_unaligned((const unsigned short *)m_pos) ==
+				get_unaligned((const unsigned short *)ip)) {
+#else
+		if (m_pos[0] != ip[0] || m_pos[1] != ip[1]) {
+#endif

Since on archs where unaligned access is slower than byte-by-byte
access (e.g. where unaligned access dirty work is done in s/w), we do
not want to use get_unaligned() - instead simply byte-by-byte access
is better.

- Nitin
