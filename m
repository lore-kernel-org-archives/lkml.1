Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbYH2OIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbYH2OIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758575AbYH2OIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:08:34 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:45703 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758566AbYH2OIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:08:32 -0400
Date: Fri, 29 Aug 2008 10:07:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Markku Savela <msa@moth.iki.fi>
Cc: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: Frustrated with capabilities..
Message-ID: <20080829140732.GB30887@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Markku Savela <msa@moth.iki.fi>, pavel@suse.cz,
	linux-kernel@vger.kernel.org
References: <87hc96by8x.fsf@burp.tkv.asdf.org> <20080828141826.GA6797@ucw.cz> <200808281445.m7SEjYsB007502@burp.tkv.asdf.org> <20080828174854.GM26987@mit.edu> <200808291018.m7TAIcqJ030105@burp.tkv.asdf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808291018.m7TAIcqJ030105@burp.tkv.asdf.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 01:18:38PM +0300, Markku Savela wrote:
> Considering the current case, without the file capabilites, I note
> 
> - if the caller of /bin/sh is ROOT, the capabities are inherited. Thus
>   my request has no relevance in that case.

In the full capabilities model (which we can't have until file
capabilities get added), having a user id of 0 has no meaning.  The
whole concept of "root" goes away.  Like SELinux, turning it on
without making sure programs are ready for it will break a lot of
things.

> - if the caller does first setuid to non-root, the capabilities are
>   cleared, unless KEEP_CAPS is explicitly set. Thus, my requested
>   change would not cause problems with your buggy mail program.
> 
> - if the caller goes through all the trouble of setting KEEP_CAPS and
>   changing to non-root, I would expect it to be sensible that the
>   caller also intends the execve code to inherit capabilities.

What you are suggesting is not insane.  But then again, the setuid
root (and allow a process to inherit all privileges) model wasn't
insane either.  The full capabilities model, however, is striving to
far more stringent than either the traditional root-oriented model or
your concept of allowing the program to decide (on its own) whether it
a downstream exec should inherit its privileges.  And what it is
trying to do is this:

It is very reasonable to suggest that a system administrator, or a
site security officer, be able to audit a system and know what
programs can run with any kind of elevated privileges (and I still
prefer the term "privileges" to "capabilities"; one of these days I
will need to buy Casey a beer).  But if you allow unbridled
inheritance, you Just Don't Know who could run as root.  If you make
it based on whether KEEP_CAPS is set, it still becomes impossible for
a system administrator to audit all of the binaries on the system ---
for the simple reason that the system administrator may not have
access to the sources, and even if she did, how would she know whether
the sources precisely matched up to the binaries, in every single
case?  And even if she did know how would she know what program or
programs a particular privileged program could exec?  It's just not
possible.

The solution in the capabilities model is that each executable has a
capability bitmask which indicates which privileges it is allowed to
inherit --- and the default is no privileges whatsoever.  This means
that just as today, a system administrator or site security officer
can scan for setuid root programs, in the capabilities world, it is
possible to determine exactly which binaries could ever run with
elevated privileges, ever.  And in order to do it, the permission to
do this needs to be in the filesystem, and not in some magic KEEP_CAPS
flag.

The KEEP_CAPS flag is simply a transition mechanism, before we have
full filesystem cpabilties and can implement the full capabilities
model, because it controls what happens when you make the move from
root to non-root.  In the capabilties world, "root" simply has no
meaning, so KEEP_CAPS would become vestigal once full capabilities is
enabled.

Your proposed change of overloading KEEP_CAPS to also mean that a
program can inherit has the downside that programs that try to take
advantage of this will break on a system with file capabilties
enabled.  Perhaps a better way of doing what you want would be to
replace the non-file capabilities version of get_file_caps with
something like this:

static inline int get_file_caps(struct linux_binprm *bprm)
{
	bprm->cap_post_execu_permitted = current->cap_inheritable;
	bprm->cap_effective = true;
	return 0;
}

Now if you want to pass some subset of your capabilities to a child
process, you have to set your processes's inheritable bitmask with the
capabilities you want passed down.  This is better than KEEP_CAPS,
since KEEP_CAPS is all or nothing, and this allows you to be selective
(and explicit) about which capabilties should be inherited.  It is
also forwards compatibile with the full capabilities model, since the
(simplified) inheritance model is:

	    pP' = fP | (pI & fI)

where:

	pP' is the new process's permitted capset
	fP is the executable's permitted capset (think of this as
		"setuid" bits)
	fI is the executable's inheritable capset
	pI is the process's inheritable capset

Previously, in effect without file capabilities, fP and fI were set to
0, which disabled capability inheritiance.  This change effectively
makes fI ~0.  This means that the process can decide to pass
capabilities to a downstream exec, and we assume (in the absence of
file capabilities) that the executable always has the permission to
receive these capabilities.

If you do then migrate to the full capability model, the system
adminsitrator will have to set the fI bits appropriate for all
processes that need to be able to receive capabilities, but your
existing programs will already be doing mostly the right thing.

> File capabilities (nor selinux) won't work, because the "helper
> applications" need to be executed with different capabilities and
> permissions, depending on the "manifests" of the downloaded
> "code". Obviously, serious permissions are granted only to properly
> verified "code" (signed).

Downloaded applications (or data which implies starting some helper
application) gets very hard, because even if the code is "signed",
there is the question of whether you trust the signer?  And maybe you
trust the signer in some contexts, but not in others.  Furthermore,
how you probably want to restrict such downloaded applications (or
data which instructs a helper application how to behave) is probably
far more than just subsets of superuser privileges.  Even if the the
process is running without any elevated privileges, you may not want
it deleting all of your home directory, or sending a copy of all of
your mail folders over the network to an attacker.  So that implies
needing to run the application in some kind of captive sandbox.  And
at this point, we end up going *far* beyond the scope of the
capabilities discussion.

> File capabilities (and setuid/setgid bits, selinux attributes) have
> another problem: they only work properly on internal disk. No sane
> person would allow them to be effective from removable media or NFS.

Absolutely, and just as we have to mount non-trusted filesystems with
nosuid, the same has to apply for capabilities.  But while this is a
"reduced to a previously unsolved problem", I don't think it's a major
problem.  We've all learned to live with the fact that if you want a
secure system, all of your programs that need to run with elevated
privileges be located on trusted filesystems, and in practice, this
isn't a major limitation.  If you want to keep the system easily
evaluated for security, you have to do this anyway.

	      		    	       	    - Ted
