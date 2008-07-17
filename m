Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbYGQUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbYGQUMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbYGQUMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:12:31 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56858 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758816AbYGQUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:12:30 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <487E78ED.30804@redhat.com>
	 <1216249383.3358.69.camel@localhost.localdomain>
	 <487E8CE4.70105@redhat.com>
	 <1216259391.3358.85.camel@localhost.localdomain>
	 <1216304290.5515.11.camel@localhost.localdomain>
	 <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	 <y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 15:12:26 -0500
Message-Id: <1216325546.5515.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 14:30 -0400, Frank Ch. Eigler wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > [...]
> > Just by way of illustration, this is systemtap fixed up according to
> > suggestion number 1.  You can see now using your test case that we get:
> >
> > # probes
> > kernel.function("do_open@fs/block_dev.c:929") /* pc=<lookup_bdev+0x90> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@fs/nfsctl.c:24") /* pc=<sys_nfsservctl+0x6a> */ /* <- kernel.function("do_open") */
> > kernel.function("do_open@ipc/mqueue.c:642") /* pc=<sys_mq_unlink+0x130> */ /* <- kernel.function("do_open") */
> > [...]
> 
> Can you explain in detail how you believe this is materially
> different from offsetting from _stext?

Basically because _stext is an incredibly dangerous symbol; being linker
generated it doesn't actually get put in the right place if you look:

jejb@sparkweed> nm vmlinux |egrep -w '_stext|_text'
ffffffff80209000 T _stext
ffffffff80200000 A _text

Since we can't do negative offsets, you've lost access to the symbols in
the sections that start before _stext.  Assuming you meant _text (which
is dangerous because it's a define in the kernel linker script and could
change).  Then you can't offset into other sections, like init sections
or modules.

James


James


