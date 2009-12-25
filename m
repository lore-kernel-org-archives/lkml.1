Return-Path: <linux-kernel-owner+w=401wt.eu-S1751787AbZLYFuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbZLYFuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 00:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbZLYFun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 00:50:43 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35035 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZLYFum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 00:50:42 -0500
Date: Thu, 24 Dec 2009 23:50:34 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091225055034.GA374@us.ibm.com>
References: <20091225001422.GB22311@us.ibm.com>
 <20091225011128.GA5213@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091225011128.GA5213@heat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Stone (michael@laptop.org):
> Serge Hallyn writes:
> >Michael Stone writes:
> >>In particular, what would be worse about a kernel in which each security hook
> >>contained nothing but conditionally-compiled function calls to the appropriate
> >>"real" implementation functions with early-exit jumps on non-zero return codes?
> >
> >The problem is that composing any two security policies can quickly have
> >subtle, unforeseen, but dangerous effects.
> 
> First, thanks very much for your helpful explanations and pragmatic advice.
> 
> Second, two thoughts and a question:
> 
>   1. I think you're probably correct when we're discussing security policies
>      chosen uniformly at random from the space of all possible such policies.
>      However, I believe that the cost-benefit ratio favors composition quite
>      strongly when we're discussing real security policies which where designed
>      with composition in mind, as is the case with my work.
> 
>   2. The problem you cite is an inherent property of software assurance which
>      is indepedent of software assurance of information-security-specific
>      properties. Thus, while you are correct that composition sometimes makes
>      it harder to assure a system due to the increased number of "moving
>      parts" that have to fit together perfectly, it also frequently makes the
>      assurance problem more tractable by reducing the cost to assure the
>      individual pieces which are being composed.
> 
>   3. Have you any specific examples of problems that have been clearly averted
>      by the current arrangement?

If you look back over the archives of when I was pushing the LSM stacker
around 2005, there were several cases where just stacking capability and
selinux were problematic.

http://lkml.indiana.edu/hypermail/linux/kernel/0507.1/0814.html may have
been one instance.  (I don't have local archive before 2006 and don't
really care to search atm)

> >So with your module, I'd recommend following the route of the capabilities
> >LSM. You can provide an optional stand-alone LSM which only hooks your
> >functions. Then smack, for instance, can call the functions in your LSM
> >from within its own hooks, or it can simply explicitly assign its hooks to
> >your functions in smack_ops.  Selinux can do the same thing, although I
> >suspect they would more likely implement their own functions for your newly
> >hooked sites.
> 
> Doesn't it seem a bit strange to you to be recommending that everyone else
> using the five security hooks I want to use modify their code *in detail* to
> support my functionality given that my functionality is explicitly intended not
> to require any such work on their part?

Not at all.  It seems prudent.  And it's really not an intrusive change -
i.e. look at security/selinux/hooks.c:selinux_ptrace_access_check() calling
cap_ptrace_access_check().

> This seems frankly silly to me, not to mention expensive and error-prone.
> 
> Instead, perhaps we'd be better off with something like a declarative
> compile-time whitelist or blacklist for compositions?

Well, taking a step back - what exactly is the motivation for making this
an LSM?  Is it just to re-use the callsites?  Or to provide a way to turn
off the functionality?  I ask bc the API is in the prctl code, so the LSM
is conceptually always there, which is different from other LSMs.

So if you (or your audience) really want this to be an LSM, then you should
probably put your prctl code in a security_task_prctl() hook.  Otherwise,
perhaps we should just explicitly call your hooks in wrappers - or whatever was
finally decided should be done with the security/integrity/ima hooks.

-serge
