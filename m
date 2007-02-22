Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbXBVTB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbXBVTB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXBVTB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:01:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbXBVTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:01:27 -0500
Message-ID: <45DDE862.2000100@redhat.com>
Date: Thu, 22 Feb 2007 14:00:50 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Aristeu Sergio Rozanski Filho <aristeu.sergio@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_io: fix race in master pty close/slave pty close
 path
References: <20070222173744.GB6938@cathedrallabs.org>
In-Reply-To: <20070222173744.GB6938@cathedrallabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Sergio Rozanski Filho wrote:
> This patch fixes a possible race that leads to double freeing an idr index.
> 
> Without the patch, on some machines it's possible get easily idr warnings like
> this one:
> idr_remove called for id=15 which is not allocated.
>  [<c02555b9>] idr_remove+0x139/0x170
>  [<c02a1b62>] release_mem+0x182/0x230
>  [<c02a28e7>] release_dev+0x4b7/0x700
>  [<c02a0ea7>] tty_ldisc_enable+0x27/0x30
>  [<c02a1e64>] init_dev+0x254/0x580
>  [<c02a0d64>] check_tty_count+0x14/0xb0
>  [<c02a4f05>] tty_open+0x1c5/0x340
>  [<c02a4d40>] tty_open+0x0/0x340
>  [<c017388f>] chrdev_open+0xaf/0x180
>  [<c017c2ac>] open_namei+0x8c/0x760
>  [<c01737e0>] chrdev_open+0x0/0x180
>  [<c0167bc9>] __dentry_open+0xc9/0x210
>  [<c0167e2c>] do_filp_open+0x5c/0x70
>  [<c0167a91>] get_unused_fd+0x61/0xd0
>  [<c0167e93>] do_sys_open+0x53/0x100
>  [<c0167f97>] sys_open+0x27/0x30
>  [<c010303b>] syscall_call+0x7/0xb

Would another possible trace look like this?

idr_remove called for id=1 which is not allocated.
 [<c0403f10>] dump_trace+0x69/0x1af
 [<c040406e>] show_trace_log_lvl+0x18/0x2c
 [<c04045e9>] show_trace+0xf/0x11
 [<c0404673>] dump_stack+0x15/0x17
 [<c04d3fcb>] idr_remove+0xe2/0x143
 [<c051ee50>] release_dev+0x63b/0x652
 [<c051ee6e>] tty_release+0x7/0xa
 [<c0461b2e>] __fput+0xba/0x178
 [<c045f466>] filp_close+0x52/0x59
 [<c041d3b4>] put_files_struct+0x64/0xa6
 [<c041e3fe>] do_exit+0x248/0x747
 [<c041e973>] sys_exit_group+0x0/0xd
 [<f5d480e4>] 0xf5d480e4
DWARF2 unwinder stuck at 0xf5d480e4
Leftover inexact backtrace:
 [<c0426b76>] get_signal_to_deliver+0x38a/0x3b2
 [<c040243a>] do_notify_resume+0x75/0x62f
 [<c044bfc0>] __pagevec_lru_add_active+0x95/0xa0
 [<c042c814>] autoremove_wake_function+0x0/0x35
 [<c05fc113>] _spin_unlock_irq+0x5/0x7
 [<c05fa9cf>] schedule+0x529/0x585
 [<c0402e2a>] work_notifysig+0x13/0x19


We have some bug reports:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=211429
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227203

