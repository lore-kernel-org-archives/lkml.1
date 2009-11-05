Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZKEQZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZKEQZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbZKEQZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:25:50 -0500
Received: from smtp6.netcologne.de ([194.8.194.26]:50871 "EHLO
	smtp6.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbZKEQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:25:50 -0500
Date: Thu, 5 Nov 2009 17:25:54 +0100
From: Max Kellermann <max@duempel.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] pipe: don't block after data has been written
Message-ID: <20091105162554.GA5430@squirrel.roonstrasse.net>
Mail-Followup-To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
References: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net> <20091105162043.GA2611@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091105162043.GA2611@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/11/05 17:20, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Nov 05, 2009 at 04:31:47PM +0100, Max Kellermann wrote:
> >According to the select() / poll() documentation, a write operation on
> >a file descriptor which is "ready for writing" must not block.  Linux
> >violates this rule: if you pass a very large buffer to write(), the
> >system call will not return until everything is written, or an error
> >occurs.
> >
> >This patch adds a simple check: if at least one byte has already been
> >written, break from the loop, instead of calling pipe_wait().
> 
> Do you have any working test-case for this?

Eric Dumazet posted a program earlier today (in response to my
pipe/splice patch):

 http://lkml.org/lkml/2009/11/5/144

With this patch applied, it runs correctly (without it, the write()
blocks until the consumer has read everything):

 poll([{fd=4, events=POLLOUT}], 1, -1)   = 1 ([{fd=4, revents=POLLOUT}])
 [...]
 write(4, "\0\0\0\0"..., 1000000) = 65536
