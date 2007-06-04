Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXFDWET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXFDWET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXFDWEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:04:08 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.212]:34278 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbXFDWEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:04:06 -0400
X-Greylist: delayed 1116 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 18:04:06 EDT
Date: Mon, 4 Jun 2007 17:44:33 -0400
From: Jeremy Maitin-Shepard <jmaitins@andrew.cmu.edu>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: vgoyal@in.ibm.com, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: A kexec approach to hibernation
Message-ID: <20070604214433.GA2515@andrew.cmu.edu>
References: <878xb3l888.fsf@jbms.ath.cx> <200706012339.06379.rjw@sisk.pl> <87zm3j9usv.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx> <20070604044041.GB10206@in.ibm.com> <1180934540.1169.31.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180934540.1169.31.camel@nigel.suspend2.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 03:22:20PM +1000, Nigel Cunningham wrote:
> Hi.
> 
> I can see that the idea of writing a kernel image from using another
> kernel sounds nice and clean initially, but the more we get into the
> details (yes, I am listening, even though I said nothing before now),
> the more it's sounding like the cure is worse than the disease.

I think if we look into the details a bit more, we may find that it is in
fact not worse after all.  It would be nice if it were also the case that this 
approach could be implemented in only a few hours of work, but unfortunately I 
doubt that to be the case even though I imagine it may be somewhat simpler to 
implement than the current swsusp and suspend2 implementations.

Just to give some perspective on the implementation, I believe the following 
functions/procedures provided by the kernel to userspace (implemented as system 
calls, sysfs files, ioctls, etc.) would be sufficient for this hibernation 
approach:

(Note that I wrote this description after writing my responses to the other 
points you make, and so it may make more sense for those to be read first.)

1. "start hibernation"
   Parameters:
    - "save image" kernel to use (either as the binary data or as a path to the
      file perhaps);

    - extra kernel command-line parameters to the "save image" kernel;

    - an initrd for the "save image" kernel (if needed).

   This function would result in the original kernel loading the "save image" 
   kernel into memory, stopping all devices, and jumping to the new kernel.

2. "resume from hibernation"
   Parameters:
   Somehow the block of memory containing the hibernate image would need to be 
   provided; it could be specified as a pointer to memory in the process 
   invoking this function, or alternatively something like /dev/snapshot could 
   be used.

   This function would stop devices, shuffle the pages around in memory, and 
   jump back to the original kernel.

3. "abort hibernation"
   Parameters:
   The address to jump back to the original kernel would need to be specified; 
   the new kernel would know this address because it would be provided as a 
   kernel command-line parameter.

   This function would act similarly to "resume from hibernation", except that 
   the pages are already in memory exactly where they need to be, so all that 
   needs to be done is to stop all devices, and jump back to the original 
   kernel.

If it is desired to do slightly more in the kernel, the "save image" kernel 
could process the kernel command-line arguments to determine the pages that 
need to be written, and provide of a view of them e.g. as /dev/snapshot, rather 
than having the userspace under the "save image" kernel do that work and then 
perhaps access the pages using /dev/mem.

> To get rid of process freezing, we're talking about:

Note that the advantage of this approach is not just getting rid of process 
freezing and its associated problems.  There is also the advantage of allowing 
much greater flexibility in how the image is written, and avoiding disturbing 
things like the network stack.

> * making hibernation depend on depriving the user of 32 or 64M of
> otherwise perfectly usable memory (thereby making hibernation on
> machines with less memory impossible)

It is not clear that this much memory would really need to be reserved.  I'll 
admit I don't fully understand the requirements for using kexec to load a 
kernel.  In particular, I don't know how much memory would really be required 
to load a kernel to write an image, and to what extent that memory needs to be 
contiguous.  Even if a significant amount of contiguous physical memory needs 
to be reserved at boot, this memory could still perhaps be used for the page 
cache by the original kernel, since it could be freed up for hibernation (and 
possibly those cached pages could be moved to different memory.)

In the best case, though, a significant amount of contiguous memory would not 
be required, in which case a certain amount of memory would need to be freed 
only for hibernation, and could be used normally while not hibernating.

(As a side note, with machines typically having 1GB+ of memory these days, even 
wasting 64MB of memory is becoming increasingly unimportant, although I agree 
it is not a good idea.  I actually run an x86 system with 1GB of memory and no 
HIGHMEM support, and as a result waste over 100MB of physical memory, which 
would handily be free for the new kernel.  Changing the VM split broke certain 
programs that I didn't feel like fixing.)

> * requiring them to set up kexec or kdump (I don't understand the
> difference, sorry) or some new variation

This new hibernation approach would indeed internally use some or all of the 
kexec code, but I don't think this detail would significantly impact the setup 
procedure.  The only real impact would be that the user would need to somehow 
specify how to access the "save image kernel" and the additional kernel 
command-line arguments to include.  If an initrd is to be used instead of an 
initramfs, then that would have to be specified as well.  I don't think this 
setup requirement is significantly more taxing than having to specify the 
path to the user interface program, for instance.

> * adding interfaces to tell kexec/dump/whatever what pages need to be
> saved and reloaded

Any hibernation mechanism needs to know which pages to save.  This approach is 
no different.  The "interface" could likely be one of the following:

1. Just before jumping to the new kernel, with interrupts disabled and devices 
already stopped, the original kernel prepares a list of pages to write 
somewhere in memory.  The old kernel passes the address of this list as a 
kernel command-line argument to the new kernel.  The initramfs or initrd 
userspace (or the kernel itself, although there would be no advantage in doing 
this in the kernel) gets this address from the kernel command-line and then 
reads that list to determine which pages to write.  Presumably preparing the 
list would be a small amount of code, and presumably both suspend2 and the 
in-kernel swsusp already need to do something like this.

2. The old kernel prepares no new data structures, and simply provides a few 
pointers as kernel command-line arguments to the new kernel to the existing 
data structures that describe the pages that are used.  The code running under 
the new kernel responsible for writing the hibernation image simply accesses 
these data structures using the pointers from the kernel command-line to 
determine which pages to write.

> * adding convolutions in which at resume time we boot one kernel, switch
> to another kernel to do the loading and then switch back again to the
> resumed kernel (assuming I understand what you're suggesting).

This shouldn't actually be necessary.  It should be possible to do the resume 
in exactly the same way the in-kernel swsusp resumes currently (except that 
userspace could be used to actually load the image into memory, and then tells 
the kernel to do the necessary manipulations to stop devices, shuffle the 
pages around so they are in the right positions, and then jump to the resumed 
kernel).

> 
> It all sounds terribly complicated and confusing to me, and that's
> before I even begin to think about how this second kernel could possibly
> write the image to an encrypted device or LVM or such like that the
> first kernel knows about and might use now.

I find in some ways it is much simpler than the current approaches.  The "save 
kernel" has to re-initialize device mapper devices that are needed to write the
image in exactly the same way that the resume kernel needs to reinitialize those
devices.  In fact, it could probably use the very same initramfs/initrd code to 
do it.  The fact that it imposes this symmetry is arguably an advantage.

> Can't we just get the freezer right and be done with it?

The question is: can the freezer ever be right?  As far as I can see, no level 
of correctness of the freezer is going to allow you to save the hibernation 
image to something on a fuse filesystem, because essentially any code that is 
run while writing the image needs to live in an special box that is totally 
isolated from the rest of the system in order to avoid problems; thus, it seems 
like it makes sense to implement this box by simply using a separate kernel, 
rather than adding hacks.

-- 
Jeremy Maitin-Shepard
