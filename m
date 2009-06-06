Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZFFPnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZFFPnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 11:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZFFPnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 11:43:16 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50896 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZFFPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 11:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kl3d3evgTmtsCu/xOA3mpFAOBiFdRkuOnOIYRlz4EXylyO9kpQ3LRknI29PZPlaR0s
         r2bCC5hOIDg8xfna9JlESHUQTPu9++j/0WjS+pDl4P5JO89PkbyHuIBcCEpBw2v9+I1D
         pqsJMyXFHcOgGKBLm83ZmN5R2aMPsngXdFlsg=
MIME-Version: 1.0
In-Reply-To: <4A2993B7.6020208@tlinx.org>
References: <4A288F85.6010809@tlinx.org>
	 <4e5e476b0906050712m33d3cd70kdf60434723f131c1@mail.gmail.com>
	 <4A2993B7.6020208@tlinx.org>
Date: Sat, 6 Jun 2009 17:43:15 +0200
Message-ID: <4e5e476b0906060843y4d438732v4c6f8ea7b5e8b962@mail.gmail.com>
Subject: Re: ionice priority "none: prio 0" v. "none: prio 1" v. best-effort 
	v. idle?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linda,

On Fri, Jun 5, 2009 at 11:52 PM, Linda Walsh<lkml@tlinx.org> wrote:
> <-- vim: se sts=4 sw=4 ts=8 nosi sc ai: /-->
> Thanks for the pointer to the exact C-file for the cfg scheduler, but
> if you intended the 'line' tag to mean anything, line#1579
> would be 38 lines beyond the end of the 1541 line file.

Hhm, which version are you looking at?
cfq-iosched.c is 2676 lines long in my 2.6.30-rc8, and I'm pointing to
function cfq_init_prio_data.
It may be that in your older version, this code is not yet present, or
has a different form.

What I see here:

static void cfq_init_prio_data(struct cfq_queue *cfqq, struct io_context *ioc)
{
        struct task_struct *tsk = current;
        int ioprio_class;

        if (!cfq_cfqq_prio_changed(cfqq))
                return;

        ioprio_class = IOPRIO_PRIO_CLASS(ioc->ioprio);
        switch (ioprio_class) {
        default:
                printk(KERN_ERR "cfq: bad prio %x\n", ioprio_class);
        case IOPRIO_CLASS_NONE:
                /*
                 * no prio set, inherit CPU scheduling settings
                 */
                cfqq->ioprio = task_nice_ioprio(tsk);
                cfqq->ioprio_class = task_nice_ioclass(tsk);
                break;
        case IOPRIO_CLASS_RT:
                cfqq->ioprio = task_ioprio(ioc);
                cfqq->ioprio_class = IOPRIO_CLASS_RT;
                break;
        case IOPRIO_CLASS_BE:
                cfqq->ioprio = task_ioprio(ioc);
                cfqq->ioprio_class = IOPRIO_CLASS_BE;
                break;
        case IOPRIO_CLASS_IDLE:
                cfqq->ioprio_class = IOPRIO_CLASS_IDLE;
                cfqq->ioprio = 7;
                cfq_clear_cfqq_idle_window(cfqq);
                break;
        }
...

The case IOPRIO_CLASS_NONE is the interesting one, since it uses
task_nice_* functions (defined in include/linux/ioprio.h) to inherit
the cpu scheduler priorities.
The rest of the code can assume that IOPRIO_CLASS_NONE will not
appear, since it was already translated to meaningful values.

<snip>
> This would seem to indicate a fundamental error in cfq's io
> scheduling.
>

As I see the code on 2.6.30, cfq is implementing it correctly, but
differently from what is stated in the man page (that, in turn,
matches what you are seeing from an earlier version of it).

> If the above is not the case -- this is the BEST example of why
> I would like "ionice" to return the actual dynamic "io-priority"
> of a process -- IF, it is set by CPU priority, AND would like it
> to be clear where the "cpu-governed priority" class
> (currently labeled 'none', but ideally would be renamed something
> like 'follow-cpu'?) maybe should be renamed 'follow-cpu'?) is
> in relation to the the other named classes (idle,be,rt).
>
It would be nice, but almost impossible to do. The fact is that the
ioprio acquires a meaning only in combination with an io-scheduler.
Different io-schedulers could, in theory, interpret the none class in
different ways (it is not even mentioned in the man). And a process
that is doing I/O on 2 disks could be talking with 2 different
io-schedulers at the same time. 'ionice' cannot therefore give a
single dynamic priority, and it is much easier to have it just display
the values of the fields, instead of their interpretation.

Corrado

>
> So just how confused am I, or,
>
> Is there a problem with the code (as it appears in this module)?
>
> Tnx,
> Linda
>

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
