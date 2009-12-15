Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbZLOAwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbZLOAwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbZLOAwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:52:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:37829 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052AbZLOAwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:52:35 -0500
Date: Mon, 14 Dec 2009 16:47:41 -0800
From: Greg KH <gregkh@suse.de>
To: Justin Madru <jdm64@gawab.com>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: s5k3e2fx.c: reduce complexity by factoring
Message-ID: <20091215004741.GA9279@suse.de>
References: <1260065000-5573-1-git-send-email-jdm64@gawab.com>
 <20091209095700.GA19355@bicker>
 <4B26DA90.7090702@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B26DA90.7090702@gawab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 04:38:40PM -0800, Justin Madru wrote:
> On 12/09/2009 01:57 AM, Dan Carpenter wrote:
> > On Sat, Dec 05, 2009 at 06:03:20PM -0800, Justin Madru wrote:
> >    
> >> I was style fixing some code when I ran into this code.
> >> It seems like the code could be reduced, by factoring the expression.
> >> But this results in a very simple expression.
> >>
> >> Am I assuming something wrong? Or is this a bug in the original code?
> >> This doesn't look right because the assignment of s_move[i] has no mention
> >> of the loop counter.
> >>
> >> Justin
> >>
> >> ------
> >>
> >> the code was looping, seting s_move[i] to the following calculations
> >>
> >> if (actual_step>= 0)
> >>          s_move[i] = ((((i + 1) * gain + 0x200) - (i * gain + 0x200)) / 0x400);
> >> else
> >>          s_move[i] = ((((i + 1) * gain - 0x200) - (i * gain - 0x200)) / 0x400);
> >>
> >> but, by factoring the expression, it can be shown that they both reduce
> >> to a very simple expression:
> >>
> >>          s_move[i] = gain / 0x400;
> >>
> >>      
> > Heh.
> >
> > Looks like an improvement to me.
> >
> > If gain were 16 bits instead of 32 I would think the "* 0x400 / 0x400" was
> > designed to mask out the highest 10 bits.
> >
> > Acked-by:  Dan Carpenter<error27@gmail.com>
> >
> > regards,
> > dan carpenter
> >
> >    
> >> Signed-off-by: Justin Madru<jdm64@gawab.com>
> >> ---
> >>   drivers/staging/dream/camera/s5k3e2fx.c |   10 +++-------
> >>   1 files changed, 3 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
> >> index f0e49be..d205a2d 100644
> >> --- a/drivers/staging/dream/camera/s5k3e2fx.c
> >> +++ b/drivers/staging/dream/camera/s5k3e2fx.c
> >> @@ -1092,14 +1092,10 @@ static int32_t s5k3e2fx_move_focus(int direction, int32_t num_steps)
> >>
> >>   	actual_step = step_direction * (int16_t)num_steps;
> >>   	pos_offset = init_code + s5k3e2fx_ctrl->curr_lens_pos;
> >> -	gain = actual_step * 0x400 / 5;
> >> +	gain = actual_step / 5;
> >>
> >> -	for (i = 0; i<= 4; i++) {
> >> -		if (actual_step>= 0)
> >> -			s_move[i] = ((((i+1)*gain+0x200) - (i*gain+0x200))/0x400);
> >> -		else
> >> -			s_move[i] = ((((i+1)*gain-0x200) - (i*gain-0x200))/0x400);
> >> -	}
> >> +	for (i = 0; i<= 4; i++)
> >> +		s_move[i] = gain;
> >>
> >>   	/* Ring Damping Code */
> >>   	for (i = 0; i<= 4; i++) {
> >> -- 
> >> 1.6.5.4
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>      
> 
> I've yet to see a reply from GregH. Has this patch been misplaced or 
> dropped?
> Or is the patch no longer valid/correct?

It's in my "to-apply" queue.  I was working on the .33-rc1 merge first.
After that comes out I'll get to my patch queue.

thanks,

greg k-h
