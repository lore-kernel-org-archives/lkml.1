Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbXLTKyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbXLTKyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 05:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbXLTKyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 05:54:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:16033 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbXLTKyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 05:54:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=YxfwEaFIqpgEQULaOk2T/9OHB3cForhzklDn7FnUvEfLR1A8iRNSmfYcN8eikwYyDN9p+i9SIIGbx5Dr9gBf1R1jkW75Ytd+HOXJFLg6LqSvsKT1P5VDKex3okXLAdti08SR7uFMjJOATH+X/kueYVDuyEHLcDkgUyVEdtmnsfA=
Date: Thu, 20 Dec 2007 13:53:54 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70  -- (triggered by "cat /proc/iomem")
Message-ID: <20071220105354.GC2419@martell.zuzino.mipt.ru>
References: <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com> <4769F409.6030300@gmail.com> <4769FF37.5060308@gmail.com> <20071219220307.d69c0fde.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219220307.d69c0fde.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Okay.  The command that directly triggers this is:       cat /proc/iomem

> > > [  252.868386] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000018

> > > [  252.868481] EIP is at r_show+0x2a/0x70
> > > [  252.868483] EAX: 00000000 EBX: 00000001 ECX: c07e3224 EDX: c04bb034
> > > [  252.868486] ESI: 00000008 EDI: ed1f52c0 EBP: f5320f10 ESP: f5320f04
> > > [  252.868489]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > [  252.868493] Process head (pid: 7088, ti=f5320000 task=f532e000 task.ti=f5320000)

> > > [  252.868552]  [<c0199a7e>] seq_read+0x19a/0x26c
> > > [  252.868557]  [<c01af4f5>] proc_reg_read+0x60/0x74
> > > [  252.868562]  [<c018390d>] vfs_read+0xa2/0x11e
> > > [  252.868567]  [<c0183d02>] sys_read+0x3b/0x60
> > > [  252.868571]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
> > > [  252.868575]  =======================
> > > [  252.868577] Code: c3 55 89 d1 89 e5 57 89 c7 56 53 8b 50 64 83 7a 
> > > 0c 00 77 0e 81 7a 08 ff ff 00 00 be 04 00 00 00 76 05 be 08 00 00 00 
> > > 89 c8 31 db <8b> 40 18 39 d0 74 06 43 83 fb 05 75 f3 8b 41 10 ba 2f 1b 
> > > 45 c0
> > > [  252.868623] EIP: [<c012d527>] r_show+0x2a/0x70 SS:ESP 0068:f5320f04
> > >
> > >
> 
> I would be suspecting iget-stop-procfs-from-using-iget-and-read_inode.patch.

Something is screwed in resources tree?
Miles, you have CONFIG_RESOURCES_64BIT=y, right?

<r_show>:
	55			push	%ebp
	89 d1			mov	%edx,%ecx
	89 e5			mov	%esp,%ebp
	57			push	%edi
	89 c7			mov	%eax,%edi
	56			push	%esi
	53			push	%ebx
	8b 50 64		mov	0x64(%eax),%edx
	83 7a 0c 00		cmpl	$0x0,0xc(%edx)
	77 0e			ja	1f
	81 7a 08 ff ff 00 00	cmpl	$0000ffff,0x8(%edx)
	be 04 00 00 00		mov	$0x4,%esi		# width	= 4
	76 05			jbe	2f
1:	be 08 00 00 00		mov	$0x8,%esi		# width	= 8
2:	89 c8			mov	%ecx,%eax		# %eax = p
	31 db			xor	%ebx,%ebx		# depth	= 0
4:===>	<8b> 40 18		mov	0x18(%eax),%eax		# p = p->parent
	39 d0			cmp	%edx,%eax		# if (p->parent == root)
	74 06			je	3f
	43			inc	%ebx			depth++
	83 fb 05		cmp	$0x5,%ebx		depth <	MAX_IORES_LEVEL
	75 f3			jne	4b
3:	8b 41 10		mov	0x10(%ecx),%eax
	ba 2f 1b 45 c0		mov	$c0451b2f,%edx
