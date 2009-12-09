Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbZLIUrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbZLIUrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbZLIUr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:47:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45404 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbZLIUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:47:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=wU1V9hYgMWlIyIlTDESY6qdJOOE5u0CGlJa4EdF9LXcsQx1k7AXXDjDka9M4oYV1J
	1A9Wtm7L4tC2c2dGPb/1w==
MIME-Version: 1.0
In-Reply-To: <20091208211639.8499FB151F@basil.firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
	 <20091208211639.8499FB151F@basil.firstfloor.org>
Date: Wed, 9 Dec 2009 12:47:27 -0800
Message-ID: <6599ad830912091247v1270a86er45ea8ceeff28e727@mail.gmail.com>
Subject: Re: [PATCH] [23/31] HWPOISON: add memory cgroup filter
From: Paul Menage <menage@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk,
       nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, npiggin@suse.de,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 1:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> The hwpoison test suite need to inject hwpoison to a collection of
> selected task pages, and must not touch pages not owned by them and
> thus kill important system processes such as init. (But it's OK to
> mis-hwpoison free/unowned pages as well as shared clean pages.
> Mis-hwpoison of shared dirty pages will kill all tasks, so the test
> suite will target all or non of such tasks in the first place.)

While the functionality sounds useful, the interface (passing an inode
number) feels a bit ugly to me. Also, if that group is deleted and a
new cgroup created, you could end up reusing the inode number.

How about an approach where you write either the cgroup path (relative
to the memcg mount) or an fd open on the desired cgroup? Then you
could store a (counted) css reference rather than an inode number,
which would make the filter function cleaner too, since it would just
need to compare css objects.

Paul
