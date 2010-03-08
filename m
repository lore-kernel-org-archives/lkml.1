Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0CHXMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:12:16 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:58228 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0CHXMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:12:13 -0500
MIME-Version: 1.0
In-Reply-To: <a36005b51003081412u536c34cbu46b5288e32c73397@mail.gmail.com>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	 <20100308094647.GA14268@elte.hu>
	 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	 <a36005b51003081412u536c34cbu46b5288e32c73397@mail.gmail.com>
Date: Mon, 8 Mar 2010 18:12:12 -0500
Message-ID: <7e0fb38c1003081512j36b4fbbfpa5f93f988495f621@mail.gmail.com>
Subject: Re: Upstream first policy
From: Eric Paris <eparis@parisplace.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 5:12 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Mon, Mar 8, 2010 at 10:08, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Notice how it's really fundamentally about the pathname? When you create a
>> new file and overwrite /etc/passwd with that file, the security rules
>> really do _not_ come from your newly created inode, they come from the
>> fact that you made the path "/etc/passwd" point to that inode.
>
> This is not a fundamental problem.  It's rather a detail of the
> current policies and legacy apps.
>
> I think I would like to see /etc/passwd to also get a file type like
> /etc/shadow.  This is I think today not done because of the work
> involved and the perceived lower severity because passwords are in
> /etc/shadow.
>
> So let's talk about /etc/shadow.  If somehow the file is removed and
> somebody creates a new file that file won't automatically get the
> right label.  This means that code reading the file then could be
> prevented from doing this with appropriate policy rules.  Here the
> filename is not sufficient for access.  You also need the label and
> that you won't get without subverting the system.  With filename based
> mechanisms this isn't the case: once the file is compromised the
> attack succeeded.
>
> Yes, the current situation isn't optimal.  We have to make the
> policies more complicated and we have to get rid of restorecond (at
> least for most cases).  But there is no fundamental problem with
> labels while filename-based mechanisms provide no security
> improvement.

At the moment the default label of a new file is created based on the
label of the creating process and the label of the parent directory.
It's certainly not impossible that a third factor could be added 'the
last component of the pathname of the new inode' to the decision
matrix.  Doing so would eliminate the need for restorecond in most (or
maybe all) situations while maintaining the useful security principles
of label based enforcement.  It actually has been suggested and
implemented, but as I recall we were told it violated some VFS rules
to pass the information we passed where we passed it and it was
abandoned.

*tongue in cheek* if TOMOYO and AppArmour can do thing which the VFS
maintainer say is wrong and unacceptable merely by sending them to the
security maintainer instead I guess SELinux can do that as well!

answering a different post in the same email: I accept "THERE ARE
DIFFERENT CASES."  You go on to say "So I'm not suggesting we
_replace_ content-based security with pathname-based security. I'm
just saying that pathnames actually do matter for security, and that
they are an independent issue."  But what you are suggesting is
EXACTLY that our users should _replace_ content-based security with
pathname-based security when they have to boot with security=TOMOYO
instead of security=SMACK.  Rather than finding a flexible framework,
finding problems or inadequacies in that framework, and solving those
problems you instead force our users to have to choose between LSMs
which are either A) secueable but non-intuitive or B) not securable
but known to be 'easier'.

I think the inode based security view as a hammer might not be all
that bad.  It works really well on nails (you know the truely hard
well researched security questions) and it can beat screws into a
piece of wood as well (although sometimes the wood cracks).  Calling
pathname based security a screwdriver fits too, it can put the screws
in but we know there are a lot of nails out there which it can't ever
deal with.

Personally I think we should all get together and agree on a framework
and fix the framework to meet all of the needs and look like a swiss
army hammer driver drill thing rather than having 4 options, none of
which meet all the needs, and then forcing our uneducated users to
choose between them.  But, hey, we all know that isn't going to happen
so I'll just go back to happy go lucky dream land where Linus is not
running around naked with a chain saw.

-Eric
