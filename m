Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbZKZNC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbZKZNC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 08:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760440AbZKZNCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 08:02:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:19240 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbZKZNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 08:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ORwEYCqGD6SYi0rdKRDMykNCCsxTox+mN7dsu74CHCySH2dRX+KISM3CAXYECW3vAR
         BMCyssEQ1L1abyCcCpo8T33niSPhmiVlpc//dk0INQO/rqAcpSCD3gq0EvqqmjhV2SNN
         OtrSPwUvcxARr4EPQkbuGGivujpe61m2IBlHo=
Subject: Re: Plan for adding XD support in mtd layer
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Alex Dubov <oakad@yahoo.com>,
       arnd@arndb.de, tglx@linutronix.de
In-Reply-To: <20091126082715.GG10944@logfs.org>
References: <1258763144.4997.12.camel@maxim-laptop>
	 <20091121102542.GA21136@logfs.org> <1258894713.4127.4.camel@maxim-laptop>
	 <1259106610.28219.34.camel@maxim-laptop> <20091125104027.GB10944@logfs.org>
	 <1259155258.4875.17.camel@maxim-laptop> <20091125153458.GC10944@logfs.org>
	 <1259165866.10147.35.camel@maxim-laptop> <20091125205942.GF10944@logfs.org>
	 <1259191365.15916.31.camel@maxim-laptop> <20091126082715.GG10944@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 15:02:54 +0200
Message-ID: <1259240574.19687.42.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 09:27 +0100, Jörn Engel wrote: 
> On Thu, 26 November 2009 01:22:45 +0200, Maxim Levitsky wrote:
> > > 
> > > According to FMTP140E.PDF, CIS and IDI are stored in sector 0 or the
> > > first non-defective block.  In other words, it can be read and written
> > > normally, without any magic.  Certainly not the atrocities I tried not
> > > to remember.
> > I wish I had the spec.
> 
> It used to be semi-free.  You could download it for your name and
> address.  But I believe I'm not legally able to forward it to you and
> the official site seems to be down.  Most of the information can also
> be found here:
> http://www.win.tue.nl/~aeb/linux/smartmedia/SmartMedia_Format.pdf
This one I have, and there is a brief description of the CIS format,
which seems to indicate that its contents are predefined.

> And there seems to be a copy available at pudn:
> http://en.pudn.com/downloads137/doc/fileformat/detail585996_en.html
> 
> > I don't know the format of the CIS, and I know that special command is
> > used to query the ID.
> > CIS these days isn't used for anything and I hoped not to touch that
> > thing.
> 
> :)
> 
> > I wont argue on that one with you, but why not to add the new field.
> > It is quite generic, it could be card vendor information or so?
> > Few bits of custom information to assign for each card no?
> > 
> > 
> > I am taking about these:
> > 
> > struct xd_card_id1 {
> > unsigned char maker_code;
> > unsigned char device_code;
> > unsigned char option_code1;
> > unsigned char option_code2;
> > } __attribute__((packed));
> > 
> > struct xd_card_id2 {
> > unsigned char characteristics_code;
> > #define XD_CARD_CELL_TYPE_MASK   0xc0
> > #define XD_CARD_MULTI_BLOCK_MASK 0x30
> > 
> > unsigned char vendor_code1;
> > unsigned char size_code;
> > unsigned char vendor_code2;
> > unsigned char vendor_code3;
> > } __attribute__((packed));
> > 
> > struct xd_card_id3 {
> > unsigned char vendor_code1;
> > unsigned char vendor_code2;
> > unsigned char id_code;
> > unsigned char vendor_code3;
> > } __attribute__((packed));
> > 
> > 
> > Are these 32 bit values copied from CIF?
> > 
> > These values are read using commands:
> > 
> > XD_CARD_CMD_ID1         = 0x90,
> > XD_CARD_CMD_ID2         = 0x91,
> > XD_CARD_CMD_ID3         = 0x9a
> > 
> > 
> > I need especially the xd_card_id1.device_code because this specifies the
> > media type, but xd_card_id3.id_code is used to detemine if media is
> > smartmedia or XD.
> 
> If you add this information to a struct xD_card and have mtd->priv point
> to said structure, wouldn't that be enough for your purposes?

I am afraid not.


My plan is to create one 'meta' mtd driver for all XD controllers, and
plug in small drivers.

The meta driver and small driver will share the ->priv structure.

I need a way to pass the ID from mtd driver to FTL, and to userspace via
mtdchar.


Best regards,
Maxim Levitsky

