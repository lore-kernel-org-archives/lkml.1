Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYH3TGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYH3TGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYH3TGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:06:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:26453 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYH3TGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZuqM/b0bJ0R4VgRPvXDaNOG+emZ4mIrXvvlR3WlcfLG1yXI9qjSNKEMNxiBZwoXozg
         o73pWqFPb2fiPme2e3l9IsPUqHqRjfCi5kkGzkU0SZrDDUE+uDQU5B4FqEgbOHU7J5n5
         g2jrBK/4FnYQTFAVHNYLGCJ/4carLrg4vd+NU=
Date: Sat, 30 Aug 2008 23:06:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Tom Tucker <tom@opengridcomputing.com>, Neil Brown <neilb@suse.de>,
       Chuck Lever <chuck.lever@oracle.com>, Greg Banks <gnb@sgi.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080830190642.GC7611@lenovo>
References: <20080830184422.GA9598@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830184422.GA9598@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Sat, Aug 30, 2008 at 08:44:22PM +0200]
| Hi,
| 
| I noticed that something weird is going on with /proc/sys/sunrpc/transports.
| This file is generated in net/sunrpc/sysctl.c, function proc_do_xprt(). When
| I "cat" this file, I get the expected output:
| 
|     $ cat /proc/sys/sunrpc/transports 
|     tcp 1048576
|     udp 32768
| 
| But I think that it does not check the length of the buffer supplied by
| userspace to read(). With my original program, I found that the stack was
| being overwritten by the characters above, even when the length given to
| read() was just 1. So I have created a test program, see it at the bottom of
| this e-mail. Here is its output:
| 
...

Indeed, maybe just add checking for user buffer length?
As proc_dodebug() in this file are doing. I don't think
the user would be happy with his stack burned :)

Something like:
---

Index: linux-2.6.git/net/sunrpc/sysctl.c
===================================================================
--- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-07-20 11:40:14.000000000 +0400
+++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-30 23:05:30.000000000 +0400
@@ -69,6 +69,8 @@ static int proc_do_xprt(ctl_table *table
 		return -EINVAL;
 	else {
 		len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
+		if (*lenp < len)
+			return -EFAULT;
 		if (!access_ok(VERIFY_WRITE, buffer, len))
 			return -EFAULT;
 
