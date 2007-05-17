Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXEQM1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXEQM1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXEQM1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:27:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45873 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbXEQM1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:27:18 -0400
Subject: Re: user pointers and race conditions
From: Arjan van de Ven <arjan@infradead.org>
To: sk b <skb300@hotmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BAY115-W33D3EC723171255D88FBF86330@phx.gbl>
References: <BAY115-W33D3EC723171255D88FBF86330@phx.gbl>
Content-Type: text/plain; charset=UTF-8
Organization: Intel International BV
Date: Thu, 17 May 2007 05:26:56 -0700
Message-Id: <1179404816.3730.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 22:56 -0600, sk b wrote:
> Hello,
> 
> I'm wondering whether there is an exploitable TOCTTOU race condition in the way user pointers are handled in the kernel. Consider the following code:
> 
> 1: struct st { int *u; };
> 2: void syscall(struct st * stp) {
> 3:        if (!access_ok(VERIFY_READ,stp,sizeof(struct st)))
> 4:                return;
> 5:        if (!access_ok(VERIFY_WRITE,stp->u,sizeof(int)))
> 6:                return;

this line is invalid; you are not allowed to dereference userspace
memory directly. You need to call copy_from_user() on stp first, and
then use the copy. 
> 7:        foo();   //user app writes a kernel address to stp->u
> 8:        *(stp->u) = 0;
> 9:}
> 
> Suppose syscall is some system call and, thus, stp and stp->u are user pointers. The function checks the stp and stp->u pointers using the access_ok macro on lines 3 and 5. Also suppose that the call to foo on line 7  takes a non-trivial amount of time to execute. During the time it takes foo to execute, the user application writes a kernel address to stp->u. Note that this write occurs after the check on line 5. Then, on line 8, the kernel writes to stp->u which contains a kernel address. So, the user application could force the kernel to overwrite itself. Is it possible to exploit this race condition? If so, does Sparse check for this?
> 
> -SKB
> _________________________________________________________________
> Download Messenger. Start an i’m conversation. Support a cause. Join now.
> http://im.live.com/messenger/im/home/?source=TAGWL_MAY07-
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

