Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYIKUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYIKUSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYIKUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:17:58 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:65167 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYIKUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nj74bKEF0/kWvAnpMyl8t11osD3EYYV4OkKY+pL6/I6TISduco0EYStSRN0G1HVjsP
         bT4FVH2C4IcIzHQ7fsblWOUzPtpw//aJm16cJDPYsrJFG8hUPUnG6JW+l232YuU1Px8o
         4RnPvj8G7ZeKcpHKu/uaniw8mSHkUxRr49fkc=
Message-ID: <f4e12c70809111317x221ab6bcmcb8bdbf2e0074f83@mail.gmail.com>
Date: Thu, 11 Sep 2008 13:17:55 -0700
From: "Priyank Patel" <pkpatel.lists@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26.3 kernel - progressive slowdown over NFS
In-Reply-To: <f4e12c70809091747rd58165ahaa6594a35752c6ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f4e12c70809091747rd58165ahaa6594a35752c6ef@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending.  Any pointers to other lists or more specific information
which might be required ?

Thanks,
-P

PS : Please cc me on the response.

On Tue, Sep 9, 2008 at 5:47 PM, Priyank Patel <pkpatel.lists@gmail.com> wrote:
> Hi,
>
>
> We have a simple python program which keeps running a C loop to lstat
> NFS mounted directories.  We are seeing some weird behavior w.r.t. the
> run-time of this program on 2.6.26.3 kernel vs 2.6.24 kernel.
>
> The run-time of the following code increases over time on the 2.6.26.3
> kernel, whereas remains flat (as expected) on the 2.6.24 kernel.
> [See attached graphs - B1.jpg and B2.jpg]  Once the 2.6.26.3 machine
> gets into this state, we need to restart the box to get back to
> reasonable run-times.  Is this a known issue ?
>
> Setup :
>
> Machine A (2.6.26) : exports NFS directory  - /a/baz contains 10,000
> directories bar0 ... bar9999
> /a/baz        *(rw,sync,no_root_squash,no_all_squash,subtree_check)
>
> Machine B1 (2.6.26.3) : mounts NFS dir RO from A - graph B1.jpg
> 10.x.x.x:/a/baz on /baz type nfs
> (ro,vers=3,rsize=4096,wsize=4096,namlen=255,hard,nointr,nolock,proto=udp,timeo=11,retrans=2,sec=sys,mountproto=udp,addr=10.x.x.x)
>
> Machine B2 (2.6.24) : mounts NFS dir RO from A - graph B2.jpg
> 10.x.x.x:/a/baz on /baz type nfs
> (ro,vers=3,rsize=4096,wsize=4096,hard,nointr,nolock,proto=udp,timeo=11,retrans=2,sec=sys,addr=10.x.x.x)
>
> Repro :
>
> B1 and B2, run the following python program :
> {{{
> #!/usr/bin/env python
>
> import os
> import sys
> import time
>
> while True:
>    t1 = time.time()
>    rv = os.system("/a.out 10000 >& /dev/null")   # lstat the 10000
> directories mounted via NFS
>    t2 = time.time()
>    print >> sys.stderr, "%.3f" % (t2 - t1), rv
> }}}
>
> where a.out is the following C code :
>
> {{{
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <unistd.h>
>
> int main(int argc, char **argv)
> {
>   int i, n = atoi(argv[1]);
>   char filename[64];
>   struct stat statbuf;
>
>   for (i = 0; i < n; i++) {
>      sprintf(filename, "/baz/bar%d", i);
>      lstat(filename, &statbuf);
>   }
>
>   printf("done\n");
>   return 0;
> }
> }}}
>
> Attachments :
>
> B1.jpg and B2.jpg - runtimes on the 2 client machines -
> X-axis : iteration number
> Y-axis : run-time
>
> Config files : - for the machines B1, B2 and A
>
> b1.2.6.26.3.config
> b2.2.6.24.config
> a.2.6.26.config
>
>
> - P
>
