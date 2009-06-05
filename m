Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZFEPl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZFEPl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZFEPlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:41:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:38295 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZFEPls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ot8KMbMXsxElAP11CoSvjrsf9u21zZ1XnPLr81BgXRBPcfXiXH+bJ6YnMHnw5SeliT
         2Mc5BVUGWjOYKH0ICGfGl7HoWhV91XwewAWfKTKBj5zw4+OljM90sgGsFbRPCzkKQEI6
         FWF/5kZiYlASKprRa1mzI88v5kFbFwmEmzSwo=
Date: Fri, 5 Jun 2009 19:41:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090605154147.GA16766@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain> <20090605104517.GA11713@infradead.org> <alpine.LFD.2.01.0906050808551.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906050808551.6847@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:10:50AM -0700, Linus Torvalds wrote:
> On Fri, 5 Jun 2009, Christoph Hellwig wrote:
> >
> > On Thu, Jun 04, 2009 at 03:04:22AM +0400, Alexey Dobriyan wrote:
> > > ->exec_path is copied on clone(2) and put at do_exit() time.
> > > 
> > > ->exec_path is going to replace struct mm_struct::exe_file et al
> > > and allows to remove VM_EXECUTABLE flag while keeping readlink("/proc/*/exe")
> > > without loop over all VMAs.
> > 
> > Why don't you leave it in mm_struct?  That'll avoid having to mess with
> > it in clone,

There is no mess in clone:

	+       get_task_exec_path(current, &p->exec_path);

and there is no mess in exit:

	+       set_task_exec_path(tsk, &(struct path){ .mnt = NULL, .dentry = NULL });

> > and given that exec always replaces the whole VM it's a more natural fit anyway.
> 
> Oh, I didn't even notice that, because I just assumed it was in mm_struct 
> already due to the earlier discussion.
> 
> So I concur with Christoph - that field should be in the mm_struct. The 
> executable is a "mapping" issue,

This mapping issue is what created VM_EXECUTABLE/MAP_EXECUTABLE in
the first place, I assume? Never mind it's cheap hack.

> and goes along with task->mm, and should be there, not in task_struct.

Because ->mm can be borrowed to unrelated task and user has to check
for it.

> So it should be copied at fork() time when you do the dup_mm(), not 
> anywhere else.
