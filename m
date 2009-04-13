Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZDMJO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZDMJO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 05:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZDMJOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 05:14:16 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64996 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDMJOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 05:14:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MXxFixUiNVA+4xdFxYqQt3a5VUSW41FaryT9f2eUaHGmpGKadxImytCifcNmAyG2yw
         hZpYqtblwypYZv18DyA57/HwXfk+NLncHPSQaZ8ZqaFPfD3NHuY0cK92Hh6LfLue9iGb
         B+avx2vU+1/z8B28noTEmGkq3dZKwqJHzhbX4=
Date: Mon, 13 Apr 2009 13:14:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
Message-ID: <20090413091423.GA19236@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239340031.24083.21.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 10:07:11PM -0700, Dave Hansen wrote:
> I'm curious how you see these fitting in with the work that we've been
> doing with Oren.  Do you mean to just start a discussion or are you
> really proposing these as an alternative to what Oren has been posting?

Yes, this is posted as alternative.

Some design decisions are seen as incorrect from here like:
* not rejecting checkpoint with possible "leaks" from container
* not having CAP_SYS_ADMIN on restart(2)
* having small (TASK_COMM_LEN) and bigger (objref[1]) image format
  misdesigns.
* doing fork(2)+restart(2) per restarted task and whole orchestration
  done from userspace/future init task.
* not seeing bigger picture (note, this is not equivalent to supporting
  everything at once, nobody is asking for everything at once) wrt shared
  objects and format and code changes because of that (note again, image
  format will change, but it's easy to design high level structure which
  won't change)
* checking of unsupported features done at wrong place and wrong time
  and runtime overhead because of that on CR=y kernels.

There are also low-level things, but it's cumulative effect.

[1] Do I inderstand correctly that cookie for shared object is an
address on kernel stack? This is obviously unreliable, if yes :-)

	int objref;
		...
	/* adding 'file' to the hash will keep a reference to it */
	new = cr_obj_add_ptr(ctx, file, &objref, CR_OBJ_FILE, 0);
					^^^^^^^
