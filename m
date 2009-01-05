Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZAESSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZAESSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZAESRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:17:48 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48210 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZAESRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:17:47 -0500
Date: Mon, 5 Jan 2009 19:19:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: ftrace breaks sparc64 build
Message-ID: <20090105181922.GA25622@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With an allmodconfig build on sparc and sparc64 I started
to see warnings that become propagated to errors by -Werror.

Example:
  CC      arch/sparc/kernel/ldc.o
arch/sparc/kernel/ldc.c: In function `process_control_frame':
arch/sparc/kernel/ldc.c:627: warning: 'vap' might be used uninitialized in this function


The code in question looks like this:
static int process_ver_nack(struct ldc_channel *lp, struct ldc_version *vp)
{
        struct ldc_version *vap;

        if ((vp->major == 0 && vp->minor == 0) ||
            !(vap = find_by_major(vp->major))) {
                return ldc_abort(lp);
        } else {
                struct ldc_packet *p;
                unsigned long new_tail;

                p = handshake_compose_ctrl(lp, LDC_INFO, LDC_VERS,
                                           vap, sizeof(*vap),
                                           &new_tail);
                if (p)
                        return send_tx_packet(lp, p, new_tail);
                else
                        return ldc_abort(lp);
        }
}

The else part will never be executed whitout assigning vap,
and this code do not emit warnings in the normal case.
[I am well aware that we recommend to move the assignment
out of the if () - but this code worked as is before].

This code gets expanded to:

static int process_ver_nack(struct ldc_channel *lp, struct ldc_version *vp)
{
	struct ldc_version *vap;

	if (__builtin_constant_p(((vp->major == 0 && vp->minor == 0) || !(vap = find_by_major(vp->major)))) ? 
	!!((vp->major == 0 && vp->minor == 0) || !(vap = find_by_major(vp->major))) : 
	({
		int ______r;
		static struct ftrace_branch_data  ______f = { .func = __func__, .file = "arch/sparc/kernel/ldc.c", .line = 630, };
		______r = !!((vp->major == 0 && vp->minor == 0) || !(vap = find_by_major(vp->major)));
		if (______r)
			______f.hit++;
		else
			______f.miss++; ______r;
	})) {

		return ldc_abort(lp);
	} else {
		struct ldc_packet *p;
		unsigned long new_tail;

		p = handshake_compose_ctrl(lp, 0x01, 0x01, vap, sizeof(*vap), &new_tail);
		if (__builtin_constant_p((p)) ? !!(p) : ({
			int ______r;
			static struct ftrace_branch_data ______f = { .func = __func__, .file = "arch/sparc/kernel/ldc.c", .line = 639, };
			______r = !!(p);
			if (______r)
				______f.hit++;
			else ______f.miss++;
				______r;
		}))
	 		return send_tx_packet(lp, p, new_tail);
		else
			return ldc_abort(lp);
	}
}
I have inserted newlines + tabs and removed a few __attribute__()
to keep line lengths to a sensible level.

My head started to spin with a dangerous speed trying to figure out
the code snippet above.

On top of this some inlining occurs which is why gcc point at another
function name.


This is with following gcc version:

sparc64-unknown-linux-gnu-gcc (GCC) 3.4.5
Copyright (C) 2004 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Build using crosstool.

Is this a known issue?

Any recommendations?

	Sam
