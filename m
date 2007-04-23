Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbXDWN4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbXDWN4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXDWN4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:56:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:20741 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbXDWN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OBKHYMI+mB937ZUZ6L9V3GZGNLDgubbH7g2xp+YbW7vZ/QfteRCqb3X7Q4R2+a9F8rRic+grovNvCU//DS/bkO6KxrsUmebkERNlPcEdC8etfd8B8igb570MuOi+FGWKdoVsBIio6sBBx1tA+HTffFCdqpW1typ/S49cKHQ45Do=
Message-ID: <38b2ab8a0704230656k4863cfb6ne019a443efb22a4b@mail.gmail.com>
Date: Mon, 23 Apr 2007 15:56:28 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <38b2ab8a0704190107x2c151bafx824beca052f97ef6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	 <adairbv57s2.fsf@cisco.com>
	 <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
	 <ada7isb3qr2.fsf@cisco.com>
	 <38b2ab8a0704171024m3d838bdak14370a7d0931557f@mail.gmail.com>
	 <adalkgq3nx6.fsf@cisco.com>
	 <38b2ab8a0704190107x2c151bafx824beca052f97ef6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

[Sorry for the late answer]

On 4/19/07, Francis Moreau <francis.moro@gmail.com> wrote:
> On 4/17/07, Roland Dreier <rdreier@cisco.com> wrote:
> >  > > It seems trivial to keep the last key you were given and do a quick
> >  > > memcmp in your setkey method to see if it's different from the last
> >  > > key you pushed to hardware, and set a flag if it is.  Then only do
> >  > > your set_key() if you have a new key to pass to hardware.
> >  > >
> >  > > I'm assuming the expense is in the aes_write() calls, and you could
> >  > > avoid them if you know you're not writing something new.
> >
> >  > that's a wrong assumption. aes_write()/aes_read() are both used to
> >  > access to the controller and are slow (no cache involved).
> >
> > Sorry, I wasn't clear.  I meant that the hardware access is what is
> > slow, and that anything you do on the CPU is relatively cheap compared
> > to that.
> >
> > So my suggestion is just to keep a cache (in CPU memory) of what you
> > have already loaded into the HW, and before reloading the HW just
> > check the cache and don't do the actual HW access if you're not going
> > to change the HW contents.  So you avoid any extra aes_write and
> > aes_read calls in the cache hit case.
> >
> > This would have the advantage of making anything that does lots of
> > bulk encryption fast without special casing ecryptfs.
> >
>
> I'm not sure how "memcmp(key, cache, KEY_SIZE)" would impact AES
> performance. I need to give it a test but can't today. I'll do
> tomorrow and give you back the result.
>

OK, I gave it a test and it appears that the cache hit case is
slightly worse than unconditionnal key loading. So it means that
testing that hte key is cached is as long as loading the key into the
controller. Here is what I did in set_key() function:

static void set_key(const char *key)
{
	static u32 my_key[4] __cacheline_aligned;

	u32 key0 = *(const u32 *)(key + 12);
	u32 key1 = *(const u32 *)(key + 8);
	u32 key2 = *(const u32 *)(key + 4);
	u32 key3 = *(const u32 *)(key);
	int timeout = 100;
	u32 miss = 0;

	miss |= key0 ^ my_key[0];
	miss |= key1 ^ my_key[1];
	miss |= key2 ^ my_key[2];
	miss |= key3 ^ my_key[3];
	if (miss == 0)
		return;

	my_key[0] = key0;
	my_key[1] = key1;
	my_key[2] = key2;
	my_key[3] = key3;
	
	aes_write(be32_to_cpu(key0), AES_KEY0);
	aes_write(be32_to_cpu(key1), AES_KEY1);
	aes_write(be32_to_cpu(key2), AES_KEY2);
	aes_write(be32_to_cpu(key3), AES_KEY3);

	/* generate dkey: should take 11 cycles */
	aes_write(aes_read(AES_CR) | CR_DKEYGEN, AES_CR);

	while (aes_read(AES_CR) & CR_DKEYGEN) {
		if (--timeout == 0)
			break;
	}
}

So I was wrong, hardware access is not so expensive as I thought. But
it also means that all instructions executed in the drivers'
encrypt()/decrypt() methods have a real cost and skipping key loadings
is a win.

Using the driver exclusively doesn't seem to be the right solution,
but I don't see another way to do that...
-- 
Francis
