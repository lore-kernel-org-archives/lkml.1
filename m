Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXHRPvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXHRPvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 11:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXHRPv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 11:51:29 -0400
Received: from main.gmane.org ([80.91.229.2]:42824 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbXHRPv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 11:51:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Panic with XFS on RHEL5 (2.6.18-8.1.8.el5)
Date: Sat, 18 Aug 2007 16:51:15 +0100
Message-ID: <yw1xmywokfik.fsf@thrashbarg.mansr.com>
References: <46C6C145.70506@abacustree.com> <yw1xr6m1ja7o.fsf@thrashbarg.mansr.com> <46C6FF93.4040509@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: agrajag.inprovide.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:T3dhyE8SKnjPs3seJU4zVXu3BsI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Boot <bootc@bootc.net> writes:

> Måns Rullgård wrote:
>> Chris Boot <chris.boot@abacustree.com> writes:
>>
>>
>>> All,
>>>
>>> I've got a box running RHEL5 and haven't been impressed by ext3
>>> performance on it (running of a 1.5TB HP MSA20 using the cciss
>>> driver). I compiled XFS as a module and tried it out since I'm used to
>>> using it on Debian, which runs much more efficiently. However, every
>>> so often the kernel panics as below. Apologies for the tainted kernel,
>>> but we run VMware Server on the box as well.
>>>
>>> Does anyone have any hits/tips for using XFS on Red Hat? What's
>>> causing the panic below, and is there a way around this?
>>>
>>> BUG: unable to handle kernel paging request at virtual address b8af9d60
>>> printing eip:
>>> c0415974
>>> *pde = 00000000
>>> Oops: 0000 [#1]
>>> SMP last sysfs file: /block/loop7/dev
[...]
>>> [<f936884e>] xfsbufd_wakeup+0x28/0x49 [xfs]
>>> [<c04572f9>] shrink_slab+0x56/0x13c
>>> [<c0457c0c>] try_to_free_pages+0x162/0x23e
>>> [<c0454064>] __alloc_pages+0x18d/0x27e
>>> [<c045214e>] find_or_create_page+0x53/0x8c
>>> [<c046c7b1>] __getblk+0x162/0x270
>>> [<c0475be0>] do_lookup+0x53/0x157
>>> [<f889138f>] ext3_getblk+0x7c/0x233 [ext3]
>>> [<f88913fe>] ext3_getblk+0xeb/0x233 [ext3]
>>> [<c048215c>] mntput_no_expire+0x11/0x6a
>>> [<f889226e>] ext3_bread+0x13/0x69 [ext3]
>>> [<f8895606>] htree_dirblock_to_tree+0x22/0x113 [ext3]
>>> [<f889574f>] ext3_htree_fill_tree+0x58/0x1a0 [ext3]
>>> [<c047828b>] do_path_lookup+0x20e/0x25f
>>> [<c046b987>] get_empty_filp+0x99/0x15e
>>> [<f889d611>] ext3_permission+0x0/0xa [ext3]
>>> [<f888eaa3>] ext3_readdir+0x1ce/0x59b [ext3]
>>> [<c047a0dd>] filldir+0x0/0xb9
>>> [<c0472973>] sys_fstat64+0x1e/0x23
>>> [<c047a1f9>] vfs_readdir+0x63/0x8d
>>> [<c047a0dd>] filldir+0x0/0xb9
>>> [<c047a447>] sys_getdents+0x5f/0x9c
>>> [<c0403eff>] syscall_call+0x7/0xb
>>> =======================
>>>
>>
>> Your Redhat kernel is probably built with 4k stacks and XFS+loop+ext3
>> seems to be enough to overflow it.
>>
> Thanks, that explains a lot. However, I don't have any XFS filesystems
> mounted over loop devices on ext3. Earlier in the day I had iso9660 on
> loop on xfs, could that have caused the issue? It was unmounted and
> deleted when this panic occurred.

The mention of /block/loop7/dev and the presence both XFS and ext3
function in the call stack suggested to me that you might have an ext3
filesystem in a loop device on XFS.  I see no other explanation for
that call stack other than a stack overflow, but then we're still back
at the same root cause.

Are you using device-mapper and/or md?  They too are known to blow 4k
stacks when used with XFS.

> I'll probably just try and recompile the kernel with 8k stacks and see
> how it goes. Screw the support, we're unlikely to get it anyway. :-P

Please report how this works out.

-- 
Måns Rullgård
mans@mansr.com

