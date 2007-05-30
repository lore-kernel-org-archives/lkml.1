Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbXE3RGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbXE3RGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXE3RG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:06:27 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48182 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXE3RG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:06:26 -0400
Date: Wed, 30 May 2007 22:44:05 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Kirill Korotaev <dev@sw.ru>, kernel@kolivas.org, tong.n.li@intel.com,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070530171405.GA21062@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070523183824.GA7388@elte.hu> <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070526154112.GA31925@holomorphy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 08:41:12AM -0700, William Lee Irwin III wrote:
> The smpnice affair is better phrased in terms of task weighting. It's
> simple to honor nice in such an arrangement. First unravel the
> grouping hierarchy, then weight by nice. This looks like
> 
> task    nice    hier1   hier2   ...     hierN
> t_1     w_n1    w_h11   w_h21   ...     w_hN1
> t_2     w_n2    w_h12   w_h22   ...     w_hN2
> ...
> 
> For the example of nice 0 vs. nice 10 as distinct users with 10%
> steppings between nice levels, one would have
> 
> task    nice   hier1
> t_1     1      1
> t_2     0.3855 1
> 
> w_1, the weight of t_1, would be
>         (w_h11*w_n1/(w_h11*w_n1 + w_h12*w_n2))
>                 = (1*1/(1 + 1*0.3855..))
>                 = 0.7217..
> w_2, the weight of t_2, would be
>         (w_h12*w_n2/(w_h11*w_n1 + w_h12*w_n2))
>                 = (1*0.3855../(1 + 1*0.3855..))
>                 = 0.27826..
> This just so happens to work out to being the same as if t_1 and t_2
> had their respective nice numbers without the scheduler grouping, which
> is basically what everyone wants to happen.
> 
> It's more obvious how to extend it to more tasks than levels of
> hierarchy. An example of that follows:
> 
> task    nice    hier1   hier2   ...     hierN
> t_1     0.3     0.6     *       ...     *
> t_2     0.7     0.4     *       ...     *
> 
> hier2 through hierN are ignorable since t_1 and t_2 are both the only
> members at those levels of hierarchy. We then get something just like
> the above example, w_1 = 0.3*0.6/(0.3*0.6+0.7*0.4) = 0.3913.. and
> w2 = 0.7*0.4/(0.3*0.6+0.7*0.4) = 0.6087..
> 
> It's more interesting with enough tasks to have more meaningful levels
> of hierarchy.
> 
> task    nice    hier1   hier2
> t_1     0.7     0.6     0.6
> t_2     0.3     0.6     0.4
> t_3     0.7     0.4     0.6
> t_4     0.3     0.4     0.4
> 
> where t_1 and t_2 share a hier1 grouping and t_3 and t_4 also share
> a hier1 grouping, but the hier1 grouping for t_1 and t_2 is distinct
> from the hier1 grouping for t_3 and t_4. All hier2 groupings are
> distinct. So t_1 would have pre-nice weight 0.6*0.6, t_2 0.6*0.4,
> t_3 0.6*0.4, and t_4 0.4*0.4 (the numbers were chosen so denominators
> conveniently collapse to 1). Now that the hierarchy is flattened,
> nice numbers can be factored in for t_1's final weight being
> 0.7*0.36/(0.7*0.36+0.3*0.24+0.7*0.24+0.3*0.16) = 0.252/0.54 = 0.467..
> and the others being 0.133.. (t_2), 0.311.. (t_3), and 0.0889.. (t_4).

Hmm ..so do you think this weight decomposition can be used to flatten
the tree all the way to a single level in case of cfs? That would mean we can 
achieve group fairness with single level scheduling in cfs ..I am
somewhat skeptical that we can achieve group fairness with a single
level rb-tree (and w/o substantial changes to pick_next_task logic in cfs
that is), but if it can be accomplished would definitely be a great win.

> In such a manner nice numbers obey the principle of least surprise.

-- 
Regards,
vatsa
