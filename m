Return-Path: <linux-kernel-owner+w=401wt.eu-S1765460AbXJRDIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765460AbXJRDIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760436AbXJRDIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:08:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53399 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbXJRDIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:08:34 -0400
Date: Wed, 17 Oct 2007 20:06:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071017200607.0bb4da9a@laptopd505.fenrus.org>
In-Reply-To: <200710180134.l9I1YGBW011092@sapphire.spiritone.com>
References: <200710180134.l9I1YGBW011092@sapphire.spiritone.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 18:34:16 -0700
"Thomas Fricaccia" <thomas_fricacci@yahoo.com> wrote:
> 
> But then I noticed that, while the LSM would remain in existence, it
> was being closed to out-of-tree security frameworks.  Yikes!  Since
> then, I've been following the rush to put SMACK, TOMOYO and AppArmor
> "in-tree". 

I think your statement isn't quite correct: it's not closed to out of
tree security frameworks; it's no longer possible to do MODULES. You
can easily patch any of the ones you mention in (and in fact, this is
how distros that use apparmor will use it anyway). You are totally free
to compile whatever security module you want into your kernel and use
it... I would actually highly encourage that; the freedom to do that is
what Linux is about.

The problem with "loadable security modules" is actually fundamental,
and afaik even the AppArmor people mostly agree with this: The security
any such system provides is generally based on being in a "Safe" state
from the start, so knowing all objects that go through the system, being
able to label them (or at least do something with them, I realize the
term "label" is maybe seen as SELinux specific, but I mean it in a
generic way; the SELinux people will tell you I'm not a fan of their
approach *at all*), check them etc etc. A loadable-module approach can't
do that, it would, at load time, have to inspect the system, make sure
no operations are in "half process" when the LSM hooks go into effect
(just think of it: if you have an operation that gets 3 LSM checks done
to it, and you load and activate your module after the first one is
done as NOP, and your code only sees the 2nd and 3rd... showing that
that gives you sane behavior.... unpleasant no matter what you do) and
on unload, undo all it's work in a semi atomic way (just try doing it
race free is already impossible).

This is the prime motivation behind the change as I understand it: It
wasn't really an option to get this correct, the distros who deploy
these frameworks tend to compile them in anyway as a result, and there
are real downsides as well (see below).

> technical arguments seem to be (1) some people use the LSM interface
> for "non-security" purposes, which is frowned upon, (2) it's
> difficult to properly secure a system with an open-ended interface
> like LSM, and (3) my security framework should be all any fair-minded
> person would ever want, so we won't let you use something else.


you missed another one: the curent (now merged) patch allows a new
option (which is under development and will be proposed for 2.6.25): A
config option to compile the kernel such that the security framework of
your choice gets compiled as "exclusive" for your binary kernel, and
such that the code doesn't go via the LSM function pointers anymore, but
just via preprocessor rules, does direct calls instead. (And gets
patched out if you issue kernel commandline options to disable security
entirely). This takes away one of the main performance overheads of LSM
(many many function pointer calls) for those who know which LSM module
they'll be using.

That option obviously doesn't mean that you can't have multiple LSM
drivers anymore in the kernel, again it is an option that IF you know
you'll only use one, you can get rid of all the overhead of needing to
be ready to do multiple.

While this strict technically isn't in conflict with the non-modular
LSM (modular-LSM can obviously be a config option in itself as well),
it does make it a lot easier and cleaner to do things this way.
