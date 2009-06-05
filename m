Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbZFEOND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbZFEOND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZFEOMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:12:54 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37367 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbZFEOMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LeNQtJ/LMMy1nqIAzqErzQ8R13222+UDAS3i6rHLIQoNmSoV/nBZimOUYGywqxixJ4
         c9Q2qi729Rz8PdwrSktSHJ/YX+Y1RWaC4YdcXgnycN8bdL7RIc+5x2QpFrclXaNdF5Gn
         M1E2TwkBMcPRCsJTjcYLRdmk2MJqAc0pJg7ZY=
MIME-Version: 1.0
In-Reply-To: <4A288F85.6010809@tlinx.org>
References: <4A288F85.6010809@tlinx.org>
Date: Fri, 5 Jun 2009 16:12:53 +0200
Message-ID: <4e5e476b0906050712m33d3cd70kdf60434723f131c1@mail.gmail.com>
Subject: Re: ionice priority "none: prio 0" v. "none: prio 1" v. best-effort 
	v. idle?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linda,
the ioprio class 'none' is the default class in which all processes
are put when created, if not specified otherwise (this is in contrast
with what I read in the man page, where it says Best Effort is the
default).
For CFQ (other io schedulers just ignore it), the 'none' class has a
special meaning, in fact, looking at:
http://git.kernel.org/?p=linux/kernel/git/aegl/linux-2.6.git;a=blob;f=block/cfq-iosched.c;h=a55a9bd75bd1baf616a3a1b7118acaeee328759f;hb=HEAD#l1579
you will see that for processes with class 'none', the class and
priority will be inherited from CPU scheduling (including RT
scheduling & nice levels).

HTH,
Corrado

On Fri, Jun 5, 2009 at 5:22 AM, Linda Walsh<lkml@tlinx.org> wrote:
> <-- vim: se sts=4 sw=4 ts=8 nosi sc ai: /--> I was looking at the output of
> ionice on the various processes
> running.
>
> Other than one I set for 'best-effort' (-c2), the rest all had
> priorities of
>   1) "none: prio 0"
> OR
>   2) "none: prio 4"
>
> Out of 183 process:
>
>  79 had "none: prio 0"   and
> 103 had "none: prio 4"
> (1 had "best effort, prio 4").
>
> Where does priority class  'none' fit in?  above or below 'idle'?
>
> Or is 'none' equal to 'best effort' (which is logical in once sense, but
> strictly, I could argue 'none' is at least below 'best effort', and possibly
> below idle, as 'idle' at least has been assigned a scheduling priority
> (vs. processes that have not -- BUT, but definition, idle is clearly meant
> to be lower precedence, so that would argue, logically, that 'none' is
> above idle and below 'best_effort' (since processes with no assigned
> priority would logically be below those assigned as 'best effort'.
>
> Within 'besteffort', 0=high, and 7=low.
>
> Is the same true in 'none', or are the values 'meaningless'?
> (In which case, why do they all exist at either 4 or 0?)
>
> Since the iopriority DOES NOT correlate with either
> the cpu priority nor 'nice' value, then how are different
> processes assigned different priority values?
> They *seem* to be mostly fixed, but very rarely I'll see maybe
> 1 process toggle from 0 to 4 or back (but its usually fixed).
>
> So why is everything in the 'none' class at either "highest level" (prio
> 0), OR the mid level of prio=4?  Um...found exception on a 32-bit i386
> based kernel, all prio's are "none: prio 0". But two different x86_64 bit
> kernels have "a split", majority in none:prio 4, and a minority of
> 25-44% in 'none:prio 4'.
>
> I'm using the cfq scheduler on all 3 machines.
>
> So what is it with 'schedclass'=none?  Is it lower than 'best effort'?  (I'd
> hope so, or like to see it that way, but wants are nice...:-))...
>
> If they *ARE* the same, why are 44% running at highest priority
> (regardless of cpu prio, 'nice' value, user-id, and the rest at 'mid')?
>
> Why so random, but worse, why put any at 'highest' (unless they
> ask for it).  Wouldn't 'mid' priority be consistent with 'mid-cpu-nice'
> value of 0 (out of +/-19)?
>
> FWIW -- I thought once the priorities varied dynamically based on
> cpu-nice levels (for cfq, anyway)...it would be VERY nice to see that
> reflected in the readable ionice data for those processes.
>
> Thanks for clarification/enlightenment...
> Linda
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
