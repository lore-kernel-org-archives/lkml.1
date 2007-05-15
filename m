Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbXEOMxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbXEOMxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbXEOMxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:53:17 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:59229 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbXEOMxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BSqkAtzryNS2aLdAENKgq8eF0LSAeU9kGFl6wqwzlS27g7xPQgMDxvOpZIFB5oavuBsgFDJoeqayLYS7VSsrEEIcne+VpdxWwU6NfzNvN4jXJYiQ89yAODlEOQ1r7VL8rJGblOy2LIjLtOo4U0pDbkGvOJT0j2i6w9q21ZxJAWk=
Message-ID: <4de7f8a60705150553s3e0cc9b2i3eac728aec3e979e@mail.gmail.com>
Date: Tue, 15 May 2007 14:53:15 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: [RFC][PATCH 2/14] Add a new mount flag (MNT_UNION) for union mount
Cc: bharata@linux.vnet.ibm.com, "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Jan Blunck" <j.blunck@tu-harburg.de>
In-Reply-To: <a4e6962a0705150506j291e17b8g3fc8db1ed83f43c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514093902.GD4139@in.ibm.com>
	 <Pine.LNX.4.61.0705142237270.9570@yvahk01.tjqt.qr>
	 <20070515081652.GD3465@in.ibm.com>
	 <a4e6962a0705150506j291e17b8g3fc8db1ed83f43c1@mail.gmail.com>
X-Google-Sender-Auth: 877772b16e8432db
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On 5/15/07, Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> >
> > So there can be two cases in union mounts:
> > 1. A file exists in topmost layer and also in one or more lower layers. Deleting
> > the file would result in the top layer file being deleted and a whiteout being
> > created in the top layer.
> >
> > 2. A file exists in one or more of lower layers, but not in the topmost layer.
> > Deleting this file would result in just a whiteout being created in the
> > topmost layer.
> >
>
> I'd imagine there is a third potential option, which I'll admit strays
> a bit from the conventional UNIX semantic.

And this is exactly why I designed it as is: NOT to do anything that
anyone can imagine. This is the reason why most of the filesystem
unification approaches fail: too much unnecessary complexity.

> If only one layer is
> marked as writable, then any changes (including delete) only effect
> that layer.  I could imagine this would be useful in situations like
> overlaying a sandbox on an otherwise read-only source code tree (you
> might want to just get rid of a modification by removing your file and
> have it replaced by the original underlying source).

You just unmount the topmost writable layer and replace it by a clean
tmpfs. There you go. Removing a file and not creating a whiteout
totally breaks what the user of the filesystem expects.

BTW: Undoing your changes to source code is solved by many
applications: patch, backup files, version control systems ...

> I suppose a further extension would be to have multiple layers marked
> as mutable and functions such as delete would effect all mutable
> layers, but functions like create would only affect the top mutable
> layer.

You want per systemcall policies of what layer is affected??? Crazy
idea but how do you do this without letting the user know of what
layer the file is in the first place. This doesn't work without major
extension of the VFS/syscall interface.

> As an aside, perhaps it would be useful to mark the mutable layer at
> mount time (instead of having it always be the top layer).  Again this
> could lead to some optional non-conventional file system semantics,
> but its proven useful in Plan 9 union mount semantics and it seems a
> fairly trivial extension to what you currently have.

I don't think so. Plan9 union directory semantic is different. Plan9
is different.

I'll stick to the conventional UNIX semantics since I think that
otherwise it will just make this thing too complex. First we need to
solve the existing problems like union readdir, bind mounts and
whiteout handling. If this is all solved and you are disappointed with
what you can achieve with only the topmost layer writable feel free to
come up with trivial extensions :)

Cheers,
Jan
