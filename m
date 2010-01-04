Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018Ab0ADXSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0ADXSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867Ab0ADXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:18:40 -0500
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:35385 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753643Ab0ADXSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:18:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KRHFHp5wfebjqk5R2gf21a149wMeDDkS4yfoUKAwLd62NFnDJhyJdAmCzfGcnTf8ukeBkpfrRUEg4neNECdNwT466oTvhE149cBq3+qQ+389kRLOVBxsxUt/qy3SS8GK;
Date: Mon, 4 Jan 2010 15:18:35 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dan Carpenter <error27@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: drm: gem_object_free without struct_mutex
Message-ID: <20100104151835.2dbd3b91@jbarnes-piketon>
In-Reply-To: <20100102144607.GA10094@bicker>
References: <alpine.LSU.2.00.0912301934070.25797@sister.anvils>
	<200912302317.48530.rjw@sisk.pl>
	<20100102144607.GA10094@bicker>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jan 2010 16:46:07 +0200
Dan Carpenter <error27@gmail.com> wrote:

> On Wed, Dec 30, 2009 at 11:17:48PM +0100, Rafael J. Wysocki wrote:
> > [CC to Jesse.]
> > 
> > On Wednesday 30 December 2009, Hugh Dickins wrote:
> > > I've changed BUG_ON to WARN_ON in drm_gem.c (patch at bottom) to
> > > get this dmesg when I resume after suspend, instead of crashing.
> > > 
> > > Perhaps it's a patch that should go in, perhaps not, but obviously
> > > the real problem lies elsewhere.  Happens with 2.6.33-rc1 and
> > > -rc2.
> > > 
> > > No surprise if I'm stupidly misconfigured to get the "pin power
> > > context" error in the first place (.config on demand), but I
> > > don't deserve to BUG!
> > > 
> 
> The problem is dev_priv->mm.suspended which was set in i915_suspend().
> 
> In i915_resume()
> 
>    107          i915_restore_state(dev);
> 
> The i915_restore_state() fails because i915_gem_object_bind_to_gtt()
> does this:
> 
>         if (dev_priv->mm.suspended)
>                 return -EBUSY;
> 
>    108  
>    109          intel_opregion_init(dev, 1);
>    110  
>    111          /* KMS EnterVT equivalent */
>    112          if (drm_core_check_feature(dev, DRIVER_MODESET)) {
>    113                  mutex_lock(&dev->struct_mutex);
>    114                  dev_priv->mm.suspended = 0;
> 
> We do set the dev_priv->mm.suspended here but it's too late.
> 
> Not sure the fix though...

I think this one should be fixed by Chris's recent patchset.  Should
land in Eric's tree soon.

-- 
Jesse Barnes, Intel Open Source Technology Center
