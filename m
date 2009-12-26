Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZLZTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZLZTsl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 14:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZLZTsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 14:48:40 -0500
Received: from lists.laptop.org ([18.85.2.145]:56233 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752675AbZLZTsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 14:48:39 -0500
Date: Sat, 26 Dec 2009 14:50:44 -0500
From: Michael Stone <michael@laptop.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
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
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Michael Stone <michael@laptop.org>
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091226195043.GA1945@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091225055034.GA374@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, taking a step back - what exactly is the motivation for making this
> an LSM? Is it just to re-use the callsites?

Yes. Alan Cox, referencing earlier versions of my patches, wrote:

   "This is a security model, it belongs as a security model using LSM."

> I ask bc the API is in the prctl code, so the LSM
> is conceptually always there, which is different from other LSMs.

The goal is to provide a stupidly simple unprivileged per-process network
isolation primitive which is broadly available "without jumping through hoops".

(See http://cr.yp.to/unix/disablenetwork.html for a nice writeup.) 

I need a primitive like this to further my work on the OLPC Bitfrost security
architecture and to further my more general work on advancing the state of
sandboxing technology. (See sandboxing.org.)

I'm willing to entertain pretty much any implementation or interface request
which meets that goal and which implements the desired semantics.

>>>> In particular, what would be worse about a kernel in which each security
>>>> hook contained nothing but conditionally-compiled function calls to the
>>>> appropriate "real" implementation functions with early-exit jumps on
>>>> non-zero return codes?
>>>
>>> The problem is that composing any two security policies can quickly have
>>> subtle, unforeseen, but dangerous effects.
>> 
>> Have you any specific examples of problems that have been clearly averted
>> by the current arrangement?
>
> If you look back over the archives of when I was pushing the LSM stacker
> around 2005, there were several cases where just stacking capability and
> selinux were problematic.

Thank you for the pointers to your earlier work and for the work itself. We
probably wouldn't be having this conversation if your work had been merged.
Unfortunately, that happy event did not come to pass.

Thus, returning to today: the most serious objection that I've heard so far
about LSM stacking is that making it too "automatic" is likely to result in
preventable security faults.

For this argument to be valid, there *must* also be a second clause which
states that the cost of the unknown security faults prevented by making
stacking hard exceeds the cost of the known security faults which would be
prevented by the additional security primitives that stacking, in any usable
form, would permit. Otherwise, the sustaining the objection leads to a worse
outcome. 

Now, given this argument, what do you actually think about systems that, like
your work, enable stacking but which do so "less automatically", e.g. by
hand-writing the implementations of the security_*() hooks like so:

   int security_socket_create(int family, int type, int protocol, int kern) 
   {
           int ret = 0;

   #ifdef CONFIG_SECURITY_SELINUX
           ret = selinux_security_socket_create(family, type, protocol, kern);
           if(ret)
                   goto out;
   #endif

   #ifdef CONFIG_SECURITY_TOMOYO
           ret = tomoyo_security_socket_create(family, type, protocol, kern);
           if(ret)
                   goto out;
   #endif

   #ifdef CONFIG_SECURITY_SMACK
           ret = smack_security_socket_create(family, type, protocol, kern);
           if(ret)
                   goto out;
   #endif

   #ifdef CONFIG_SECURITY_PRCTL_NETWORK
           ret = prctl_network_socket_create(family, type, protocol, kern);
           if(ret)
                   goto out;
   #endif

   out:
           return ret;
   }

This way, the behavior of the system is as predictable as possible, we can
statically check for known unsafe configurations, manual tweaking of the order
in which functionality is composed is possible, and security is fully
"pay-as-you-go".

Where is the flaw in this approach?

Regards,

Michael

P.S. - I think I will write up some new patches for prctl_network based on this
idea so that we can see what they look like.
