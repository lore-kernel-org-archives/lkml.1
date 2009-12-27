Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZL0DEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZL0DEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 22:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZL0DEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 22:04:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZL0DEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 22:04:12 -0500
X-Authority-Analysis: v=1.0 c=1 a=igne1qBhNWMA:10 a=Op-mwl0xAAAA:8 a=SzAbGp5KEjVXmnKxPlEA:9 a=K5-J2EMxqUMrc6rXpqUA:7 a=72pCHJrbqPX5b2mekUqDA0mS2zIA:4 a=d4CUUju0HPYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 70.124.57.33
Date: Sat, 26 Dec 2009 21:16:31 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Michael Stone <michael@laptop.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
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
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091227031631.GA17629@hallyn.com>
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091226195043.GA1945@heat>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Stone (michael@laptop.org):
> Now, given this argument, what do you actually think about systems that, like
> your work, enable stacking but which do so "less automatically", e.g. by
> hand-writing the implementations of the security_*() hooks like so:
>
>   int security_socket_create(int family, int type, int protocol, int 
> kern)   {
>           int ret = 0;
>
>   #ifdef CONFIG_SECURITY_SELINUX
>           ret = selinux_security_socket_create(family, type, protocol, kern);
>           if(ret)
>                   goto out;
>   #endif
>
>   #ifdef CONFIG_SECURITY_TOMOYO
>           ret = tomoyo_security_socket_create(family, type, protocol, kern);
>           if(ret)
>                   goto out;
>   #endif
>
>   #ifdef CONFIG_SECURITY_SMACK
>           ret = smack_security_socket_create(family, type, protocol, kern);
>           if(ret)
>                   goto out;
>   #endif
>
>   #ifdef CONFIG_SECURITY_PRCTL_NETWORK
>           ret = prctl_network_socket_create(family, type, protocol, kern);
>           if(ret)
>                   goto out;
>   #endif
>
>   out:
>           return ret;
>   }
>
> This way, the behavior of the system is as predictable as possible, we can
> statically check for known unsafe configurations, manual tweaking of the order
> in which functionality is composed is possible, and security is fully
> "pay-as-you-go".
>
> Where is the flaw in this approach?

Well, according to Mimi's email this is essentially what was
decided upon for IMA.  So I think workable guidelines would
be that anything which can't possibly be expected to interfere
with other LSMs can be added like that.  

More generally, the flaw in the approach is that the hooks for
several permutations of LSMs might interfere with each other.
So for instance the cap_inode_setxattr() hook should always
be called if selinux is not enabled, but should not be called
for security.selinux namespace xattrs if selinux is enabled.
Rather than try to capture all the permutations in one
security_socket_create() hook, we would want to just arrange
some stacking orders, and have the 'parent' hooks call the
'child' hooks.  That is precisely what I was suggesting in my
previous posts.

Oh, you'll also want to take into consideration whether
the LSM is actively loaded, since I can compile a kernel
with smack, SELinux, TOMOYO, and your system, but only
load smack.  So just #ifdef isn't enough.  Just a note.

Anyway, your LSM may be specific enough to qualify for the
IMA treatment (like you suggest).  So no harm in trying :)
But I wouldn't try to overly generalize the stacking, as I'd
fear it risks becoming a drag on the acceptence of the rest of
your patch.

-serge
