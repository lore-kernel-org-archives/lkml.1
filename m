Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbXKFBXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbXKFBXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbXKFBXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:23:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:13078 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbXKFBXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hwbXIvjg8F7zZvv/cm98zxjQjqpzUMa4g6x75RSHGesogvUpV1rIOIn5BW17XaOIdYp64hNF2dRP7nSWISHVU+BHaAJnYaDe5xWH362YghOal0eEizUhC1OEpbLHmQV3X2UT9zML/FnOFpTt9SPUzX8BeAlF9/9T++yA9/SDIgs=
Message-ID: <a8e1da0711051723kb9f866fv1f023f220d9d284d@mail.gmail.com>
Date: Tue, 6 Nov 2007 09:23:06 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH]bluetooth rfcomm_dev refcount bug fix
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <1194274870.4437.8.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20071105045921.GA3556@darkstar.te-china.tietoenator.com>
	 <1194274870.4437.8.camel@aeonflux>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Dave,
>
> > In the rfcomm_tty_hangup the rfcomm_dev refcnt should be dropped later.
> >
> > If rfcomm_dev is destructed in tty_hangup function, then the later tty_close function will oops.
>
> your patch removes the complete release on hangup logic. That can't be
> right. I think the problem is with calling tty_vhangup() and then
> decrementing the reference count. In case we call tty_vhangup and we
> have release on hangup we should not delete the device here. What about
> the attached patch? Does it solve it?
>
> What are the steps to reproduce this?

Hi, marcel
steps to reproduce this :
1. add SP service
1."rfcomm listen 0 1"
2.from remote device connect to host side.
3. rfcomm release 0
    right now , the rfcomm should be disconnected.
    oops will arise (sometimes) (please try more times)
4. then run again "rfcomm listen 0 1"
    if interval between these commands is shor, it will cause SLUB
"poison writting" report, IMHO, the reason is same.
=============================================================================
BUG kmalloc-128: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xc27ca6e8-0xc27ca700. First byte 0x6a instead of 0x6b
INFO: Allocated in rfcomm_dev_add+0x55/0x310 [rfcomm] age=91597 cpu=1 pid=2626
INFO: Freed in rfcomm_dev_destruct+0x84/0xb0 [rfcomm] age=71651 cpu=0 pid=2672
INFO: Slab 0xc104f940 used=5 fp=0xc27ca6e0 flags=0x400000c3
INFO: Object 0xc27ca6e0 @offset=1760 fp=0xc27ca000

Bytes b4 0xc27ca6d0:  00 00 00 00 e3 b1 fe ff 5a 5a 5a 5a 5a 5a 5a 5a
....ã±þÿZZZZZZZZ
  Object 0xc27ca6e0:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
kkkkkkkkjkkkkkkk
  Object 0xc27ca6f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
kkkkkkkkkkkkkkkk
  Object 0xc27ca700:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
jkkkkkkkkkkkkkkk
  Object 0xc27ca710:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
kkkkkkkkkkkkkkkk
  Object 0xc27ca720:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
kkkkkkkkkkkkkkkk
  Object 0xc27ca730:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
kkkkkkkkkkkkkkkk
  Object 0xc27ca740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
kkkkkkkkkkkkkkkk
  Object 0xc27ca750:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5
kkkkkkkkkkkkkkk¥
 Redzone 0xc27ca760:  bb bb bb bb
»»»»
 Padding 0xc27ca788:  5a 5a 5a 5a 5a 5a 5a 5a
ZZZZZZZZ
 [<c0176f7a>] check_bytes_and_report+0xaa/0xe0
 [<c01772a8>] check_object+0x198/0x1e0
 [<c01776cc>] alloc_debug_processing+0x9c/0x130
 [<c0178260>] __slab_alloc+0x200/0x250
 [<c0193560>] alloc_fdtable+0x80/0xf0
 [<c01791a7>] __kmalloc+0xe7/0xf0
 [<c0193560>] alloc_fdtable+0x80/0xf0
 [<c0193560>] alloc_fdtable+0x80/0xf0
 [<c01935fa>] expand_fdtable+0x2a/0xc0
 [<c0128f49>] dup_fd+0x1b9/0x200
 [<c01454ae>] getnstimeofday+0x3e/0x130
 [<c0128fc3>] copy_files+0x33/0x60
 [<c0129729>] copy_process+0x2e9/0x9f0
 [<c0129f2c>] do_fork+0x4c/0x220
 [<c017c9b1>] fd_install+0x21/0x50
 [<c0102ed2>] sys_clone+0x32/0x40
 [<c01043ca>] syscall_call+0x7/0xb
 [<c0400000>] wait_for_common+0x60/0x160
 =======================
FIX kmalloc-128: Restoring 0xc27ca6e8-0xc27ca700=0x6b

FIX kmalloc-128: Marking all objects used

Your patch seems doesn't solve the problem. After release the rfcomm
device, the remote device cannot connect again due to "Address already
in use".

Actually, remove the dev_del in hangup is just well, because the main
issue is flush the buffer , let's leave the device deletion work for
the tty_close.

please take a look at my below dmesg text with debug infomation:

Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
rfcomm_dev_ioctl: cmd 1074025160 arg bf9edeb0
rfcomm_create_dev: sk c2db18c0 dev_id 0 flags 0x3
rfcomm_dev_add: id 0 channel 1
rfcomm_tty_open: tty c2e41060 id 0
rfcomm_tty_open: dev c266c630 dst 56:B4:B6:C5:18:00 channel 1 opened 0
rfcomm_dev_modem_status: dlc c255adc0 dev c266c630 v24_sig 0x8d
rfcomm_dev_put: dev c266c630 refcnt 19
rfcomm_dev_put: dev c266c630 refcnt 18
rfcomm_dev_put: dev c266c630 refcnt 17
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_put: dev c266c630 refcnt 16
rfcomm_dev_put: dev c266c630 refcnt 15
rfcomm_dev_put: dev c266c630 refcnt 14
rfcomm_dev_put: dev c266c630 refcnt 13
rfcomm_dev_put: dev c266c630 refcnt 12
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_ioctl: cmd 1074025161 arg bfcfc160
rfcomm_release_dev: dev_id 0 flags 0x0
rfcomm_tty_flush_buffer: tty c2e41060 dev c266c630
rfcomm_dev_put: dev c266c630 refcnt 11
rfcomm_dev_put: dev c266c630 refcnt 10
rfcomm_dev_put: dev c266c630 refcnt 9
rfcomm_dev_put: dev c266c630 refcnt 8
rfcomm_dev_put: dev c266c630 refcnt 7
rfcomm_dev_put: dev c266c630 refcnt 6
rfcomm_dev_put: dev c266c630 refcnt 5
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_tty_hangup: tty c2e41060 dev c266c630
rfcomm_tty_flush_buffer: tty c2e41060 dev c266c630
rfcomm_dev_del: dev c266c630
rfcomm_dev_put: dev c266c630 refcnt 4
rfcomm_dev_put: dev c266c630 refcnt 3
rfcomm_dev_del: dev c266c630
rfcomm_dev_put: dev c266c630 refcnt 2
rfcomm_dev_put: dev c266c630 refcnt 1
rfcomm_dev_destruct: dev c266c630 dlc c255adc0
rfcomm_tty_close: tty c2e41060 dev c266c630 dlc c255adc0 opened 1
BUG: unable to handle kernel NULL pointer dereference at virtual
address 00000008
printing eip: c01c0884 *pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
Modules linked in: bnep rfcomm l2cap snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
e100 psmouse btusb bluetooth evdev sg thermal snd_hda_intel snd_pcm
serio_raw snd_timer snd processor button rtc_cmos pcspkr rtc_core
rtc_lib intel_agp agpgart soundcore snd_page_alloc i2c_i801

Pid: 2621, comm: rfcomm Not tainted (2.6.24-rc1 #3)
EIP: 0060:[<c01c0884>] EFLAGS: 00010246 CPU: 1
EIP is at sysfs_move_dir+0x24/0x1d0
EAX: c04e4028 EBX: c1c3314c ECX: 00000000 EDX: c1c3314c
ESI: c1c3314c EDI: 00000000 EBP: 00000000 ESP: c2e7be1c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rfcomm (pid: 2621, ti=c2e7a000 task=c2764590 task.ti=c2e7a000)
Stack: ffffffff 0000000a 3d92326f c26dcd90 c048ff2b 00000000 00000000 c278dda8
       c1c3314c c2780690 c26dcd90 c0249d22 c26dcd90 c048ff1d c2780690 fffffff4
       c26dcd90 00000000 c278dd20 00000000 00000000 c1c3314c c02b43bb c278dda8
Call Trace:
 [<c0249d22>] kobject_move+0xa2/0x120
 [<c02b43bb>] device_move+0x5b/0x120
 [<f88cbcee>] rfcomm_tty_close+0x8e/0xd0 [rfcomm]
 [<c029753a>] release_dev+0x58a/0x6b0
 [<c02a7050>] con_put_char+0x30/0x40
 [<c013fe7a>] remove_wait_queue+0x1a/0x50
 [<c0125500>] default_wake_function+0x0/0x10
 [<c029b759>] write_chan+0x1b9/0x200
 [<c01255be>] __wake_up+0x3e/0x60
 [<c02954d3>] tty_ldisc_deref+0x63/0x80
 [<c0297aef>] tty_release+0xf/0x20
 [<c017e79e>] __fput+0x14e/0x180
 [<c017cb6c>] filp_close+0x3c/0x80
 [<c017cc19>] sys_close+0x69/0xd0
 [<c01043ca>] syscall_call+0x7/0xb
 [<c0400000>] wait_for_common+0x60/0x160
 =======================
Code: 6c 24 28 83 c4 2c c3 55 57 31 ff 56 53 83 ec 1c 89 d3 8b 68 1c
31 c0 89 44 24 18 31 c0 89 44 24 14 b8 28 40 4e c0 e8 0c fe 23 00 <8b>
55 08 85 d2 0f 84 65 01 00 00 8b 73 1c b8 a0 40 4e c0 85 f6
EIP: [<c01c0884>] sysfs_move_dir+0x24/0x1d0 SS:ESP 0068:c2e7be1c

Regards
dave
