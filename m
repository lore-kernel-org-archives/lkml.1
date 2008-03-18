Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYCRBzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYCRBzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYCRBzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:55:47 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:41957 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752406AbYCRBzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:55:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1y/bWwAry+OeIschvF58Rcz0/r4Ba7DGMOEHlxwimucy8u2OovKm4wsevBcl+rXyt5HmAIt8k2gR92O7V3a9nmPXjd6CKAKzR+nBOKX47GLJL2OZvekGGsJ6JS6CbwjhRfFWiIqzxgE4XxWwAHjVRHhl3/Mew0X9rmRNl60kuGc=  ;
X-YMail-OSG: TmwTcJEVM1kY4pnAGMmWfwjVu23E0JfjcsxGqs0tcZ.HmABJXY27Md78nxbhYIW0IiOjWoE8pQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: ehci-hcd affects hda speed
Date: Mon, 17 Mar 2008 17:55:44 -0800
User-Agent: KMail/1.9.6
Cc: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl>
In-Reply-To: <47DF19AD.405@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171855.44552.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Rene Herman wrote:
> On 18-03-08 01:00, David Brownell wrote:
> 
> > On Monday 17 March 2008, Rene Herman wrote:
> >> +       case PCI_VENDOR_ID_VIA:
> >> +               if (pdev->device == 0x3104 && pdev->revision >= 0x60) {
> > 
> > Unless you have specific docs from VIA saying that this register
> > isn't revision-specific (at least in the sense that all revisions
> > after 0x60 define that bit in that way), this should probably be a
> > switch on pdev->revision and just include the known-safe revisions.
> 
> I'm looking at a VIA datasheet which says the revision ID for the "VT6212 / 
> VT6212L PCI USB2.0 Controller" is simply 0x60. The VT61212L I myself owned 
> advertised a revision ID of 0x63 and Lev's VT6212L advertises 0x65.

Probably the same one I saw, from that URL.


> The thing is -- you don't necesarily immediately notice this problem. I 
> noticed it earlier on an old system, as did Lev, but even if on a modern 
> system you may not immediately see an IDE throughput drop, you may still 
> have a sucky system.

True, and bothersome.  All VIA would have to do is adopt a design
and production methodology different than they've used for many
years now, and this problem wouldn't appear.  ;)

 
> With 0x60 documented and 0x63 and 0x65 confirmed as VT6212L, I'd personally 
> still go with >= 0x60 and assume either backwards-compatibility or a "don't 
> care" definition if some later revision were to not define this hack.

No ... see below:


> > At one point I had a table mapping those revision codes to
> > specific VIA chips.  Too bad I didn't keep it.  ISTR that the
> > VT6212 has a newer revision code than the vt8235 southbridge,
> > and probably not as new as the vt8237 one...
> 
> Some googling seems to indicate that:

... I was wrong about the vt8235 preceding the vt6212 then!


> VT6202 = 0x5x (0x50, 0x51 at least)
> VT6212 = 0x6x (0x60, 0x61, 0x63, 0x65 at least)
> VT8235 = 0x82
> VT8237 = 0x86
> VT*800 = 0x90 (KM800Pro, VN800, K8N800, ...)
> 
> Do you want one with 0x6x?

I'd take that.  Thing is, someone sent me a vt8235 datasheet
which explicitly says "do not write that register", which
makes the ">= 0x60" test a lose.


> I feel it's very likely that everyone on anything  
> later will then still have a sucky system. Tons of people with VT8235/VT8237 
> around (although not me). Any quick test available for them?

They could try the "setpci" thing you used ... but even if
that works, I'd really want to avoid writing into registers
where the docs say "do not write".  Unless VIA comes out and
says "just kidding!" ... :)

 
> > But otherwise, yes -- that's the kind of patch I'd sign off on
> > after making this comment a bit more informative about how
> > that 1 usec sleep time creates an amount of PCI bus hogging.
> 
> Version with 0x6x and the somewhat more expansive comment. I'd like to be 
> able to test VT8235/VT8237 first though...

OK, I'll leave this in my mailbox for a few days waiting more
testing results, and if nothing goes wrong I'll send it along
for a post-2.6.25 merge.

Thanks!

- Dave


