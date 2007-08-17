Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXHQHnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXHQHnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbXHQHnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:43:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:23991 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbXHQHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dgrfnJ3t+1YTIO0TxV2nPd43uIeKJks0FZn4mWIFWRkR/UwqS6SewDX/9//IDGapjWG4d3/x5Lr+qURR1vvE6o9S8DxnGyD7XlSg1ExPMzdOEMlIQYITufqjxuifM+//W62Svv/jgpbvu3NwgD/InbSGqjUr4z6DUeWuFPpnzi8=
Message-ID: <91b13c310708170043n49c90a79n4d3fed177b9b93b2@mail.gmail.com>
Date: Fri, 17 Aug 2007 15:43:38 +0800
From: "rae l" <crquan@gmail.com>
To: "Steven Whitehouse" <swhiteho@redhat.com>
Subject: Re: [Cluster-devel] Re: [gfs2][RFC] readdir caused ls process into D (uninterruptible) state, under testing with Samba 3.0.25
Cc: cluster-devel@redhat.com,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1187252928.8765.881.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310708160120v7379d867k73ecf1995719d694@mail.gmail.com>
	 <1187252928.8765.881.camel@quoit>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/07, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On Thu, 2007-08-16 at 16:20 +0800, 程任全 wrote:
> > It seems that gfs2 cannot work well with Samba,
> >
> > I'm using the gfs2 and the new cluster suite(cman with openais),
> >
> > 1. the testing environment is that 1 iscsi target and 2 cluster node,
> > 2. the two nodes both used iscsi initiator connect to the target,
> > 3. they're using the same physical iscsi disk,
> > 4. run LVM2 on top of the same iscsi disk,
> > 5. on the same lv (logical volume), I created a gfs2 filesystem,
> > 6. mount the gfs2 system to a same path under 2 nodes,
> > 7. start samba to shared the gfs2 mounting pointer on the 2 nodes,
> >
> > now test with windows client, when two or above clients connects to the samba,
> > everything is still normal; but when heavy writers or readers start,
> > the samba server daemon changed to D state, that's uninterruptible in
> > the kernel,
> > I wonder that's a problem of gfs2?
> >
> Which version of gfs2 are you using? GFS2 doesn't support leases which I
> know that Samba uses, however only relatively recent kernels have been
> able to report that fact via the VFS.
>
> > then I start a simple ls command on the gfs2 mouting point:
> > $ ls /mnt/gfs2
> > the ls process is also changed to D state,
> >
> > I think it's problems about readdir implementation in gfs2, and I want
> > to fix it, someone could give me some pointers?
> >
> Can you get a stack trace? echo 't' >/proc/sysrq-trigger
> That should show where Samba is getting stuck,
>
> Steve.
the stack trace of the 'D' state `ls`:

 =======================
ls            D F89B83F8  2200 12018      1 (NOTLB)
       f3eeadd4 00000082 f6a425c0 f89b83f8 f3eead9c f6a425d4 f6f32d80 f573a93c
       00010000 f89b83f3 00000000 c40a2030 c3fa9fa0 c40aaa70 c40aab7c 00000e89
       b2a4b036 000002e4 c40a2030 f3eeae1c 00000000 c3f85e98 f8e11e09 f8e11e0e
Call Trace:
 [<f89b83f8>] gdlm_bast+0x0/0x93 [lock_dlm]
 [<f89b83f3>] gdlm_ast+0x0/0x5 [lock_dlm]
 [<f8e11e09>] holder_wait+0x0/0x8 [gfs2]
 [<f8e11e0e>] holder_wait+0x5/0x8 [gfs2]
 [<c0303adf>] __wait_on_bit+0x2c/0x51
 [<c0303b73>] out_of_line_wait_on_bit+0x6f/0x77
 [<f8e11e09>] holder_wait+0x0/0x8 [gfs2]
 [<c012dd7d>] wake_bit_function+0x0/0x3c
 [<c012dd7d>] wake_bit_function+0x0/0x3c
 [<f8e11e4d>] wait_on_holder+0x3c/0x40 [gfs2]
 [<f8e12a9a>] glock_wait_internal+0x81/0x1a3 [gfs2]
 [<f8e12d64>] gfs2_glock_nq+0x5e/0x79 [gfs2]
 [<f8e1fc02>] gfs2_getattr+0x72/0xb5 [gfs2]
 [<f8e1fbfb>] gfs2_getattr+0x6b/0xb5 [gfs2]
 [<c0166946>] do_path_lookup+0x17a/0x1c3
 [<f8e1fb90>] gfs2_getattr+0x0/0xb5 [gfs2]
 [<c0161f92>] vfs_getattr+0x3e/0x51
 [<c016201e>] vfs_lstat_fd+0x2b/0x3d
 [<c0166946>] do_path_lookup+0x17a/0x1c3
 [<c0171e40>] mntput_no_expire+0x11/0x6e
 [<c016260b>] sys_lstat64+0xf/0x23
 [<c01681a0>] sys_symlinkat+0x81/0xb5
 [<c01030b8>] sysenter_past_esp+0x5d/0x81
 [<c0300000>] __ipv6_addr_type+0x88/0xb8

the system is still running, so the mormal 'R' and 'S' state process
are ignored, But it turns out that it's not the readdir's fault from
this call trace, but gdlm_bast's problem in lock_dlm module.

>
>
>


-- 
Denis Cheng
