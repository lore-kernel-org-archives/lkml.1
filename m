Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257Ab0ANQrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab0ANQrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 11:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880Ab0ANQrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 11:47:21 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49288 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab0ANQrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 11:47:19 -0500
Date: Thu, 14 Jan 2010 10:47:02 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Michael Stone <michael@laptop.org>, Andrew Morgan <morgan@kernel.org>
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
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@ZenIV.linux.org.uk>, Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100114164702.GA13439@us.ibm.com>
References: <20100114150039.GB6322@us.ibm.com>
 <20100114163645.GA6230@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114163645.GA6230@heat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Stone (michael@laptop.org):
> >Quoting Pavel Machek (pavel@ucw.cz):
> >> > Quoting Michael Stone (michael@laptop.org):
> >> > > Serge Hallyn wrote:
> >> > > >Michael, I'm sorry, I should go back and search the thread for the
> >> > > >answer, but don't have time right now - do you really need
> >> > > >disablenetwork to be available to unprivileged users?
> >> > > > > > Rainbow can only drop the networking privileges when
> >we know at app launch time
> >> > > (e.g. based on a manifest or from the human operator) that privileges can be
> >> > > dropped. Unfortunately, most of the really interesting uses of disablenetwork
> >> > > happen *after* rainbow has dropped privilege and handed control the app.
> >> > > Therefore, having an API which can be used by at least some low-privilege
> >> > > processes is important to me.
> >> > > > > > >is it ok to require CAP_SETPCAP (same thing required
> >for dropping privs from
> >> > > >bounding set)?
> >> > > > > > Let me try to restate your idea:
> >> > > > > >   We can make disablenetwork safer by permitting its
> >use only where explicitly
> >> > >   permitted by some previously privileged ancestor. The securebits facility
> >> > >   described in
> >> > > > > >     http://lwn.net/Articles/280279/
> >> > > > > >   may be a good framework in which to implement this
> >control.
> >> > > > > > Did I understand correctly? If so, then yes, this
> >approach seems like it would
> >> > > work for me.
> >> > > > That is a little more than I was saying this time though I
> >think I
> >> > suggested it earlier.
> >> > > > But really I don't think anyone would care to separate a
> >system into
> >> > some processes allowed to do unprivileged disablenetwork and other
> >> > processes not allowed to, so a (root-owned mode 644) sysctl seems just
> >> > as useful.
> >> > Global solution like that is always wrong. (And we have better
> >> solution available.)
> >
> >All right, so Michael suggested securebits, I personally feel prctl would
> >be more appropriate.
> 
> I'm happy with either approach so I'll prepare patches based on Serge's
> suggestion first.

Ah - but I worry that if you do that Alan or others will object.  Where do
you plan to store the disablenet_allowed bit?  You can use security_prctl()
to keep the code out of sys_prctl(), but you still have the question of
whether you add a bit to the task struct, use task->security and not stack
with selinux, use a thread flag, or try to enable stacking of task->security.

To me securebits are all about capability hacks, but their name is more
generic than that :), so maybe they are appropriate after all.  Andrew Morgan,
would you object to using securebits to store the fact that a privileged
process has said "from now on an unprivileged process may call disablenetwork"?

-serge
