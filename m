Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825Ab0AEQAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0AEQAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572Ab0AEQAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:00:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab0AEQAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:00:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <78aa970c1001020516m3d2255fj38f02629e7d740c8@mail.gmail.com>
References: <78aa970c1001020516m3d2255fj38f02629e7d740c8@mail.gmail.com>
To: Kevin Qu <rofail@gmail.com>, Jeff Epler <jepler@unpythonic.net>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: how to get right euid?
Date: Tue, 05 Jan 2010 16:00:33 +0000
Message-ID: <17885.1262707233@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kevin Qu <rofail@gmail.com> wrote:

> I wrote a kernel module and it create a "file" in /proc.
> The "file" permission is set to 644.
> When check access permission, I use :

Check where?  In file_operations::open(), in file_operations::write() or in
inode_operations::permission()?

> if( op == 4 || (op ==2 && current->euid == 0) )
>         return 0;
> 
> But it does not work on 2.6.29,
> so I changed it like below:
> 
> if( op & 0x4 || (op & 0x2 && current_euid() == 0) )
>         return 0;

What is op?  Is "op == N" equivalent to "op & N"?  Should N be a symbolic
constant (MAY_READ or MAY_WRITE)?

> It works when read from the "file" in /proc,
> but when write to it with sudo, like:
> 
> sudo echo "some thing" > /proc/my_file
> 
> It denied. (But it works when I su to superuser and do so.)
> 
> So I checked the current_euid(),
> but it returns 1000 (not 0),Why?

As Jeff said, where you're making the check matters.

In the above sudo command, the open() call is done by the shell, under the
EUID of whoever is logged in, whereas the write() call is done by the echo
command as executed by sudo, under the EUID set by sudo.

Note that if you're making the check in write(), the UID that you're checking
should be the one in struct file::f_cred.

David
