Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbZFWBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbZFWBTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZFWBTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:19:06 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:50468 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751313AbZFWBTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:19:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Pccj+9bIZQyuprJ3Cq6J/uU5u3+S3W+Fm3+0kV2ulWsExoz+j6AzTB+OwqBFGGy63eqyx9nSfWQNZ+T4PeLJ9wqzgTnBEU5F2ahzLdx0Op9T15pBeEwYBjslvvYPlBtA;
Date: Mon, 22 Jun 2009 18:18:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas =?UTF-8?B?SGVs?= =?UTF-8?B?bHN0csO2bQ==?= 
	<thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm: previous pull req + 1.
Message-ID: <20090622181832.771dac03@jbarnes-g45>
In-Reply-To: <1245719079.4017.25.camel@pasglop>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	<4A3DABE1.50309@mit.edu>
	<alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	<alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	<alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	<cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	<alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	<alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	<4A3F3E3A.2030202@shipmail.org>
	<1245715213.4017.13.camel@pasglop>
	<alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
	<1245719079.4017.25.camel@pasglop>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 11:04:39 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2009-06-22 at 17:24 -0700, Linus Torvalds wrote:
> > 
> > On Tue, 23 Jun 2009, Benjamin Herrenschmidt wrote:
> > > 
> > > As far as I can remember, all fbdev operations are done under the
> > > console semaphore.
> > 
> > Yeah, and some of them are horribly broken (ie copying data from
> > user space while doing it - causing horrible things like VC
> > switching latencies and invisible printk's if an oops happens
> > during the op).
> > 
> > Or maybe that got fixed. 
> 
> Well, it does rely on userspace behaving.. ie, no accel ops are done
> by the kernel in KD_GRAPHICS and userspace is -supposed- to switch to
> KD_GRAPHICS before touching the fb.
> 
> In fact, nowdays, we do have the infrastructure to be smart and
> enforce that. IE. Instead of using a boring remap_page_ranges() in
> fb_mmap() we could use a fault handler. When in KD_TEXT, we fail
> them, when in KD_GRAPHICS, we service them, and we
> unmap_mapping_range() when switching. Something like that...
> 
> Dunno how that interacts with the new DRM thingy though.

I think it could work, but ideally we'd keep the kernel fbcon object
pinned, and keep printing into it even while some other gfx app is
running.  That way we don't have to dump the whole queue into it when a
panic occurs, we can just switch buffers (something like this would
also be handy for dual head debugging; one head running your desktop
and the other a debug console printing all the messages).  That's
slightly more invasive surgery though...  I should have a chance to do
something like that as part of the kdb/kms work I'll be doing with
Jason.

-- 
Jesse Barnes, Intel Open Source Technology Center
