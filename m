Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZJAISk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZJAISk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZJAISj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:18:39 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:58128 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbZJAISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:18:37 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Thu, 1 Oct 2009 10:17:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-prerelease; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291531.23389.borntraeger@de.ibm.com> <20090930171321.GA17200@amit-x200.redhat.com>
In-Reply-To: <20090930171321.GA17200@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910011017.29502.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 30 September 2009 19:13:21 schrieb Amit Shah:
> On (Tue) Sep 29 2009 [15:31:23], Christian Borntraeger wrote:
> > Am Dienstag 29 September 2009 15:09:50 schrieb Amit Shah:
> > > Great, thanks. However I was thinking of moving this init to the
> > > probe() routine instead of in the init_conosle routine just because
> > > multiple consoles can be added and we don't want to init this each
> > > time.. just once in probe is fine.
> >
> > If you have new patch CC me and I can give it a spin.
> 
> Hey Christian,
> 
> I have a new patch that changes a few things:
> - moves the put_char fix to probe instead of doing it in
>   init_port_console(), which gets called on each console port found.
> - uses port->id instead of a static hvc_vtermno to pass on a value to
>   hvc_alloc(). Motivation explained within comments in the code.
> - A few other changes that introduce and make use of port->vcon instead
>   of accessing the static virtconsole directly -- aimed at easing future
>   fix to have multiple virtio-console devices.
> 
> It would be great if you could test this.

The basic stuff seems to work, but when I did a console resize I get:

    <0>------------[ cut here ]------------                                                                       
    <2>kernel BUG at drivers/s390/kvm/kvm_virtio.c:117!                                                           
    <4>illegal operation: 0001 [#1] SMP                                                                           
    <4>Modules linked in: dm_multipath scsi_dh sunrpc ipv6 binfmt_misc dm_mod virtio_rng rng_core                 
    <4>CPU: 0 Not tainted 2.6.31-selfgit-08936-g851b147-dirty #172                                                
    <4>Process events/0 (pid: 19, task: 000000000c4f3040, ksp: 000000000c305cc8)                                  
    <4>Krnl PSW : 0704200180000000 0000000000460bf2 (kvm_get+0x86/0x90)                                           
    <4>           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3                                         
    <4>Krnl GPRS: 0000000300000001 0000000000000004 0000000000000008 0000000000000004                             
    <4>           000000000c305e2c 0000000000000004 0000000000000000 0000000000c56308                             
    <4>           00000000003b863c 000000000c4f3040 0000000000460b6c 0000000000903e28                             
    <4>           000000000c800000 0000000000525a90 00000000003b8682 000000000c305d88                             
    <4>Krnl Code: 0000000000460be6: a737fff9            brctg   %r3,460bd8                                        
    <4>           0000000000460bea: a7f4ffee            brc     15,460bc6                                         
    <4>           0000000000460bee: a7f40001            brc     15,460bf0
    <4>          >0000000000460bf2: a7f40000            brc     15,460bf2
    <4>           0000000000460bf6: d20040001000        mvc     0(1,%r4),0(%r1)
    <4>           0000000000460bfc: ebaff0680024        stmg    %r10,%r15,104(%r15)
    <4>           0000000000460c02: c0d000081b7f        larl    %r13,564300
    <4>           0000000000460c08: a7f11fc0            tmll    %r15,8128
    <4>Call Trace:
    <4>([<0000000000000000>] 0x0)
    <4> [<000000000015d43e>] worker_thread+0x1ea/0x2d0
    <4> [<0000000000163666>] kthread+0x9a/0xa4
    <4> [<000000000010a212>] kernel_thread_starter+0x6/0xc
    <4> [<000000000010a20c>] kernel_thread_starter+0x0/0xc
    <4>Last Breaking-Event-Address:
    <4> [<0000000000460bee>] kvm_get+0x82/0x90
    <4>

One of the config->get() related changes is probably wrong.

