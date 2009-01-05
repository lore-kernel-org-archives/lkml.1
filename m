Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZAETqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZAETqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZAETqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:46:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38863 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZAETqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:46:21 -0500
Date: Mon, 5 Jan 2009 14:46:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: [PATCH] sparc: make proces_ver_nack a bit more readable
In-Reply-To: <alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901051443100.27085@gandalf.stny.rr.com>
References: <20090105181922.GA25622@uranus.ravnborg.org> <alpine.DEB.1.10.0901051428370.27085@gandalf.stny.rr.com> <alpine.DEB.1.10.0901051437490.27085@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 Jan 2009, Steven Rostedt wrote:

> 
> Impact: clean up
> 
> The code in process_ver_nack is a little obfuscated. This change
> makes it a bit more readable by humans. It removes the complex
> if statement and replaces it with a cleaner flow of control.

Note, I do not have a sparc compiler at my disposal, so I was not
able to compile (or boot) test this change.

Here's the original code:

static int process_ver_nack(struct ldc_channel *lp, struct ldc_version 
*vp)
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


And the new code:

static int process_ver_nack(struct ldc_channel *lp, struct ldc_version 
*vp)
{
        struct ldc_version *vap;
        struct ldc_packet *p;
        unsigned long new_tail;

        if (vp->major == 0 && vp->minor == 0)
                return ldc_abort(lp);

        vap = find_by_major(vp->major);
        if (!vap)
                return ldc_abort(lp);

        p = handshake_compose_ctrl(lp, LDC_INFO, LDC_VERS,
                                           vap, sizeof(*vap),
                                           &new_tail);
        if (!p)
                return ldc_abort(lp);

        return send_tx_packet(lp, p, new_tail);
}

This should be binary the same. But as I said, I do not have a sparc 
compiler to test.

Thanks,

-- Steve
