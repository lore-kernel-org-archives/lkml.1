Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYHRTrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYHRTrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765456AbYHRTmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:42:49 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42493 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516AbYHRTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Bl7jeCIL0comy8LhTGax18A7jAL9FmTYqxp0SvA+rnFkMIqp7wwCRwwl1dWG0vzl/e
         JqCV9SSxS8eLTIz/DzR0+bsDISYIDHzf86d6/R6P1CpSIriK0HSWeJgmPHF6JIZIrVTD
         Yqy4qfFImYb4bakuRk83BBNodzZlqedh1gC6A=
Message-ID: <19f34abd0808181242x7ec382c7o53e54fb7758c74fa@mail.gmail.com>
Date: Mon, 18 Aug 2008 21:42:45 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Philippe Elie" <phil.el@wanadoo.fr>, "Ingo Molnar" <mingo@elte.hu>
Subject: latest -git: [x86/oprofile] BUG: using smp_processor_id() in preemptible
Cc: "Johannes Weiner" <hannes@saeurebad.de>, "Mike Travis" <travis@sgi.com>,
       oprofile-list@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just got this on latest -git (+ unrelated build fix):

BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/4133
APIC error on CPU1: 00(40)
APIC error on CPU0: 00(40)
APIC error on CPU1: 40(40)
APIC error on CPU0: 40(40)
caller is get_stagger+0x9/0x30
Pid: 4133, comm: oprofiled Not tainted 2.6.27-rc3-00415-g122c9e0 #9
 [<c037228e>] debug_smp_processor_id+0xce/0xd0
 [<c0583d19>] get_stagger+0x9/0x30
 [<c05843de>] p4_fill_in_addresses+0x1e/0x3a0
 [<c058313d>] nmi_setup+0xcd/0x190
 [<c05811fa>] oprofile_setup+0x3a/0xc0
 [<c05820a6>] event_buffer_open+0x56/0x80
 [<c01a22c4>] __dentry_open+0xf4/0x1f0
 [<c01a2407>] nameidata_to_filp+0x47/0x60
 [<c0582050>] ? event_buffer_open+0x0/0x80
 [<c01ae1bc>] do_filp_open+0x18c/0x6d0
 [<c015626d>] ? put_lock_stats+0xd/0x30
 [<c01b883c>] ? alloc_fd+0xdc/0x100
 [<c0371bb6>] ? _raw_spin_unlock+0x46/0x80
 [<c066af57>] ? _spin_unlock+0x27/0x50
 [<c01a208b>] do_sys_open+0x4b/0xe0
 [<c0362da4>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c01a2189>] sys_open+0x29/0x40
 [<c01040db>] sysenter_do_call+0x12/0x3f
 =======================

I didn't want to simply wrap the code in
preempt_enable()/preempt_disable(), because that feels too much like
papering over a bigger design error.

I think oprofile is in big trouble SMP-wise, also indicated by Mike
Travis's comments in commit d18d00f5dbcd1a95811617e9812cf0560bd465ee:
"The existing code passed a reference to cpu 0's instance of struct
op_msrs to model->shutdown, whilst the other functions are passed a
reference to <this cpu's> instance of a struct op_msrs.  This seemed
to be a bug to me even though as long as cpu 0 and <this cpu> are of
the same type it would have the same effect...?"

Any ideas on how to best solve this?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
