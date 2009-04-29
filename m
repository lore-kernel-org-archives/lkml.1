Return-Path: <linux-kernel-owner+w=401wt.eu-S1761332AbZD2NYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332AbZD2NYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760831AbZD2NX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:23:58 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:63517 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761268AbZD2NX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:23:57 -0400
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090429125606.GA27901@redhat.com>
References: <20090428223025.GA11997@redhat.com>
	 <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org>
	 <20090429065809.GA477@redhat.com>
	 <1241007630.18249.141.camel@localhost.localdomain>
	 <20090429125606.GA27901@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 29 Apr 2009 09:16:54 -0400
Message-Id: <1241011014.18249.192.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 14:56 +0200, Oleg Nesterov wrote:
> On 04/29, Stephen Smalley wrote:
> >
> > On Wed, 2009-04-29 at 08:58 +0200, Oleg Nesterov wrote:
> > >
> > > Why do we need to s/IGN/DFL/ and why do we clear ->blocked ? How this can
> > > help from the security pov?
> >
> > We don't want the caller to be able to arrange conditions that prevent
> > correct handling of signals (e.g. SIGHUP) by the callee.  That was
> > motivated by a specific attack against newrole, but was a general issue
> > for any program that runs in a more trusted domain than its caller.
> 
> Still can't understand...
> 
> If the new image runs in a more trusted domain, then we should not change
> SIG_IGN to SIG_DFL ?
> 
> For example, a user does "nohup setuid_app". Now, why should we change
> SIG_IGN to SIG_DFL for SIGHUP? This makes setuid_app more "vulnerable"
> to SIGHUP, not more "protected". Confused.

Not if the app was depending on the default handler for SIGHUP to
correctly handle vhangup().  The point is that we don't necessarily
trust the caller to define the handling behavior for signals in the
callee.  If we trust the caller to do so, then we can grant the
corresponding permission.

newrole scenario was to run it nohup, logout, wait for other user to
login on same tty, trigger termination of newrole'd child shell, and
have newrole relabel other user's tty to attacker's sid.

> OK. Since I don't understand the security magic, you can just ignore me.
> But I will appreciate any explanation for dummies ;)
> 
> > As I recall, I based the logic in part on existing logic in
> > call_usermodehelper().
> 
> ____call_usermodehelper() does this because we should not exec a user-space
> application with SIGKILL/SIGSTOP ignored/blocked. We don't have this problem
> when user-space execs.

But we still have the problem of the caller setting up the signal
handlers or blocked signal mask prior to exec'ing the privileged
program, right?

-- 
Stephen Smalley
National Security Agency

