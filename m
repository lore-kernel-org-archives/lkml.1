Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbZLTRyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbZLTRyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZLTRyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:54:06 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52678 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbZLTRyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:54:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XqQw1Tkm8MR7fgF0AL6tgagCiywNIOonzOKoSzAW2MoCwWnCam7b8YbWQutqJJcfJO
         Dv217kXrDQLHUgAGd67/PYVVsaWHccdojvXChQVgTMNSvG5h47lInhQZEsxqY+3F6apj
         nkbBLtjU9opFcWiB0BXhaqAfnozfiQRobHSnc=
MIME-Version: 1.0
In-Reply-To: <20091218030056.GC3047@heat>
References: <20091217.225856.145758950057800056.mrs@deli>
	 <20091218030056.GC3047@heat>
Date: Sun, 20 Dec 2009 17:53:58 +0000
X-Google-Sender-Auth: df0e82076352a4e5
Message-ID: <fb69ef3c0912200953x2546f03cs5a88c9a54fd750ee@mail.gmail.com>
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
From: Mark Seaborn <mrs@mythic-beasts.com>
To: Michael Stone <michael@laptop.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 3:00 AM, Michael Stone <michael@laptop.org> wrote:

> @Eric, Mark: regarding ptrace()-ing from network-disabled processes: I agree
> that this functionality is critical and I have altered the
> __ptrace_may_access() check to support it.
> The new rule I propose is equivalent to the rule I used in ptrace_set_network()
> and is similar to the rule that Eric proposed earlier this afternoon. I now
> propose:
>
>  "You may ptrace() any process that has all the network restrictions you do."
>
> This should take care of your use of strace without bending anything else into
> an unnatural shape.

I am in two minds about this.  On the one hand, it adds the
flexibility that I asked for.  On the other hand, it is a more
complicated rule to have fixed in the kernel.

It still seems wrong to me that the disable-networking flag should
affect ptrace() at all.

The reason is that the disable-networking flag is not useful on its
own.  Anyone who uses it will use it in combination with some other
authority-limiting mechanism.  They will already have a story for how
to prevent sandboxed processes with interfering with other processes
via ptrace(), kill(), writing to ~/.bashrc, etc.  There's no point in
disabling network access for a process if it has full access to your
home directory and can cause programs to be run with your full
authority as a user.

So if there is already a way to control access to ptrace(), we
shouldn't add another check to the kernel's access control rules.
They are complicated enough already.


On ad-hocness: I am very much in favour of providing unprivileged
mechanisms for switching off sources of ambient authority.  But it
does not seem very useful to provide an unprivileged mechanism to
switch off network access if there is no unprivileged mechanism for
switching off access to the filesystem namespace, which is usually a
more important source of authority.  Maybe we should solve both
problems?

Cheers,
Mark
