Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYGHOIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYGHOIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYGHOIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:08:15 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11834 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYGHOIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:08:13 -0400
Subject: Re: [bug ?] do_get_mempolicy()
From: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reply-To: lee.schermerhorn@hp.com
To: David Rientjes <rientjes@google.com>
Cc: John Blackwood <john.blackwood@ccur.com>, linux-kernel@vger.kernel.org,
       Joe Korty <joe.korty@ccur.com>
In-Reply-To: <alpine.DEB.1.10.0807031440170.17955@chino.kir.corp.google.com>
References: <486D3A4A.6000502@ccur.com>
	 <alpine.DEB.1.10.0807031440170.17955@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 08 Jul 2008 09:43:46 -0400
Message-Id: <1215524626.22680.13.camel@murky.zko.hp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 14:44 -0700, David Rientjes wrote:
> On Thu, 3 Jul 2008, John Blackwood wrote:
> 
> > Hi Lee,
> > 
> > I'm having unexpected results with get_mempolicy(2) in 2.6.26, and
> > I am hoping that you can either agree with me, or maybe comment on my
> > misconceptions.
> > 
> > When I have a task with no special task mempolicy (the default mempolicy),
> > when I call get_mempolicy(2), it returns a policy value of 2 (MPOL_BIND)
> > with a NULL nodemask.
> > 
> > I believe that this is because of the code in do_get_mempolicy() that does:
> > 
> >  *policy |= pol->flags;
> > 
> > in the else case when flags do not contain MPOL_F_NODE.
> > 
> > I guess I don't understand why we are ORing in the pol->flags into the
> > *policy value.  For example, when this is for the default_policy, the
> > MPOL_F_LOCAL flag (which has a value of 2) gets stuffed into the *policy
> > location, and a get_mempolicy(2) caller sees this as the MPOL_BIND
> > mempolicy.
> > 
> > Maybe the "*policy |= pol->flags;" line should be removed ?
> > 
> 
> You're right, the flags member of struct mempolicy has subsequently 
> changed to carry "internal" flags that are not supposed to be exposed to 
> userspace via the get_mempolicy() API.
> 
> The following patch probably fixes it.
> 
> Lee?

David:  Just getting back from long weekend.  This looks good.  I was
thinking that, in addition to masking off the internal flags, we need to
shift the flags into the upper half word.  However, external flags are
already shifted to the correct position, so just the mask is needed.

> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

> ---
>  mm/mempolicy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -729,7 +729,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
>  	} else {
>  		*policy = pol == &default_policy ? MPOL_DEFAULT :
>  						pol->mode;
> -		*policy |= pol->flags;
> +		*policy |= (pol->flags & MPOL_MODE_FLAGS);
>  	}
>  
>  	if (vma) {

