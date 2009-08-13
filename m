Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZHMPEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZHMPEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZHMPEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:04:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47925 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbZHMPEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:04:45 -0400
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0908130804010.1283@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <1249500006.4365.86.camel@lexx>
	 <alpine.LFD.2.00.0908112005190.1283@localhost.localdomain>
	 <1250109930.7493.165.camel@lexx>
	 <alpine.LFD.2.00.0908130804010.1283@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Thu, 13 Aug 2009 10:04:26 -0500
Message-Id: <1250175866.6419.34.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 09:30 +0200, Thomas Gleixner wrote:
> Will,
> 
> On Wed, 12 Aug 2009, Will Schmidt wrote:
> > The .find_legacy_serial_ports function in the backtrace is very very
> > early during boot.   I'll do a bit more looking around to see if it's
> > anything obvious,..  
> 
> I almost expected some wreckage from converting a rwlock to a
> spinlock. Grr. That code really takes the lock recursive. None of my
> powerpc systems triggered that code path. :(
> 
> So the reason for having a rwlock was not the concurrent access, it
> was just the lazy^W reuse of the existing functions which lead to
> recursive locking.
> 
> As it's the only code in tree which would need the real rwlock version
> I fixed up the of code instead of creating all the extra rwlock
> functions for rt.
> 
> Does the patch below fix it ?

Yes, and thanks for spinning that up for me.

With this patch, the reported problem is cleared up..   :-)  Now I'm
getting as far as finding the other processors in the system before it
stops.  :-(

Last output on the console is 
"
...
clockevent: decrementer mult[83126e97] shift[32] cpu[3]
Processor 3 found.
clockevent: decrementer mult[83126e97] shift[32] cpu[4]
Processor 4 found.
"

Some other info is in the log_buf, I got this via xmon dump, and parsed
it by hand, try to ignore the extra spaces..  :-)

<7>xics: map virq 16, hwi rq 0x2.
<7>irq: i rq 2 on host nul l mapped to virt ual irq 16.
<7>xi cs: unmask virq 16.
<7> -> map to hwirq 0x2.
<6>Te sting tracer nop : PASSED.
<7>cloc kevent: decremen ter mult[83126e9 7] shift[32] cpu [1].
<4>Processor 1 found..
<7>clo ckevent: decreme nter mult[83126e 97] shift[32] cp u[2].
<4>Processo r 2 found..
<7>cl ockevent: decrem enter mult[83126 e97] shift[32] c pu[3].
<4>Process or 3 found..
<7>c lockevent: decre menter mult[8312 6e97] shift[32] cpu[4].
<4>Proces sor 4 found..
<4> .
<4>============ ================ =====.
<4>[ INFO: inconsistent lo ck state ].
<4>2. 6.31-rc4-rt1-wms .aug12 #3.
<4>--- ---------------- --------------.
< 4>inconsistent { HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage..
<4>irq/16 -IPI/3 [HC1[1]:S C0[0]:HE0:SE1] t akes:.
<4> (devtr ee_lock){?.+...} , at: [
<c0000000 006684f8>] .of_f ind_property+0x4 c/0x9c.
<4>{HARDI RQ-ON-W} state w as registered at :.
<4> [
<c000000 000119090>] .__l ock_acquire+0x69 8/0x900.
<4> [
<c 00000000011a3ec> ] .lock_acquire+ 0x144/0x194.
<4> [
<c0000000007ac 7d8>] ._atomic_s pin_lock+0x58/0x 84.
<4> [
<c00000 0000668dfc>] .of _find_node_by_na me+0x40/0x110.
<4 > [
<c0000000005 0d320>] .hvc_fin d_vtys+0x128/0x1 68.
<4> [
<c00000 0000b78c68>] .co nsole_init+0x50/ 0x7c.
<4> [
<c000 000000b34d70>] . start_kernel+0x3 40/0x59c.
<4> [
< c0000000000083d8 >] .start_here_c ommon+0x1c/0x44. 
<4>irq event sta mp: 9532942.
<4>h ardirqs last en abled at (953294 1): [
<c000000000 008a1c>] restore +0x1c/0xec.
<4>ha rdirqs last disa bled at (9532942 ): [
<c0000000000 04808>] hardware _interrupt_entry +0x10/0x20.
<4>so ftirqs last ena bled at (0): [
<c 0000000000bb6e4> ] .copy_process+ 0x8dc/0x20c8.
<4> softirqs last di sabled at (0): [ 
<(null)>] (null) .
<4>.
<4>other in fo that might he lp us debug this :.
<4>1 lock held by irq/16-IPI/3 :.
<4> #0: (&rq- >lock){-.....}, at: [
<c000000000 09bc20>] .task_r q_lock+0x80/0x12 8.
<4>.
<4>stack b acktrace:.
<4>Cal l Trace:.
<4>[c00 000000fffaf40] [ c0000000000181ac ] .show_stack+0x 124/0x320
(unrel iable).
<4>[c0000 0000fffb010] [c0 0000000001a410] .dump_stack+0x28 /0x3c.
<4>[c00000 000fffb090] [c00 0000000114dc0] . print_usage_bug+
0x1dc/0x214.
<4>[ c00000000fffb150 ] [c000000000115 18c] .mark_lock+ 0x394/0x700.
<4>[ c00000000fffb210 ] [c000000000119 008] .__lock_acq uire
+0x610/0x900 .
<4>[c00000000ff fb310] [c0000000 0011a3ec] .lock_ acquire+0x144/0x 194.
<4>[c0000000 0fffb3e0] [c0000 000007ac7d8] ._a tomic_spin_lock+
0x58/0x84.
<4>[c0 0000000fffb470] [c0000000006684f 8] .of_find_prop erty+0x4c/0x9c.
< 4>[c00000000fffb 510] [c000000000 66858c] .of_get_ property+0x44/0x
78.
<4>[c00000000 fffb5b0] [c00000 000002f244] .rta s_token+0x6c/0xa 0.
<4>[c00000000f ffb640] [c000000 00007ffe8] .fwnm i_release_errinf o
+0x24/0x98.
<4>[ c00000000fffb6c0 ] [c000000000080 3f4] .pSeries_sy stem_reset_excep
tion+0x94/0xb0.
< 4>[c00000000fffb 750] [c000000000 03dae4] .system_ reset_exception+
0x7c/0x174.
<4>[c 00000000fffb7e0] [c0000000000034 04] system_reset _common+0x104/0x
180.
<4>--- Excep tion: 100 at ._r aw_spin_lock+0x8 0/0x2e8.
<4> L R = ._raw_spin_l ock+0x64/0x2e8.
< 4>[c00000000fffb b70] [c000000000 7ac7e4] ._atomic _spin_lock+0x64/
0x84.
<4>[c000000 00fffbc00] [c000 00000009bc20] .t ask_rq_lock+0x80 /0x128.
<4>[c0000 0000fffbcb0] [c0 000000000b33f4] .try_to_wake_up+ 0x114/0x6e0.
<4>[ c00000000fffbd90 ] [c0000000000b3 bac] .wake_up_pr ocess
+0x38/0x50. 
<4>[c00000000fff be20] [c00000000 0155a70] .handle _IRQ_event
+0x3f4 /0x460.
<4>[c0000 0000fffbef0] [c0 0000000015a06c] .handle_percpu_i rq
+0xbc/0x184.
<4 >[c00000000fffbf 90] [c0000000000 40da8] .call_han dle_irq+0x1c/0x2
c.
<4>[c00000006a 3e7940] [c000000 000011cb4] .do_I RQ+0x20c/0x30c.
< 4>[c00000006a3e7 9f0] [c000000000 004814] hardware _interrupt_entry
+0x1c/0x20.
<4>-- - Exception: 501 at .raw_local_i rq_restore+0x10c /0x124.
<4> LR = .schedule+0x5 8/0xbc.
<4>[c0000 0006a3e7d70] [c0 000000001588dc] .irq_thread+0x41 c/0x4a4.
<4>[c000 00006a3e7e20] [c 0000000000f7844] .kthread+0xdc/0 xe8.
<4>[c0000000 6a3e7f90] [c0000 00000041010] .ke rnel_thread
+0x54 /0x70....

No additional spinlock error messages, I'll see what else I can figure
out and follow up with more details.


> 
> Thanks,
> 
> 	tglx
> -----
> commit 925df9b36dc9abe0bab32cbd2ac544d773da71ff
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Aug 13 09:04:10 2009 +0200


