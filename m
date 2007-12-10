Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXLJPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXLJPFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 10:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbXLJPF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 10:05:26 -0500
Received: from gherkin.frus.com ([192.158.254.49]:51046 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXLJPFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 10:05:25 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <1197128912.5483.51.camel@lov.site> "from Kay Sievers at Dec 8,
 2007 04:48:32 pm"
To: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 10 Dec 2007 09:05:13 -0600 (CST)
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, greg@kroah.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071210150513.0C04BDBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, 2007-12-07 at 23:05 -0600, Bob Tracy wrote:
> > Kay Sievers wrote:
> > > Is the udev daemon (still) running while it fails?
> > 
> > Yes, and there's something else I forgot to mention that may be
> > significant...  For the bad case, in addition to udevd, "ps -ef"
> > shows a "sh -e /lib/udev/net.agent" running with a PPID of 1.  This
> > process doesn't exit until I reboot.  If this is normal under the
> > circumstances, please disregard.
> 
> Does SysRq-T show where it hangs?

A quick comparison of the trace sections for udevd and net.agent indicates
those traces are identical: none of the function names in the traces appear
to be what you might be looking for, i.e., the processes appear to have been
waiting for an event of some kind, and woke up long enough to process the
SysRq-T keyboard interrupt and the corresponding action.

Hmm...  Ok...  The state information itself is probably more useful in
this context.  Here's the info for net.agent:

net.agent      S      fffffc000032c37c   0    895    1
  fffffc0000743b10  0000000000000010  fffffc00004f3b5c  fffffc00007601a8
    0000000000000001  0000000000000074  fffffc0000747758  fffffc00230f0000
    0000000000000007  0000000000000007  fffffc00004f390c  0000000000000010
    fffffc00004e9eb8  fffffc00230f0000  0000000000000014  fffffc0023085140
    0000000000000001  0000000000000014  fffffc00001de000  0000000000000001
    fffffc000055dcfc  fffffc0023085140  fffffc00232788c0  0000000000000001

Addresses of presumed interest from System.map:

fffffc000032c000 t do_wait
fffffc0000740000 D init_thread_union
fffffc00004f3b40 t sysrq_handle_showstate
fffffc00007601a8 d sysrq_showstate_op
fffffc0000747758 D console_printk
fffffc002...  not in System.map (module?) -- I'll track this down later
   if needed.
fffffc00004f3850 T __handle_sysrq
fffffc00004e9850 t kbd_event
fffffc00001...  not in System.map (?? begins with fffffc0000300000 A swapper_pg_dir)
fffffc000055dc30 t input_pass_event

--Bob T.
