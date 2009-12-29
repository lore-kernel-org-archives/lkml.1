Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZL2V1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZL2V1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZL2V1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:27:22 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40069 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZL2V1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:27:21 -0500
Date: Tue, 29 Dec 2009 15:27:22 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091229212722.GA20178@us.ibm.com>
References: <20091229050114.GC14362@heat>
 <m1y6km11lj.fsf@fess.ebiederm.org>
 <20091229151146.GA32153@us.ibm.com>
 <3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
 <20091229163939.GA6984@us.ibm.com>
 <3e8340490912290901y60d7daf2w5778c25f44972955@mail.gmail.com>
 <m1fx6ty6ds.fsf@fess.ebiederm.org>
 <3e8340490912291108t7e000e75p8264fa585f831464@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e8340490912291108t7e000e75p8264fa585f831464@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bryan Donlan (bdonlan@gmail.com):
> On Tue, Dec 29, 2009 at 1:36 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > Bryan Donlan <bdonlan@gmail.com> writes:
> >
> >> On Tue, Dec 29, 2009 at 11:39 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >>> Quoting Bryan Donlan (bdonlan@gmail.com):
> >>>> On Tue, Dec 29, 2009 at 10:11 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >>>> > Eric, let me specifically point out a 'disable setuid-root'
> >>>> > problem on linux: root still owns most of the system even when
> >>>> > it's not privileged.  So does "disable setuid-root" mean
> >>>> > we don't allow exec of setuid-root binaries at all, or that
> >>>> > we don't setuid to root, or that we just don't raise privileges
> >>>> > for setuid-root?
> >>>>
> >>>> I, for one, think it would be best to handle it exactly like the
> >>>> nosuid mount option - that is, pretend the file doesn't have any
> >>>> setuid bits set. There's no reason to deny execution; if the process
> >>>> would otherwise be able to execute it, it can also copy the file to
> >>>> make a non-suid version and execute that instead. And some programs
> >>>> can operate with reduced function without setuid. For example, screen
> >>>> comes to mind; it needs root to share screen sessions between multiple
> >>>> users, but can operate for a single user just fine without root, and
> >>>> indeed the latter is usually the default configuration.
> >>>
> >>> That's fine with me, seems safe for a fully unprivileged program to
> >>> use, and would make sense to do through one of the securebits set
> >>> with prctl(PR_SET_SECUREBITS).
> >>>
> >>> In addition, I assume we would also refuse to honor file capabilities?
> >>
> >> Yes - essentially a one-time switch saying "never allow me to gain
> >> capabilities again".
> >
> > That is what I was thinking.  Does setresuid case problems?  Assuming
> > the application that drop permissions could have successfully
> > called setresuid?
> 
> It's probably reasonable to require that real == effective == saved ==
> fs UID (and same for GID); anything else brings up sticky issues of
> "which UID is a higher capability?"

I think i disagree.  A uid is just a uid (or should be).  One day we may
have a way for a factotum-style daemon to grant the ability to an unpriv
task to setuid without CAP_SETUID.  I think slingling uids and gids
around that you already have access to should be fine.

> If a process does this call, it's effectively saying that the only way
> it's going to be accessing resources beyond its current UID and
> capabilities is by talking to another process over a (unix domain)
> socket.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
