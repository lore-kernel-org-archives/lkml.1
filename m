Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbXEQE43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbXEQE43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXEQE4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:56:23 -0400
Received: from bay0-omc3-s13.bay0.hotmail.com ([65.54.246.213]:50111 "EHLO
	bay0-omc3-s13.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756106AbXEQE4W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:56:22 -0400
Message-ID: <BAY115-W33D3EC723171255D88FBF86330@phx.gbl>
X-Originating-IP: [171.64.143.221]
From: sk b <skb300@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: user pointers and race conditions
Date: Wed, 16 May 2007 22:56:22 -0600
Importance: Normal
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 17 May 2007 04:56:22.0460 (UTC) FILETIME=[B70A0FC0:01C7983F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I'm wondering whether there is an exploitable TOCTTOU race condition in the way user pointers are handled in the kernel. Consider the following code:

1: struct st { int *u; };
2: void syscall(struct st * stp) {
3:        if (!access_ok(VERIFY_READ,stp,sizeof(struct st)))
4:                return;
5:        if (!access_ok(VERIFY_WRITE,stp->u,sizeof(int)))
6:                return;
7:        foo();   //user app writes a kernel address to stp->u
8:        *(stp->u) = 0;
9:}

Suppose syscall is some system call and, thus, stp and stp->u are user pointers. The function checks the stp and stp->u pointers using the access_ok macro on lines 3 and 5. Also suppose that the call to foo on line 7  takes a non-trivial amount of time to execute. During the time it takes foo to execute, the user application writes a kernel address to stp->u. Note that this write occurs after the check on line 5. Then, on line 8, the kernel writes to stp->u which contains a kernel address. So, the user application could force the kernel to overwrite itself. Is it possible to exploit this race condition? If so, does Sparse check for this?

-SKB
_________________________________________________________________
Download Messenger. Start an i’m conversation. Support a cause. Join now.
http://im.live.com/messenger/im/home/?source=TAGWL_MAY07