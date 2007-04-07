Return-Path: <linux-kernel-owner+w=401wt.eu-S966315AbXDGUT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966315AbXDGUT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966328AbXDGUT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:19:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:48894 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966315AbXDGUT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JbVuQU2iwNgVqX0DDnkXLoWSXdo6yZgi5l7usbjXpqZm85giV2NODL9/0pc2UBW/GB7W4A5X52M4eJfDStO0hKqyJwdB4d2srPtIP9/cI3GNl5rEa6B75lyBr/sd5TE5YZDUZ7UKRhtjLDD1uUyRQiS/SGFI6AS/VZ493R4f7ZA=
Message-ID: <6bffcb0e0704071319u373cc6fci2e0637c57ee5381e@mail.gmail.com>
Date: Sat, 7 Apr 2007 22:19:27 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
Cc: LKML <linux-kernel@vger.kernel.org>, "Roland McGrath" <roland@redhat.com>
In-Reply-To: <20070407131351.39c7884d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
	 <46178ECC.2030107@googlemail.com>
	 <20070407105328.836902d1.akpm@linux-foundation.org>
	 <4617DE67.4090801@googlemail.com>
	 <20070407113829.c10e9fd1.akpm@linux-foundation.org>
	 <6bffcb0e0704071148m238a7d96x5038e1c9f4fdfeeb@mail.gmail.com>
	 <20070407131351.39c7884d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 7 Apr 2007 20:48:43 +0200 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>
> > On 07/04/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Sat, 07 Apr 2007 20:09:43 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > >
> > > > BTW. I guess that this need a similar fix.
> > > >
> > > > kernel BUG at kernel/ptrace.c:494!
> > > > invalid opcode: 0000 [#2]
> > > > PREEMPT SMP
> > > > last sysfs file: devices/platform/w83627hf.656/temp2_input
> > > > Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss intel_agp snd_pcm agpgart evdev snd_timer snd soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
> > > > CPU:    1
> > > > EIP:    0060:[<c0163f22>]    Not tainted VLI
> > > > EFLAGS: 00010202   (2.6.21-rc6-mm1 #1)
> > > > EIP is at ptrace_exit+0x29/0x21d
> > > >
> > >
> > > no, I don't see what would cause that.  Was there no call trace?
> >
> > Here is a call trace (it was in the first email).
> >
> > Call Trace:
> >  [<c012820e>] do_exit+0x16b/0x86c
> >  [<c0105a77>] die+0x206/0x22c
> >  [<c0105b27>] do_trap+0x8a/0xa4
> >  [<c0105e93>] do_invalid_op+0x88/0x92
> >  [<c0351e89>] error_code+0x79/0x80
> >  [<c0163566>] ptrace_do_wait+0x1eb/0x510
> >  [<c0127e10>] do_wait+0x9d6/0xbad
> >  [<c0128017>] sys_wait4+0x30/0x32
> >  [<c0128040>] sys_waitpid+0x27/0x29
> >  [<c010424c>] syscall_call+0x7/0xb
> >  [<b7f36410>] 0xb7f36410
>
> Was that with the earlier ptrace fix applied?

No, it wasn't. I'll retest with patch applied.

>
> Because what could happen is that ptrace_do_wait() (or anything else)
> goes BUG, then the trap handler ends up calling do_exit(), which calls
> ptrace_exit() which will then go BUG again over non-zero preempt_count.
>
> Asserting that preempt_count==0 on the do_exit() path is a bad idea, because
> do_exit() is called on the oops path - we're virtually assured that we'll get
> recursive crashes.
>
> I think I'll just disable the whole NO_LOCKS thing.
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
