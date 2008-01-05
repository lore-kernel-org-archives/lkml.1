Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYAEAFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYAEAFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 19:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYAEAFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 19:05:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:65205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYAEAFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 19:05:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=oMYPQKw4oMZrdlpsbv6KCgd6dvv7wbJk5XQRR98KcdWDQfg/hX5g+ly3kflKnJ/5XggE6o00shKn1CnQGzJVQfQOBOMkX+e1xfxP77gc9mg60py5zpVnyyjUhg3jEEyUhF6gkj/y9ahS1M//RukjRdpeJTCJ6pdBkJ425EFzbhY=
Date: Sat, 5 Jan 2008 01:07:00 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       netdev@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080105000700.GA3224@ami.dom.local>
References: <64bb37e0801040223q17a76565k3c7667a197403ce5@mail.gmail.com> <20080104133031.GA3329@ff.dom.local> <64bb37e0801040721p57ff3d54wc3de00546d1d2ff1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0801040721p57ff3d54wc3de00546d1d2ff1@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 04:21:26PM +0100, Torsten Kaiser wrote:
> On Jan 4, 2008 2:30 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
...
> I'm open for any suggestions and will try to answer any questions.

I'm very glad, thanks!

> The only thing that is sadly not practical is bisecting the borkenout
> mm-patches, as triggering this error is to unreliable /
> time-consuming.

Right, but it seems there are these 2 main suspects here...

> > - is it still vanilla -rc6-mm1; I've seen on kernel list you tried
> > some fixes around raid?
> 
> Yes, without these fixes I can't boot.
> But they should only be run during starting the arrays, so I doubt
> that this is that cause.
> (Also -rc3-mm2 did not need this fix)

You've written vanilla -rc6 is OK. Does it mean -rc6 with these fixes?
I think it would be easier just to start with this working -rc6 and
simply check if we have 'right' suspects, so: git-net.patch and
git-nfsd.patch from -mm1-broken-out, as suggested by Herbert (I hope,
can compile - otherwise you could try the other way: add the whole -mm
and revert these two). Using current gits could complicate this
"investigation". 

> My skbuff-double-free-detector is still in there, but was never triggered.
> 
> > - could you remind this lockdep warning; is it always and the same,
> > always before crash, or no rules?
> 
> ???
> I see no lockdep warning before the crashes.
> I have seen a warning about the dst->__refcnt in dst_release and
> different warnings about list operations.
> 
> I think I have always posted everything I have seen before the
> crashes. (captured via serial console)

So, you mean there are no more of these?:
 
"looked into the log in question and the only other warning was a
 circular locking dependency that lockdep detected around 1.5 hour
 before this warning."
...
"[ 7620.845168] INFO: lockdep is turned off."

> (If you mean the lockdep-problem in -rc6: That is more or less a
> missing annotation during early bootup. The only problem with that is,
> that it will causes lockdep to be turned off and so it can not be used
> to find any real problem. A fix for that is in -mm so I do have
> lockdep on the mm-kernels)
> 
> > - I've seen you looked after double freeing, but this last debug list
> > warning could suggest locking problems during list modification too.
> 
> Yes, but Herbert mentioned double freeing a skb explicit and so I
> tried to catch this.
> I do not know enough about the network core to verify the locking of
> the involved lists.

Right, the list corruption could be because of use after freeing too.

> > - above git-nfsd and git-net tests should be probably repeated with
> > -rc6-mm1 git versions: so vanilla rc6 plus both these -mm patches
> > only, and if bug triggers, with one reversed; btw., since in previous
> > message you mentioned that 50 packages could be not enough to trigger
> > this, these 54 above could make too little margin yet.
> 
> Yes, I think I really need to redo the git-nfsd-test.
> With IOMMU_DEBUG enabled rc6-mm1worked for 52 packages, only a secound
> run of kde-packages triggered it after only 5 packages.
> I don't know what this bug hates about kdeartwork-wallpaper (triggered
> it this time) or kdeartwork-styles.

I didn't read all this thread, so probably I miss many points, but are
you sure there are no problems with filesystem corruption around these
packets or where you compile(?) them (e.g. after these raid problems)?

> Output from the crash with IOMMU_DEBUG (lockdep was enabled, but did
> not trigger):
> [15593.236374] Unable to handle kernel NULL pointer
> dereference<3>list_add corruption. prev->next should be next

Fine! I'll try to look at this. BTW, I guess/hope DEBUG_SLAB etc. are
also on...

Thanks,
Jarek P.
