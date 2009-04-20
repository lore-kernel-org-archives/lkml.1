Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbZDTIOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbZDTIOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZDTIOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:14:34 -0400
Received: from ozlabs.org ([203.10.76.45]:50830 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZDTIOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:14:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Date: Mon, 20 Apr 2009 17:44:21 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <200904161130.28129.rusty@rustcorp.com.au> <20090416075541.527b8f85@bike.lwn.net>
In-Reply-To: <20090416075541.527b8f85@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904201744.22572.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 11:25:41 pm Jonathan Corbet wrote:
> On Thu, 16 Apr 2009 11:30:26 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Anyone want to try to write a guide on writing good commit messages?
> 
> I've tried to do that about halfway through
> Documentation/development-process/5.Posting.  No doubt it can be
> improved...patches (with good commit messages) welcome :)

I think Ted put his finger on it: the definition of a good commit
message is one which is kind to the reader.

There are several readers: someone reviewing the patch, someone looking
for a specific bug, someone backporting, someone dealing with an API change,
someone bisecting.  A reviewer needs to know why the patch is done the way it
is, the bughunter needs to be able to find the commit from the bug symptoms,
the backporter needs to know what the patch fixes, how severe it is, and what
side effects are expected, the what-happened reader needs to know how to port
to the new API (and probably why it changed), and the bisector doesn't need
much at all (since the patch is buggy, the commentry is probably wrong anyway,
but perhaps they need to judge what reverting the patch will do).

Here are my thoughts:

- Actual demonstrated fixes for demonstrated bugs should aim for subject
  "<subsystem>: fix <symptom> <condition>...", eg: "modules: fix crash when out
  of memory" or "modules: fix compile error on arm" or "modules: fix module
  load when CONFIG_FOO=y, CONFIG_BAR=n, moon=full".

  Body should include:
  - how likely (if not obvious from subject).
  - how important.  Root can crash box maybe isn't important, but if
    NetworkManager default configuration tickles the bug, it might be.
  - text of message which results if any.  Oops (trimmed), compile error,
    unexpected output of utility.
  - when the bug was introduced (or exposed).
  - upstream (bugzilla, ml message, or at least reporter) so it can be dug
    further if required.

  I suggest that the keyword "fix" not be used for theoretical or soon-to-be-
  exposed limitations of code.  eg. "virtio: correction to BAD_RING
  macro if arg is not called 'vq'" not "virtio: fix BAD_RING macro when..."
  (this was a real example, but the arg was always called 'vq').

- Neatening-and-documenting commits should aim for "<subsystem>: cleanup...",
  eg. "lguest: cleanup typos in headers" or "lguest: cleanup: rename internal
  function", or "module: cleanup: move function out of header".

  Body should include:
  - larger plan if there is one (eg. removing obsolete function, reordering
    functions because we're going to do something later, exposing functions
    because we're going to need them in successive patch).

- No subject should ever contain the word "trivial".  If it's really trivial,
  you can sum it up in the subject and we'll know it's trivial.  Plus the
  diffstat shows it.  'trivial' is propaganda to sneak a patch into -rc7.

- API changes or deprecation should say why the change is happening, and
  how to port.  The subject line should say what's changed in preference
  to why.  eg. "per_cpu: deprecate per_cpu_ptr in favor of percpu_ptr", or
  "list.h: add list_for_each_reverse_rcu_backflip".

- The change message should always be about the change, not the new code.
  For example, the above commit might say "we need this for the new backflip.c
  debugging code", but the documentation of the function belongs in the code
  itself, not the git log!

Writing good commit messages takes time, practice and feedback.  But
if you're having trouble writing a good commit message, it's often a sign
that your patch needs to be reworked anyway.

Sorry for the too-long post, but this stuff actually matters...
Rusty.
