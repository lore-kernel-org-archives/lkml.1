Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYCZQs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYCZQs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbYCZQsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:48:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59629 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401AbYCZQr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:47:58 -0400
Date: Wed, 26 Mar 2008 11:47:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: NeilBrown <neilb@suse.de>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, miklos@szeredi.hu,
       viro@zeniv.linux.org.uk, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: Re: r-o bind in nfsd
Message-ID: <20080326164753.GA20578@sergelap.ibm.com>
References: <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk> <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> <18408.26863.617591.836548@notabene.brown> <200803252045.CGB04105.HLSQFOJMtOFVOF@I-love.SAKURA.ne.jp> <57096.192.168.1.70.1206484328.squirrel@neil.brown.name> <1206533042.3302.266.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206533042.3302.266.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> 
> On Wed, 2008-03-26 at 09:32 +1100, NeilBrown wrote:
> > On Tue, March 25, 2008 10:45 pm, Tetsuo Handa wrote:
> > > Hello.
> > >
> > >> Maybe some enhancement to the 'intent' structure with a similar
> > >> effect could be done instead.
> > >>
> > >> Then you could, presumably, put a security hook somewhere in
> > >> link_path_walk for those modules (like AppArmor) which want to do
> > >> checks based on the namespace.
> > >
> > > I think link_path_walk() is not a good place to insert new LSM hooks
> > > for pathname based access control (AppArmor and TOMOYO) purpose because
> > >
> > >   (1) The kernel don't know what operation (open/create/truncate etc.)
> > > will be
> > >       done at the moment of link_path_walk().
> > 
> > Though the 'indent' data structure could be used to carry this information.
> > 
> > >
> > >   (2) Not all operations call link_path_walk() before these operations
> > >       are done. For example, ftruncate() doesn't call link_path_walk().
> > 
> > But do you want to impose path-name based controls to ftruncate?
> > Surely once you have a file open for write (not O_APPEND), then no
> > other permission is required to truncate the file, is it?
> > If it is, then maybe the 'struct file' should be tagged at open time
> > to say whether 'truncate' is allowed.
> > 
> > >
> > >   (3) The rename() and link() operations handle two pathnames.
> > >       But, it is not possible to know both pathnames at the moment of
> > >       link_path_walk().
> > 
> > Not an insolvable problem.
> > One could imagine an implementation where a TYPE_RENAME_FROM security
> > check produced a cookie that was consumed by a TYPE_RENAME_TO security
> > check.  The cookie could then be used by the security module to
> > make any connection between the two names that might be appropriate.
> > 
> > >
> > > I think we need to introduce new LSM hooks outside link_path_walk().
> > > http://kerneltrap.org/mailarchive/linux-fsdevel/2008/2/17/882024
> > >
> > <rant>
> > I suspect we would be much better off removing all the security hooks.
> > Security done at that level seems to be way too complex such that most
> > people don't really understand it.  And people who don't understand
> > security don't use it.
> > We'd be much better off getting rid of the whole "micro-manage security"
> > concept and provide isolation via some sort of high level container
> > approach.
> > </rant>
> 
> Containers can be useful, but they aren't a substitute for access
> control, and they don't solve the same problem.

Not only that, but containers require an LSM to provide user isolation
and root containment.

Hopefully at some point we'll be able to get around that for most VPSs,
but that's a long ways off and personally I suspect I would always want
a policy locking VPSs up nice and tight.

> And SELinux does get used, and recent stats on Fedora 8 suggest that few
> people disable it anymore.  Advances in the SELinux tools (loadable
> modules, semanage, system-config-selinux, setroubleshoot, etc) have gone
> a long way to enabling users to solve problems they encounter.
> 
> -- 
> Stephen Smalley
> National Security Agency
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
