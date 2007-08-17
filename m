Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXHQPdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXHQPdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXHQPdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:33:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXHQPdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:33:23 -0400
Subject: Re: [Cluster-devel] Re: [gfs2][RFC] readdir caused ls process into
	D (uninterruptible) state, under testing with Samba 3.0.25
From: Steven Whitehouse <swhiteho@redhat.com>
To: rae l <crquan@gmail.com>
Cc: cluster-devel@redhat.com, Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <91b13c310708170043n49c90a79n4d3fed177b9b93b2@mail.gmail.com>
References: <91b13c310708160120v7379d867k73ecf1995719d694@mail.gmail.com>
	 <1187252928.8765.881.camel@quoit>
	 <91b13c310708170043n49c90a79n4d3fed177b9b93b2@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 17 Aug 2007 16:27:12 +0100
Message-Id: <1187364432.8765.916.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2007-08-17 at 15:43 +0800, rae l wrote:
[some comments trimmed for brevity]
> > > then I start a simple ls command on the gfs2 mouting point:
> > > $ ls /mnt/gfs2
> > > the ls process is also changed to D state,
> > >
> > > I think it's problems about readdir implementation in gfs2, and I want
> > > to fix it, someone could give me some pointers?
> > >
> > Can you get a stack trace? echo 't' >/proc/sysrq-trigger
> > That should show where Samba is getting stuck,
> >
> > Steve.
> the stack trace of the 'D' state `ls`:
> 
>  =======================
> ls            D F89B83F8  2200 12018      1 (NOTLB)
>        f3eeadd4 00000082 f6a425c0 f89b83f8 f3eead9c f6a425d4 f6f32d80 f573a93c
>        00010000 f89b83f3 00000000 c40a2030 c3fa9fa0 c40aaa70 c40aab7c 00000e89
>        b2a4b036 000002e4 c40a2030 f3eeae1c 00000000 c3f85e98 f8e11e09 f8e11e0e
> Call Trace:
>  [<f89b83f8>] gdlm_bast+0x0/0x93 [lock_dlm]
>  [<f89b83f3>] gdlm_ast+0x0/0x5 [lock_dlm]
>  [<f8e11e09>] holder_wait+0x0/0x8 [gfs2]
>  [<f8e11e0e>] holder_wait+0x5/0x8 [gfs2]
                ^^^^ This function doesn't exist in recent kernels, so I
guess you are using an older kernel. Which version is it?

>  [<c0303adf>] __wait_on_bit+0x2c/0x51
>  [<c0303b73>] out_of_line_wait_on_bit+0x6f/0x77
>  [<f8e11e09>] holder_wait+0x0/0x8 [gfs2]
>  [<c012dd7d>] wake_bit_function+0x0/0x3c
>  [<c012dd7d>] wake_bit_function+0x0/0x3c
>  [<f8e11e4d>] wait_on_holder+0x3c/0x40 [gfs2]
>  [<f8e12a9a>] glock_wait_internal+0x81/0x1a3 [gfs2]
>  [<f8e12d64>] gfs2_glock_nq+0x5e/0x79 [gfs2]
>  [<f8e1fc02>] gfs2_getattr+0x72/0xb5 [gfs2]
>  [<f8e1fbfb>] gfs2_getattr+0x6b/0xb5 [gfs2]
>  [<c0166946>] do_path_lookup+0x17a/0x1c3
>  [<f8e1fb90>] gfs2_getattr+0x0/0xb5 [gfs2]
>  [<c0161f92>] vfs_getattr+0x3e/0x51
>  [<c016201e>] vfs_lstat_fd+0x2b/0x3d
>  [<c0166946>] do_path_lookup+0x17a/0x1c3
>  [<c0171e40>] mntput_no_expire+0x11/0x6e
>  [<c016260b>] sys_lstat64+0xf/0x23
>  [<c01681a0>] sys_symlinkat+0x81/0xb5
>  [<c01030b8>] sysenter_past_esp+0x5d/0x81
>  [<c0300000>] __ipv6_addr_type+0x88/0xb8
> 
> the system is still running, so the mormal 'R' and 'S' state process
> are ignored, But it turns out that it's not the readdir's fault from
> this call trace, but gdlm_bast's problem in lock_dlm module.
> 
Yes, it does look a bit odd. There was a bug fix (which has only very
recently made it into Linus' kernel as of the last GFS2 pull a few days
ago) which fixes a problem in the DLM, although this doesn't look like
that, at least at first sight.

The other thing which you can check is the glock state which you can
find in /sys/kernel/debug/gfs2/<fsname>/glocks on each node. The list is
usually quite large, so its best to just email a url where it can be
found. That will tell you which processes own which locks and thus what
is holding the lock which is causing the problem. Likewise there is also
a debugfs file which contains the locks from the DLM's point of view
too.

Steve.


