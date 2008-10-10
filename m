Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYJJOhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYJJOhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbYJJOh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:37:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47353 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024AbYJJOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:37:27 -0400
Date: Fri, 10 Oct 2008 16:37:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: fix leak of uninitialized data to userspace
	(acpi_system_read_event)
Message-ID: <20081010143707.GC21104@elte.hu>
References: <126003.45052.qm@web38204.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <126003.45052.qm@web38204.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> > From: Ingo Molnar <mingo@elte.hu>
> 
> > 
> > * Vegard Nossum wrote:
> >
> > > ...so it seems that dev->unique is never updated to reflect the
> > > actual length of the string. The remaining bytes (20 in this case)
> > > are random uninitialized bytes that are copied into userspace.
> > > 
> > > This patch fixes the problem by setting dev->unique_len after the
> > > snprintf().
> > > 
> > > Completely untested.
> > > 
> > > Reported-by: Sitsofe Wheeler 
> > > Signed-off-by: Vegard Nossum 
> > 
> > i've stuck it into the tip/out-of-tree quick-fixes branch.
> > 
> > Sitsofe, could you please check very latest tip/master with 
> > CONFIG_KMEMCHECK=y, does it find any other uninitialized memory access?
> 
> No other uninitialized memory access so far (although having kmemcheck on does seem to provoke rcu stall warnings)...
> 
> ...I take it back. This just turned up:
> [  992.417019] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f2363d14)
> [  992.417033] 000110000002200061635f61646170746572000000000000cc2c030041433000
> [  992.417077]  i i i i i i i i i i i i i i i i i i i u u u u u u u u u i i i i
> [  992.417117]                                          ^
> [  992.417121] 
> [  992.417127] Pid: 1893, comm: acpid Not tainted (2.6.27-tipskw-00088-g9f41241-dirty #84) 900
> [  992.417134] EIP: 0060:[<c025fbdd>] EFLAGS: 00000286 CPU: 0
> [  992.417147] EIP is at acpi_bus_receive_event+0xd6/0x109
> [  992.417153] EAX: 00054489 EBX: f2363d00 ECX: 00000006 EDX: ffffffed
> [  992.417158] ESI: f2363d14 EDI: f6057f28 EBP: f6057f08 ESP: c0566d68
> [  992.417164]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [  992.417169] CR0: 8005003b CR2: f6671034 CR3: 360ea000 CR4: 000006c0
> [  992.417175] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  992.417180] DR6: ffff4ff0 DR7: 00000400
> [  992.417184]  [<c026b86f>] acpi_system_read_event+0x49/0xc5
> [  992.417195]  [<c01b2381>] proc_reg_read+0x61/0x90
> [  992.417206]  [<c017efb5>] vfs_read+0x95/0x120
> [  992.417215]  [<c017f5f2>] sys_read+0x42/0x70
> [  992.417222]  [<c010336d>] sysenter_do_call+0x12/0x35
> [  992.417230]  [<ffffffff>] 0xffffffff

this too could be a real bug i think, uncovered by kmemcheck. Vegard?

	Ingo
