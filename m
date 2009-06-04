Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZFDT60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZFDT60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZFDT6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:58:19 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:47775 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZFDT6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:58:18 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 15:58:18 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NBtsVfLCiXvu9mYyAr40AHGgDPWnlIr3WIyq+EAwbGdvGRNVduVahg1ed+64ymajvP
         EJ4441ww7k4yvLfIM9Vz4rdpkNGbSEJuocvQKnB/VEaxPFZ8SjArkW6uf62swGQ4D3L+
         DelQO1ejPgyQdoL2n03yEU/CTsdyG4Ckpzxgw=
MIME-Version: 1.0
In-Reply-To: <87iqjedf2a.fsf@basil.nowhere.org>
References: <alpine.DEB.2.00.0906021141010.19390@bicker>
	 <87iqjedf2a.fsf@basil.nowhere.org>
Date: Thu, 4 Jun 2009 21:50:08 +0200
Message-ID: <a63d67fe0906041250v6e4252c2g594322a3a49e7307@mail.gmail.com>
Subject: Re: smatch 1.53 released
From: Dan Carpenter <error27@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/09, Andi Kleen <andi@firstfloor.org> wrote:
> Dan Carpenter <error27@gmail.com> writes:
>
>> Smatch is a source code checker for C.  Right now the focus is on checking
>>
>> for kernel bugs.
>
> Could you give a quick overview on what kinds of bugs it looks for
> and where the limitations are?
>

It's pretty good at finding locking bugs.  It also checks for double
kfree() bugs, null pointer dereferences and also if you check for null
instead of checking for PTR_ERR().  There is a check for using kfree()
instead of kfree_skb() as well.

The cool thing about smatch is that it's pretty easy to write custom
checks.  It's uses sparse as a C parser so you have to look through
expression.h to figure out how to do the pattern matching.  There is a
small example script which shows how that works.
http://repo.or.cz/w/smatch.git?a=blob;f=check_template.c

So you use sparse to grep the code for locking functions and then you
use set_state() to set the state to "locked".

If your code looks like this:
lock_kernel();
if (foo) {
        unlock_kernel();
} else {
        frob();
}
<--  Here the state can be either "locked" or "unlocked".
Calling get_state() here will tell you that it is state &merged.  You
can use get_possible() to get a list of possible states it could be.

Say later code looked like this:
if (!foo) {
<--  Here the state is "locked" because of the !foo.  Smatch figures
this out automatically, that comes from the "implications" module.  Do
other code checkers do this?  I'm pretty proud of the feature either
way.  :)
}

So basically you grep for locking functions and you set the state
based on that, then you grep for return statements and check that the
state is correct or print an error.  Smatch tracks the code paths in
the background and merges states or sets implied states.

Limitations:  The big limitation is that smatch only does one pass
through the code so loops aren't handled correctly.  Eventually it
will do two passes.

A lot of null dereference false positives come from places where it's
hard to tell if a loop is true at least once.
x = NULL;
while (param--) {
        x = &something;
}
x->member;
Someone reading the code probably knows what param is and that it's
non-zero at the start.  There is a "--assume-loops" option to make
smatch assume loops go through once.

Many of the locking false positives come from places where the unlock
happens in a seperate function.  It should be relatively straight
forward to make a list functions to say that if frob_the_module()
returns -12, or -14 that implies it unlocked a certain lock.  I
haven't done this yet.

Otherwise, it's still very young code.  Ideally smatch would know the
possible values of every variable in a function but right now many
variables just default to &undefined.  The implication code is not as
good as it could be.  Also I don't have a good way to build call trees
yet.  There is a lot of work to do at every level.

Still, it doesn't hurt to run smatch on your code before submitting a
patch.  There is an easy script for this:  kchecker /path/to/code.c.
Some of my accepted kernel patches have had bugs which could have been
caught by the current version of smatch...

regards,
dan carpenter

> Thanks,
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
