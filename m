Return-Path: <linux-kernel-owner+w=401wt.eu-S934242AbXEQFEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242AbXEQFEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760229AbXEQFEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:04:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40971 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760164AbXEQFEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:04:37 -0400
Date: Thu, 17 May 2007 06:04:36 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: sk b <skb300@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: user pointers and race conditions
Message-ID: <20070517050436.GN4095@ftp.linux.org.uk>
References: <BAY115-W33D3EC723171255D88FBF86330@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY115-W33D3EC723171255D88FBF86330@phx.gbl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 10:56:22PM -0600, sk b wrote:
> 
> Hello,
> 
> I'm wondering whether there is an exploitable TOCTTOU race condition in the way user pointers are handled in the kernel. Consider the following code:
> 
> 1: struct st { int *u; };
> 2: void syscall(struct st * stp) {
> 3:        if (!access_ok(VERIFY_READ,stp,sizeof(struct st)))
> 4:                return;
> 5:        if (!access_ok(VERIFY_WRITE,stp->u,sizeof(int)))

... and there's your bug - direct access to userland data.  The normal
variant is to use accessors (get_user() or copy_from_user()) to fetch
the value of stp->u.  At which point races of the kind you mentioned
take an obviously dumb code (explicitly copying the same struct from
userland _twice_).

