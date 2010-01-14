Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095Ab0ANPII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0ANPII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932271Ab0ANPHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:07:17 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59655 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab0ANPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:03 -0500
Date: Thu, 14 Jan 2010 09:00:39 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
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
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100114150039.GB6322@us.ibm.com>
References: <20100111174922.GA17285@us.ibm.com>
 <20100112061058.GA5231@heat>
 <20100112155246.GA9255@us.ibm.com>
 <20100114092328.GB11500@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114092328.GB11500@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@ucw.cz):
> > Quoting Michael Stone (michael@laptop.org):
> > > Serge Hallyn wrote:
> > > >Michael, I'm sorry, I should go back and search the thread for the
> > > >answer, but don't have time right now - do you really need
> > > >disablenetwork to be available to unprivileged users?
> > > 
> > > Rainbow can only drop the networking privileges when we know at app launch time
> > > (e.g. based on a manifest or from the human operator) that privileges can be
> > > dropped. Unfortunately, most of the really interesting uses of disablenetwork
> > > happen *after* rainbow has dropped privilege and handed control the app.
> > > Therefore, having an API which can be used by at least some low-privilege
> > > processes is important to me.
> > > 
> > > >is it ok to require CAP_SETPCAP (same thing required for dropping privs from
> > > >bounding set)?
> > > 
> > > Let me try to restate your idea:
> > > 
> > >   We can make disablenetwork safer by permitting its use only where explicitly
> > >   permitted by some previously privileged ancestor. The securebits facility
> > >   described in
> > > 
> > >     http://lwn.net/Articles/280279/
> > > 
> > >   may be a good framework in which to implement this control.
> > > 
> > > Did I understand correctly? If so, then yes, this approach seems like it would
> > > work for me.
> > 
> > That is a little more than I was saying this time though I think I
> > suggested it earlier.
> > 
> > But really I don't think anyone would care to separate a system into
> > some processes allowed to do unprivileged disablenetwork and other
> > processes not allowed to, so a (root-owned mode 644) sysctl seems just
> > as useful.
> 
> Global solution like that is always wrong. (And we have better
> solution available.)

All right, so Michael suggested securebits, I personally feel prctl would
be more appropriate, but in any case the suggestion then is:

foo_enable_disablenet() is either prctl(PR_ALLOW_DISABLENET) or
prctl(PR_SET_SECUREBITS, (1 << PR_ALLOW_DISABLENET) | (1 << PR_ALLOW_DISABLENET_LOCK))
and it requires privilege (CAP_NET_ADMIN presumably) to make this call.

prctl(PR_SET_DISABLENETWORK), or whatever Michael was using, does not
require privilege, but requires that foo_enable_disablenet() have been
previously called by a privileged app.

-serge
