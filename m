Return-Path: <linux-kernel-owner+w=401wt.eu-S1764026AbXJEUIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764026AbXJEUIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761873AbXJEUIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:08:38 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:33007 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759866AbXJEUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:08:37 -0400
X-YMail-OSG: ggUhsFoVM1nQN8GOKQte9eUPRt5n6T6gVb_kQScHHq8jtl6r0DDe8Z8MBLFr3E_wvmQcSs4gqA--
X-RocketYMMF: rancidfat
Date: Fri, 5 Oct 2007 13:08:33 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
In-Reply-To: <1191609774.891.123.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <814946.73115.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> ...
> 
> > Good suggestion. In fact, that is exactly how I approached my
> > first two attempts at the problem. What you get if you take that
> > route is an imposing infrastructure that has virually nothing
> > to do and that adds no value to the solution. Programming to the
> > LSM interface, on the other hand, allowed me to drastically reduce
> > the size and complexity of the implementation.
> 
> It would be interesting to see the result of those first two attempts
> (even if they didn't get very far) just to see your approach and what
> obstacles you ran up against.

Woof. It weren't pretty, and I've carefully archived it so as
to make it hard to go back to for that very reason. Maybe someday.
 
> ... 
> > Smack is not a subset of SELinux, it behaves differently. SELinux
> > has a policy that is program behavior oriented, Smack is strictly
> > subjet/object oriented. Your 4 components (A-D) are meaningless to
> > Smack.
> 
> To clarify, SELinux is also based on subjects and objects grouped into
> equivalence classes (labels), and the granularity at which one applies
> protection is configurable, so you can certainly have very
> coarse-grained labels that don't require any specific knowledge of
> application behavior.  A type is just a security equivalence class - it
> doesn't have to map to an application at all.
> 
> Also, the idea behind SELinux was that its policy engine (security
> server, security/selinux/ss/*) could be replaced with other
> implementations without affecting the rest of SELinux if someone wanted
> to try radically different logic.  The interface to that policy engine
> is itself general and not tied to TE.

The ss interface provides no advantage over the LSM interface that
I can see.

> > > >>> I'm not yet annoyed enough to go implement an iptables like  
> > > >>> interface to the LSM enhancing it with more generic mechanism to  
> > > >>> make the problem simpler, but I'm getting there.  Perhaps next  
> > > >>> time  I'm bored.
> > > >>
> > > >> I think a fair amount of what we need is already done in SELinux,  
> > > >> and efforts would be better spent in figuring out what seems too  
> > > >> complicated in SELinux and making it simpler.
> > 
> > The granularity and consequently the size of the policy specificiation
> > result in policies that are too complicated. Tieing the policy to the
> > expected behavior of specific applications adds to the complexity.
> 
> Well, it reveals the complexity already present in the system, and gives
> you the option of controlling it.  Your choice as to at what granularity
> to apply it.

Which is the same for LSM. There are a bunch of LSM hooks that Smack
does not need, and going into SELinux code to choose to do nothing
is pretty pointless.

> > SELinux is designed to increase in complexity as it evolves. Making
> > it simpler would conflict with the design goal of finer granularity.
> > 
> > > >> Probably a fair amount  of that just means better tools.
> > 
> > Now what kind of tools are you talking about? Static analysis?
> > Data flow diagrammers for Java?
> > 
> > > > How about thinking of it another way.
> > > >
> > > > Perform the split up you talked about above and move the table  
> > > > matching into the LSM hooks.
> > > >
> > > > Use something like the iptables action and match to module mapping  
> > > > code so we can have multiple modules compiled in and useable at the  
> > > > same time with the LSM hooks.
> > > >
> > > > I think it is firmly established that selling SElinux to everyone  
> > > > is politically untenable.  However enhancing the LSM (even if it is  
> > > > mostly selinux code movement down a layer) I think can be sold.
> > 
> > That would be silly. Smack uses a significantly smaller set of hooks
> > than SELinux requires and still does interesting things. We went through
> > the "replace LSM with the SELinux interface" exercise a couple years
> > ago, I would hate to have to regurgitate all those discussions.
> 
> I don't think Eric is proposing replacing LSM with the SELinux interface
> as it exists today, but rather making LSM more Netfilter-like and
> radically refactoring SELinux (and any other security module) to consist
> of a chain of smaller modules that are more general and reusable, and
> that can be composed and applied in interesting ways via an
> iptables-like interface.  I'm not sure what that would look like
> exactly, but it seems reasonable to explore.

The image that just flashed into my brain had a disturbing
similarity to STREAMS modules, but spread everywhere, not just
in the tty code. And anyone who thinks that there are too many
LSM hooks now would have kittens over this. I don't think it's a
bad idea, but I don't see how it would change the well documented
disputes regarding what kinds of security behavior it ought to
provide for. How would it help AppArmor, for example? I'm willing
to bet (a beer or equivalence) that anything that helped there
would face stiff resistance simply because it helped there.

I could see it working if you restricted the interface to dealing
with things that have security blobs, or even better to subjects
and objects. But that's my security mindset, and I think pretty
much yours, too. It's the policies that don't use good old
fashioned OrangeBook concepts that have issue, not SELinux or Smack.

> One of the things left unresolved with LSM is userland API, and it does
> involve more than just returning EPERM or EACCES to applications.  You
> already have patched ls and sshd programs, and have acknowledged the
> need for more userland modifications to ultimately achieve your own
> goals.  If LSM is going to succeed in the kernel, then ultimately you
> need some common API for userland so that you don't need separate
> versions of ls, ps, sshd, etc for Smack vs SELinux vs. whatever.

Smack uses text strings for labels. It's amazing how many of the API
issues evaporate when the only thing you have to do with your labels is
compare them and print them. With the labels for processes available
through /proc, and the labels for most things available via getxattr(2)
and its variants the API issue seems hard to get worked up about. If
ls(1) had an option to show selected extended attributes, and it really
should by now, it wouldn't require fixing at all. Now sshd, login, and
the rest of the authentification gaggle are going to need policy
specific behavior so I feel no serious need to provide common API there.
Smack is designed to make this easy because I had to do it the hard
way before and didn't like it much.



Casey Schaufler
casey@schaufler-ca.com
