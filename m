Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbZIYVAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbZIYVAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 17:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZIYVAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 17:00:22 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:43276 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbZIYVAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 17:00:22 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC][PATCH] Privilege dropping security module
Date: Fri, 25 Sep 2009 21:00:26 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <h9jb1a$url$2@taverner.cs.berkeley.edu>
References: <20090923005644.GA28244@c.hsd1.tn.comcast.net> <20090923213109.GA936@c.hsd1.tn.comcast.net> <4ABB9D6D.8000607@schaufler-ca.com> <20090925100630.GD10098@c.hsd1.tn.comcast.net>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1253912426 31605 128.32.168.222 (25 Sep 2009 21:00:26 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 25 Sep 2009 21:00:26 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Spencer  wrote:
>static ssize_t dpriv_stage_write(struct file *filp, const char *ubuffer,
>		size_t length, loff_t *off)
>{
>	struct file *file;
>	int err, rval, perm;
>	char *kbuffer, *perm_str, *path_str;
>	int perm_start, perm_end, path_start;
>
>	if (!(kbuffer = kzalloc(length+1, GFP_KERNEL)))
>		return -ENOMEM;
>
>	if (copy_from_user(kbuffer, ubuffer, length))
>		goto fail_fault;

Can 'length+1' overflow?
(Can the caller arrange to pass MAX_SIZE_T as the length parameter?
If yes, that's a vulnerability.)
I haven't checked how dpriv_stage_write() is called, to see whether
this is possible.

>	/* Parse input */
>	path_start = -1;
>	sscanf(kbuffer, " %n%*s%n %n", &perm_start, &perm_end, &path_start);
>	if (path_start == -1)
>		goto fail_inval;
>	perm_str = kbuffer+perm_start;
>	kbuffer[perm_end] = '\0';
>	path_str = kbuffer+path_start;

What if kbuffer isn't '\0'-terminated?  Won't this read past the end
of kbuffer?

Are you certain that perm_end and path_start will be within bounds?
If the user supplies a sufficiently large string (more than MAX_INT
characters long), could perm_end or path_start be negative?

>	rval = length;

Converts size_t to ssize_t.
