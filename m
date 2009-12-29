Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZL2GIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZL2GIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 01:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZL2GIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 01:08:18 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43090 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZL2GIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 01:08:17 -0500
Date: Tue, 29 Dec 2009 00:08:15 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Valdis.Kletnieks@vt.edu,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091229060815.GA25125@us.ibm.com>
References: <20091227190802.GH11737@elf.ucw.cz>
 <20091228060759.GB13266@heat>
 <20091228101006.GA19984@elf.ucw.cz>
 <8817.1262011044@localhost>
 <20091228205511.GD1637@ucw.cz>
 <3e8340490912281333l1459f769yf621a36ad1ed6482@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e8340490912281333l1459f769yf621a36ad1ed6482@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bryan Donlan (bdonlan@gmail.com):
> On Mon, Dec 28, 2009 at 3:55 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Mon 2009-12-28 09:37:24, Valdis.Kletnieks@vt.edu wrote:
> >> On Mon, 28 Dec 2009 11:10:06 +0100, Pavel Machek said:
> >>
> >> > a) make disablenetwork reset to "enablenetwork" during setuid exec
> >>
> >> That won't work either.  If you only make it 'setuid==0' binaries, you still
> >> break 'setuid-FOO' binaries that require the net. If you just check the setuid
> >> bit, it allows a trivial escape by creating a setuid-yourself binary and using
> >> that to exec something else (now with network access, because we apparently
> >> don't have a way to remember the previous setting).
> >
> >
> > it is really only required for binaries setuid to someone else, but
> > that would be too ugly. (Plus, as someone said, ping is great for
> > leaking data out.)
> 
> No, this is not sufficient; one needs only to find a setuid process
> that can be convinced to run a program with the original (pre-suid)
> privileges. For example, one could invoke gpg (older versions setuid
> so it can lock memory, executes user code for the passphrase input
> agent) or pulseaudio (in some cases setuid to go realtime, loads user
> plugins) or screen (setuid for sharing sessions, obviously executes
> user programs) or at/cron (did you remember to deny access to these?)
> ...
> 
> Or one can target a non-root setuid program that may have security
> holes - how about nethack?
> 
> While in modern distros these uses of setuid may be rare, they can
> exist, and under the old security model they were safe. Not so
> anymore. As such, re-enabling network access upon executing a setuid
> program is not acceptable.
> 
> That said, I do feel this is a separate issue. The process should
> first drop its ability to suid; then it can freely apply additional
> restrictions without there being any risk of breaking setuid
> applications.
> 
> In short, how does this sound:
> * Add an API to allow processes to permanently revoke their own
> ability to gain privileges from setuid-exec

Well, this is possible now, but requires privilege:  Remove
any bit not in pP from the bounding set.

Removing the requirement for privilege to do so has some conerns.  Do we
force a task to then run with absolutely no capabilities, or can it just
stop itself from gaining new ones?  If the latter, then we are close to
re-raising the sendmail-capabilities bug.  The main difference would be
that you must already have the capbilities you want to keep, but I'm
not convinced that's sufficient.

A function which can be called without privilege, which empties out
all capability sets and the bounding set, that may be safe.  Still might
cause a setuid-root app which is running as root but with no privilege
to be confused and mess up the system...

> * Add this disablenetwork facility, conditional on dropping
> setuid-exec abilities
> 
> This also paves the way for:
> * Allow processes that have dropped said suid ability to freely create
> new namespaces (and chroot)
> 
> Which, combined with doing whatever audits are necessary to allow
> cross-network-namespace uses of unix domain sockets, actually
> eliminates the need for the disablenetwork API. :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
