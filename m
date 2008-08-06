Return-Path: <linux-kernel-owner+w=401wt.eu-S1763802AbYHFP4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763802AbYHFP4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYHFPzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:55:16 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:58128 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292AbYHFPzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:55:13 -0400
In-Reply-To: <20080806152236.GE14109@mit.edu>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Rik van Riel <riel@redhat.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a	linuxinterfaceforon access
 scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 16:54:19 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 16:55:07,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 16:55:07,
	Serialize complete at 06/08/2008 16:55:07,
	S/MIME Sign failed at 06/08/2008 16:55:07: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 16:54:21,
	Serialize complete at 06/08/2008 16:54:21
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806155513.25BA137659D@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@MIT.EDU> wrote on 06/08/2008 16:22:36:

> On Wed, Aug 06, 2008 at 03:16:02PM +0100, tvrtko.ursulin@sophos.com 
wrote:
> > 
> > You can't do something like inotify("/") (made up API) but you have to 
set 
> > up a watch for every directory you wan't to watch. That seems like a 
waste 
> > of resources.
> > 
> > Then you get back a file name, if you wan't to report it or attempt* 
to 
> > scan it you have to build a pathname yourself, which means you have to 

> > maintain the whole tree of names in memory. Even bigger waste.
> 
> Yes, it would be nice if inotify gave you back a full pathname and
> where a single watch would return all changes anywhere in the
> filesystem tree.  I'd recommend that folks try to create such a patch.

I will have a brief look to familiarise myself with inotify 
implementation. So maybe, but even if that solves only one 
sub-requirement.
 
> > When I say attempt to scan it above I mean that we are back into the 
> > pathanme teritorry. It is not guaranteed we will be able to open and 
scan 
> > using that pathname. I don't know what inotify reports with chroots 
and 
> > private namespaces, but it can certainly fail with NFS and 
root_squash. So 
> > it is less effective as well as being resource intensive.
> 
> Linux's namespace support does break a lot of traditional paradigm.
> I'll note the TALPA "requirements" are broken themselves since they
> refer to pathnames.

Core functionality does not depend on pathnames. I thought that was 
sufficiently clear from the design description. But read below...
 
> Furthermore, I assume you'll always want to do the scanning in
> userspace; the virus signature files for Windows are ***huge***.  And

You assume correctly so the rest of the paragraph was not needed. :)

> if you are going to be scanning for Windows virii on the argument that
> you want to stop malware on fileservers, I don't think you want to put
> all of that code into the kernel.  (I'll note that all that code
> complexity leads to bugs, which will in kernel code cause system
> crashes.  One company's Linux AV code --- I won't say which --- almost
> lead to a rather big and public customer abandoning an Linux
> deployment because said proprietary, badly/disastrously written,
> kernel code was leaking a small amount of memory on every file open,
> and no one could figure out why their file server was crashing every
> five days or so.  I was called in to rescue said customer before they
> cancelled the contract in disgust, and I traced it back to a
> proprietary AV kernel module.  What fun...)

Once upon a time I worked for a different company and we used embedded 
linux to drive some custom hardware, rather complex things. On some 
customer sites, every week or so the OS would hang. Some free, public and 
open kernel GPL code was leaking kernel memory on each USB transaction and 
depending on the use it would use up all memory sooner or later. We lost 
the customer, but didn't abandon Linux. Instead we helped fix the leak and 
if you don't believe me it should be ChangeLogs under my name, something 
like five or six years ago.

So what do ours anecdotes prove? Only lack of testing I would say.

Also, that companies from your example bad code would probably be better 
if a proper interface did exist and they didn't have to hack around.
 
> So if we are going to have to deal with namespaces, I suspect the best
> we can do for any interface (whether it is inotify based or not) is to
> have it return pathnames that are valid in the namespace that the
> program calling said interface happens to be running in.  If necessary
> the AV program can be given access to a highly privileged namespace
> where all mounts are visible.  And if you want to restrict namespaces
> from being created at all, that's a security policy decision that
> should be made via the LSM hooks.

I agree wih the first part and that is how it works.

Pathnames are used for reporting purposes and for possible filesystem 
hiearchy exclusions. For reporting it is obviously not critical from 
security point of view and the design document showed how we get them. 
There is no new code added to do it and it happens from userspace. Such 
pathnames are relative to the userspace daemon since they are obtained via 
/proc/self/fd/ and readlink. Exclusions use relative paths and that is 
also explained in the document.

Therefore access to all namespaces should not be needed except in a way of 
getting a file descriptor from another process, possibly from another 
namespace, do to the scan.
 
> As far as blocking opens are concerned, my suggestion there would be
> changes would probably be much more likely accepted if they solved
> more problems than just what the AV folks need.  For example, think
> about hierarchical storage management, and DMAPI.  DMAPI is a total
> disaster because it doesn't know about namespaces and so is completely
> pathname based (which doesn't work well when you have namespaces).
> But a solution which is general enough that it can also be used to
> support HSM would probably be a good thing.

I agree and think we are completely open to this. However the story 
reverses in a way that we now don't know what are the requirements for 
those so couldn't possibly address them initially.
 
> Also, it may very well be that instead of one, purpose-specific
> interface such as what you suggested in TALPA, it might be much better
> if it was a series of different interfaces; and in some cases, some of
> the changes might be extensions and improvments to existing
> facilities, such inotify.

Could be, but I think we won't know for sure until everything is fleshed 
out.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

