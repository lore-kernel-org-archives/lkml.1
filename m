Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYARFDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYARFDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYARFDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:03:04 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2699 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbYARFDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:03:03 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <torvalds@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <clameter@sgi.com>, <penberg@cs.helsinki.fi>
Subject: RE: Why is the kfree() argument const?
Date: Thu, 17 Jan 2008 21:02:44 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEKDJJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 17 Jan 2008 21:04:03 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 17 Jan 2008 21:04:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Thu, 17 Jan 2008, David Schwartz wrote:

> > > "const" has nothing to do with "logical state".  It has one
> > > meaning, and
> > > one meaning only: the compiler should complain if that
> > > particular type is
> > > used to do a write access.
> >
> > Right, exactly.

> So why do you complain?
>
> kfree() literally doesn't write to the object.

Because the object ceases to exist. However, any modification requires write
access, whether or not that modification is a write.

> > You are the only one who has suggested it has anything to do
> > with changes
> > through other pointers or in other ways. So you are arguing against only
> > yourself here.

> No, I'm saying that "const" has absolutely *zero* meaning on writes to an
> object through _other_ pointers (or direct access) to the object.

Nobody disagrees with that.

> And you're seemingly not understanding that *lack* of meaning.

No, I understand that.

> kfree() doesn't do *squat* to the object pointed to by the pointer it is
> passed. It only uses it to look up its own data structures, of which the
> pointer is but a small detail.

> And those other data structures aren't constant.

Nonsense. The 'kfree' function *destroys* the object pointer to by the
pointer. How can you describe that as not doing anything to the object?

> > Nobody has said it has anything to do with anything but
> > operations through
> > that pointer.

> .. and I'm telling you: kfree() does *nothing* conceptually through that
> pointer. No writes, and not even any reads! Which is exactly why it's
> const.

It destroys the object the pointer points to. Destroying an object requires
write access to it.

> The only thing kfree does through that pointer is to update its own
> concept of what memory it has free.

That is not what it does, that is how it does it. What it does is destroy
the object.

> Now, what it does to its own free memory is just an
> implementation detail,
> and has nothing what-so-ever to do with the pointer you passed it.

I agree, except that it destroys the object the pointer points to.

> See?

I now have a much better understanding of what you're saying, but I still
think it's nonsense.

1) An operation that modifies the logical state of an object should not
normally be done through a 'const' pointer. The reason you make a pointer
'const' is to indicate that this pointer should not be used to change the
logical state of the object pointed to.

2) The 'kfree' operation changes the logical state of the object pointed to,
as the object goes from existent to non-existent.

3) It is most useful for 'kfree' to be non-const because destroying an
object through a const pointer can easily be done in error. One of the
reasons you provide a const pointer is because you need the function you
pass the pointer to not to modify the object. Since this is an unusual
operation that could be an error, it is logical to force the person doing it
to clearly indicate that he knows the pointer is const and that he knows it
is right anyway.

I'm curious to hear how some other people on this feel. You are the first
competent coder I have *ever* heard make this argument.

By the way, I disagree with your metadata versus data argument. I would
agree that a function that changes only an object's metadata could be done
through a const pointer without needed a cast. A good example would be a
function that updates a "last time this object was read" variable.

However, *destroying* an object is not a metadata operation -- it destroys
the data as well. This is kind of a philosophical point, but an object does
not have a "does this object exist" piece of metadata. If an object does not
exist, it has no data. So destroying an object destroys the data and is thus
a write/modification operation on the data.

DS


