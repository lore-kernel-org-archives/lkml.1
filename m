Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZKSUsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZKSUsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZKSUsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:48:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:40504 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZKSUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:48:50 -0500
Date: Thu, 19 Nov 2009 20:48:47 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Jerome Glisse <jglisse@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net
Subject: Re: [PATCH] drm/radeon/kms: Fix oops when set_base is call with no
 FB
In-Reply-To: <1258023778.2473.2.camel@localhost>
Message-ID: <alpine.LFD.2.00.0911181852050.23795@casper.infradead.org>
References: <1257361399-5128-1-git-send-email-jglisse@redhat.com> <20091110143056.defb1a82.akpm@linux-foundation.org> <1258023778.2473.2.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, 2009-11-10 at 14:30 -0800, Andrew Morton wrote:
> > On Wed,  4 Nov 2009 20:03:19 +0100
> > Jerome Glisse <jglisse@redhat.com> wrote:
> > 
> > > Just do nothings crct_set_base i call with no FB.
> > > 
> > 
> > hmpf.  It's obvious that you spent hours carefully describing this
> > patch for us.
> > 
> 
> Sorry, truth is i don't understand why crtc set_base call back
> can be call with a null fb, i did just replicate what intel kms
> and other part of radeon kms was doing in front of such situation.
> It should go down to 2.6.31, useless before as there is no KMS
> for radeon in earlier version. The oops will happen when user
> switch btw X & vt or in some case when changing mode.
> 
> Will clearly state my ignorance in future patch.

	The secert to understanding why a oops occurs is to look at the
function drm_crtc_helper_set_config in drm_crtc_helper.c. This function is 
called  by both drm_fb_helper_set_par and drm_fb_helper_pan_display as 
well as from userland attempting to set a mode via the dri layer. The 
code path for this last case is drm_mode_setcrtc in drm_crtc.c. 
	 In the userland setting case drm_mode_setcrtc() test to see if a 
drm_framebuffer is avaliable. Either by user requesting a specific fb or
by using the default fb from the drm_crtc. If no fb is found then the 
function returns a error. So the user must prepare a framebuffer before 
hand.
	Now the second case is the fbdev emulation layer calling 
drm_crtc_helper_set_config. First in this method we have two states, 
mode_change and fb_change. The first test is to see if crtc->fb equals
the desired fb. If the crtc->fb or the desired fb is NULL it is considered 
a full mode change. If we have do have both fb which are not the same 
objects then we expect a fb_change. This is true also we want any panning.
After that we test if the drm_display_mode passed in and the crtc->mode 
are equal. If not then it is a mode_change. Now if the driver doesn't 
support set_base then it is always a mode_change.
	After all the testing we are ready to change the hardware state. 
In the mode_change case we save the original fb which is crtc->fb. Then we
set the crtc->fb to the new fb and then call our function. 

	old_fb = set->crtc->fb;
        set->crtc->fb = set->fb;
	...
        drm_crtc_helper_set_mode(set->crtc, set->mode, set->x, set->y, 
				old_fb)
In the fb_change case we also shuffle the fbs like above and call the 
following.

	old_fb = set->crtc->fb;
        if (set->crtc->fb != set->fb)
            set->crtc->fb = set->fb;
        ret = crtc_funcs->mode_set_base(set->crtc, set->x, set->y, 
					old_fb);


Okay now to the problem with the fbdev emulation layer. If you look at
drm_fb_helper_single_fb_probe you will notice a new drm_framebuffer could 
be created. Now the following field at set to this new fb:

  modeset->fb
  fb_helper->fb

If you notice no crtc->fb is set. This what causes the problems. Even more 
interesting is the conditional check in drm_fb_helper_set_par.

if (crtc->fb == fb_helper->crtc_info[i].mode_set.fb) {

But because crtc->fb is null the mode is never changed. I repeat the 
set_par function never changes the graphics mode. The worst part is the 
var for the framebuffer console ends up out of sync with the dri layer
if someone attempts to change the mode via the fbdev layer. So what is 
setting the default graphics mode. Actually it's the panning function 
drm_fb_helper_pan_display. You will notice that the fb is never checked 
there.






