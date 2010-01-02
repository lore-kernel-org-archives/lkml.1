Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631Ab0ABOwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0ABOwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 09:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492Ab0ABOwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 09:52:49 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:43815 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0ABOws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 09:52:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ovMREKRkh6t0JuK9u58l4Ov54Dlhq1Fvbnh0es+DSEtDHp3iGXxkbz/yiWzBf+zjbQ
         rug/lXi/gCQlOQSLLfvzR+QIc8z8IbvnPqby2WGL8xJOoBAdVNVdWBh/kkQuyXoEd5K+
         +NSaj2SaS/jVv6wi3P3qmQKmWGS7hDxp5imUg=
Date: Sat, 2 Jan 2010 16:46:07 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: drm: gem_object_free without struct_mutex
Message-ID: <20100102144607.GA10094@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>,
	linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <alpine.LSU.2.00.0912301934070.25797@sister.anvils> <200912302317.48530.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912302317.48530.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 11:17:48PM +0100, Rafael J. Wysocki wrote:
> [CC to Jesse.]
> 
> On Wednesday 30 December 2009, Hugh Dickins wrote:
> > I've changed BUG_ON to WARN_ON in drm_gem.c (patch at bottom) to
> > get this dmesg when I resume after suspend, instead of crashing.
> > 
> > Perhaps it's a patch that should go in, perhaps not, but obviously
> > the real problem lies elsewhere.  Happens with 2.6.33-rc1 and -rc2.
> > 
> > No surprise if I'm stupidly misconfigured to get the "pin power context"
> > error in the first place (.config on demand), but I don't deserve to BUG!
> > 

The problem is dev_priv->mm.suspended which was set in i915_suspend().

In i915_resume()

   107          i915_restore_state(dev);

The i915_restore_state() fails because i915_gem_object_bind_to_gtt()
does this:

        if (dev_priv->mm.suspended)
                return -EBUSY;

   108  
   109          intel_opregion_init(dev, 1);
   110  
   111          /* KMS EnterVT equivalent */
   112          if (drm_core_check_feature(dev, DRIVER_MODESET)) {
   113                  mutex_lock(&dev->struct_mutex);
   114                  dev_priv->mm.suspended = 0;

We do set the dev_priv->mm.suspended here but it's too late.

Not sure the fix though...

regards,
dan carpenter

