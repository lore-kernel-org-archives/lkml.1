Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZLYAO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZLYAO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 19:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZLYAO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 19:14:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52080 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbZLYAO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 19:14:27 -0500
Date: Thu, 24 Dec 2009 18:14:22 -0600
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
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091225001422.GB22311@us.ibm.com>
References: <20091224022902.GA24234@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224022902.GA24234@heat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Stone (michael@laptop.org):
> Dear kernel folks,
> 
> There are a variety of places where I'd like to be able to get the kernel to
> return EPERM more often [1]. Many of these places already have security hooks.
> 
> Unfortunately, I don't feel that I can make effective use of these hooks
> because they seem to be "occupied" by the large mandatory access control
> frameworks.
> 
> I'm hoping that you can tell me why this state of affairs persists.
> 
> More specifically, now that LSMs are statically linked, why is it good for the
> security hooks to call into a single monolithic "security_ops" struct instead
> of cheaper and simpler alternatives?
> 
> In particular, what would be worse about a kernel in which each security hook
> contained nothing but conditionally-compiled function calls to the appropriate
> "real" implementation functions with early-exit jumps on non-zero return codes?

The problem is that composing any two security policies can quickly have
subtle, unforeseen, but dangerous effects.  That's why so far we have
stuck with the status quo where only one LSM is 'active', but that LSM
can manually call hooks from other LSMs.

So with your module, I'd recommend following the route of the capabilities
LSM.  You can provide an optional stand-alone LSM which only hooks your
functions.  Then smack, for instance, can call the functions in your LSM
from within its own hooks, or it can simply explicitly assign its hooks to
your functions in smack_ops.  Selinux can do the same thing, although I
suspect they would more likely implement their own functions for your newly
hooked sites.

A distro can then compile a kernel with all LSMs compiled in, and switch
behavior by using "security=selinux" vs. "security=prctl_network_lsm"

-serge
