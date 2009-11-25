Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZKYP2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZKYP2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbZKYP2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:28:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:46987 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbZKYP2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:28:34 -0500
Date: Wed, 25 Nov 2009 07:27:47 -0800
From: Greg KH <gregkh@suse.de>
To: eran liberty <eran.liberty@gmail.com>
Cc: balajirrao@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: kobjects: mark cleaned up kobjects as unitialized
Message-ID: <20091125152747.GB24498@suse.de>
References: <ffc2b1d40911250127x7b3c3609qb99820d212a7a0ad@mail.gmail.com>
 <20091125123534.GA17486@suse.de>
 <ffc2b1d40911250627q6c7e459v89a580d793b24fcf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ffc2b1d40911250627q6c7e459v89a580d793b24fcf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 04:27:59PM +0200, eran liberty wrote:
> Hi Greg,
> 
> On Wed, Nov 25, 2009 at 2:35 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Nov 25, 2009 at 11:27:58AM +0200, eran liberty wrote:
> >> Hi Greg & Balaji,
> >>
> >> After diving into the LDKM and failed to spot the point where you
> >> actually un-initialize the 'state_initialized' of a kobject... and
> >> since I have statically allocated object which trip over this very
> >> same trap...
> >
> > Ah, there's your problem, don't statically allocate a kobject.  Fix that
> > and your issue goes away, right?
> 
> right... but... I want to :).

No you do not.  Seriously, why would you want a static structure for
something that is, by the very nature of what it is supposed to do,
dynamic?

> Is there a Linux directive saying 'thus shall not statically allocate
> (or reuse in any other way) kobjects"?

Yes there is: Documentation/kobject.txt says:
	Because kobjects are dynamic, they must not be declared
	statically or on the stack, but instead, always allocated
	dynamically.  Future versions of the kernel will contain a
	run-time check for kobjects that are created statically and will
	warn the developer of this improper usage.

Doesn't anyone read documentation anymore?  :(

> >> Google-ing for others who fell into this trap, I found your thread/patch at:
> >> http://lkml.org/lkml/2008/3/8/155
> >> and
> >> http://lkml.indiana.edu/hypermail/linux/kernel/0902.0/01969.html
> >>
> >> I noticed this patch did not make it into the mainline.
> >>
> >> Is this patch still valid?
> 
> Why was your proposed patch not merged?
> Is there some logic behind not having it?

Because we realized the root problem was static kobjects, which we do
not support.

> >> Is there some other, better way to do it by the book?
> >
> > Do not statically allocate a kobject.
> >
> >> Right now I by-pass the problem by memset-ing the whole object after I
> >> release it... but I feel this is a bit brutal.
> 
> Assuming I will keep it static and clear the status_initialize bit (by
> memset-ing the whole object) after the kobject was released... am I
> doing something wrong? should i expect other bad phenomena?

Again, DO NOT CREATE A STATIC KOBJECT.

Please.  Pretty please?  Pretty please with a cherry on top?

Ok, how about this, let's flip this the other way around, why do you
feel that you have to use a static kobject?

> > You should be freeing your memory in your release function.
> >
> Should I free the object itself in release() function?

Yes.

> In OO-like thinking I would expect release() to be a cleanup function
> for the device to be used, while the kfree() be done by the same
> object which did the kmalloc()

No, the object destroys itself when the last reference to it is dropped,
which is a very OO-like way of doing things (smart pointers and all of
that.)

Please read the above referenced document about kobject and how they
operate.  If you have any questions after doing that, please let me
know.

Oh, and another thing, your really do not want to be using a "raw"
kobject, use 'struct device' instead :)

> 
> > Do you have a pointer to your code somewhere?
> >
> 
> I will pack something and send you (i dont think Mr. vger will
> tolerate attachments :) )

Inline is the way to do it, I don't want a tarball either.

> but basically you can demonstrate the problem with this simple code:
> 
> struct device dev;
> while(1) {
>   dev->release = dummy_release_function_that_does_nothing;

WTF!!!

Ugh, if I see one more person try to "trick" the kernel from reporting
this error by providing a "dummy" release function, I'm going to go find
a kitten to kick.

Seriously, why are you blatently ignoring the warning that the kernel is
trying to be nice and give to you?  Do we just invent messages that need
to be worked around?

>   device_register(&dev); /* will fail on second iteration without the
> memset!! ?? */

Yup, don't do that.

>   device_unregister(&dev);
>   memset(&dev,0,sizeof(struct device)); /* should be unnecessary  */

No, this code is broken.

{sigh}  Doesn't anyone read the archives or documentation anymore?

greg k-h
