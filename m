Return-Path: <linux-kernel-owner+w=401wt.eu-S936676AbXGLDQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936676AbXGLDQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761034AbXGLDQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:16:00 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:58165
	"EHLO moonbase" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765462AbXGLDP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:15:59 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Date: Wed, 11 Jul 2007 20:15:53 -0700
User-Agent: KMail/1.9.5
Cc: Zan Lynx <zlynx@acm.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200707111916.35036.jesper.juhl@gmail.com> <200707111305.08603.phillips@phunq.net> <18069.21771.945367.815193@notabene.brown>
In-Reply-To: <18069.21771.945367.815193@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707112015.53434.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2007 15:09, Neil Brown wrote:
> > > Has anyone fixed the infrequent crashes with 4K stacks and ext3
> > > -> LVM snapshot -> LVM -> DM mirror -> libata?
> >
> > Ahem: ext3 -> LVM snapshot -> LVM -> DM mirror -> DM crypt -> md ->
> > libata, or worse.
> >
> > No, it's not fixed.  The model is wrong.  Virtual block drivers
> > should not be callling submit_bio.  The recursive IO submissions
> > should be handled on a dedicated stack, most probably allocated as
> > part of the request queue. This could be done easily in device
> > mapper and md, or better, in submit_bio.
>
> Maybe you should read that latest kernel source code.  Particularly
> generic_make_request in block/ll_rw_blk.c.

And plus you've had that one sitting around since 2005, hats off for
nailing the issue from way out.  Sorry for missing the action, I was 
elsewhere.  Niggles begin here.

I'm not sure I like the additional task_struct encumbrance when the
functions themselves could sort it out, albeit with an API change
affecting a gaggle of md and dm drivers.

Hopefully there are other users of the bio list fields, otherwise I
would point out that a per-queue stack is less memory than two
per-bio fields.  I didn't go delving that far.

The pointer to the description of the barrier deadlock is not right, it
points to the problem report when it really out to point to the
definitive analysis and include a subject line, because list archives
come and go:

   [PATCH] block: always requeue !fs requests at the front
   http://thread.gmane.org/gmane.linux.kernel/537473

Is there a good reason why we should not just put the whole
analysis from Tejun Heo in as a comment?  It is terse enough.

In other words, looks good to me :)

Regards,

Daniel
