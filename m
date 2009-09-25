Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbZIYTqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbZIYTqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 15:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZIYTqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 15:46:04 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62867 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZIYTqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 15:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b//fNUED/XBANb0cNCze1oxORYl2scC0nNy0OGtbxGf71Ot2A2Y5Ty1mdRBZ3JC8P3
         f9c0BdZpBXptvr3m82TDn7UkWc3g2X96vlLN6D1hu3vfcuzX9pu5UEzMBMrYFW/WO+pl
         isF3oNRHVw4CIazz+WbcCFdz/soSpk6TZjkjY=
MIME-Version: 1.0
In-Reply-To: <1253892426.31072.37.camel@heimdal.trondhjem.org>
References: <c4e36d110909250812g74e049b7u39566d189970d77e@mail.gmail.com>
	 <1253892426.31072.37.camel@heimdal.trondhjem.org>
Date: Fri, 25 Sep 2009 21:46:04 +0200
Message-ID: <c4e36d110909251246s6af618e8n663afe2b66c4cd5d@mail.gmail.com>
Subject: Re: NFS problem with past 2.6.31 git tree
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/25 Trond Myklebust <Trond.Myklebust@netapp.com>:
> On Fri, 2009-09-25 at 17:12 +0200, Zdenek Kabelac wrote:
>> Hi
>>
>> I've noticed that my qemu guest is now unable to use localy exported
>> nfs directory.
>> Directory gets mounted, plain 'ls' shows filenames - but nothing else
>> could be done.
>>
>> ls -la gives this output:
>> ls: cannot access patch: Input/output error
>> ...
>>
>>
>> Both host & guest are running same kernel:
>> 851b147e4411df6a1e7e90e2a609773c277eefd2
>>
>> I've checked last few commits and tried to revert them -
>> and this one seems to cure my problem when reverted:
>>
>> Sep 23:  8a6e5deb8a8caa810fef2c525f5dbea2cfe04a47
>> NFS: Get rid of the NFS_MOUNT_VER3 and NFS_MOUNT_TCP flags
>>
>> I should also probably note that I'm seeing this message in my dmesg log:
>> svc: failed to register lockdv1 RPC service (errno 97)
>>
>> rpcinfo -p
>>    program vers proto   port
>>     100000    2   tcp    111  portmapper
>>     100000    2   udp    111  portmapper
>>     100024    1   udp  53550  status
>>     100024    1   tcp  44174  status
>>     100021    1   udp  49878  nlockmgr
>>     100021    3   udp  49878  nlockmgr
>>     100021    4   udp  49878  nlockmgr
>>     100021    1   tcp  47319  nlockmgr
>>     100021    3   tcp  47319  nlockmgr
>>     100021    4   tcp  47319  nlockmgr
>>
>> automount(pid1720) /misc autofs
>> rw,relatime,fd=4,pgrp=1720,timeout=300,minproto=2,maxproto=4,indirect
>> 0 0
>> 192.168.122.1:/home/u/export /misc/u nfs
>> rw,relatime,vers=3,rsize=524288,wsize=524288,namlen=255,soft,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountaddr=192.168.xxx.yyy,mountvers=3,mountproto=tcp,addr=192.168.xxx.yyy
>> 0 0
>>
>>
>> Zdenek
> What does
>
>   cat /proc/self/mountinfo
>
> give you?
>


Working version: (kernel 2.6.31 or current git with reverted NFS patch)

22 12 0:17 / /misc rw,relatime - autofs automount(pid1720)
rw,fd=4,pgrp=1720,timeout=300,minproto=2,maxproto=4,indirect

24 22 0:19 / /misc/kabi rw,relatime - nfs IP:/home/kabi/export
rw,vers=3,rsize=524288,wsize=524288,namlen=255,soft,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountaddr=IP,mountvers=3,mountproto=tcp,addr=IP


Nonworking version:

22 12 0:17 / /misc rw,relatime - autofs automount(pid1704)
rw,fd=4,pgrp=1704,timeout=300,minproto=2,maxproto=4,indirect

24 22 0:19 / /misc/kabi rw,relatime - nfs IP:/home/kabi/export
rw,vers=2,rsize=8192,wsize=8192,namlen=255,soft,proto=tcp,port=65535,timeo=600,retrans=2,sec=sys,mountaddr=IP,mountvers=3,mountproto=tcp,addr=IP



Looks like vers=2  != vers=3   and rsize/wsize - which is also set by
the kernel itself to those lower values.
(i.e. my /etc/init.d/autofs doesn't modify localoptions - of course I
could use this to set 8192 wsize and rsize for my working kernel)

Zdenek
