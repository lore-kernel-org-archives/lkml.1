Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYKGCuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYKGCuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYKGCuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:50:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806AbYKGCuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:50:06 -0500
Date: Thu, 6 Nov 2008 18:49:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task
 directories
Message-Id: <20081106184945.179c248a.akpm@linux-foundation.org>
In-Reply-To: <m1abccxpc5.fsf@frodo.ebiederm.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
	<m1abcd2kqk.fsf@frodo.ebiederm.org>
	<20081106172617.dd51d0af.akpm@linux-foundation.org>
	<m1abccxpc5.fsf@frodo.ebiederm.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 18:05:46 -0800 ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Thu, 06 Nov 2008 02:48:35 -0800
> > ebiederm@xmission.com (Eric W. Biederman) wrote:
> >
> >> +void proc_shrink_automounts(void)
> >> +{
> >> +	struct list_head *list = &proc_automounts;
> >> +
> >> +	mark_mounts_for_expiry(list);
> >> +	mark_mounts_for_expiry(list);
> >
> > Strange.  In case the first attempt didn't work?
> 
> Yes.  I'd like to say.  Mount just go away but it takes two passes before
> a mount is actually removed.

hm.  I stared at mark_mounts_for_expiry() for a while trying to work
out how that can happen and what it semantically *means*, and failed.

I guess I'm just not smart/experienced enough.

> For NFS which does the whole expiry of all inodes where it comes from it
> is a good fit.  For /proc where we don't have to guess it isn't the best
> fit but it isn't shabby either.
> 
> >
> >> +	if (list_empty(list))

So even after two passes through mark_mounts_for_expiry(), there can
still be mounts on our list.

> >> +		return;
> >> +
> >> +	schedule_delayed_work(&proc_automount_task, proc_automount_timeout);

And this causes proc_shrink_automounts() to be called every 500 seconds
for ever and ever, until proc_automounts is empty.

Again, I just don't know how the reader of this file is to understand
why this is done this way.  What is the thinking behind it?  What is
the expected dynamic behaviour?  Under what circumstances will this
very unusual repeated polling activity be triggered?

Obviously, that becomes clearer as one spends more time with the code,
but I wonder whether this has all been made as maintainble as it
possibly could be.

