Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYDGVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYDGVGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYDGVGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:06:11 -0400
Received: from outbound-mail-150.bluehost.com ([67.222.38.40]:39725 "HELO
	outbound-mail-150.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751997AbYDGVGK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:06:10 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas =?iso-8859-1?q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Subject: Re: [PATCH] x86: create array based interface to change page attribute
Date: Mon, 7 Apr 2008 14:04:28 -0700
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071259.19743.jbarnes@virtuousgeek.org> <47FA8826.2060802@tungstengraphics.com>
In-Reply-To: <47FA8826.2060802@tungstengraphics.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804071404.28691.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 07, 2008 1:46 pm Thomas Hellström wrote:
> > Why would we need to flush at all at unbind-read-bind time?  We should be
> > able to leave pages in the WC state even when we unbind them, then when
> > we need to bind them back into the GTT they'll be ready, but maybe I'm
> > misunderstanding you here...
>
> We want to make the user-space mapping cache-coherent after unbind
> during read, to have any serious read-speed, and the linear kernel map
> has to follow, unless it's non-present. Even if it's non present, we
> need to flush whatever was written through the user-space mapping from
> the cache when rebinding. Having the user-space mapping read-only when
> possible will help avoid this.

Ah, you actually want to *read* from memory?  Yeah that would be really slow 
if we left it UC or WC.  But I thought that was really only necessary for 
relocation, and keithp dealt with that with the "presumed offset" stuff?  Are 
you seeing other cases where we need to read back frequently?

> > Yeah, they're ioremapped now, but that's a problem since with the PAT
> > patches they'll be mapped hard UC (right now it just happens to work).
>
> Ouch, so we'll be needing an ioremap_wc(), I guess. We probably
> shouldn't use the linear kernel map for this anyway, since that would
> require a chipset flush for each ring commit.  We can actually use
> vmap() with a wc page protection for that, but an ioremap_wc() would
> certainly save us a lot of trouble.

Yeah, ioremap_wc is probably the best thing to use in the DRM.  And in AGP 
we'll need to clarify things more, since some drivers can do cacheable 
memory, some want UC, etc.

Thanks,
Jesse
