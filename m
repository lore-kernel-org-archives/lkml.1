Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbZDCX23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbZDCX23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 19:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZDCX2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 19:28:20 -0400
Received: from mail.crca.org.au ([67.207.131.56]:57518 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZDCX2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:28:19 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Andreas Robinson <andr345@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <1238763183.13099.19.camel@andreas-desktop>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com> <1238624827.15230.58.camel@andreas-desktop>
	 <49D3EDEA.4090803@zytor.com>  <49D3F4A3.1040609@linux.intel.com>
	 <1238629202.9027.111.camel@nigel-laptop>
	 <1238675410.13249.42.camel@andreas-desktop>
	 <1238705969.10479.8.camel@nigel-laptop>
	 <1238756060.11839.19.camel@andreas-desktop>
	 <1238759294.9692.49.camel@nigel-laptop>
	 <1238763183.13099.19.camel@andreas-desktop>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Sat, 04 Apr 2009 10:28:11 +1100
Message-Id: <1238801291.6802.3.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2009-04-03 at 14:53 +0200, Andreas Robinson wrote: 
> On Fri, 2009-04-03 at 22:48 +1100, Nigel Cunningham wrote:
> 
> > Okay. Am I right in thinking (from staring at the code) that the
> > compression algo just assumes it has an output buffer big enough? (I
> > don't see it checking out_len, only writing to it).
> 
> I came to that conclusion too. And it is not just LZO that needs a
> bigger buffer. Non-compressed blocks in deflate streams occupy 4 bytes
> more than the original, according to RFC 1951 section 3.2.4.
> 
> >  If that's the case,
> > I guess I need to (ideally) persuade the cryptoapi guys to extend the
> > api so you can find out how big an output buffer is needed for a
> > particular compression algorithm - or learn how they've already done
> > that (though it doesn't look like it to me).
> 
> I can not see anything to that effect either.
> 
> > > If there are multiple threads perhaps they clobber each other's output
> > > buffers?
> > 
> > Nope. The output buffers you see here are fed to the next part of the
> > pipeline (the block I/O code), which combines them (under a mutex) into
> > a stream of |index|size|data|index|size|data... so that we don't have to
> > worry at all about which processor compressed (or decompresses data
> > later). As I said earlier, it's worked fine with LZF - or no compression
> > - for years. It's just LZO that causes me problems.
> > 
> > Thanks!
> > 
> > Nigel
> > 
> I'm glad I was able to help!

Vmalloc'ing a 2 * PAGE_SIZE buffer seems to have done the trick - I've
done a couple of cycles with no problems and slightly better throughput
than LZF. A couple of tests in a row of just compressing data using
first LZO then LZF gave 260MB/s vs 230MB/s throughput respectively.
Doing real writes slows things down so that the difference is only about
10MB/s (I only have a 53MB/s SATA HDD), but that's still better than a
poke in the eye!

Thanks!

Nigel

